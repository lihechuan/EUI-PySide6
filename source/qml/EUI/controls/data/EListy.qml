import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQml.Models 2.15
import QtQuick.Controls

ListView {
    id: control

    property var items: []
    property var group: null
    property var rowKey: "key"
    property int indexOffset: 0
    property real overscan: 120
    property bool sticky: false
    property bool virtual: true
    property Component itemDelegate: null
    property Component groupHeaderDelegate: null

    readonly property var rows: dataset.rows
    readonly property var dataset: buildRows()
    readonly property string errorString: dataset.error

    signal itemClicked(var item, int index)

    function groupFor(identifier) {
        return rows.find(function(row) {
            return row.groupId === identifier
        }) || null
    }

    function keyFor(item, index) {
        if (typeof rowKey === "function")
            return rowKey(item, index)

        return item && typeof item === "object" && item[rowKey] !== undefined ? item[rowKey] : index
    }

    function syncSections() {
        if (!sectionModel || sectionModel.sourceRows === rows)
            return
        sectionModel.sourceRows = rows
        sectionModel.clear()
        rows.forEach(function(row) {
            sectionModel.append({groupId: row.groupId})
        })
    }

    function buildRows() {
        if (!EDataUtils.isArray(items))
            return {
            "rows": [],
            "error": "items must be an array"
        }

        try {
            const buckets = new Map()
            const result = []
            items.forEach(function(item, index) {
                const sourceIndex = index + indexOffset
                const key = keyFor(item, sourceIndex)
                if (!group) {
                    result.push({
                        "item": item,
                        "sourceIndex": sourceIndex,
                        "key": key,
                        "groupId": "",
                        "groupKey": null,
                        "groupTitle": ""
                    })
                    return
                }
                const groupKey = typeof group.key === "function" ? group.key(item)
                    : typeof group.key === "string" && item ? item[group.key]
                    : undefined
                if (groupKey === undefined)
                    throw new Error("group.key must resolve a group key")

                if (!buckets.has(groupKey))
                    buckets.set(groupKey, [])

                buckets.get(groupKey).push({
                    "item": item,
                    "sourceIndex": sourceIndex,
                    "key": key
                })
            })
            let groupIndex = 0
            buckets.forEach(function(bucket, groupKey) {
                const title = typeof group.title === "function"
                    ? group.title(groupKey, bucket.map(function(row) {
                    return row.item
                })) : String(groupKey)
                bucket.forEach(function(row) {
                    row.groupKey = groupKey
                    row.groupId = String(groupIndex)
                    row.groupTitle = title === null || title === undefined ? "" : String(title)
                    result.push(row)
                })
                ++groupIndex
            })
            return {
                "rows": result,
                "error": ""
            }
        } catch (error) {
            return {
                "rows": [],
                "error": String(error)
            }
        }
    }

    function scrollTo(config) {
        if (!enabled)
            return false

        syncSections()
        forceLayout()
        const options = typeof config === "number" ? {
            "top": config
        } : config || {
            "top": 0
        }
        if (typeof options !== "object")
            return false

        if (options.key !== undefined || options.groupKey !== undefined) {
            const matches = []
            for (let index = 0; index < rows.length; ++index) {
                if (options.key !== undefined ? rows[index].key === options.key
                    : rows[index].groupKey === options.groupKey)
                    matches.push(index)

            }
            if (!matches.length || options.key !== undefined && matches.length !== 1)
                return false

            const alignment = options.align || "auto"
            if (["top", "bottom", "auto"].indexOf(alignment) < 0)
                return false

            const offset = options.offset === undefined ? 0 : Number(options.offset)
            if (!isFinite(offset))
                return false

            positionViewAtIndex(matches[0], alignment === "top" ? ListView.Beginning
                : alignment === "bottom" ? ListView.End
                : ListView.Contain)
            contentY = Math.max(originY, Math.min(originY
                + Math.max(0, contentHeight - height), contentY
                + offset))
            return true
        }
        const top = options.top === undefined ? contentY - originY : Number(options.top)
        const left = options.left === undefined ? contentX - originX : Number(options.left)
        if (!isFinite(top) || !isFinite(left))
            return false

        contentY = originY + Math.max(0, Math.min(Math.max(0, contentHeight - height), top))
        contentX = originX + Math.max(0, Math.min(Math.max(0, contentWidth - width), left))
        return true
    }

    clip: true
    implicitWidth: 320
    implicitHeight: 260
    model: sectionModel
    reuseItems: virtual
    ScrollBar.vertical: ScrollHandle {
    }
    boundsBehavior: Flickable.StopAtBounds
    section.criteria: ViewSection.FullString
    section.property: group ? "groupId" : ""
    cacheBuffer: virtual ? Math.max(0, isFinite(overscan) ? overscan : 0) : Math.max(0, contentHeight)
    section.labelPositioning: sticky ? ViewSection.InlineLabels | ViewSection.CurrentLabelAtStart
        : ViewSection.InlineLabels
    section.delegate: Item {
        id: groupHeader

        readonly property var metadata: control.groupFor(section)

        width: control.width
        height: groupLoader.item ? groupLoader.item.implicitHeight : 36

        Loader {
            id: groupLoader

            property var groupKey: groupHeader.metadata ? groupHeader.metadata.groupKey : null
            property string groupTitle: groupHeader.metadata ? groupHeader.metadata.groupTitle : ""

            width: parent.width
            sourceComponent: control.groupHeaderDelegate || defaultHeader

            onLoaded: {
                if ("groupKey" in item) {
                    item.groupKey = Qt.binding(function() {
                        return groupLoader.groupKey
                    })
                }
                if ("groupTitle" in item) {
                    item.groupTitle = Qt.binding(function() {
                        return groupLoader.groupTitle
                    })
                }
            }
        }
    }
    delegate: Item {
        id: row

        readonly property var entry: control.rows[index]
            || {item: null, key: null, groupKey: null, sourceIndex: -1}

        width: control.width
        height: rowLoader.item ? Math.max(0, rowLoader.item.implicitHeight || rowLoader.item.height) : 40

        MouseArea {
            anchors.fill: parent

            onClicked: control.itemClicked(row.entry.item, row.entry.sourceIndex)
        }
        Loader {
            id: rowLoader

            property var listControl: control
            property var itemKey: row.entry.key
            property var itemData: row.entry.item
            property var groupKey: row.entry.groupKey
            property int itemIndex: row.entry.sourceIndex

            width: parent.width
            sourceComponent: control.itemDelegate || defaultItem

            onLoaded: {
                const bindings = {
                    "itemData": function() {
                        return rowLoader.itemData
                    },
                    "itemIndex": function() {
                        return rowLoader.itemIndex
                    },
                    "itemKey": function() {
                        return rowLoader.itemKey
                    },
                    "groupKey": function() {
                        return rowLoader.groupKey
                    },
                    "listControl": function() {
                        return control
                    }
                }
                Object.keys(bindings).forEach(function(key) {
                    if (key in rowLoader.item)
                        rowLoader.item[key] = Qt.binding(bindings[key])

                })
            }
        }
    }

    onRowsChanged: Qt.callLater(syncSections)
    Component.onCompleted: Qt.callLater(syncSections)

    ListModel {
        id: sectionModel

        property var sourceRows: null
    }
    Component {
        id: defaultItem

        EText {
            padding: 12
            font.pixelSize: 14
            text: itemData && typeof itemData === "object"
                ? String(itemData.label === undefined ? itemData.title || "" : itemData.label)
                : itemData === null || itemData === undefined ? ""
                : String(itemData)
        }
    }
    Component {
        id: defaultHeader

        Item {
            implicitHeight: label.implicitHeight

            ERectangle {
                anchors.fill: parent
                color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            }
            EText {
                id: label

                padding: 10
                font.bold: true
                text: groupTitle
                width: parent.width
            }
        }
    }
}
