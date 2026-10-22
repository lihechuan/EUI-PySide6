import json
from pathlib import Path
import re
from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtQml import QJSValue

from eui.utils.ECodeTools import CodeTools

ROOT = Path(__file__).resolve().parents[1]

class GalleryData(QObject):
    changed = Signal()

    def __init__(self, locale, parent=None):
        super().__init__(parent)
        self.locale = locale
        self.languages = {
            language: json.loads((ROOT / f"data/gallery-{language}.json").read_text(encoding="utf-8"))
            for language in ("zh", "en")
        }
        self.tools = CodeTools(self)
        self._script_data = {language: {key: parent.toScriptValue(values[key]) for key in ("ui", "models", "samples")}
                             for language, values in self.languages.items()}
        locale.languageChanged.connect(self.changed)

    def data(self, key):
        return self.languages[self.locale.language][key]

    ui = Property(QJSValue, lambda self: self._script_data[self.locale.language]["ui"], notify=changed)
    icons = Property("QVariantList", lambda self: self.data("icons"), constant=True)
    models = Property(QJSValue, lambda self: self._script_data[self.locale.language]["models"], notify=changed)
    samples = Property(QJSValue, lambda self: self._script_data[self.locale.language]["samples"], notify=changed)

    @Slot(str, result=str)
    def codeFor(self, name):
        if not re.fullmatch(r"E\w+", name):
            return ""
        return f"import EUI 1.0\nimport QtQuick\n\n{name} {{\n}}\n"

    @Slot(str, "QVariantMap", result=str)
    def highlightCode(self, code, colors):
        return self.tools.highlight(code, colors)
