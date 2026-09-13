"""Download all COG-BCI Flanker subjects, then validate and replace the live model.

Progress and errors are written to results/cogbci_refresh.log and
results/cogbci_refresh_status.json. Safe to rerun after an interrupted download.
"""
from datetime import datetime, timezone
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import traceback

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results"


def status(phase, **details):
    target = RESULTS / "cogbci_refresh_status.json"
    temporary = target.with_suffix(".json.part")
    temporary.write_text(json.dumps({
        "phase": phase,
        "updated_at": datetime.now(timezone.utc).isoformat(),
        **details,
    }, indent=2), encoding="utf-8")
    temporary.replace(target)


def refresh(log):
    status("downloading", expected_subjects=29)
    subprocess.run([
        sys.executable, "-u", str(ROOT / "scripts/08_download_cogbci.py"),
        "--all-subjects", "--flanker-only", "--workers", "4",
    ], cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, check=True)

    status("verifying")
    spec = importlib.util.spec_from_file_location(
        "cogbci_download", ROOT / "scripts/08_download_cogbci.py",
    )
    downloader = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(downloader)
    metadata = json.loads((downloader.ROOT / "zenodo_metadata.json").read_text())
    entries = {entry["key"]: entry for entry in metadata["files"]}
    for subject in range(1, 30):
        name = f"sub-{subject:02}.zip"
        if not downloader.extracted_verified(downloader.ROOT / name, entries[name]):
            raise ValueError(f"Subject {subject} failed extracted-file verification")

    status("training")
    candidate = RESULTS / "cogbci_flanker_candidate.joblib"
    candidate_manifest = RESULTS / "cogbci_flanker_candidate.json"
    subprocess.run([
        sys.executable, "-u", str(ROOT / "scripts/12_train_cogbci_flanker.py"),
        "--model", str(candidate), "--manifest", str(candidate_manifest),
    ], cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, check=True)

    sys.path.insert(0, str(ROOT))
    import numpy as np
    from neuroloop.live_model import load_deployment_model

    model = load_deployment_model(candidate)
    evaluation = model.evaluation
    if evaluation["training_subjects"] != list(range(1, 30)):
        raise ValueError("Candidate model does not include all 29 subjects")
    if evaluation["training_sessions"] != 87:
        raise ValueError("Candidate model does not include all 87 sessions")
    if not np.isfinite(evaluation["mean_auc"]):
        raise ValueError("Held-out AUROC is not finite")
    model.predict_failure_probability(np.zeros(len(model.feature_names)))

    status("installing", evaluation=evaluation)
    backup = RESULTS / "cogbci_previous_model"
    backup.mkdir(exist_ok=True)
    for source, name in (
        (candidate, "cogbci_flanker_live_model.joblib"),
        (candidate_manifest, "cogbci_flanker_live_model.json"),
    ):
        target = ROOT / "artifacts" / name
        if target.exists():
            shutil.copy2(target, backup / name)
        staged = target.with_suffix(target.suffix + ".part")
        shutil.copy2(source, staged)
        staged.replace(target)
    status("complete", evaluation=evaluation)
    print(f"Refresh complete. Mean held-out AUROC: {evaluation['mean_auc']:.4f}",
          file=log, flush=True)


def main():
    RESULTS.mkdir(exist_ok=True)
    with (RESULTS / "cogbci_refresh.log").open("a", encoding="utf-8", buffering=1) as log:
        try:
            refresh(log)
        except Exception as error:
            status("failed", error=str(error))
            traceback.print_exc(file=log)
            raise


if __name__ == "__main__":
    main()
