import os
import sys
import tomllib
from pathlib import Path

from PyInstaller.utils.hooks import collect_data_files, collect_submodules, copy_metadata

root = Path(SPECPATH).parent
package_path = os.environ["EUI_FREEZE_PYTHON"]
sys.path.insert(0, package_path)
version = tomllib.loads((root / "pyproject.toml").read_text(encoding="utf-8"))["project"]["version"]
name = "EUI-PySide6-Gallery"
datas = collect_data_files("eui") + collect_data_files("eui_gallery")
for package in ("PySide6", "PySide6-Essentials", "PySide6-Addons", "shiboken6", "Pillow", "qrcode"):
    datas += copy_metadata(package)
hiddenimports = collect_submodules("eui") + collect_submodules("eui_gallery.src")
hiddenimports += ["PySide6.QtSvg", "PySide6.QtQuick3D", "PySide6.QtMultimedia",
                  "PySide6.QtWebChannel", "PySide6.QtWebEngineCore", "PySide6.QtWebEngineQuick"]
a = Analysis([str(root / "main.py")], pathex=[package_path, str(root)], datas=datas,
             hiddenimports=hiddenimports, excludes=["PySide6.QtQuickTest", "PySide6.QtTest", "tkinter"])
pyz = PYZ(a.pure)
exe = EXE(pyz, a.scripts, [], exclude_binaries=True, name=name, console=False,
          icon=str(root / "assets/eui-icon.ico") if sys.platform == "win32" else None,
          disable_windowed_traceback=False)
collection = COLLECT(exe, a.binaries, a.datas, strip=False, upx=False, name=name)
if sys.platform == "darwin":
    app = BUNDLE(collection, name="EUI PySide6 Gallery.app",
                 bundle_identifier="cn.easy-ui.pyside6.gallery",
                 info_plist={"CFBundleShortVersionString": version, "NSHighResolutionCapable": True})
