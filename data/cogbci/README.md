# COG-BCI version 4

Official source: https://zenodo.org/records/7413650
DOI: 10.5281/zenodo.7413650
Creators: Hinss, Jahanpour, Somon, Pluchon, Dehais, and Roy.

29 participants, three sessions each; about 31.7 GB of subject archives including
Flanker, N-back, PVT, MATB, and resting-state recordings. Version 4 fixes an
electrode-name mismatch. Preserve the downloaded Zenodo metadata for attribution
and the release's rights information.

## Current download scope: five participants, flanker only

Participants 01?05 are being downloaded sequentially. Each source archive is
verified against Zenodo's size and MD5, then only the three sessions' flanker EEG,
behavioral data, and channel-location files are extracted. ZIP CRC checks run
while reading each member; extracted files receive SHA-256 hashes in a manifest.
The source archive is deleted only after successful extraction. Final retained
size is expected to be about 1.2 GB, with temporary space for an archive.

`.part` means unfinished. `sub-XX.flanker_manifest.json` records a completed
participant. The old download.log describes the stopped full-dataset download,
not this new run. The current run reports progress in the agent terminal.

After the active download has stopped, resume in Command Prompt:

```bat
python scripts/08_download_cogbci.py --subjects 1 2 3 4 5 --flanker-only
```

Do not run two downloaders for the same participant simultaneously. Completed
extractions are hash-verified and skipped; partial archives resume when the
server supports ranges. The script defaults to participants 1?5, not all 29.

## Files needed for flanker

Inside each subject archive, for each `ses-S1`, `ses-S2`, `ses-S3`:

- `eeg/Flanker.set` and `eeg/Flanker.fdt` (keep together)
- `behavioral/Flanker.mat`
- `chanlocs/get_chanlocs.txt`

The archive preview confirms these paths for subject 1. Local archive contents
are listed in `sub-XX.zip.contents.json` after download verification.

## Verified frontend protocol from COG-BCI_info.pdf

- 120 trials; four arrow patterns equally frequent in pseudorandom order.
- Congruent: `<<<<<`, `>>>>>`; incongruent: `<<><<`, `>><>>`.
- Respond to the center arrow. No neutral condition in this protocol.
- 2000 ms ISI; 16 ms stimulus; fixation screen for 2250–2750 ms for response;
  then 500 ms correctness/miss feedback. Approximate run length: 10 minutes.
- Study used a 120 Hz display. A browser's requested duration alone does not
  guarantee actual 16 ms presentation; log actual frame-based onset/offset.
- EEG: ActiCHamp, 500 Hz; Cz missing for subjects 1–9. ECG is not an EEG/EOG
  feature channel. Montage and ANT transfer need checking before model use.

Flanker trigger codes (from triggerlist.txt): 241/242 stimulus congruent/incongruent;
2511/2512 correct response; 2521/2522 incorrect response; 25321/25322 missed-response
feedback. Response events and feedback events must not be counted as separate trials.

The next analysis step is to inspect `.set` events and `.mat` behavioral fields,
verify their alignment and units, and define held-out-subject evaluation before
training. Downloading the data does not establish predictive performance.
