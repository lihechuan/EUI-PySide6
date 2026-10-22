from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QColor

class DefaultPalette(QObject):
    def __init__(self, theme, parent=None):
        super().__init__(parent)
        self.theme = theme

    @Slot(result=QColor)
    def resolveThemeBorderColor(self):
        return self.theme.fetchColorForStyle()

    @Slot(bool, result=QColor)
    def resolveThemeBackgroundColor(self, dark):
        return self.theme.fetchThemeColor(dark)
