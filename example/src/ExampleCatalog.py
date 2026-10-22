import json
import importlib.util
from copy import deepcopy
from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtQml import QJSValue

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class GalleryCatalog(QObject):
    groupsChanged = Signal()

    def __init__(self, data, parent=None):
        super().__init__(parent)
        self.data = data
        self.api = json.loads((ROOT / "data/component-api.json").read_text(encoding="utf-8"))
        data.changed.connect(self.groupsChanged)

    groups = Property("QVariantList", lambda self: self.data.data("groups"), notify=groupsChanged)
    quick3DAvailable = Property(bool, lambda self: importlib.util.find_spec("PySide6.QtQuick3D") is not None, constant=True)

    @Slot(str, result="QVariant")
    def find(self, index):
        return next((entry for group in self.groups for entry in group["children"] if entry["index"] == index), QJSValue(QJSValue.NullValue))

    @Slot(str, result="QVariantList")
    def filtered(self, query):
        term = query.strip().casefold()
        if not term:
            return self.groups
        results = []
        for i, group in enumerate(self.groups):
            variants = [self.data.languages[language]["groups"][i] for language in ("zh", "en")]
            match_group = any(term in variant["text"].casefold() for variant in variants)
            children = [entry for j, entry in enumerate(group["children"])
                        if match_group or term in entry["index"].casefold()
                        or any(term in variant["children"][j]["label"].casefold() for variant in variants)]
            if children:
                results.append(dict(group, children=children))
        return results

    @Slot(str, result="QVariantList")
    def breadcrumb(self, index):
        path = ["组件目录" if self.data.locale.language == "zh" else "Components"]
        for group in self.groups:
            for entry in group["children"]:
                if entry["index"] == index:
                    return path + [group["text"], entry["label"]]
        return path

    @Slot(str, result="QVariantMap")
    def documentation(self, index):
        result = deepcopy(self.api.get(index, {}))
        result.setdefault("properties", [])
        for row in result.get("properties", []):
            row["defaultValue"] = row.pop("default", {}).get(self.data.locale.language, "")
            for field in ("description", "details"):
                row[field] = row.get(field, {}).get(self.data.locale.language, "")
        return result

    @Slot(str, result=str)
    def quick3DSource(self, name):
        if name not in ("TokyoView.qml", "TokyoScene.qml", "assets/LittlestTokyo.qml"):
            return ""
        return (ROOT / "quick3d/littlest-tokyo" / name).read_text(encoding="utf-8")
