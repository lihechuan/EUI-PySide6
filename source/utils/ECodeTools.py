import html
import re
from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QColor, QGuiApplication

class CodeTools(QObject):
    @Slot(str, result=bool)
    def copyText(self, text):
        QGuiApplication.clipboard().setText(text)
        return True

    @Slot(str, "QVariantMap", result=str)
    def highlight(self, code, colors):
        keywords = set("as if on for let new var else case break const while import return signal switch default property readonly continue function".split())
        pattern = r'//[^\n]*|/\*[\s\S]*?(?:\*/|$)|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|`(?:\\.|[^`\\])*`|\b\d+(?:\.\d+)?\b|\b[A-Za-z_]\w*\b|[^\w/]+|/'
        chunks = []
        for match in re.finditer(pattern + "|.", code):
            token = match.group()
            role = "comment" if token.startswith(("//", "/*")) else "string" if token.startswith(('"', "'", "`")) else "keyword" if token in keywords else "literal" if token in ("true", "false", "null", "undefined") else "number" if token[0].isdigit() else "type" if token[0].isupper() else ""
            escaped = html.escape(token).replace("\t", "    ").replace(" ", "&nbsp;").replace("\r\n", "\n").replace("\n", "<br/>")
            color = QColor(colors.get(role, ""))
            chunks.append(f'<span style="color:{color.name()};">{escaped}</span>' if role and color.isValid() else escaped)
        return "".join(chunks)
