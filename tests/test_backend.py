import hashlib
import json
import os
import tempfile
import unittest
from pathlib import Path

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from PySide6.QtCore import QUrl
from PySide6.QtGui import QColor, QGuiApplication
from PySide6.QtQml import QQmlComponent, QQmlEngine

from eui import initialize
from eui.component.EFileUploader import FileUploader
from eui.style.palettes.EPaletteManager import PaletteManager
from eui.utils.ECodeTools import CodeTools
from eui.utils.ETextDocument import TextDocument
from eui_gallery.src.Example3DRuntime import GalleryRuntime
from eui_gallery.src.ExampleUpdater import GalleryUpdater
from eui_gallery.src.bootstrap import install_gallery


class BackendTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = QGuiApplication.instance() or QGuiApplication([])

    def test_palette_meta_types_are_shared(self):
        first, second = PaletteManager(), PaletteManager()
        for name in ("BasePalette", "StatePalette", "ThemePalette"):
            self.assertIs(type(getattr(first, name)), type(getattr(second, name)))

    def test_services_keep_python_state_after_garbage_collection(self):
        engine = QQmlEngine()
        services = initialize(engine)
        gallery = install_gallery(engine, services)
        engine.collectGarbage()
        services["ETheme"].changeTheme()
        self.assertTrue(services["ETheme"].dark)
        self.assertTrue(gallery["exampleCatalog"].find("unknown").isNull())
        self.assertEqual(len(gallery["exampleData"].icons), 1044)

    def test_uploader_reports_readable_local_files(self):
        uploader = FileUploader()
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "hello.txt"
            path.write_text("hello", encoding="utf-8")
            info = uploader.fileInfo(QUrl.fromLocalFile(str(path)))
            self.assertTrue(info["readable"])
            self.assertEqual(info["size"], 5)
            self.assertFalse(uploader.fileInfo(QUrl.fromLocalFile(directory))["readable"])
            self.assertFalse(uploader.fileInfo(QUrl("https://example.test/file"))["readable"])

    def test_highlighting_preserves_unterminated_comments_and_operators(self):
        markup = CodeTools().highlight('Text { text: "<unsafe>&"; value: 2/3 } /* open', {"string": QColor("red")})
        self.assertIn("&lt;unsafe&gt;&amp;", markup)
        self.assertIn("/*&nbsp;open", markup)
        self.assertIn("2/3", markup)

    def test_runtime_reports_bundled_dependency(self):
        runtime = GalleryRuntime()
        self.assertTrue(runtime.installed)
        runtime.confirmReady()
        self.assertEqual(runtime.stage, "ready")

    def test_text_formatting_accepts_qml_color_values(self):
        engine = QQmlEngine()
        component = QQmlComponent(engine)
        component.setData(b'import QtQuick\nTextEdit { text: "hello" }', QUrl())
        root = component.create()
        self.assertIsNotNone(root, component.errorString())
        formatter = TextDocument()
        formatter.document = root.property("textDocument")
        self.assertTrue(formatter.apply(0, 5, "color", QColor("red")))
        self.assertEqual(formatter.formatAt(1)["color"], QColor("red"))
        self.assertFalse(formatter.apply(0, 5, "color", "invalid color"))


class UpdateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = QGuiApplication.instance() or QGuiApplication([])

    def release(self, url=None, size=4):
        base = "https://github.com/lihechuan/EUI-PySide6/releases/download/v9.0.0/"
        name = "eui_pyside6-9.0.0-py3-none-any.whl"
        return dict(tag_name="v9.0.0", assets=[
            dict(name=name, size=size, browser_download_url=url or base + name),
            dict(name="SHA256SUMS", size=100, browser_download_url=base + "SHA256SUMS")])

    def test_new_release_requires_python_wheel_and_checksums(self):
        updater = GalleryUpdater()
        updater._release(json.dumps(self.release()).encode())
        self.assertEqual(updater.stage, "available")
        updater._release(json.dumps(self.release(url="https://untrusted.test/update.whl")).encode())
        self.assertEqual(updater.stage, "failed")
        self.assertEqual(updater.error, "missingPackage")

    def test_oversized_release_is_rejected(self):
        updater = GalleryUpdater()
        updater._release(json.dumps(self.release(size=128 * 1024 * 1024 + 1)).encode())
        self.assertEqual(updater.error, "missingPackage")

    def test_checksum_failure_cannot_install(self):
        updater = GalleryUpdater()
        updater._release(json.dumps(self.release()).encode())
        updater._development = False
        name = updater._asset["name"]
        checksum = hashlib.sha256(b"safe").hexdigest()
        responses = iter([(checksum + "  " + name).encode(), b"evil"])
        updater._request = lambda url, limit, callback: callback(next(responses))
        updater.install()
        self.assertEqual(updater.error, "hashMismatch")
        self.assertIsNone(updater._process)

    def test_source_checkout_cannot_replace_itself(self):
        updater = GalleryUpdater()
        updater._release(json.dumps(self.release()).encode())
        updater._development = True
        updater.install()
        self.assertEqual(updater.error, "developmentBuild")


if __name__ == "__main__":
    unittest.main()
