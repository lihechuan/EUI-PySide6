import secrets
from PySide6.QtCore import QObject, Slot

class RandomUtils(QObject):
    @Slot(result=str)
    @Slot(int, result=str)
    def nanoid(self, size=21):
        return "".join(secrets.choice("_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") for _ in range(max(0, min(size, 65536))))
