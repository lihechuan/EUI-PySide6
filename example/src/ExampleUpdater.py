import hashlib
import json
import re
import sys
from pathlib import Path

from PySide6.QtCore import QObject, Property, QProcess, QTemporaryDir, QUrl, Signal, Slot
from PySide6.QtNetwork import QNetworkAccessManager, QNetworkReply, QNetworkRequest

from eui import __version__


class GalleryUpdater(QObject):
    changed = Signal()
    restartReady = Signal()

    busy = Property(bool, lambda self: self._stage in ("checking", "checksums", "downloading", "extracting"), notify=changed)
    error = Property(str, lambda self: self._error, notify=changed)
    stage = Property(str, lambda self: self._stage, notify=changed)
    progress = Property(float, lambda self: self._progress, notify=changed)
    currentVersion = Property(str, lambda self: __version__, constant=True)
    latestVersion = Property(str, lambda self: self._latest, notify=changed)

    repository = "lihechuan/EUI-PySide6"

    def __init__(self, parent=None):
        super().__init__(parent)
        self._error, self._stage, self._progress = "", "idle", 0.0
        self._latest = __version__
        self._asset = self._sums = None
        self._network = QNetworkAccessManager(self)
        self._reply = self._workspace = self._process = None
        self._development = (Path(__file__).resolve().parents[2] / "pyproject.toml").exists()

    def _set_stage(self, stage, error="", progress=0.0):
        self._stage, self._error, self._progress = stage, error, progress
        self.changed.emit()

    def _request(self, url, limit, callback):
        request = QNetworkRequest(QUrl(url))
        request.setTransferTimeout(60000)
        request.setRawHeader(b"User-Agent", b"EUI-PySide6")
        reply = self._network.get(request)
        self._reply = reply
        content = bytearray()

        def read():
            content.extend(bytes(reply.readAll()))
            if len(content) > limit:
                reply.abort()
            if self._stage == "downloading":
                self._progress = min(.85, .05 + len(content) / limit * .8)
                self.changed.emit()

        def finished():
            read()
            self._reply = None
            try:
                status = reply.attribute(QNetworkRequest.HttpStatusCodeAttribute)
                if reply.error() != QNetworkReply.NoError or len(content) > limit:
                    self._set_stage("failed", "notPublished" if status == 404 else "networkFailed")
                else:
                    callback(bytes(content))
            except (OSError, ValueError, TypeError, KeyError):
                self._set_stage("failed", "invalidRelease")
            finally:
                reply.deleteLater()

        reply.readyRead.connect(read)
        reply.finished.connect(finished)

    @Slot()
    def check(self):
        if self.busy:
            return
        self._asset = self._sums = None
        self._set_stage("checking")
        self._request(f"https://api.github.com/repos/{self.repository}/releases/latest", 1024 * 1024, self._release)

    def _release(self, payload):
        self._asset = self._sums = None
        release = json.loads(payload)
        version = str(release["tag_name"]).removeprefix("v")
        if not re.fullmatch(r"\d+\.\d+\.\d+", version) or release.get("prerelease") or release.get("draft"):
            self._set_stage("failed", "invalidRelease")
            return
        self._latest = version
        if tuple(map(int, version.split("."))) <= tuple(map(int, __version__.split("."))):
            self._set_stage("current")
            return
        filename = f"eui_pyside6-{version}-py3-none-any.whl"
        for asset in release["assets"]:
            name, url = asset["name"], asset["browser_download_url"]
            if not url.startswith(f"https://github.com/{self.repository}/releases/download/"):
                continue
            if name == filename and 0 < asset["size"] <= 128 * 1024 * 1024:
                self._asset = asset
            elif name in ("SHA256SUMS", "SHA256SUMS.txt"):
                self._sums = url
        self._set_stage("available" if self._asset and self._sums else "failed", "" if self._asset and self._sums else "missingPackage")

    @Slot()
    @Slot(str)
    @Slot(str, bool)
    def install(self, language="zh", dark=False):
        if self.busy or self._stage != "available":
            return
        if self._development:
            self._set_stage("failed", "developmentBuild")
            return
        self._set_stage("checksums")

        def checksums(payload):
            expected = next((parts[0].lower() for line in payload.decode("utf-8").splitlines()
                             if len(parts := line.split()) == 2 and parts[1].lstrip("*") == self._asset["name"]), "")
            if not re.fullmatch(r"[a-f0-9]{64}", expected):
                self._set_stage("failed", "invalidChecksum")
                return
            self._set_stage("downloading", progress=.05)

            def downloaded(data):
                if len(data) != self._asset["size"] or hashlib.sha256(data).hexdigest() != expected:
                    self._set_stage("failed", "hashMismatch")
                    return
                self._workspace = QTemporaryDir()
                if not self._workspace.isValid():
                    self._set_stage("failed", "writeFailed")
                    return
                path = Path(self._workspace.path()) / self._asset["name"]
                path.write_bytes(data)
                self._set_stage("extracting", progress=.9)
                self._process = QProcess(self)
                self._process.finished.connect(self._installed)
                self._process.errorOccurred.connect(lambda _: self._set_stage("failed", "prepareFailed"))
                self._process.start(sys.executable, ["-m", "pip", "install", "--no-index", "--no-deps", "--force-reinstall", "--disable-pip-version-check", str(path)])

            self._request(self._asset["browser_download_url"], self._asset["size"], downloaded)

        self._request(self._sums, 1024 * 1024, checksums)

    @Slot(int, QProcess.ExitStatus)
    def _installed(self, code, status):
        if code == 0 and status == QProcess.NormalExit:
            self._set_stage("completed", progress=1.0)
            self.restartReady.emit()
        else:
            self._set_stage("failed", "prepareFailed")
