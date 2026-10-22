import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")
os.environ.setdefault("QT_QUICK_CONTROLS_HOVER_ENABLED", "1")
os.environ.setdefault("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-gpu")

from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QQmlEngine
from PySide6.QtQuick import QQuickItem
from PySide6.QtGui import QGuiApplication, QOpenGLContext
from PySide6.QtQuickTest import QUICK_TEST_MAIN_WITH_SETUP
from PySide6.QtWebEngineQuick import QtWebEngineQuick

from eui import initialize
from eui_gallery.src.bootstrap import install_gallery


class Setup(QObject):
    engines = []

    @Slot(QQmlEngine)
    def qmlEngineAvailable(self, engine):
        hints = QGuiApplication.styleHints()
        if hasattr(hints, "setUseHoverEffects"):
            hints.setUseHoverEffects(True)
        QQmlEngine.setObjectOwnership(engine, QQmlEngine.CppOwnership)
        self.engines.append(engine)
        self.engine = engine
        self.services = initialize(engine, language="en")
        self.gallery = install_gallery(engine, self.services)
        engine.rootContext().setContextProperty("galleryTest", self)
        context = QOpenGLContext()
        engine.rootContext().setContextProperty("testOpenGlAvailable", context.create())
        engine.rootContext().setContextProperty("testNativeDialogsAvailable", QGuiApplication.platformName() != "offscreen")

    @Slot(QQuickItem, result=int)
    def cursorShape(self, item):
        return item.window().cursor().shape().value if item and item.window() else 24

    @Slot(QQuickItem, result=int)
    def incubatingObjectCount(self, item):
        controller = self.engine.incubationController() if item else None
        return controller.incubatingObjectCount() if controller else 0

    @Slot(QQuickItem, int, result=bool)
    def seekAnimation(self, item, milliseconds):
        controller = self.services["EAnimation"]._controllers.get(id(item))
        if controller is None:
            return False
        animation = controller.animation
        if milliseconds < animation.duration():
            animation.pause()
        else:
            animation.resume()
        animation.setCurrentTime(milliseconds)
        return True


if __name__ == "__main__":
    QtWebEngineQuick.initialize()
    raise SystemExit(QUICK_TEST_MAIN_WITH_SETUP("eui_pyside6", Setup, sys.argv, str(Path(__file__).parent / "qml")))
