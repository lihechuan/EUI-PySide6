from PySide6.QtCore import QObject, Property, Signal, Slot

class Theme(QObject):
    darkChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._dark = False

    def _set_dark(self, value):
        if self._dark != value:
            self._dark = value
            self.darkChanged.emit()

    dark = Property(bool, lambda self: self._dark, _set_dark, notify=darkChanged)

    @Slot()
    def changeTheme(self):
        self._set_dark(not self._dark)

    @Slot(bool)
    def setDark(self, value):
        self._set_dark(value)
