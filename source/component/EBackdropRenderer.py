from PySide6.QtCore import QObject, Property, Signal, Slot, QTimer
from PySide6.QtGui import QColor, QImage, QPainterPath, QBrush
from PySide6.QtQuick import QQuickItem, QQuickWindow

from ..utils.qt import qt_property
from .PaintedItem import PaintedItem

class BackdropRenderer(PaintedItem):
    readyChanged = Signal()
    live = qt_property(bool, "live", False, notify=PaintedItem.changed, hook="refresh")
    radius = qt_property(float, "radius", 8., notify=PaintedItem.changed)
    blurRadius = qt_property(int, "blurRadius", 32, notify=PaintedItem.changed, hook="refresh")
    tintColor = qt_property(QColor, "tintColor", QColor("white"), notify=PaintedItem.changed, hook="refresh")
    tintOpacity = qt_property(float, "tintOpacity", .7, notify=PaintedItem.changed)
    noiseOpacity = qt_property(float, "noiseOpacity", .025, notify=PaintedItem.changed)
    sourceItem = qt_property(QQuickItem, "sourceItem", None, notify=PaintedItem.changed, hook="refresh")
    ready = Property(bool, lambda self: not self._image.isNull(), notify=readyChanged)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._image = QImage()
        self._grab = None
        self._timer = QTimer(self)
        self._timer.timeout.connect(self._capture)
        self.widthChanged.connect(self.refresh)
        self.heightChanged.connect(self.refresh)
        self._window = None
        self._window_connections = []
        self._region = None
        self.windowChanged.connect(self._connect_window)
        self._connect_window(self.window())

    @Slot(QQuickWindow)
    def _connect_window(self, window):
        for connection in self._window_connections:
            QObject.disconnect(connection)
        self._window_connections = []
        self._window = window
        if window:
            self._window_connections = [window.afterAnimating.connect(self._check_region),
                                        window.visibleChanged.connect(self.refresh)]
        self.refresh()

    @Slot()
    def _check_region(self):
        source = self.sourceItem
        if source and (self._image.isNull() or self.mapRectToItem(source, self.boundingRect()) != self._region):
            self._capture()

    @Slot()
    @Slot(bool)
    def refresh(self, *_):
        self._timer.setInterval(50 if self.live else 0)
        self._timer.setSingleShot(not self.live)
        self._timer.start()

    @Slot()
    def _capture(self):
        if self.window() is not self._window:
            self._connect_window(self.window())
        source = self.sourceItem
        if (self._grab is not None or source is None or source is self or not self.window()
                or not self.window().isVisible() or source.width() <= 0 or source.height() <= 0):
            return
        self._grab = source.grabToImage()
        if self._grab:
            self._grab.ready.connect(self._captured)

    @Slot()
    def _captured(self):
        from PIL import Image, ImageFilter
        source = self.sourceItem
        image = self._grab.image()
        self._grab = None
        if source and not image.isNull():
            region = self.mapRectToItem(source, self.boundingRect())
            self._region = region
            sx, sy = image.width() / source.width(), image.height() / source.height()
            image = image.copy(int(region.x() * sx), int(region.y() * sy), max(1, int(region.width() * sx)), max(1, int(region.height() * sy)))
            image = image.convertToFormat(QImage.Format_RGBA8888)
            pil = Image.frombytes("RGBA", (image.width(), image.height()), bytes(image.constBits()))
            pil = pil.filter(ImageFilter.GaussianBlur(max(0, min(128, self.blurRadius)) / 2))
            data = pil.tobytes()
            self._image = QImage(data, pil.width, pil.height, pil.width * 4, QImage.Format_RGBA8888).copy()
            self.readyChanged.emit()
            self.update()

    def paint(self, painter):
        path = QPainterPath()
        path.addRoundedRect(self.boundingRect(), max(0, self.radius), max(0, self.radius))
        painter.setClipPath(path)
        if not self._image.isNull():
            painter.drawImage(self.boundingRect(), self._image)
        color = QColor(self.tintColor)
        color.setAlphaF(max(0, min(1, self.tintOpacity)))
        painter.fillPath(path, color)
        if self.noiseOpacity > 0:
            noise = QImage(32, 32, QImage.Format_ARGB32)
            for y in range(32):
                for x in range(32):
                    n = (x * 137 + y * 149 + x * y * 13) % 256
                    noise.setPixelColor(x, y, QColor(n, n, n, round(max(0, min(1, self.noiseOpacity)) * 255)))
            painter.fillPath(path, QBrush(noise))
