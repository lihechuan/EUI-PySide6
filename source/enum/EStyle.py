from enum import IntEnum
from PySide6.QtCore import QObject, QEnum

class EStyle(QObject):
    Component = IntEnum("Component", {
        'Default': 0,
        'Primary': 1,
        'Success': 2,
        'Info': 3,
        'Warning': 4,
        'Danger': 5,
    })
    QEnum(Component)

    System = IntEnum("System", {
        'Light': 0,
        'Dark': 1,
    })
    QEnum(System)

    Size = IntEnum("Size", {
        'Small': 0,
        'Medium': 1,
        'Large': 2,
    })
    QEnum(Size)

    Role = IntEnum("Role", {
        'Uncertain': 0,
        'BorderColor': 1,
        'TextColor': 2,
        'Color': 3,
        'BackgroundColor': 4,
    })
    QEnum(Role)
