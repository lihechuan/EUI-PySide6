from PySide6.QtCore import QRectF, Qt
from PySide6.QtGui import QColor, QPainterPath, QPen
from PySide6.QtQml import QJSValue

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class AdvancedRectangle(PaintedItem):
    color = qt_property(QColor, "color", QColor("white"), notify=PaintedItem.changed)
    radius = qt_property("QVariant", "radius", [0, 0, 0, 0], notify=PaintedItem.changed)
    borderWidth = qt_property(float, "borderWidth", 0., notify=PaintedItem.changed)
    borderColor = qt_property(QColor, "borderColor", QColor("#409eff"), notify=PaintedItem.changed)
    borderStyle = qt_property(int, "borderStyle", 1, notify=PaintedItem.changed)
    dashPattern = qt_property("QVariantList", "dashPattern", [], notify=PaintedItem.changed)

    def paint(self, painter):
        rect = self.boundingRect()
        if rect.isEmpty():
            return
        border = min(max(0, self.borderWidth), rect.width(), rect.height())
        rect.adjust(border / 2, border / 2, -border / 2, -border / 2)
        radius = self.radius.toVariant() if isinstance(self.radius, QJSValue) else self.radius
        radius = [radius] * 4 if isinstance(radius, (int, float)) else radius or []
        radii = [max(0, float(v)) for v in (list(radius) + [0] * 4)[:4]]
        scale = min([1.] + [length / total for length, total in [(rect.width(), radii[0] + radii[1]), (rect.width(), radii[3] + radii[2]), (rect.height(), radii[0] + radii[3]), (rect.height(), radii[1] + radii[2])] if total > 0])
        tl, tr, br, bl = [v * scale for v in radii]
        path = QPainterPath()
        path.moveTo(rect.left() + tl, rect.top())
        path.lineTo(rect.right() - tr, rect.top())
        if tr:
            path.arcTo(QRectF(rect.right() - 2 * tr, rect.top(), 2 * tr, 2 * tr), 90, -90)
        path.lineTo(rect.right(), rect.bottom() - br)
        if br:
            path.arcTo(QRectF(rect.right() - 2 * br, rect.bottom() - 2 * br, 2 * br, 2 * br), 0, -90)
        path.lineTo(rect.left() + bl, rect.bottom())
        if bl:
            path.arcTo(QRectF(rect.left(), rect.bottom() - 2 * bl, 2 * bl, 2 * bl), 270, -90)
        path.lineTo(rect.left(), rect.top() + tl)
        if tl:
            path.arcTo(QRectF(rect.left(), rect.top(), 2 * tl, 2 * tl), 180, -90)
        path.closeSubpath()
        painter.fillPath(path, self.color)
        if border and self.borderColor.alpha():
            pen = QPen(self.borderColor, border, Qt.PenStyle(self.borderStyle))
            if self.dashPattern and self.borderStyle in (2, 6):
                pen.setDashPattern(self.dashPattern)
            painter.strokePath(path, pen)
