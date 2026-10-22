from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QColor

from ...utils.ColorUtils import mix

class StatePalette(QObject):
    def __init__(self, theme, parent=None):
        super().__init__(parent)
        self.theme = theme

    def _resolve(self, state, role, effective=False):
        if state is None:
            return QColor()
        s = state.values
        tokens = self.theme.tokens(s["dark"])
        style = s["componentStyle"] if not effective or s["isFound"] else 0
        color = s["color"] if not effective or s["isFound"] else QColor("transparent")
        custom = color.isValid() and color.alpha() > 0
        interaction = 3 if not s["enabled"] else 2 if s["pressed"] else 1 if s["hovered"] or s["activeFocus"] else 0
        if not custom and style == 0:
            if role == "text":
                return tokens["textDisabled"] if interaction == 3 else self.theme.fetchColorForStyle(1) if interaction else tokens["textRegular"]
            if role == "border":
                return tokens["borderDisabled"] if interaction == 3 else mix(self.theme.fetchColorForStyle(1), tokens["onLight"], .2) if interaction == 2 else self.theme.fetchColorForStyle(1) if interaction else tokens["borderDefault"]
            return tokens["surfaceDisabled"] if interaction == 3 else mix(self.theme.fetchColorForStyle(1), tokens["surfacePage"], .8 if interaction == 2 else .9) if interaction else tokens["surfaceComponent"]
        seed = color if custom else self.theme.fetchColorForStyle(style)
        variant = "text" if s["textButton"] else "plain" if s["plain"] else "solid"
        if role == "text" and (variant == "solid" or variant == "plain" and interaction in (1, 2)):
            return tokens["onDark"]
        tones = (0, .3, -.2, .5) if variant == "solid" else (.5, 0, -.2, .8) if role == "border" else (0, 0, -.2, .5) if role == "text" or variant == "text" else (.9, 0, -.2, .9)
        amount = tones[interaction]
        return mix(seed, tokens["onDark"] if s["dark"] else tokens["onLight"], -amount) if amount < 0 else mix(seed, tokens["surfacePage"], amount)

    @Slot(int, result=QColor)
    def validationColor(self, value):
        return self.theme.fetchColorForStyle({1: 2, 2: 4, 3: 5}.get(value, 0)) if value in (1, 2, 3) else QColor("transparent")

    @Slot(QObject, result=QColor)
    def resolveRectBorderColor(self, state):
        if not state:
            return QColor()
        s = state.values
        return self.theme.tokens(s["dark"])["borderDisabled"] if not s["enabled"] else self.theme.fetchColorForStyle(s["componentStyle"]) if s["activeFocus"] else self.theme.tokens(s["dark"])["borderHover" if s["hovered"] else "borderDefault"]

    @Slot(QObject, result=QColor)
    def resolveRectBackgroundColor(self, state):
        return self.theme.tokens(state.values["dark"])["surfaceComponent" if state.values["enabled"] else "surfaceDisabled"] if state else QColor()

    @Slot(QObject, result=QColor)
    def resolveSwitchOffColor(self, state):
        return self.resolveRectBorderColor(state)

    @Slot(QObject, result=QColor)
    def defaultTextColor(self, state):
        return self.theme.tokens(state.values["dark"])["textRegular" if state.values["enabled"] else "textDisabled"] if state else QColor()

    @Slot(QObject, result=QColor)
    def resolveEffectiveTextColor(self, state):
        if not state:
            return QColor()
        s = state.values
        return s["color"] if s["color"].isValid() and s["color"].alpha() else self.theme.fetchColorForStyle(s["componentStyle"]) if s["componentStyle"] else self.theme.tokens(s["dark"])["textPrimary"]

    @Slot(QObject, result=QColor)
    def adjustPlainTextButtonColor(self, state):
        if not state:
            return QColor()
        s = state.values
        if not s["enabled"]:
            return s["color"] if s["isOpenBackgroundColor"] else QColor("transparent")
        return self.theme.tokens(s["dark"])["surfacePressed" if s["pressed"] else "surfaceHover"] if s["pressed"] or s["hovered"] or s["isOpenBackgroundColor"] else QColor("transparent")


def _state_palette_type():
    attributes = {}
    for name, role, effective in [
        ("computeTextColor", "text", True), ("computeEffectiveTextColor", "text", False),
        ("computeBorderColor", "border", False), ("computeBackgroundColor", "background", False),
        ("resolveEffectiveBorderColor", "border", True), ("resolveEffectiveBackgroundColor", "background", True),
    ]:
        def value(self, state, r=role, e=effective):
            return self._resolve(state, "border" if r == "background" and state and state.values["border"] else r, e)
        attributes[name] = Slot(QObject, result=QColor, name=name)(value)
    return type("EStatePalette", (StatePalette,), attributes)

EStatePalette = _state_palette_type()
