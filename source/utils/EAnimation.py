import json
import math
from pathlib import Path

import shiboken6
from PySide6.QtCore import QObject, Property, Slot, QVariantAnimation, QEasingCurve
from PySide6.QtGui import QMatrix4x4
from PySide6.QtQuick import QQuickItem, QQuickTransform


def bounce_scale(progress):
    if progress < .55:
        return .3 + .82 * progress / .55
    if progress < .75:
        return 1.12 - .2 * (progress - .55) / .2
    if progress < .9:
        return .92 + .12 * (progress - .75) / .15
    return 1.04 - .04 * (progress - .9) / .1


def bounce_offset(progress):
    if progress < .55:
        return 1 - 1.16 * progress / .55
    if progress < .75:
        return -.16 + .24 * (progress - .55) / .2
    return .08 * (1 - progress) / .25


class Controller(QQuickTransform):
    def __init__(self, target, parent):
        super().__init__(parent)
        self.target = target
        self.matrix = QMatrix4x4()
        self.animation = QVariantAnimation(self)
        self.animation.setStartValue(0.)
        self.animation.setEndValue(1.)
        self.animation.valueChanged.connect(self._apply)
        self.animation.finished.connect(self._finished)
        self.opacity = target.opacity()
        self.changes_opacity = False
        self.writing = False
        target.opacityChanged.connect(self._opacity_changed)
        self.appendToItem(target)

    @Slot()
    def _opacity_changed(self):
        if not self.writing:
            self.opacity = self.target.opacity()

    def _write_opacity(self, value):
        self.writing = True
        self.target.setOpacity(value)
        self.writing = False

    def applyTo(self, matrix):
        matrix *= self.matrix

    def stop(self):
        self.animation.stop()
        self.matrix.setToIdentity()
        if shiboken6.isValid(self.target) and self.changes_opacity:
            self._write_opacity(self.opacity)
        self.changes_opacity = False
        self.update()

    def play(self, effect, duration, distance, easing):
        self.stop()
        self.effect = effect
        self.distance = distance
        self.opacity = self.target.opacity()
        self.changes_opacity = effect[1] != "Attention" or effect[0] == "Flash"
        self.animation.setDuration(duration)
        self.animation.setEasingCurve(QEasingCurve.Type(easing))
        self._apply(0.)
        self.animation.start()

    @Slot()
    def _finished(self):
        self._apply(1.)
        self.matrix.setToIdentity()
        self.changes_opacity = self.effect[1] == "Out"
        self.update()

    @Slot("QVariant")
    def _apply(self, progress):
        if not shiboken6.isValid(self.target):
            return
        motion, phase, dx, dy = self.effect
        alpha = max(0., min(1., progress))
        exiting = phase == "Out"
        remaining = progress if exiting else 1 - progress
        x, y, angle, skew, sx, sy = 0., 0., 0., 0., 1., 1.
        ox, oy = self.target.width() / 2, self.target.height() / 2
        opacity = 1 - alpha if exiting else alpha
        pi = math.pi
        if motion in ("Fade", "Slide", "Zoom", "Roll", "LightSpeed"):
            power = remaining * remaining if motion in ("Fade", "Zoom") else remaining
            x, y = dx * self.distance * power, dy * self.distance * power
        if motion in ("Scale", "Zoom"):
            sx = sy = 1 - (.15 if motion == "Scale" else .7) * remaining
        elif motion == "Rotate":
            angle = (90 * dx * dy if dx or dy else 90 if exiting else -90) * remaining
            if dx or dy:
                ox, oy = (0 if dx < 0 else self.target.width()), (0 if dy < 0 else self.target.height())
        elif motion == "Bounce":
            if phase == "Attention":
                y = -self.distance * abs(math.sin(3 * pi * alpha)) * (1 - alpha)
            elif not dx and not dy:
                sx = sy = bounce_scale(1 - alpha if exiting else alpha)
            else:
                offset = self.distance * bounce_offset(1 - alpha if exiting else alpha)
                x, y = dx * offset, dy * offset
        elif motion == "Flip":
            angle = 360 * progress if phase == "Attention" else 90 * remaining
        elif motion == "Shake":
            offset = self.distance * math.sin(6 * pi * alpha) * (1 - alpha)
            x, y = dx * offset, dy * offset
        elif motion == "Pulse":
            sx = sy = 1 + .08 * math.sin(pi * alpha)
        elif motion == "Swing":
            oy = 0
            angle = 18 * math.sin(3 * pi * alpha) * (1 - alpha)
        elif motion == "Tada":
            sx = sy = 1 + .1 * math.sin(pi * alpha)
            angle = 8 * math.sin(10 * pi * alpha) * math.sin(pi * alpha)
        elif motion == "Wobble":
            angle = 10 * math.sin(5 * pi * alpha) * (1 - alpha)
            x = self.distance * math.sin(5 * pi * alpha) * (1 - alpha)
        elif motion == "Jello":
            skew = 12 * math.sin(6 * pi * alpha) * (1 - alpha)
        elif motion == "RubberBand":
            sx = 1 + .3 * math.sin(4 * pi * alpha) * (1 - alpha)
            sy = 1 / sx
        elif motion == "Flash":
            opacity = .25 + .75 * abs(math.cos(3 * pi * alpha))
        elif motion == "HeartBeat":
            sx = sy = 1 + .16 * math.sin(2 * pi * alpha) ** 2 * (1 - alpha)
        elif motion == "HeadShake":
            angle = 8 * math.sin(4 * pi * alpha) * (1 - alpha)
            x = self.distance * math.sin(4 * pi * alpha) * (1 - alpha)
        elif motion == "Spin":
            angle = 360 * progress
        elif motion == "Roll":
            angle = 120 * dx * remaining
        elif motion == "LightSpeed":
            skew = 20 * dx * remaining
        self.matrix.setToIdentity()
        self.matrix.translate(x, y)
        self.matrix.translate(ox, oy)
        self.matrix.rotate(angle, dx if motion == "Flip" else 0, dy if motion == "Flip" else 0, 0 if motion == "Flip" else 1)
        self.matrix.scale(sx, sy)
        shear = QMatrix4x4()
        row = shear.row(0)
        row.setY(math.tan(skew * pi / 180))
        shear.setRow(0, row)
        if motion == "Jello":
            row = shear.row(1)
            row.setX(-math.tan(skew * pi / 180) / 2)
            shear.setRow(1, row)
        self.matrix *= shear
        self.matrix.translate(-ox, -oy)
        if self.changes_opacity:
            self._write_opacity((self.opacity if self.opacity > 0 or exiting or phase == "Attention" else 1.) * opacity)
        self.update()


class Animation(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._effects = json.loads((Path(__file__).resolve().parents[1] / "data/effects.json").read_text(encoding="utf-8"))
        self._controllers = {}

    effects = Property("QStringList", lambda self: list(self._effects), constant=True)

    @Slot(QQuickItem, result=bool)
    def stop(self, target):
        controller = self._controllers.get(id(target))
        if not controller:
            return False
        controller.stop()
        return True

    @Slot(QQuickItem, str, result=bool)
    @Slot(QQuickItem, str, "QVariantMap", result=bool)
    def play(self, target, effect, options=None):
        if target is None or effect not in self._effects or target.thread() != self.thread():
            return False
        options = options or {}
        if set(options) - {"duration", "distance", "easing"}:
            return False
        preset = self._effects[effect]
        easing = QEasingCurve.Linear.value if preset[1] == "Attention" or preset[0] == "Bounce" else QEasingCurve.OutCubic.value
        values = dict(duration=300, distance=24, easing=easing)
        values.update(options)
        for key, maximum in (("duration", 2147483647), ("distance", 1000000), ("easing", QEasingCurve.OutInBounce.value)):
            value = values[key]
            if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value) or not 0 <= value <= maximum or key != "distance" and int(value) != value:
                return False
        key = id(target)
        if key not in self._controllers:
            self._controllers[key] = Controller(target, self)
            target.destroyed.connect(lambda *_, k=key: self._remove(k))
        self._controllers[key].play(preset, int(values["duration"]), values["distance"], int(values["easing"]))
        return True

    def _remove(self, key):
        controller = self._controllers.pop(key, None)
        if controller and shiboken6.isValid(controller):
            controller.animation.stop()
            controller.deleteLater()
