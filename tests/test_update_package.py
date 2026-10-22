import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

import PySide6


@unittest.skipUnless(sys.platform == "win32", "Windows update helper")
class UpdatePackageTests(unittest.TestCase):
    def prepare(self, root, entries, checksum=None):
        target = root / "Gallery"
        target.mkdir()
        (target / "EUI-PySide6-Gallery.exe").write_bytes(b"existing application")
        workspace = root / ".eui-update-test"
        workspace.mkdir()
        package = workspace / "package.zip"
        with zipfile.ZipFile(package, "w") as archive:
            for name, value in entries:
                archive.writestr(name, value)
        job = workspace / "job.json"
        job.write_text(json.dumps(dict(target=str(target), version="1.3.3", pid=os.getpid(), arguments=[],
                                      sha256=checksum or hashlib.sha256(package.read_bytes()).hexdigest())), encoding="utf-8")
        script = Path(__file__).resolve().parents[1] / "example/assets/update/Update.ps1"
        program = Path(os.environ["WINDIR"]) / "System32/WindowsPowerShell/v1.0/powershell.exe"
        result = subprocess.run([str(program), "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass",
                                 "-File", str(script), "-Mode", "prepare", "-Job", str(job)],
                                capture_output=True, timeout=60, creationflags=subprocess.CREATE_NO_WINDOW)
        self.assertEqual((target / "EUI-PySide6-Gallery.exe").read_bytes(), b"existing application")
        return result, workspace

    def test_valid_qt6_archive_is_prepared_without_replacing_running_application(self):
        prefix = "EUI-PySide6-Gallery/"
        core = (Path(PySide6.__file__).parent / "Qt6Core.dll").read_bytes()
        entries = [(prefix + "EUI-PySide6-Gallery.exe", b"new application"),
                   (prefix + "_internal/PySide6/Qt6Core.dll", core),
                   (prefix + "_internal/eui/resources.rcc", b"resource"),
                   (prefix + "_internal/eui_gallery/example.rcc", b"resource")]
        with tempfile.TemporaryDirectory() as directory:
            result, workspace = self.prepare(Path(directory), entries)
            self.assertEqual(result.returncode, 0, result.stderr.decode(errors="replace"))
            self.assertTrue((workspace / prefix / "_internal/eui/resources.rcc").is_file())

    def test_unsafe_incomplete_and_corrupt_archives_are_rejected(self):
        for name in ("EUI-PySide6-Gallery/../../escape.txt", "OtherGallery/app.exe", "EUI-PySide6-Gallery/incomplete.txt"):
            with self.subTest(name=name), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                result, _ = self.prepare(root, [(name, b"payload")])
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse((root / "escape.txt").exists())
        with tempfile.TemporaryDirectory() as directory:
            result, _ = self.prepare(Path(directory), [("EUI-PySide6-Gallery/file", b"tampered")], "0" * 64)
            self.assertNotEqual(result.returncode, 0)
