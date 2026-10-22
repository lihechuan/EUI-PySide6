from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl, QFile, QIODevice, QSaveFile
from PySide6.QtNetwork import QNetworkAccessManager, QNetworkRequest, QNetworkReply

from ..utils.file_helpers import local_path

class ImageIO(QObject):
    busyChanged = Signal()
    failed = Signal(str)
    saved = Signal(QUrl)
    progress = Signal("qint64", "qint64")
    busy = Property(bool, lambda self: self._reply is not None, notify=busyChanged)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._network = QNetworkAccessManager(self)
        self._reply = None

    def _write(self, data, destination):
        path = local_path(destination)
        if not path:
            self.failed.emit("A local destination is required")
            return False
        file = QSaveFile(path)
        if not file.open(QIODevice.WriteOnly) or file.write(data) != len(data) or not file.commit():
            self.failed.emit(file.errorString())
            return False
        self.saved.emit(destination)
        return True

    @Slot(QUrl, QUrl, result=bool)
    def save(self, source, destination):
        if self.busy:
            return False
        if source.scheme() in ("http", "https"):
            request = QNetworkRequest(source)
            request.setTransferTimeout(60000)
            self._reply = self._network.get(request)
            reply = self._reply
            reply.downloadProgress.connect(self.progress)
            def finished():
                if reply.error() != QNetworkReply.NoError:
                    self.failed.emit(reply.errorString())
                else:
                    self._write(bytes(reply.readAll()), destination)
                self._reply = None
                self.busyChanged.emit()
                reply.deleteLater()
            reply.finished.connect(finished)
            self.busyChanged.emit()
            return True
        path = ":" + source.path() if source.scheme() == "qrc" else local_path(source)
        file = QFile(path)
        if not file.open(QIODevice.ReadOnly):
            self.failed.emit(file.errorString())
            return False
        return self._write(bytes(file.readAll()), destination)
