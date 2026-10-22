import json
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot

class Locale(QObject):
    languageChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        directory = Path(__file__).resolve().parents[1] / "qml/EUI/i18n"
        self._translations = {
            key: json.loads((directory / f"{key}.json").read_text(encoding="utf-8"))
            for key in ("zh", "en")
        }
        self._script_texts = {key: parent.toScriptValue(value) for key, value in self._translations.items()} if hasattr(parent, "toScriptValue") else self._translations
        self._language = "zh"

    def _set_language(self, value):
        language = "zh" if value.lower().startswith("zh") else "en"
        if language != self._language:
            self._language = language
            self.languageChanged.emit()

    language = Property(str, lambda self: self._language, _set_language, notify=languageChanged)
    texts = Property("QVariant", lambda self: self._script_texts[self._language], notify=languageChanged)

    @Slot(str, result="QVariantMap")
    def textsForLanguage(self, language):
        return self._translations["zh" if language.lower().startswith("zh") else "en"]
