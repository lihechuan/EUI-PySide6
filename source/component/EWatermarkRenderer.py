import math
from PySide6.QtCore import QPointF, QSizeF, Qt
from PySide6.QtGui import QColor, QFont, QFontMetricsF, QImage, QPainter, QBrush, QTransform

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class WatermarkRenderer(PaintedItem):
    gap = qt_property(QPointF, "gap", QPointF(100, 100), notify=PaintedItem.changed)
    font = qt_property(QFont, "font", QFont(), notify=PaintedItem.changed)
    text = qt_property(str, "text", "", notify=PaintedItem.changed)
    color = qt_property(QColor, "color", QColor("#20000000"), notify=PaintedItem.changed)
    rotate = qt_property(float, "rotate", -22., notify=PaintedItem.changed)
    offset = qt_property(QPointF, "offset", QPointF(), notify=PaintedItem.changed)
    fontGap = qt_property(float, "fontGap", 0., notify=PaintedItem.changed)
    tileSize = qt_property(QSizeF, "tileSize", QSizeF(120, 64), notify=PaintedItem.changed)
    textAlign = qt_property(str, "textAlign", "center", notify=PaintedItem.changed)
    textBaseline = qt_property(str, "textBaseline", "middle", notify=PaintedItem.changed)

    def paint(self, painter):
        width, height = self.tileSize.width() + self.gap.x(), self.tileSize.height() + self.gap.y()
        if not self.text or not math.isfinite(width + height) or min(width, height) <= 0:
            return
        scale = min(1., 2048 / max(width, height))
        image = QImage(max(1, math.ceil(width * scale)), max(1, math.ceil(height * scale)), QImage.Format_ARGB32_Premultiplied)
        image.fill(Qt.transparent)
        tile = QPainter(image)
        tile.scale(image.width() / width, image.height() / height)
        tile.setFont(self.font)
        tile.setPen(self.color)
        metrics = QFontMetricsF(self.font)
        lines = self.text.split("\n")
        block_height = len(lines) * metrics.height() + max(0, len(lines) - 1) * self.fontGap
        for row in range(-1, 2):
            for column in range(-1, 2):
                tile.save()
                tile.translate(column * width + self.tileSize.width() / 2, row * height + self.tileSize.height() / 2)
                tile.rotate(self.rotate)
                baseline = {"top": -self.tileSize.height() / 2 + metrics.ascent(), "hanging": -self.tileSize.height() / 2 + metrics.ascent() * .8, "alphabetic": 0., "ideographic": -metrics.descent(), "bottom": self.tileSize.height() / 2 - block_height + metrics.ascent()}.get(self.textBaseline, -block_height / 2 + metrics.ascent())
                for line in lines:
                    x = -self.tileSize.width() / 2 if self.textAlign == "left" else self.tileSize.width() / 2 - metrics.horizontalAdvance(line) if self.textAlign == "right" else -metrics.horizontalAdvance(line) / 2
                    tile.drawText(QPointF(x, baseline), line)
                    baseline += metrics.height() + self.fontGap
                tile.restore()
        tile.end()
        brush = QBrush(image)
        transform = QTransform()
        transform.translate(self.offset.x(), self.offset.y())
        transform.scale(width / image.width(), height / image.height())
        brush.setTransform(transform)
        painter.fillRect(self.boundingRect(), brush)
