from PySide6.QtCore import QUrl

def result(ok, message="", text="", **values):
    return dict(ok=ok, message=message, text=text, **values)


def local_path(url):
    url = QUrl(url)
    return url.toLocalFile() if url.isLocalFile() else url.toString() if not url.scheme() else ""
