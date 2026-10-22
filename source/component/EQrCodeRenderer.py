from PySide6.QtCore import Property, Slot, QRectF
from PySide6.QtGui import QColor, QPainter

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class QrCodeRenderer(PaintedItem):
    text = qt_property(str, "text", "", notify=PaintedItem.changed, hook="_encode")
    color = qt_property(QColor, "color", QColor("black"), notify=PaintedItem.changed)
    quietZone = qt_property(int, "quietZone", 4, notify=PaintedItem.changed)
    errorCorrection = qt_property(int, "errorCorrection", 1, notify=PaintedItem.changed, hook="_encode")
    backgroundColor = qt_property(QColor, "backgroundColor", QColor("white"), notify=PaintedItem.changed)
    valid = Property(bool, lambda self: bool(self._matrix), notify=PaintedItem.changed)
    modules = Property(int, lambda self: len(self._matrix), notify=PaintedItem.changed)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._matrix = []

    def _encode(self):
        import qrcode
        from qrcode.exceptions import DataOverflowError
        self._matrix = []
        if self.text:
            levels = (qrcode.constants.ERROR_CORRECT_L, qrcode.constants.ERROR_CORRECT_M, qrcode.constants.ERROR_CORRECT_Q, qrcode.constants.ERROR_CORRECT_H)
            qr = qrcode.QRCode(error_correction=levels[max(0, min(3, self.errorCorrection))], border=0)
            try:
                qr.add_data(self.text)
                qr.make(fit=True)
                self._matrix = qr.get_matrix()
            except DataOverflowError:
                pass

    @Slot(int, int, result=bool)
    def moduleAt(self, x, y):
        return bool(0 <= y < len(self._matrix) and 0 <= x < len(self._matrix) and self._matrix[y][x])

    def paint(self, painter):
        painter.fillRect(self.boundingRect(), self.backgroundColor)
        if not self._matrix:
            return
        quiet = max(0, min(32, self.quietZone))
        size = self.modules + quiet * 2
        scale = min(self.width(), self.height()) / size
        left, top = (self.width() - size * scale) / 2, (self.height() - size * scale) / 2
        painter.setRenderHint(QPainter.Antialiasing, False)
        for y, row in enumerate(self._matrix):
            for x, active in enumerate(row):
                if active:
                    painter.fillRect(QRectF(left + (x + quiet) * scale, top + (y + quiet) * scale, scale, scale), self.color)
