"""Tests for scripts/08_download_cogbci.py's archive extraction and verification.

Team: Monster's Inc
"""

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import zipfile


spec = importlib.util.spec_from_file_location(
    "cogbci_download",
    Path(__file__).resolve().parents[1] / "scripts" / "08_download_cogbci.py",
)
download = importlib.util.module_from_spec(spec)
spec.loader.exec_module(download)


class CogBciDownloadTests(unittest.TestCase):
    def test_nested_subject_archive_is_normalized_and_verified(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            archive = root / "sub-03.zip"
            with zipfile.ZipFile(archive, "w") as source:
                for session in ("ses-S1", "ses-S2", "ses-S3"):
                    for relative in (
                        "eeg/Flanker.set", "eeg/Flanker.fdt",
                        "behavioral/Flanker.mat", "chanlocs/get_chanlocs.txt",
                    ):
                        source.writestr(f"sub-03/sub-03/{session}/{relative}", b"data")
            entry = {"checksum": "md5:test"}
            with patch.object(download, "ROOT", root):
                download.extract_flanker(archive, entry)
                self.assertTrue(download.extracted_verified(archive, entry))
                self.assertFalse(archive.exists())
                manifest = json.loads((root / "sub-03.flanker_manifest.json").read_text())
                self.assertEqual(len(manifest["files"]), 12)
                (root / "sub-03/ses-S1/eeg/Flanker.fdt").write_bytes(b"oops")
                self.assertFalse(download.extracted_verified(archive, entry))


if __name__ == "__main__":
    unittest.main()
