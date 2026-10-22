from pathlib import Path
from PySide6.QtCore import QObject, Slot, QUrl, QIODevice, QSaveFile, QSettings
from PySide6.QtGui import QGuiApplication, QPdfWriter, QTextDocument
from PySide6.QtPrintSupport import QPrinter, QPrinterInfo

from .file_helpers import result, local_path

class TableIO(QObject):
    @Slot(result=str)
    def clipboardText(self):
        return QGuiApplication.clipboard().text()

    @Slot(str, result=bool)
    def setClipboardText(self, text):
        QGuiApplication.clipboard().setText(text)
        return QGuiApplication.clipboard().text() == text

    @Slot(QUrl, result="QVariantMap")
    def readText(self, url):
        path = local_path(url)
        if not path:
            return result(False, "A local file is required")
        try:
            if Path(path).stat().st_size > 64 * 1024 * 1024:
                return result(False, "The input exceeds 64 MiB")
            return result(True, text=Path(path).read_text(encoding="utf-8-sig", errors="replace"))
        except OSError as error:
            return result(False, str(error))

    @Slot(QUrl, str, result="QVariantMap")
    def writeText(self, url, text):
        path = local_path(url)
        if not path:
            return result(False, "A local file is required")
        output = QSaveFile(path)
        if not output.open(QIODevice.WriteOnly):
            return result(False, output.errorString())
        data = text.encode("utf-8")
        if output.write(data) != len(data) or not output.commit():
            return result(False, output.errorString())
        return result(True)

    @Slot(QUrl, result="QVariantMap")
    def readWorkbook(self, url):
        from .workbook import read_workbook
        try:
            return read_workbook(local_path(url))
        except (OSError, ValueError, KeyError) as error:
            return result(False, str(error))

    @Slot(QUrl, "QVariantList", result="QVariantMap")
    def writeWorkbook(self, url, matrix):
        from .workbook import write_workbook
        try:
            return write_workbook(local_path(url), matrix)
        except (OSError, ValueError) as error:
            return result(False, str(error))

    @Slot(str, result="QVariantMap")
    def loadLayout(self, key):
        return QSettings("EUI-PySide6", "TableLayouts").value(key, {}) if key else {}

    @Slot(str, "QVariantMap", result=bool)
    def saveLayout(self, key, layout):
        if not key:
            return False
        settings = QSettings("EUI-PySide6", "TableLayouts")
        if layout:
            settings.setValue(key, layout)
        else:
            settings.remove(key)
        settings.sync()
        return settings.status() == QSettings.NoError

    @Slot(str, QUrl, result="QVariantMap")
    @Slot(str, QUrl, str, result="QVariantMap")
    def printHtml(self, markup, url, printerName=""):
        path = local_path(url)
        document = QTextDocument()
        document.setHtml(markup)
        if path:
            output = QSaveFile(path)
            if not output.open(QIODevice.WriteOnly):
                return result(False, output.errorString())
            writer = QPdfWriter(output)
            document.print_(writer)
            del writer
            return result(output.commit(), output.errorString())
        if QGuiApplication.platformName() == "offscreen" or printerName not in QPrinterInfo.availablePrinterNames():
            return result(False, "The printer is unavailable")
        printer = QPrinter(QPrinter.HighResolution)
        printer.setPrinterName(printerName)
        document.print_(printer)
        return result(True)
