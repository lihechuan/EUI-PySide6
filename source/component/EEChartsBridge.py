import json
from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickWindow

from ..utils.qt import qt_property
from ..style.palettes.EThemePalette import ThemePalette

class EChartsBridge(QObject):
    changed = Signal()
    finished = Signal()
    readyChanged = Signal()
    optionChanged = Signal()
    failed = Signal(str)
    clicked = Signal("QVariantMap")
    dataZoomed = Signal("QVariantMap")
    legendSelected = Signal("QVariantMap")
    renderRequested = Signal(str)
    commandRequested = Signal(str, str)

    dark = qt_property(bool, "dark", False, notify=changed, hook="_schedule")
    language = qt_property(str, "language", "zh", notify=changed, hook="_schedule")
    renderer = qt_property(str, "renderer", "canvas", notify=changed, hook="_schedule")
    pageUrl = Property(QUrl, lambda self: QUrl("qrc:/qt/qml/EUI/charts/chart.html"), constant=True)
    supported = Property(bool, lambda self: QQuickWindow.sceneGraphBackend() != "software", constant=True)
    ready = Property(bool, lambda self: self._ready, notify=readyChanged)
    errorString = Property(str, lambda self: self._error if self.supported else self._backend_error(), notify=changed)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._values = {}
        self._ready = False
        self._error = ""
        self._option = {}
        self._settings = {}
        self._attached = False
        self._dirty = True
        self._timer = QTimer(self)
        self._timer.setSingleShot(True)
        self._timer.timeout.connect(self._publish)

    def _backend_error(self):
        from PySide6.QtCore import QFile, QIODevice
        file = QFile(":/qt/qml/EUI/i18n/" + ("zh" if self.language.lower().startswith("zh") else "en") + ".json")
        if file.open(QIODevice.ReadOnly):
            return json.loads(bytes(file.readAll()))["ChartRequiresOpenGl"]
        return "This chart requires OpenGL."

    @Slot("QVariantMap")
    @Slot("QVariantMap", "QVariantMap")
    def setOption(self, option, settings=None):
        if self._attached and self._dirty and self._timer.isActive():
            self._publish()
        self._option = option
        self._settings = {"notMerge": True} if settings is None else settings
        self._dirty = True
        self._schedule()
        self.optionChanged.emit()

    option = Property("QVariantMap", lambda self: self._option, setOption, notify=optionChanged)

    def _schedule(self):
        self._timer.start(0)

    @Slot()
    def _publish(self):
        if not self._attached:
            return
        self._timer.stop()
        theme = ThemePalette()
        tokens = theme.tokens(self.dark)
        text = dict(color=tokens["textRegular"].name(), fontFamily=QGuiApplication.font().family())
        line = dict(color=tokens["borderDefault"].name())
        axis = dict(axisLabel=text, axisLine=dict(lineStyle=line), splitLine=dict(lineStyle=line))
        palette = dict(color=[theme.fetchColorForStyle(i).name() for i in (1, 2, 4, 5, 3)], textStyle=text, categoryAxis=axis, valueAxis=axis, logAxis=axis, timeAxis=axis, legend=dict(textStyle=text), backgroundColor=tokens["surfaceComponent"].name(), title=dict(textStyle=dict(color=tokens["textPrimary"].name())), tooltip=dict(textStyle=text, borderColor=line["color"], backgroundColor=tokens["surfaceComponent"].name()))
        self.renderRequested.emit(json.dumps(dict(option=self._option, settings=self._settings, theme=palette, dark=self.dark, applyOption=self._dirty, renderer="svg" if self.renderer == "svg" else "canvas", locale="ZH" if self.language.lower().startswith("zh") else "EN")))
        self._dirty = False

    @Slot()
    def attach(self):
        self._attached = True
        self._dirty = True
        self._error = ""
        self.changed.emit()
        self._schedule()

    @Slot()
    def clear(self):
        self._option = {}
        self._dirty = False
        self._timer.stop()
        self.optionChanged.emit()
        if self._ready:
            self.commandRequested.emit("clear", "{}")

    @Slot()
    def resize(self):
        if self._ready:
            self.commandRequested.emit("resize", "{}")

    @Slot(int)
    def terminate(self, exitCode):
        self._attached = False
        self._timer.stop()
        self.report("error", f"Chart process exited: {exitCode}")

    @Slot("QVariantMap")
    def appendData(self, data):
        self._command("appendData", data)

    @Slot("QVariantMap")
    def dispatchAction(self, action):
        self._command("dispatchAction", action)

    def _command(self, name, data):
        if self._ready:
            if self._timer.isActive():
                self._publish()
            self.commandRequested.emit(name, json.dumps(data))

    @Slot(str, str)
    def report(self, event, payload):
        if event in ("ready", "error"):
            self._ready = event == "ready"
            self._error = payload if event == "error" else ""
            self.readyChanged.emit()
            self.changed.emit()
            if event == "error":
                self.failed.emit(payload)
            return
        if event == "finished":
            self.finished.emit()
            return
        signal = {"click": self.clicked, "datazoom": self.dataZoomed, "legendselectchanged": self.legendSelected}.get(event)
        if signal:
            try:
                parameters = json.loads(payload)
            except (TypeError, ValueError):
                parameters = {}
            signal.emit(parameters if isinstance(parameters, dict) else {})
