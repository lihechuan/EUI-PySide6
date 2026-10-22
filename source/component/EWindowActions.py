from PySide6.QtCore import QObject, Slot, Qt
from PySide6.QtGui import QWindow
from PySide6.QtQuick import QQuickItem

def window_for(item):
    if isinstance(item, QWindow):
        return item
    if isinstance(item, QQuickItem):
        return item.window()
    return item.property("window") if item else None


class WindowActions(QObject):
    @Slot(QQuickItem, result=bool)
    def move(self, item):
        window = window_for(item)
        return bool(window and window.startSystemMove())

    @Slot(QQuickItem, int, result=bool)
    def resize(self, item, edges):
        window = window_for(item)
        return bool(window and window.startSystemResize(Qt.Edge(edges)))

    @Slot(QQuickItem)
    def close(self, item):
        window = window_for(item)
        if window:
            window.close()

    @Slot(QQuickItem)
    def minimize(self, item):
        window = window_for(item)
        if window:
            window.showMinimized()

    @Slot(QQuickItem)
    def toggleMaximized(self, item):
        window = window_for(item)
        if window:
            window.showNormal() if window.windowState() == Qt.WindowMaximized else window.showMaximized()

    @Slot(QQuickItem)
    def toggleFullScreen(self, item):
        window = window_for(item)
        if window:
            window.showNormal() if window.windowState() == Qt.WindowFullScreen else window.showFullScreen()
