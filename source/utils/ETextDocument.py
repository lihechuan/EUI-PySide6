from PySide6.QtCore import QObject, Property, Signal, Slot, QUrl, Qt
from PySide6.QtGui import QColor, QFont, QTextCursor, QTextCharFormat, QTextBlockFormat, QTextListFormat
from PySide6.QtQuick import QQuickTextDocument

class TextDocument(QObject):
    documentChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._document = None

    def _set_document(self, value):
        if value is not None and not isinstance(value, QQuickTextDocument):
            raise TypeError("document must be a QQuickTextDocument or None")
        if value is not self._document:
            self._document = value
            self.documentChanged.emit()

    document = Property(QObject, lambda self: self._document, _set_document, notify=documentChanged)

    @Slot(int, result="QVariantMap")
    def formatAt(self, position):
        if not self._document:
            return {}
        doc = self._document.textDocument()
        cursor = QTextCursor(doc)
        cursor.setPosition(max(0, min(position, doc.characterCount() - 1)))
        fmt = cursor.charFormat()
        return dict(bold=fmt.fontWeight() >= QFont.Bold, italic=fmt.fontItalic(), underline=fmt.fontUnderline(), strike=fmt.fontStrikeOut(), color=fmt.foreground().color(), size=fmt.fontPointSize(), alignment=cursor.blockFormat().alignment().value)

    @Slot(int, int, str, "QVariant", result=bool)
    def apply(self, start, end, operation, value):
        doc = self._document.textDocument() if self._document else None
        if doc is None or min(start, end) < 0 or max(start, end) >= doc.characterCount():
            return False
        cursor = QTextCursor(doc)
        cursor.setPosition(min(start, end))
        cursor.setPosition(max(start, end), QTextCursor.KeepAnchor)
        fmt = QTextCharFormat()
        if operation == "bold":
            fmt.setFontWeight(QFont.Bold if value else QFont.Normal)
        elif operation in ("italic", "underline", "strike"):
            getattr(fmt, {"italic": "setFontItalic", "underline": "setFontUnderline", "strike": "setFontStrikeOut"}[operation])(bool(value))
        elif operation == "color" and isinstance(value, (str, QColor)) and QColor(value).isValid():
            fmt.setForeground(QColor(value))
        elif operation == "size" and isinstance(value, (int, float)) and 6 <= value <= 144:
            fmt.setFontPointSize(value)
        elif operation == "family":
            fmt.setFontFamilies([str(value)])
        elif operation == "align" and value in (1, 2, 4, 8):
            block = QTextBlockFormat()
            block.setAlignment(Qt.AlignmentFlag(value))
            cursor.mergeBlockFormat(block)
            return True
        elif operation == "list":
            listing = QTextListFormat()
            listing.setStyle(QTextListFormat.ListDecimal if value == "ordered" else QTextListFormat.ListDisc)
            cursor.createList(listing)
            return True
        elif operation == "link" and QUrl(str(value)).scheme() in ("http", "https", "mailto"):
            fmt.setAnchor(True)
            fmt.setAnchorHref(str(value))
            fmt.setFontUnderline(True)
        elif operation == "clear":
            cursor.setCharFormat(fmt)
            return True
        else:
            return False
        if not cursor.hasSelection():
            cursor.select(QTextCursor.WordUnderCursor)
        cursor.mergeCharFormat(fmt)
        return True
