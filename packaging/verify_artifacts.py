import argparse
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

from check_package import check


def run(*arguments):
    subprocess.run([str(argument) for argument in arguments], check=True, timeout=300,
                   creationflags=subprocess.CREATE_NO_WINDOW if sys.platform == "win32" else 0)


def verify(directory):
    archives = list(directory.glob("EUI-PySide6-Gallery-*-portable.zip"))
    if len(archives) != 1:
        raise ValueError("Expected one portable package for this platform.")
    with tempfile.TemporaryDirectory(prefix="eui-delivery-") as temporary:
        root = Path(temporary)
        if sys.platform == "win32":
            with zipfile.ZipFile(archives[0]) as archive:
                archive.extractall(root)
            check(root / "EUI-PySide6-Gallery")
            installers = list(directory.glob("EUI-PySide6-Gallery-*-setup.exe"))
            if len(installers) != 1:
                raise ValueError("Expected one Windows installer.")
            target = root / "installed"
            run(installers[0], "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/SP-", "/NOICONS", "/DIR=" + str(target))
            try:
                check(target)
            finally:
                run(target / "unins000.exe", "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART")
        else:
            run("ditto", "-x", "-k", archives[0], root)
            check(root / "EUI PySide6 Gallery.app")
            images = list(directory.glob("EUI-PySide6-Gallery-*.dmg"))
            if len(images) != 1:
                raise ValueError("Expected one macOS disk image.")
            mount = root / "mounted"
            mount.mkdir()
            run("hdiutil", "attach", images[0], "-readonly", "-nobrowse", "-mountpoint", mount)
            try:
                check(mount / "EUI PySide6 Gallery.app")
            finally:
                run("hdiutil", "detach", mount)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Verify the extracted portable archive and installed/mounted application.")
    parser.add_argument("directory", type=Path)
    verify(parser.parse_args().directory.resolve())
