from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QGuiApplication

class Clipboard(QObject):
    @Slot(str)
    def setText(self, text):
        QGuiApplication.clipboard().setText(text)
