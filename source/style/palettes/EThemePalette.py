from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QColor

from ...utils.ColorUtils import mix

class ThemePalette(QObject):
    seeds = ("#409eff", "#409eff", "#67c23a", "#909399", "#e6a23c", "#f56c6c")

    def tokens(self, dark):
        surface = QColor("#141414" if dark else "#ffffff")
        return {
            "textPrimary": QColor("#ebeef5" if dark else "#303133"),
            "textRegular": QColor("#c0c4cc" if dark else "#6c6e72"),
            "textDisabled": QColor("#6c6e72" if dark else "#c0c4cc"),
            "textSecondary": QColor("#a8abb2" if dark else "#909399"),
            "surfacePage": surface,
            "surfaceHover": mix(surface, "white", .08) if dark else QColor("#f5f7fa"),
            "surfacePressed": mix(surface, "white", .12) if dark else QColor("#ebeef5"),
            "surfaceDisabled": mix(surface, "white", .06) if dark else QColor("#f5f7fa"),
            "surfaceComponent": mix(surface, "white", .04) if dark else surface,
            "borderHover": QColor("#6c6e72" if dark else "#c0c4cc"),
            "borderDefault": QColor("#4c4d4f" if dark else "#dcdfe6"),
            "borderDisabled": QColor("#414243" if dark else "#e4e7ed"),
            "onDark": QColor("white"), "onLight": QColor("#141414"),
        }

    @Slot(result=QColor)
    @Slot(int, result=QColor)
    def fetchColorForStyle(self, style=1):
        return QColor(self.seeds[style if 0 <= style < 6 else 1])

    @Slot(bool, result=QColor)
    def fetchThemeColor(self, dark):
        return self.tokens(dark)["surfacePage"]

    @Slot(bool, result=QColor)
    def fetchInverseThemeColor(self, dark):
        return QColor("white" if dark else "#141414")

    @Slot(bool, result=QColor)
    def shadowColor(self, dark):
        return QColor("#141414" if dark else "#6c6e72")


def _theme_type():
    attributes = {}
    for name in ("textPrimary", "textRegular", "textSecondary", "textDisabled",
                 "surfaceComponent", "surfaceHover", "surfacePressed", "surfaceDisabled",
                 "borderDefault", "borderHover", "borderDisabled"):
        def value(self, dark, n=name):
            return self.tokens(dark)[n]
        attributes[name] = Slot(bool, result=QColor, name=name)(value)
    return type("EThemePalette", (ThemePalette,), attributes)

EThemePalette = _theme_type()
