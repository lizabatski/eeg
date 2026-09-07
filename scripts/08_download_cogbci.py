"""Download COG-BCI v4 from Zenodo, verifying published checksums."""
import argparse
import hashlib
import json
from pathlib import Path
import time
import urllib.request
import zipfile
import shutil

ROOT = Path(__file__).resolve().parents[1] / 'data' / 'cogbci'


def extract_flanker(archive, entry):
    manifest_path = ROOT / (archive.stem + '.flanker_manifest.json')
    records = []
    with zipfile.ZipFile(archive) as z:
        members = [i for i in z.infolist() if not i.is_dir() and
                   (Path(i.filename).name.lower() in ('flanker.set', 'flanker.fdt', 'flanker.mat', 'get_chanlocs.txt'))]
        for session in ('ses-S1', 'ses-S2', 'ses-S3'):
            for relative in ('eeg/Flanker.set', 'eeg/Flanker.fdt', 'behavioral/Flanker.mat', 'chanlocs/get_chanlocs.txt'):
                expected = f'{archive.stem}/{session}/{relative}'
                if expected not in [i.filename for i in members]:
                    raise ValueError(f'Missing required member: {expected}')
        for info in members:
            target = (ROOT / info.filename).resolve()
            if not target.is_relative_to(ROOT.resolve() / archive.stem):
                raise ValueError('Unsafe archive member')
            target.parent.mkdir(parents=True, exist_ok=True)
            temporary = target.with_suffix(target.suffix + '.part')
            with z.open(info) as source, temporary.open('wb') as output:
                shutil.copyfileobj(source, output)
            if temporary.stat().st_size != info.file_size:
                raise ValueError('Extracted size mismatch')
            temporary.replace(target)
            with target.open('rb') as f:
                digest = hashlib.file_digest(f, 'sha256').hexdigest()
            records.append(dict(path=info.filename, size=info.file_size, sha256=digest))
    manifest_path.write_text(json.dumps(dict(source_checksum=entry['checksum'], files=records), indent=2), encoding='utf-8')
    # Only delete this explicitly verified source archive inside the dataset directory.
    if archive.resolve().parent != ROOT.resolve():
        raise ValueError('Unsafe archive cleanup path')
    archive.unlink()
    print(f'Extracted and verified {len(records)} flanker files; removed {archive.name}', flush=True)


def extracted_verified(archive, entry):
    manifest = ROOT / (archive.stem + '.flanker_manifest.json')
    if not manifest.exists():
        return False
    saved = json.loads(manifest.read_text(encoding='utf-8'))
    if saved['source_checksum'] != entry['checksum'] or len(saved['files']) < 12:
        return False
    for record in saved['files']:
        path = (ROOT / record['path']).resolve()
        if not path.is_relative_to(ROOT.resolve() / archive.stem):
            raise ValueError('Unsafe manifest path')
        if not path.exists() or path.stat().st_size != record['size']:
            return False
        with path.open('rb') as f:
            if hashlib.file_digest(f, 'sha256').hexdigest() != record['sha256']:
                return False
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--subjects', nargs='+', type=int, default=list(range(1, 6)))
    parser.add_argument('--flanker-only', action='store_true', help='Extract flanker files and delete verified source archives')
    args = parser.parse_args()
    if any(n < 1 or n > 29 for n in args.subjects):
        parser.error('subjects must be between 1 and 29')
    ROOT.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen('https://zenodo.org/api/records/7413650', timeout=60) as response:
        metadata = json.load(response)
    (ROOT / 'zenodo_metadata.json').write_text(json.dumps(metadata, indent=2), encoding='utf-8')
    selected = {f'sub-{n:02}.zip' for n in args.subjects}
    files = [f for f in metadata['files'] if not f['key'].endswith('.zip') or f['key'] in selected]
    files.sort(key=lambda f: (f['key'].endswith('.zip'), f['key']))
    for entry in files:
        name = entry['key']
        if Path(name).name != name:
            raise ValueError('Unexpected filename')
        dest = ROOT / name
        if args.flanker_only and name.endswith('.zip') and extracted_verified(dest, entry):
            print(f'Already verified extracted flanker data: {name}', flush=True)
            continue
        algorithm, expected = entry['checksum'].split(':', 1)
        def verified(path):
            if not path.exists() or path.stat().st_size != entry['size']:
                return False
            with path.open('rb') as f:
                return hashlib.file_digest(f, algorithm).hexdigest() == expected
        if verified(dest):
            print(f'Already verified: {name}', flush=True)
            if args.flanker_only and name.endswith('.zip'):
                extract_flanker(dest, entry)
            continue
        partial = dest.with_suffix(dest.suffix + '.part')
        offset = partial.stat().st_size if partial.exists() else 0
        request = urllib.request.Request(entry['links']['self'], headers={'Range': f'bytes={offset}-'} if offset else {})
        print(f'Downloading {name}: {entry["size"]/1e6:.1f} MB', flush=True)
        with urllib.request.urlopen(request, timeout=120) as response:
            append = offset > 0 and response.status == 206
            if append and not response.headers.get('Content-Range', '').startswith(f'bytes {offset}-'):
                raise RuntimeError('Unexpected resume range')
            total = offset if append else 0
            last = time.monotonic()
            with partial.open('ab' if append else 'wb') as f:
                while chunk := response.read(1024 * 1024):
                    f.write(chunk)
                    total += len(chunk)
                    if time.monotonic() - last > 15:
                        print(f'  {name}: {total/entry["size"]:.0%}', flush=True)
                        last = time.monotonic()
        if not verified(partial):
            raise RuntimeError(f'Checksum/size mismatch: {partial}; remove this partial file before retrying')
        partial.replace(dest)
        print(f'Checksum verified: {name}', flush=True)
        if name.endswith('.zip'):
            with zipfile.ZipFile(dest) as z:
                members = [i.filename for i in z.infolist()]
            (ROOT / (name + '.contents.json')).write_text(json.dumps(members, indent=2), encoding='utf-8')
            print('Flanker entries: ' + str([n for n in members if 'flanker' in n.lower()]), flush=True)
            if args.flanker_only:
                extract_flanker(dest, entry)
    print('Requested downloads complete: ' + str(ROOT), flush=True)


if __name__ == '__main__':
    main()
