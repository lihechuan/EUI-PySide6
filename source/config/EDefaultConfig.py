from PySide6.QtCore import QObject, Property, Slot
from PySide6.QtGui import QFontDatabase

class DefaultConfig(QObject):
    font = Property(str, lambda self: "EIcons", constant=True)
    fontLib = Property(str, lambda self: "qrc:/qt/qml/EUI/font/EFont.ttf", constant=True)
    primaryFontFamily = Property(str, lambda self: self._primary_font, constant=True)
    secondaryFontFamily = Property(str, lambda self: self._secondary_font, constant=True)

    def __init__(self, parent=None):
        super().__init__(parent)
        families = set(QFontDatabase.families())
        self._primary_font = next((family for family in ("Microsoft YaHei UI", "Microsoft YaHei", "Segoe UI") if family in families), QFontDatabase.systemFont(QFontDatabase.GeneralFont).family())
        self._secondary_font = next((family for family in ("Consolas", "Menlo") if family in families), QFontDatabase.systemFont(QFontDatabase.FixedFont).family())

    @Slot(int, result=int)
    def iconSize(self, size):
        return 12 if size == 0 else 14

    @Slot(int, result=int)
    def controlFontPixelSize(self, size):
        return 12 if size == 0 else 14

    @Slot(int, result=int)
    def controlHeight(self, size):
        return (24, 32, 40)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=int)
    def switchHeight(self, size):
        return (16, 20, 24)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=int)
    def sliderTrackSize(self, size):
        return (4, 6, 8)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=int)
    def sliderHandleSize(self, size):
        return (12, 16, 20)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=int)
    def horizontalPadding(self, size):
        return (11, 15, 19)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=int)
    def selectionIndicatorSize(self, size):
        return (12, 14, 16)[size if size in (0, 1, 2) else 1]

    @Slot(int, result=str)
    def iconGraphic(self, value):
        from ..enum.EIcons import EIcons
        try:
            path = f":/qt/qml/EUI/font/icons/{EIcons.IconType(value).name}.svg"
            from PySide6.QtCore import QFile
            return f"qrc{path}" if QFile.exists(path) else ""
        except ValueError:
            return ""
