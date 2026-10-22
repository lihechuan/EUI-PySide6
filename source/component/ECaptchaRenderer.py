import secrets
from PySide6.QtCore import Slot, QPointF, QRectF, Qt
from PySide6.QtGui import QColor, QFont

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class CaptchaRenderer(PaintedItem):
    color = qt_property(QColor, "color", QColor("#303133"), notify=PaintedItem.changed)
    length = qt_property(int, "length", 4, notify=PaintedItem.changed, hook="refresh")
    backgroundColor = qt_property(QColor, "backgroundColor", QColor("white"), notify=PaintedItem.changed)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setImplicitSize(160, 48)
        self.refresh()

    @Slot()
    def refresh(self):
        self._values["length"] = max(1, min(12, self.length))
        self._code = "".join(secrets.choice("23456789ABCDEFGHJKLMNPQRSTUVWXYZ") for _ in range(self.length))
        self.changed.emit()
        self.update()

    @Slot(str, result=bool)
    def verify(self, text):
        return text.upper() == self._code

    def paint(self, painter):
        painter.fillRect(self.boundingRect(), self.backgroundColor)
        cell = self.width() / self.length
        font = QFont(painter.font())
        font.setBold(True)
        font.setPixelSize(max(1, round(min(cell, self.height()) * .6)))
        painter.setFont(font)
        painter.setPen(self.color)
        for index, char in enumerate(self._code):
            painter.save()
            painter.translate(cell * (index + .5), self.height() / 2)
            painter.rotate(ord(char) % 17 - 8)
            painter.drawText(QRectF(-cell / 2, -self.height() / 2, cell, self.height()), Qt.AlignCenter, char)
            painter.restore()
        painter.save()
        painter.setOpacity(.2)
        for index in range(6):
            y = self.height() * (index + 1) / 7
            painter.drawLine(QPointF(0, y), QPointF(self.width(), self.height() - y))
        painter.restore()
