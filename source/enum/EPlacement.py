from enum import IntEnum
from PySide6.QtCore import QObject, QEnum

class EPlacement(QObject):
    Position = IntEnum("Position", {
        'TopLeft': 0,
        'Top': 1,
        'TopRight': 2,
        'Left': 3,
        'Center': 4,
        'Right': 5,
        'BottomLeft': 6,
        'Bottom': 7,
        'BottomRight': 8,
    })
    QEnum(Position)
