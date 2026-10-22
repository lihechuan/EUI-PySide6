from PySide6.QtCore import QObject, Property
from PySide6.QtGui import QColor

def _base_palette_type():
    colors = dict(blue="#409eff", black="#141414", white="#ffffff", silver="#c0c4cc",
                  manatee="#a8abb2", darkGray="#303133", gainsboro="#dcdfe6", lightGray="#a8abb2",
                  slateGray="#6c6e72", ghostWhite="#f5f7fa", romanSilver="#909399", transparent="transparent",
                  charcoalGray="#4c4d4f", modalOverlay="#80000000", modelessOverlay="#00000000")
    return type("EBasePalette", (QObject,), {
        key: Property(QColor, lambda self, color=value: QColor(color), constant=True)
        for key, value in colors.items()
    })

EBasePalette = _base_palette_type()
