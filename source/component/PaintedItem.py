from PySide6.QtCore import Signal
from PySide6.QtQuick import QQuickPaintedItem

class PaintedItem(QQuickPaintedItem):
    changed = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._values = {}
        self.setAntialiasing(True)
