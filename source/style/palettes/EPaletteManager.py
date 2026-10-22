from PySide6.QtCore import QObject, Property, Slot

from ...state.EComponentStateObject import ComponentState, EComponentStateObject
from .EBasePalette import EBasePalette
from .EThemePalette import EThemePalette
from .EStatePalette import EStatePalette
from .EDefaultPalette import DefaultPalette

class PaletteManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._theme = EThemePalette(self)
        self._base = EBasePalette(self)
        self._state = EStatePalette(self._theme, self)
        self._default = DefaultPalette(self._theme, self)
        self._states = {}

    BasePalette = Property(QObject, lambda self: self._base, constant=True)
    StatePalette = Property(QObject, lambda self: self._state, constant=True)
    ThemePalette = Property(QObject, lambda self: self._theme, constant=True)
    DefaultPalette = Property(QObject, lambda self: self._default, constant=True)

    @Slot(QObject, result=QObject)
    @Slot(QObject, int, result=QObject)
    def createStateObject(self, parent, role=0):
        if parent is None:
            return None
        key = (id(parent), role)
        if key not in self._states:
            self._states[key] = EComponentStateObject(self)
            if parent:
                parent.destroyed.connect(lambda *_, k=key: self._states.pop(k, None))
        else:
            self._states[key].values = ComponentState().values
        return self._states[key]
