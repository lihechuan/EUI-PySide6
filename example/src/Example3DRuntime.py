import importlib.util
import sys

from PySide6.QtCore import QObject, Property, Signal, Slot


class GalleryRuntime(QObject):
    changed = Signal()
    handoffReady = Signal()
    supported = Property(bool, lambda self: self._installed, constant=True)
    installed = Property(bool, lambda self: self._installed, constant=True)
    busy = Property(bool, lambda self: False, constant=True)
    progress = Property(float, lambda self: 1.0 if self._installed else 0.0, constant=True)
    stage = Property(str, lambda self: self._stage, notify=changed)
    error = Property(str, lambda self: self._error, notify=changed)
    platform = Property(str, lambda self: sys.platform, constant=True)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._installed = importlib.util.find_spec("PySide6.QtQuick3D") is not None
        self._stage = "ready" if self._installed else "unavailable"
        self._error = "" if self._installed else "missingDependency"

    @Slot(str, bool)
    def install(self, language="zh", dark=False):
        if self._installed:
            self.confirmReady()
        else:
            self._stage, self._error = "failed", "missingDependency"
            self.changed.emit()

    @Slot()
    def confirmReady(self):
        if self._installed:
            self._stage = "ready"
            self.changed.emit()
            self.handoffReady.emit()
