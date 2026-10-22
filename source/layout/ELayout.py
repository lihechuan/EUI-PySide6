import shiboken6
from PySide6.QtCore import QObject, Slot, QPointF
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickItem

from ..component.EWindowActions import window_for

class Layout(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._components = {}

    def _base(self, placement, component):
        from ..enum import EPlacement
        names = {v.value: v.name for v in EPlacement.Position}
        name = names.get(placement, "")
        item = component if isinstance(component, QQuickItem) else component.property("contentItem")
        window = window_for(item)
        width, height = (window.width(), window.height()) if window else (QGuiApplication.primaryScreen().size().width(), QGuiApplication.primaryScreen().size().height())
        w, h = float(component.property("width") or 0), float(component.property("height") or 0)
        x = 10 if "Left" in name or name == "Left" else width - w - 10 if "Right" in name or name == "Right" else (width - w) / 2
        y = 10 if name.startswith("Top") else height - h - 10 if name.startswith("Bottom") else (height - h) / 2
        return QPointF(x, y), window, name.startswith("Bottom")

    @Slot(int, QObject, result=QPointF)
    def calculatePosition(self, placement, component):
        if not component:
            return QPointF()
        entries = [entry for entry in self._components.get(placement, []) if shiboken6.isValid(entry)]
        point, window, bottom = self._base(placement, component)
        offset = 0
        for entry in entries:
            if entry is component:
                break
            _, other, _ = self._base(placement, entry)
            if other is window:
                offset += float(entry.property("height") or 0) + 10
        if component not in entries:
            entries.append(component)
        self._components[placement] = entries
        point.setY(point.y() + (-offset if bottom else offset))
        return point

    @Slot(int, QObject, result="QVariantList")
    def releasePosition(self, placement, component):
        entries = [entry for entry in self._components.get(placement, []) if shiboken6.isValid(entry) and entry is not component]
        self._components[placement] = entries
        for entry in entries:
            point = self.calculatePosition(placement, entry)
            entry.setProperty("targetX", point.x())
            entry.setProperty("targetY", point.y())
        return entries
