import argparse
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path


def check(package):
    if package.suffix == ".app":
        executable = package / "Contents/MacOS/EUI-PySide6-Gallery"
        resources = package / "Contents/Resources"
    else:
        executable = package / "EUI-PySide6-Gallery.exe"
        resources = package / "_internal"
    for path in (executable, resources / "eui/resources.rcc", resources / "eui_gallery/example.rcc"):
        if not path.is_file():
            raise FileNotFoundError("Missing package file: " + str(path))
    environment = {key: value for key, value in os.environ.items()
                   if not key.startswith(("PYTHON", "QT_", "QML", "QTWEBENGINE_"))}
    environment.update(QT_QPA_PLATFORM="offscreen", QT_QUICK_BACKEND="software")
    if sys.platform == "win32":
        environment["PATH"] = str(Path(environment["WINDIR"]) / "System32")
    with tempfile.TemporaryDirectory(prefix="eui-package-smoke-") as directory:
        result = subprocess.run([str(executable), "--smoke-test"], cwd=directory, env=environment,
                                capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=90,
                                creationflags=subprocess.CREATE_NO_WINDOW if sys.platform == "win32" else 0)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr + f"\nExit code: {result.returncode}")
    print(json.dumps({"package": str(package), "isolated_startup": "passed"}))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Verify standalone Gallery startup without the development environment.")
    parser.add_argument("package", type=Path)
    arguments = parser.parse_args()
    check(arguments.package.resolve())
