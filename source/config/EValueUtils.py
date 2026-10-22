from PySide6.QtCore import QObject, Slot, QDate, QDateTime, QTime, Qt
from PySide6.QtGui import QColor, QKeySequence
from PySide6.QtQml import QJSValue

from ..utils.EDataUtils import js_array


def date_from_text(text):
    date = QDate.fromString(text, "yyyy-MM-dd")
    return date if date.isValid() and date.year() >= 100 and date.toString("yyyy-MM-dd") == text else QDate()


class ValueUtils(QObject):
    def __init__(self, engine):
        super().__init__(engine)
        self.engine = engine
        self._is_array = engine.evaluate("(function(v){return Array.isArray(v)||Object.prototype.toString.call(v)==='[object V4Sequence]'})")

    def items(self, value):
        return js_array(value, self._is_array)

    @Slot(int, result=str)
    def paddedNumber(self, number):
        return str(number).zfill(2)

    @Slot(str, result=str)
    def parseColor(self, text):
        color = QColor(text.strip())
        return color.name(QColor.HexArgb) if color.isValid() else ""

    @Slot(str, result=str)
    def colorName(self, text):
        color = QColor(text.strip())
        if not color.isValid():
            return ""
        return next((name for name in QColor.colorNames() if QColor(name).rgba() == color.rgba()),
                    color.name(QColor.HexRgb if color.alpha() == 255 else QColor.HexArgb))

    @Slot(str, result=QJSValue)
    def parseDate(self, text):
        date = date_from_text(text)
        if not date.isValid():
            return QJSValue(QJSValue.NullValue)
        return self.engine.globalObject().property("Date").callAsConstructor([QJSValue(float(QDateTime(date, QTime(0, 0)).toMSecsSinceEpoch()))])

    @Slot(QJSValue, result=str)
    def formatDate(self, date):
        return date.toDateTime().date().toString("yyyy-MM-dd") if date.isDate() else ""

    @Slot(QJSValue, result="QVariantMap")
    def dateParts(self, date):
        parsed = date.toDateTime().date() if date.isDate() else QDate()
        return {"year": parsed.year(), "month": parsed.month() - 1} if parsed.isValid() else {}

    @Slot(int, int, result=str)
    def shortcutText(self, key, modifiers):
        if key <= 0 or key in (Qt.Key_unknown, Qt.Key_Shift, Qt.Key_Control, Qt.Key_Alt, Qt.Key_Meta, Qt.Key_AltGr):
            return ""
        mask = Qt.ShiftModifier.value | Qt.ControlModifier.value | Qt.AltModifier.value | Qt.MetaModifier.value
        return QKeySequence(key | (modifiers & mask)).toString(QKeySequence.NativeText)

    @Slot(str, bool, result=bool)
    def validTime(self, text, seconds):
        fmt = "HH:mm:ss" if seconds else "HH:mm"
        time = QTime.fromString(text, fmt)
        return time.isValid() and time.toString(fmt) == text

    @Slot(str, bool, result="QVariantMap")
    def parseTime(self, text, seconds):
        time = QTime.fromString(text, "HH:mm:ss" if seconds else "HH:mm") if self.validTime(text, seconds) else QTime(0, 0)
        return dict(hour=time.hour(), minute=time.minute(), second=time.second())

    @Slot(int, int, int, bool, result=str)
    def formatTime(self, hour, minute, second, seconds):
        return QTime(hour, minute, second if seconds else 0).toString("HH:mm:ss" if seconds else "HH:mm")

    @Slot(int, int, int, result="QVariantMap")
    def shiftMonth(self, year, month, offset):
        date = QDate(year, 1, 1).addMonths(month + offset)
        return dict(year=date.year(), month=date.month() - 1) if date.isValid() else dict(year=year, month=month)

    @Slot(QJSValue, str, str, QJSValue, result=bool)
    def dateAllowed(self, date, minimum, maximum, disabledDate):
        key = self.formatDate(date)
        if not key or minimum and (not date_from_text(minimum).isValid() or key < minimum) or maximum and (not date_from_text(maximum).isValid() or key > maximum):
            return False
        return not disabledDate.isCallable() or not disabledDate.call([date]).toBool()

    @Slot(QJSValue, str, bool, result=QJSValue)
    def selectTreeOptions(self, nodes, childrenRole, leavesOnly):
        result, stack = [], [(node, 0, ()) for node in reversed(self.items(nodes))]
        while stack:
            node, depth, ancestors = stack.pop()
            if not node.isObject() or node.property("disabled").toBool() or any(node.strictlyEquals(a) for a in ancestors):
                continue
            children = self.items(node.property(childrenRole))
            if not leavesOnly or not children:
                label, value = node.property("label"), node.property("value")
                entry = self.engine.newObject()
                entry.setProperty("level", depth)
                entry.setProperty("label", "" if label.isNull() or label.isUndefined() else label.toString())
                entry.setProperty("value", label if value.isUndefined() else value)
                result.append(entry)
            stack.extend((child, depth + 1, ancestors + (node,)) for child in reversed(children))
        array = self.engine.newArray(len(result))
        for index, item in enumerate(result):
            array.setProperty(index, item)
        return array
