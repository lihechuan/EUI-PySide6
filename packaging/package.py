import argparse
import hashlib
import importlib.metadata
import json
import os
import platform
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

from github_release import read_version

ROOT = Path(__file__).resolve().parents[1]
NAME = "EUI-PySide6-Gallery"


def run(*arguments, **options):
    subprocess.run([str(value) for value in arguments], check=True, **options)


def target_platform():
    machine = platform.machine().lower()
    if sys.platform == "win32" and machine in ("amd64", "x86_64"):
        return "windows-x64"
    if sys.platform == "darwin" and machine in ("x86_64", "arm64"):
        return "macos-" + ("x64" if machine == "x86_64" else "arm64")
    raise ValueError("Desktop packaging supports Windows x64 and macOS x64/arm64.")


def copy_licenses(destination):
    destination.mkdir(parents=True, exist_ok=True)
    files = {
        "LICENSE": "EUI-LICENSE.txt",
        "THIRD_PARTY_NOTICES.md": "THIRD_PARTY_NOTICES.md",
        "source/thirdparty/echarts/LICENSE": "ECharts-LICENSE.txt",
        "source/thirdparty/echarts/NOTICE": "ECharts-NOTICE.txt",
        "source/qml/EUI/font/icons/LICENSE": "Skill-Icons-LICENSE.txt",
        "example/quick3d/littlest-tokyo/assets/ATTRIBUTION.md": "LittlestTokyo-ATTRIBUTION.md",
    }
    for source, name in files.items():
        shutil.copy2(ROOT / source, destination / name)
    for source in (ROOT / "packaging/licenses").glob("*.txt"):
        if not source.name.startswith("OpenSSL"):
            shutil.copy2(source, destination / source.name)
    for package in ("PySide6", "PySide6-Essentials", "PySide6-Addons", "shiboken6", "Pillow", "qrcode", "PyInstaller"):
        distribution = importlib.metadata.distribution(package)
        for file in distribution.files or []:
            if "license" in file.name.lower() or file.name in ("COPYING.txt", "COPYRIGHT.txt"):
                source = Path(distribution.locate_file(file))
                if source.is_file():
                    target = destination / package / str(file).split("dist-info/")[-1]
                    target.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(source, target)


def archive_windows(directory, archive):
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as output:
        for file in sorted(directory.rglob("*")):
            if file.is_file():
                output.write(file, file.relative_to(directory.parent).as_posix())


def inno_compiler():
    candidates = [shutil.which("ISCC"), os.environ.get("ISCC_EXE")]
    for base in ("LOCALAPPDATA", "ProgramFiles(x86)", "ProgramFiles"):
        if os.environ.get(base):
            parent = Path(os.environ[base])
            candidates += [parent / "Programs/Inno Setup 6/ISCC.exe", parent / "Inno Setup 6/ISCC.exe"]
    return next((Path(path) for path in candidates if path and Path(path).is_file()), None)


def checksums(files, destination):
    records = []
    for file in sorted(files):
        with file.open("rb") as stream:
            records.append(hashlib.file_digest(stream, "sha256").hexdigest() + "  " + file.name)
    destination.write_text("\n".join(records) + "\n", encoding="ascii")


def main():
    parser = argparse.ArgumentParser(description="Build the standalone EUI-PySide6 Gallery packages.")
    parser.add_argument("--skip-freeze", action="store_true", help="Reuse the already frozen application.")
    args = parser.parse_args()
    target = target_platform()
    version = read_version((ROOT / "pyproject.toml").read_text(encoding="utf-8"))
    output = ROOT / "dist"
    stage = ROOT / "build/desktop" / target
    stage.mkdir(parents=True, exist_ok=True)
    output.mkdir(exist_ok=True)
    if not args.skip_freeze:
        run(sys.executable, ROOT / "build/resources.py")
        with tempfile.TemporaryDirectory(prefix="freeze-python-", dir=ROOT / "build") as directory:
            run(sys.executable, "-m", "pip", "install", "--no-deps", "--target", directory, ROOT)
            environment = dict(os.environ, EUI_FREEZE_PYTHON=directory)
            run(sys.executable, "-m", "PyInstaller", "--noconfirm", "--clean",
                "--distpath", stage, "--workpath", ROOT / "build/pyinstaller" / target,
                ROOT / "packaging/gallery.spec", cwd=ROOT, env=environment)
    prefix = f"{NAME}-{version}-{target}"
    archive = output / (prefix + "-portable.zip")
    if target.startswith("windows"):
        directory = stage / NAME
        copy_licenses(directory / "licenses")
        run(sys.executable, ROOT / "packaging/check_package.py", directory)
        archive_windows(directory, archive)
        compiler = inno_compiler()
        if not compiler:
            raise FileNotFoundError("Install Inno Setup 6 or set ISCC_EXE to ISCC.exe.")
        run(compiler, "/Qp", "/DAppVersion=" + version, "/DAppArchitecture=x64",
            "/DPackageDir=" + str(directory), "/DOutputDir=" + str(output), ROOT / "packaging/windows.iss")
        installer = output / (prefix + "-setup.exe")
    else:
        directory = stage / "EUI PySide6 Gallery.app"
        copy_licenses(directory / "Contents/Resources/licenses")
        run("codesign", "--force", "--deep", "--sign", "-", directory)
        run("codesign", "--verify", "--deep", "--strict", directory)
        run(sys.executable, ROOT / "packaging/check_package.py", directory)
        run("ditto", "-c", "-k", "--sequesterRsrc", "--keepParent", directory, archive)
        image = stage / "dmg"
        image.mkdir(exist_ok=True)
        app = image / directory.name
        if app.exists():
            if app.is_symlink() or not app.resolve().is_relative_to(stage.resolve()):
                raise ValueError("Unexpected DMG staging path.")
            shutil.rmtree(app)
        shutil.copytree(directory, app, symlinks=True)
        applications = image / "Applications"
        if not applications.exists():
            applications.symlink_to("/Applications")
        installer = output / (prefix + ".dmg")
        run("hdiutil", "create", "-volname", "EUI PySide6 Gallery", "-srcfolder", image,
            "-format", "UDZO", "-ov", installer)
    checksums([installer, archive], output / "SHA256SUMS.txt")
    info = {"version": version, "platform": target, "python": platform.python_version(),
            "pyside6": importlib.metadata.version("PySide6"),
            "pyinstaller": importlib.metadata.version("PyInstaller")}
    (output / "BUILD-INFO.json").write_text(json.dumps(info, indent=2) + "\n", encoding="utf-8")
    print("Created", installer.name, "and", archive.name)


if __name__ == "__main__":
    main()
