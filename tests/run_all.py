import argparse
import concurrent.futures
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def run(path):
    log = ROOT / "test-results" / f"{path.stem}.txt"
    environment = os.environ.copy()
    try:
        process = subprocess.run([sys.executable, str(ROOT / "tests/run_qml.py"), "-input", str(path), "-o", f"{log},txt"],
                                 cwd=ROOT, env=environment, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=300)
        output = log.read_text(encoding="utf-8", errors="replace") if log.exists() else process.stdout + process.stderr
        totals = re.search(r"Totals: (\d+) passed, (\d+) failed, (\d+) skipped", output)
        ok = process.returncode == 0 and totals is not None and int(totals[2]) == 0
        return dict(suite=path.stem, ok=ok, passed=int(totals[1]) if totals else 0,
                    failed=int(totals[2]) if totals else 1, skipped=int(totals[3]) if totals else 0,
                    errors=process.stderr if not ok else "")
    except subprocess.TimeoutExpired:
        return dict(suite=path.stem, ok=False, passed=0, failed=1, skipped=0, errors="Timed out after 300 seconds")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--match", default="*", help="Suite filename pattern")
    parser.add_argument("--failed", action="store_true", help="Rerun failed suites from the last complete run")
    parser.add_argument("--jobs", type=int, default=1)
    args = parser.parse_args()
    paths = sorted((ROOT / "tests/qml").glob(f"tst_{args.match}.qml"))
    previous = []
    if args.failed:
        summary = ROOT / "test-results/summary.json"
        if not summary.exists():
            parser.error("No complete test summary exists")
        previous = json.loads(summary.read_text(encoding="utf-8"))
        failed = {item["suite"] for item in previous if not item["ok"]}
        paths = [path for path in paths if path.stem in failed]
    (ROOT / "test-results").mkdir(exist_ok=True)
    results = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        for future in concurrent.futures.as_completed([pool.submit(run, path) for path in paths]):
            result = future.result()
            results.append(result)
            print(f"{'PASS' if result['ok'] else 'FAIL'} {result['suite']}: {result['passed']} passed, {result['failed']} failed, {result['skipped']} skipped", flush=True)
    if args.failed:
        updated = {item["suite"]: item for item in previous}
        updated.update({item["suite"]: item for item in results})
        results = sorted(updated.values(), key=lambda item: item["suite"])
    name = "summary.json" if args.match == "*" else "summary-" + re.sub(r"[^\w-]", "_", args.match) + ".json"
    (ROOT / "test-results" / name).write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"{sum(r['ok'] for r in results)}/{len(results)} suites passed", flush=True)
    return int(any(not result["ok"] for result in results))


if __name__ == "__main__":
    raise SystemExit(main())
