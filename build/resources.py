"""Build bundled resources before starting a Gallery or test process."""
import os
import subprocess
import sys
from pathlib import Path

import PySide6


def main():
    root = Path(__file__).resolve().parents[1]
    tool = Path(PySide6.__file__).parent / ("rcc.exe" if sys.platform == "win32" else "rcc")
    for source in (root / "source/resources.qrc", root / "example/example.qrc"):
        target = source.with_suffix(".rcc")
        temporary = target.with_suffix(f".{os.getpid()}.tmp")
        try:
            subprocess.run([str(tool), "--binary", str(source), "-o", str(temporary)], check=True)
            temporary.replace(target)
        finally:
            temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
