import mimetypes
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl, QFile, QIODevice
from PySide6.QtNetwork import QNetworkAccessManager, QNetworkRequest, QNetworkReply, QHttpMultiPart, QHttpPart

class FileUploader(QObject):
    busyChanged = Signal()
    languageChanged = Signal()
    progressChanged = Signal()
    started = Signal(QUrl)
    finished = Signal(QUrl, bool, int, str, str)
    busy = Property(bool, lambda self: self._reply is not None, notify=busyChanged)
    progress = Property(float, lambda self: self._progress, notify=progressChanged)
    language = Property(str, lambda self: self._language, lambda self, value: self._set_language(value), notify=languageChanged)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._network = QNetworkAccessManager(self)
        self._reply = None
        self._progress = 0.
        self._language = "zh"

    def _set_language(self, value):
        if self._language != value:
            self._language = value
            self.languageChanged.emit()

    @Slot()
    def cancel(self):
        if self._reply:
            self._reply.abort()

    @Slot(QUrl, result="QVariantMap")
    def fileInfo(self, url):
        path = Path(url.toLocalFile()) if url.isLocalFile() else None
        if path is None or not path.is_file():
            return dict(valid=False, readable=False, error="A local file is required")
        try:
            with path.open("rb") as stream:
                stream.read(0)
            size = path.stat().st_size
        except OSError as error:
            return dict(valid=False, readable=False, error=str(error))
        mime = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
        return dict(valid=True, readable=True, url=url.toString(), name=path.name, size=size, type=mime, relativePath=path.name)

    @Slot(QUrl, result="QVariantList")
    def directoryFiles(self, url):
        root = Path(url.toLocalFile()) if url.isLocalFile() else None
        if root is None or not root.is_dir():
            return []
        files = []
        for path in sorted(root.rglob("*")):
            if path.is_file() and not path.is_symlink():
                info = self.fileInfo(QUrl.fromLocalFile(str(path)))
                info["relativePath"] = path.relative_to(root.parent).as_posix()
                files.append(info)
        return files

    @Slot(QUrl, QUrl, result=bool)
    @Slot(QUrl, QUrl, str, result=bool)
    @Slot(QUrl, QUrl, str, "QVariantMap", result=bool)
    @Slot(QUrl, QUrl, str, "QVariantMap", "QVariantMap", result=bool)
    @Slot(QUrl, QUrl, str, "QVariantMap", "QVariantMap", str, result=bool)
    @Slot(QUrl, QUrl, str, "QVariantMap", "QVariantMap", str, bool, result=bool)
    def submit(self, file, endpoint, fieldName="file", headers=None, data=None, method="POST", withCredentials=False):
        if self.busy:
            return False
        if endpoint.scheme() not in ("http", "https") or method.upper() not in ("POST", "PUT", "PATCH") or not self.fileInfo(file).get("valid") or not fieldName or any(c in fieldName for c in '\r\n"'):
            self.finished.emit(file, False, 0, "", "Invalid file, endpoint, method or field name")
            return False
        multipart = QHttpMultiPart(QHttpMultiPart.FormDataType)
        for name, value in (data or {}).items():
            if any(c in name for c in '\r\n"'):
                multipart.deleteLater()
                return False
            part = QHttpPart()
            part.setHeader(QNetworkRequest.ContentDispositionHeader, f'form-data; name="{name}"')
            part.setBody(str(value).encode())
            multipart.append(part)
        upload = QFile(file.toLocalFile(), multipart)
        if not upload.open(QIODevice.ReadOnly):
            multipart.deleteLater()
            self.finished.emit(file, False, 0, "", upload.errorString())
            return False
        part = QHttpPart()
        name = Path(file.toLocalFile()).name.replace('"', "_").replace("\r", "_").replace("\n", "_")
        part.setHeader(QNetworkRequest.ContentDispositionHeader, f'form-data; name="{fieldName}"; filename="{name}"')
        part.setHeader(QNetworkRequest.ContentTypeHeader, self.fileInfo(file)["type"])
        part.setBodyDevice(upload)
        multipart.append(part)
        request = QNetworkRequest(endpoint)
        request.setTransferTimeout(60000)
        if not withCredentials:
            request.setAttribute(QNetworkRequest.CookieLoadControlAttribute, QNetworkRequest.Manual)
            request.setAttribute(QNetworkRequest.CookieSaveControlAttribute, QNetworkRequest.Manual)
        for key, value in (headers or {}).items():
            if "\r" in key + str(value) or "\n" in key + str(value):
                multipart.deleteLater()
                return False
            request.setRawHeader(key.encode(), str(value).encode())
        self._reply = self._network.sendCustomRequest(request, method.upper().encode(), multipart)
        reply = self._reply
        multipart.setParent(reply)
        self._progress = 0.
        reply.uploadProgress.connect(self._upload_progress)
        def done():
            status = reply.attribute(QNetworkRequest.HttpStatusCodeAttribute) or 0
            response = bytes(reply.readAll()).decode("utf-8", errors="replace")
            success = reply.error() == QNetworkReply.NoError and 200 <= status < 300
            self._reply = None
            self.busyChanged.emit()
            self.finished.emit(file, success, status, response, "" if success else reply.errorString())
            reply.deleteLater()
        reply.finished.connect(done)
        self.busyChanged.emit()
        self.progressChanged.emit()
        self.started.emit(file)
        return True

    @Slot("qint64", "qint64")
    def _upload_progress(self, sent, total):
        self._progress = sent / total if total > 0 else 0.
        self.progressChanged.emit()
