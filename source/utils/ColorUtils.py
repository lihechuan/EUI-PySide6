from PySide6.QtGui import QColor

def mix(first, second, amount):
    first, second = QColor(first), QColor(second)
    return QColor.fromRgbF(*[
        a + (b - a) * amount
        for a, b in zip(first.getRgbF(), second.getRgbF())
    ])
