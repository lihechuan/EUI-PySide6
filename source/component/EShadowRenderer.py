from PySide6.QtCore import Qt
from PySide6.QtGui import QColor, QPen

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class ShadowRenderer(PaintedItem):
    color = qt_property(QColor, "color", QColor("#6c6e72"), notify=PaintedItem.changed)
    radius = qt_property(float, "radius", 4., notify=PaintedItem.changed)
    elevation = qt_property(int, "elevation", 8, notify=PaintedItem.changed)

    def paint(self, painter):
        elevation = max(0, min(32, self.elevation))
        painter.save()
        painter.setBrush(Qt.NoBrush)
        for layer in range(elevation, 0, -1):
            distance = elevation - layer + .5
            painter.setOpacity(.012 * layer)
            painter.setPen(QPen(self.color, 1))
            painter.drawRoundedRect(self.boundingRect().adjusted(distance, distance, -distance, -distance), self.radius + layer, self.radius + layer)
        painter.restore()
