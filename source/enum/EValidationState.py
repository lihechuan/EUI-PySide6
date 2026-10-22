from enum import IntEnum
from PySide6.QtCore import QObject, QEnum

class EValidationState(QObject):
    State = IntEnum("State", {
        'None': 0,
        'Success': 1,
        'Warning': 2,
        'Error': 3,
    })
    QEnum(State)
