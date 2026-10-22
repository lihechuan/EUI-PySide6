from PySide6.QtCore import Signal
from PySide6.QtQuick import QQuickItem

from ..utils.qt import qt_property

class MasonryLayout(QQuickItem):
    changed = Signal()
    columns = qt_property(int, "columns", 3, notify=changed, hook="polish")
    spacing = qt_property(float, "spacing", 12., notify=changed, hook="polish")

    def __init__(self, parent=None):
        super().__init__(parent)
        self._values = {}
        self._watched = set()
        self.childrenChanged.connect(self.polish)
        self.widthChanged.connect(self.polish)

    def updatePolish(self):
        columns = max(1, min(128, self.columns))
        spacing = max(0, self.spacing)
        width = max(0, (self.width() - spacing * (columns - 1)) / columns)
        heights = [0.] * columns
        for child in self.childItems():
            if id(child) not in self._watched:
                self._watched.add(id(child))
                child.heightChanged.connect(self.polish)
                child.visibleChanged.connect(self.polish)
            if not child.isVisible():
                continue
            column = min(range(columns), key=lambda c: heights[c])
            child.setX(column * (width + spacing))
            child.setY(heights[column])
            child.setWidth(width)
            heights[column] += child.height() + spacing
        self.setImplicitHeight(max(0, max(heights) - spacing))
