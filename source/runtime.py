import json
import os
import sys
from pathlib import Path

from PySide6.QtCore import QResource, QUrl
from PySide6.QtGui import QFont, QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlEngine, qmlRegisterModule, qmlRegisterType, qmlRegisterUncreatableType

from . import enum as enums
from .utils.EAnimation import Animation
from .utils.EDataUtils import DataUtils
from .utils.ECodeTools import CodeTools
from .utils.EFilePickerUtils import PickerFileUtils
from .utils.ETableIO import TableIO
from .utils.ETextDocument import TextDocument
from .utils.EImageIO import ImageIO
from .utils.RandomUtils import RandomUtils
from .layout.ELayout import Layout
from .component.EWindowActions import WindowActions
from .component.EEChartsBridge import EChartsBridge
from .component.EFileUploader import FileUploader
from .component.EAdvancedRectangle import AdvancedRectangle
from .component.EBackdropRenderer import BackdropRenderer
from .component.ECaptchaRenderer import CaptchaRenderer
from .component.EChartRenderer import ChartRenderer
from .component.EMasonryLayout import MasonryLayout
from .component.EQrCodeRenderer import QrCodeRenderer
from .component.EShadowRenderer import ShadowRenderer
from .component.EWatermarkRenderer import WatermarkRenderer
from .config.EDefaultConfig import DefaultConfig
from .config.ELocale import Locale
from .config.EValueUtils import ValueUtils
from .state.EComponentStateObject import EComponentStateObject
from .style.ETheme import Theme
from .style.palettes.EPaletteManager import PaletteManager

_registered = False


def prepare_resources():
    root = Path(__file__).parent
    resource = root / "resources.rcc"
    if not QResource.registerResource(str(resource)):
        raise RuntimeError(f"Cannot register resources: {resource}. Run python build/resources.py from the source checkout.")


def register_types():
    global _registered
    if _registered:
        return
    prepare_resources()
    root = Path(__file__).parent
    definitions = json.loads((root / "data/types.json").read_text(encoding="utf-8"))
    for cls, name in ((EComponentStateObject, "EComponentStateObject"), (AdvancedRectangle, "EAdvancedRectangle")):
        qmlRegisterType(cls, "EUI", 1, 0, name)
    for cls, name in ((CodeTools, "CodeTools"), (PickerFileUtils, "PickerFileUtils"), (ImageIO, "ImageIO"), (TextDocument, "TextDocument"), (FileUploader, "FileUploader"), (ShadowRenderer, "ShadowRenderer"), (BackdropRenderer, "BackdropRenderer"), (WatermarkRenderer, "WatermarkRenderer"), (QrCodeRenderer, "QrCodeRenderer"), (ChartRenderer, "ChartRenderer"), (MasonryLayout, "MasonryLayout"), (CaptchaRenderer, "CaptchaRenderer"), (WindowActions, "WindowActions"), (EChartsBridge, "EChartsBridge")):
        qmlRegisterType(cls, "EUI.Private", 1, 0, name)
    for name, path in definitions["public"]:
        qmlRegisterType(QUrl("qrc:/qt/qml/EUI/" + path), "EUI", 1, 0, name)
    for name, path in definitions["private"]:
        qmlRegisterType(QUrl("qrc:/qt/qml/EUI/" + path), "EUI.Private", 1, 0, name)
    for name in definitions["enums"]:
        qmlRegisterUncreatableType(getattr(enums, name), "EUI", 1, 0, name, "Enums only")
    qmlRegisterModule("EUI.Private", 1, 0)
    qmlRegisterModule("EUI", 1, 0)
    _registered = True


def initialize(engine, *, language="zh", dark=False):
    """Register EUI's Python types and install its services on a QML engine."""
    register_types()
    if not QFontDatabase.families() and sys.platform == "win32":
        fonts = Path(os.environ.get("WINDIR", "C:/Windows")) / "Fonts"
        for name in ("msyh.ttc", "segoeui.ttf", "consola.ttf"):
            QFontDatabase.addApplicationFont(str(fonts / name))
    engine.addImportPath(str(Path(__file__).parent / "qml"))
    services = dict(ELocale=Locale(engine), ETheme=Theme(engine), EDefaultConfig=DefaultConfig(engine), EPaletteManager=PaletteManager(engine), EDataUtils=DataUtils(engine), ETableIO=TableIO(engine), EValueUtils=ValueUtils(engine), ELayout=Layout(engine), RandomUtils=RandomUtils(engine), EAnimation=Animation(engine))
    services["ELocale"].language = language
    services["ETheme"].dark = dark
    for name, instance in services.items():
        QQmlEngine.setObjectOwnership(instance, QQmlEngine.CppOwnership)
        engine.rootContext().setContextProperty(name, instance)
    engine.globalObject().setProperty("EDataUtils", engine.newQObject(services["EDataUtils"]))
    QFontDatabase.addApplicationFont(":/qt/qml/EUI/font/EFont.ttf")
    font = QFont(services["EDefaultConfig"].primaryFontFamily)
    font.setPixelSize(14)
    QGuiApplication.setFont(font)
    engine._eui_services = services
    return services
