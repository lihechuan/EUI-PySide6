from enum import IntEnum
from PySide6.QtCore import QObject, QEnum

class EOrientation(QObject):
    Direction = IntEnum("Direction", {
        'Horizontal': 0,
        'Vertical': 1,
    })
    QEnum(Direction)
