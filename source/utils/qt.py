from copy import deepcopy

from PySide6.QtCore import Property


def qt_property(kind, name, default, *, notify, readonly=False, hook=None):
    """A Qt property backed by an instance dictionary and a shared change signal."""
    def get(self):
        if name not in self._values:
            self._values[name] = deepcopy(default)
        return self._values[name]

    def set_value(self, value):
        if self._values.get(name, default) == value:
            return
        self._values[name] = value
        if hook:
            getattr(self, hook)()
        self.changed.emit()
        if hasattr(self, "update"):
            self.update()

    return Property(kind, get, None if readonly else set_value, notify=notify)
