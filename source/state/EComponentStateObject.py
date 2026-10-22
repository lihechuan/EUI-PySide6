from PySide6.QtCore import QObject, Property, Slot
from PySide6.QtGui import QColor

class ComponentState(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.values = {
            "dark": False, "plain": False, "border": False,
            "color": QColor("transparent"), "hovered": False, "pressed": False,
            "enabled": True, "isFound": False, "textButton": False,
            "activeFocus": False, "componentStyle": 0, "isOpenBackgroundColor": False,
        }


def _state_type():
    attributes = {}
    defaults = ComponentState().values
    for name, default in defaults.items():
        attributes[name] = Property(type(default), lambda self, n=name: self.values[n],
                                    lambda self, value, n=name: self.values.__setitem__(n, value))
        def setter(self, value, n=name):
            self.values[n] = value
            return self
        slot_name = "set" + name[0].upper() + name[1:]
        attributes[slot_name] = Slot(type(default), result=QObject, name=slot_name)(setter)
    attributes["disabled"] = Property(bool, lambda self: not self.values["enabled"],
                                      lambda self, value: self.values.__setitem__("enabled", not value))
    return type("EComponentStateObject", (ComponentState,), attributes)


EComponentStateObject = _state_type()
