

from .ExampleData import GalleryData
from .ExampleCatalog import GalleryCatalog
from .ExampleClipboard import Clipboard
from .ExampleUpdater import GalleryUpdater
from .Example3DRuntime import GalleryRuntime
from pathlib import Path

from PySide6.QtCore import QResource
from PySide6.QtQml import QQmlEngine

def install_gallery(engine, services):
    resource = Path(__file__).resolve().parents[1] / "example.rcc"
    if not QResource.registerResource(str(resource)):
        raise RuntimeError(f"Cannot register Gallery resources: {resource}")
    data = GalleryData(services["ELocale"], engine)
    gallery = dict(exampleData=data, exampleCatalog=GalleryCatalog(data, engine), exampleClipboard=Clipboard(engine),
                   exampleUpdater=GalleryUpdater(engine), exampleRuntime=GalleryRuntime(engine))
    for name, instance in gallery.items():
        QQmlEngine.setObjectOwnership(instance, QQmlEngine.CppOwnership)
        engine.rootContext().setContextProperty(name, instance)
    engine.rootContext().setContextProperty("galleryAsyncLoading", True)
    from eui import __version__
    engine.rootContext().setContextProperty("galleryVersion", __version__)
    engine._gallery_services = gallery
    return gallery
