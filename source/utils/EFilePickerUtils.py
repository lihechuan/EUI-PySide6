from pathlib import Path
from PySide6.QtCore import QObject, Slot, QUrl

class PickerFileUtils(QObject):
    @Slot(QUrl, result=str)
    def filePath(self, url):
        return str(Path(url.toLocalFile())) if url.isLocalFile() else url.toDisplayString()

    @Slot("QVariantList", str, bool, result="QVariantMap")
    def selection(self, urls, mode, multiple):
        def rejected(reason):
            return dict(valid=False, reason=reason)
        if mode not in ("open", "save", "folder"):
            return rejected("invalid-mode")
        if not urls:
            return rejected("empty-selection")
        normalized = []
        for value in urls:
            url = QUrl(value)
            if not url.isValid() or not url.isLocalFile() or url.hasQuery() or url.hasFragment():
                return rejected("invalid-url")
            path = Path(url.toLocalFile())
            if not path.is_absolute():
                return rejected("invalid-path")
            if mode == "open" and not path.is_file():
                return rejected("not-a-file")
            if mode == "folder" and not path.is_dir():
                return rejected("not-a-folder")
            if mode == "save" and (path.is_dir() or not path.parent.is_dir()):
                return rejected("invalid-save-target")
            encoded = QUrl.fromLocalFile(str(path.resolve())).toString(QUrl.FullyEncoded)
            if encoded not in normalized:
                normalized.append(encoded)
        if len(normalized) > 1 and (mode != "open" or not multiple):
            return rejected("multiple-not-allowed")
        return dict(valid=True, urls=normalized)
