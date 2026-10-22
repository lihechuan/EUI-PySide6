import argparse
import json
import os
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="EUI PySide6 component gallery")
    parser.add_argument("--dark", action="store_true", help="Use the dark theme")
    parser.add_argument("--language", choices=("zh", "en"), default="zh")
    parser.add_argument("--component", default="", help="Open a component by name, for example ETable")
    parser.add_argument("--smoke-test", action="store_true", help="Load the gallery offscreen and exit")
    parser.add_argument("--update-result", default="", help=argparse.SUPPRESS)
    parser.add_argument("--update-failed", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")
    if args.smoke_test:
        os.environ["QT_QPA_PLATFORM"] = "offscreen"
        os.environ.setdefault("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-gpu")

    from PySide6.QtCore import QProcess, QTimer, QUrl
    from PySide6.QtGui import QGuiApplication, QIcon
    from PySide6.QtQml import QQmlApplicationEngine
    from PySide6.QtWebEngineQuick import QtWebEngineQuick
    from eui import __version__, initialize
    from eui_gallery.src.bootstrap import install_gallery

    QtWebEngineQuick.initialize()
    app = QGuiApplication(sys.argv[:1])
    app.setOrganizationName("EUI-PySide6")
    app.setApplicationName("EUI PySide6 Gallery")
    app.setApplicationVersion(__version__)
    engine = QQmlApplicationEngine()
    services = initialize(engine, language=args.language, dark=args.dark)
    gallery = install_gallery(engine, services)
    def restart():
        if getattr(sys, "frozen", False):
            app.quit()
            return
        arguments = ["-m", "eui", "--language", services["ELocale"].language]
        if services["ETheme"].dark:
            arguments.append("--dark")
        started, _ = QProcess.startDetached(sys.executable, arguments)
        if started:
            app.quit()
        else:
            gallery["exampleUpdater"]._set_stage("failed", "restartFailed")
    gallery["exampleUpdater"].restartReady.connect(restart)
    app.setWindowIcon(QIcon(":/example/eui-mark.svg"))
    if args.component:
        entry = gallery["exampleCatalog"].find(args.component)
        if entry is None:
            parser.error(f"Unknown component: {args.component}")
        engine.setInitialProperties(dict(currentComponent=args.component, currentSource=entry["source"]))
    engine.load(QUrl("qrc:/example/qml/component/App.qml"))
    if not engine.rootObjects():
        return 1
    if args.update_failed:
        gallery["exampleUpdater"]._set_stage("failed", "prepareFailed")
    if args.update_result and getattr(sys, "frozen", False):
        job = Path(args.update_result)
        target = gallery["exampleUpdater"]._desktop_target()
        if (job.name != "job.json" or not job.parent.name.startswith(".eui-update-")
                or job.parent.parent.resolve() != target.parent or job.is_symlink() or job.parent.is_symlink()):
            return 1
        metadata = json.loads(job.read_text(encoding="utf-8"))
        if Path(metadata["target"]).resolve() != target or metadata["version"] != __version__:
            return 1
        QTimer.singleShot(0, lambda: Path(str(job) + ".ready").write_text(__version__, encoding="ascii"))
    if args.smoke_test:
        QTimer.singleShot(1500, app.quit)
    code = app.exec()
    del engine
    return code


if __name__ == "__main__":
    raise SystemExit(main())
