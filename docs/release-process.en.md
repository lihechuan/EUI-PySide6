# Local and GitHub release process

[简体中文](release-process.zh-CN.md) | English · [Usage guide](guide.en.md)

Read the version from `project.version` in `pyproject.toml` and keep `source.__version__` synchronized. Write commit messages in English and update both language versions of the documentation. Release notes contain only a short numbered list of added, changed, or fixed features.

| Target | Installer | Portable |
| --- | --- | --- |
| Windows x64 | `*-windows-x64-setup.exe` | `*-windows-x64-portable.zip` |
| macOS Intel | `*-macos-x64.dmg` | `*-macos-x64-portable.zip` |
| macOS Apple Silicon | `*-macos-arm64.dmg` | `*-macos-arm64-portable.zip` |
| Python library | `eui_pyside6-*.whl` | `eui_pyside6-*.tar.gz` (source) |

The desktop prefix is `EUI-PySide6-Gallery-VERSION`. Windows x86 is excluded. Desktop packages include Python, PySide6/Qt, and required resources. A wheel installs dependencies with pip. Keep the complete portable directory or macOS app bundle together.

## Local build

Build on the target operating system and architecture with 64-bit Python 3.12. Windows requires Inno Setup 6 (`ISCC` on PATH or `ISCC_EXE`). macOS uses system `codesign`, `ditto`, and `hdiutil`.

```powershell
python -m venv build/package-venv
.\build\package-venv\Scripts\python.exe -m pip install -r packaging/requirements.txt
.\build\package-venv\Scripts\python.exe -m pip install --no-deps -e .
.\build\package-venv\Scripts\python.exe -m unittest discover -s tests -p "test_*.py"
.\build\package-venv\Scripts\python.exe tests/run_all.py --jobs 1
.\build\package-venv\Scripts\python.exe packaging/package.py
.\build\package-venv\Scripts\python.exe -m build
```

On macOS use `./build/package-venv/bin/python`. The build regenerates resources, freezes the Gallery, checks isolated startup, and creates packages, checksums, and build information in `dist/`. macOS bundles use ad-hoc signatures without Developer ID signing or notarization. Windows installers are not Authenticode signed.

## GitHub publication

Follow EUI's release sequence: push to `master`, build all targets, collect packages and `SHA256SUMS.txt`, create a draft release, upload files, download each file again and verify SHA-256, then publish. The `vVERSION` tag and release refer to the exact source commit.

An unpublished version is retried on subsequent `master` pushes. Published versions are preserved. Pull requests and manual workflow runs build without publishing. Tag pushes must match the project version. Confirm Actions logs, public release visibility, all eight packages, and the checksum manifest before reporting completion.

Packaged Gallery updates use the platform portable archive and checksum manifest. Source checkouts are protected from replacement. Preserve the executable and archive layout in future versions.
