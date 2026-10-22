import math
from PySide6.QtCore import QPointF, QRectF, Qt
from PySide6.QtGui import QColor, QPainterPath, QPen

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class ChartRenderer(PaintedItem):
    type = qt_property(int, "type", 0, notify=PaintedItem.changed)
    color = qt_property(QColor, "color", QColor("#409eff"), notify=PaintedItem.changed)
    model = qt_property("QVariantList", "model", [], notify=PaintedItem.changed)
    gridColor = qt_property(QColor, "gridColor", QColor("#dcdfe6"), notify=PaintedItem.changed)
    textColor = qt_property(QColor, "textColor", QColor("#6c6e72"), notify=PaintedItem.changed)

    def paint(self, painter):
        plot = self.boundingRect().adjusted(52, 12, -12, -32)
        if plot.isEmpty():
            return
        values = []
        for index, entry in enumerate(self.model):
            record = entry if isinstance(entry, dict) else {"value": entry}
            try:
                value = float(record.get("value"))
            except (TypeError, ValueError):
                continue
            if math.isfinite(value):
                values.append((value, str(record.get("label", index + 1))))
        minimum = min([0.] + [v for v, _ in values])
        maximum = max([0.] + [v for v, _ in values])
        if minimum == maximum:
            maximum = minimum + 1
        magnitude = max(1, abs(minimum), abs(maximum))
        low, high = minimum / magnitude, maximum / magnitude
        span = high - low
        painter.save()
        font = painter.font()
        font.setPixelSize(11)
        painter.setFont(font)
        for tick in range(5):
            y = plot.bottom() - plot.height() * tick / 4
            painter.setPen(self.gridColor)
            painter.drawLine(QPointF(plot.left(), y), QPointF(plot.right(), y))
            painter.setPen(self.textColor)
            painter.drawText(QRectF(0, y - 8, plot.left() - 8, 16), Qt.AlignRight | Qt.AlignVCenter, f"{(low + span * tick / 4) * magnitude:.4g}")
        if values:
            spacing = plot.width() / len(values)
            baseline = plot.bottom() + plot.height() * low / span
            def point(index):
                return QPointF(plot.left() + spacing * (index + .5), plot.bottom() - plot.height() * (values[index][0] / magnitude - low) / span)
            path = QPainterPath(point(0))
            stride = max(1, math.ceil(len(values) / max(1, plot.width())))
            for index in range(0, len(values), stride):
                sample = range(index, min(len(values), index + stride))
                bottom, top = min(sample, key=lambda i: values[i][0]), max(sample, key=lambda i: values[i][0])
                if self.type == 1:
                    width = max(1, spacing * stride * .6)
                    y1, y2 = min(point(top).y(), baseline), max(point(bottom).y(), baseline)
                    painter.fillRect(QRectF(point(top).x() - width / 2, y1, width, y2 - y1), self.color)
                else:
                    for i in sorted({bottom, top}):
                        path.lineTo(point(i))
            if self.type != 1:
                path.lineTo(point(len(values) - 1))
                if self.type == 2:
                    area = QPainterPath(path)
                    area.lineTo(point(len(values) - 1).x(), baseline)
                    area.lineTo(point(0).x(), baseline)
                    area.closeSubpath()
                    fill = QColor(self.color)
                    fill.setAlphaF(fill.alphaF() * .16)
                    painter.fillPath(area, fill)
                painter.setPen(QPen(self.color, 2))
                painter.drawPath(path)
                if len(values) == 1:
                    painter.setBrush(self.color)
                    painter.drawEllipse(point(0), 3, 3)
            painter.setPen(self.textColor)
            stride = max(1, math.ceil(len(values) / max(1, plot.width() / 70)))
            for index in range(0, len(values), stride):
                painter.drawText(QRectF(point(index).x() - 35, plot.bottom() + 8, 70, 20), Qt.AlignHCenter | Qt.AlignTop, values[index][1])
        painter.restore()
