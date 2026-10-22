import math

from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QJSValue
from PySide6.QtQuick import QQuickItem

from .data_algorithms import ALGORITHMS


def js_array(value, predicate=None):
    if not isinstance(value, QJSValue):
        return list(value or [])
    length = value.property("length")
    if value.isArray() or predicate is not None and predicate.call([value]).toBool():
        return [value.property(i) for i in range(length.toUInt())]
    return []


def js_value(value):
    return value.toVariant() if isinstance(value, QJSValue) else value


class DataUtils(QObject):
    def __init__(self, engine):
        super().__init__(engine)
        self.engine = engine
        self._algorithms = engine.evaluate(ALGORITHMS)
        self._is_array = engine.evaluate("(function(v){return Array.isArray(v)||Object.prototype.toString.call(v)==='[object V4Sequence]'})")
        self._identity = engine.evaluate("(function(){const ids=new WeakMap();let next=0;return function(v){if(v===null||(typeof v!=='object'&&typeof v!=='function'))return '';if(!ids.has(v))ids.set(v,String(++next));return ids.get(v)}})()")

    def array(self, values):
        result = self.engine.newArray(len(values))
        for index, value in enumerate(values):
            result.setProperty(index, value if isinstance(value, QJSValue) else self.engine.toScriptValue(value))
        return result

    def object(self, **values):
        result = self.engine.newObject()
        for key, value in values.items():
            result.setProperty(key, value if isinstance(value, QJSValue) else self.engine.toScriptValue(value))
        return result

    @Slot(QJSValue, result=bool)
    def isArray(self, value):
        return self._is_array.call([value]).toBool()

    def items(self, value):
        return js_array(value, self._is_array)

    @Slot(QJSValue, result=str)
    def objectIdentity(self, value):
        return self._identity.call([value]).toString()

    @Slot(QObject, result="QVariantList")
    def configProviders(self, control):
        pending, seen, result = [control], set(), []
        for current in pending:
            if current is None or id(current) in seen:
                continue
            seen.add(id(current))
            if current != control and current.property("euiConfigProvider"):
                result.append(current)
            if isinstance(current, QQuickItem):
                pending.append(current.parentItem())
            pending.append(current.parent())
        return result

    @Slot(float, int, str, str, result=str)
    def formatNumber(self, value, precision, groupSeparator, decimalSeparator):
        if not math.isfinite(value):
            return ""
        parts = f"{value:,.{max(0, min(20, precision))}f}".split(".")
        return parts[0].replace(",", groupSeparator) + (decimalSeparator + parts[1] if len(parts) > 1 else "")

    @Slot(int, int, int, result=QJSValue)
    def visiblePages(self, pageCount, currentPage, pagerCount):
        pages, count = max(1, pageCount), max(5, min(21, pagerCount))
        if pages <= count:
            return self.array(list(range(1, pages + 1)))
        start = max(2, min(pages - count + 2, max(1, min(pages, currentPage)) - (count - 3) // 2))
        end = min(pages - 1, start + count - 3)
        return self.array([1] + ([0] if start > 2 else []) + list(range(start, end + 1)) + ([0] if end < pages - 1 else []) + [pages])

    @Slot(QJSValue, QJSValue, result=str)
    def cellText(self, row, column):
        value = row
        prop = column.property("prop")
        if prop.isUndefined():
            prop = column.property("property")
        for part in prop.toString().split("."):
            value = value.property(part) if value.isObject() else QJSValue()
        formatter = column.property("formatter")
        if formatter.isCallable():
            result = formatter.call([row, value])
            return "" if result.isError() else result.toString()
        return "" if value.isNull() or value.isUndefined() else value.toString()

    @Slot(QJSValue, str, str, result=QJSValue)
    def tableRows(self, model, prop, order):
        return self._algorithms.property("tableRows").callWithInstance(self._algorithms, [model, prop, order])

    @Slot(QJSValue, float, result=QJSValue)
    def columnWidths(self, columns, availableWidth):
        items = self.items(columns)
        fixed, flexible, minimum, widths = 0, [], 0, []
        for index, column in enumerate(items):
            width = column.property("width").toNumber()
            if math.isfinite(width) and width > 0:
                widths.append(max(40, width))
                fixed += widths[-1]
            else:
                requested = column.property("minWidth").toNumber()
                widths.append(max(40, requested) if math.isfinite(requested) and requested > 0 else 100)
                minimum += widths[-1]
                flexible.append(index)
        extra = max(0, availableWidth - fixed - minimum) / max(1, len(flexible))
        for index in flexible:
            widths[index] += extra
        return self.object(widths=widths, total=sum(widths))

    @Slot(QJSValue, str, result=QJSValue)
    def treeEntry(self, nodes, key):
        return next((node for node in self.items(nodes) if node.property("key").toString() == key), QJSValue(QJSValue.NullValue))

    @Slot(QJSValue, QJSValue, result=QJSValue)
    def treeVisibleNodes(self, nodes, expandedKeys):
        return self._algorithms.property("treeVisibleNodes").callWithInstance(self._algorithms, [nodes, expandedKeys])

    @Slot(QJSValue, QJSValue, bool, result=QJSValue)
    @Slot(QJSValue, QJSValue, bool, int, result=QJSValue)
    @Slot(QJSValue, QJSValue, bool, int, QJSValue, result=QJSValue)
    @Slot(QJSValue, QJSValue, bool, int, QJSValue, bool, result=QJSValue)
    def treeNodes(self, model, expandedKeys, visibleOnly, initialLevel=0, parentPath=None, inheritedDisabled=False):
        return self._algorithms.property("treeNodes").callWithInstance(self._algorithms, [model, expandedKeys, visibleOnly, initialLevel, parentPath or QJSValue(), inheritedDisabled])

    @Slot(QJSValue, QJSValue, bool, result=QJSValue)
    def menuEntries(self, model, openedIndexes, horizontal):
        return self._algorithms.property("menuEntries").callWithInstance(self._algorithms, [model, openedIndexes, horizontal])
