import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var items: []
    property var grid: null
    property int pageSize: 10
    property bool split: true
    property var rowKey: "key"
    property int currentPage: 1
    property bool loading: false
    property bool bordered: false
    property string footerText: ""
    property string headerText: ""
    property bool pagination: false
    property Component itemDelegate: null
    property Component footerDelegate: null
    property Component headerDelegate: null
    property string emptyText: ELocale.texts.NoData

    readonly property alias view: viewLoader.item
    readonly property int columns: resolveColumns()
    readonly property int effectivePageSize: Math.max(1, pageSize)
    readonly property int itemCount: EDataUtils.isArray(items) ? items.length : 0
    readonly property int pageCount: Math.max(1, Math.ceil(itemCount / effectivePageSize))
    readonly property int pageOffset: pagination ? (currentPage - 1) * effectivePageSize : 0
    readonly property real gutter: grid && isFinite(grid.gutter) ? Math.max(0, Number(grid.gutter)) : 12
    readonly property var pageItems: EDataUtils.isArray(items)
        ? pagination
        ? items.slice(pageOffset, pageOffset + effectivePageSize)
        : items
        : []

    signal pageChanged(int page)
    signal itemClicked(var item, int index)

    function normalizePage() {
        currentPage = Math.max(1, Math.min(pageCount, currentPage))
    }

    function setPage(page) {
        if (!enabled
            || !isFinite(page)
            || Math.floor(Number(page)) !== Number(page)
            || page < 1
            || page > pageCount)
            return false

        currentPage = Number(page)
        return true
    }

    function resolveColumns() {
        if (!grid)
            return 1

        let value = grid.columns === undefined ? grid.column : grid.columns
        const breakpoints = [{
            "name": "xs",
            "width": 0
        }, {
            "name": "sm",
            "width": 576
        }, {
            "name": "md",
            "width": 768
        }, {
            "name": "lg",
            "width": 992
        }, {
            "name": "xl",
            "width": 1200
        }, {
            "name": "xxl",
            "width": 1600
        }]
        breakpoints.forEach(function(point) {
            if (width >= point.width && grid[point.name] !== undefined)
                value = grid[point.name]

        })
        return isFinite(value) ? Math.max(1, Math.min(64, Math.floor(Number(value)))) : 1
    }

    implicitWidth: 360
    implicitHeight: 320
    padding: bordered ? 1 : 0
    background: ERectangle {
        radius: 4
        border.width: control.bordered ? 1 : 0
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    contentItem: Item {
        Column {
            id: heading

            width: parent.width

            EText {
                padding: 12
                width: parent.width
                text: control.headerText
                visible: text.length > 0
            }
            Loader {
                width: parent.width
                sourceComponent: control.headerDelegate
            }
        }
        Column {
            id: footing

            width: parent.width
            anchors.bottom: parent.bottom

            Loader {
                width: parent.width
                sourceComponent: control.footerDelegate
            }
            EText {
                padding: 12
                width: parent.width
                text: control.footerText
                visible: text.length > 0
            }
            EPagination {
                id: pager

                width: parent.width
                total: control.itemCount
                layout: "prev, pager, next"
                visible: control.pagination
                objectName: "listPagination"
                pageSize: control.effectivePageSize

                onCurrentChange: function(page) {
                    control.setPage(page)
                }

                Binding {
                    target: pager
                    property: "currentPage"
                    value: control.currentPage
                }
            }
        }
        Loader {
            id: viewLoader

            anchors.left: parent.left
            anchors.bottom: footing.top
            anchors.right: parent.right
            anchors.top: heading.bottom
            sourceComponent: control.columns > 1 ? gridView : listView
        }
        EEmpty {
            anchors.centerIn: parent
            description: control.emptyText
            visible: !control.loading && control.itemCount === 0
        }
        ELoading {
            anchors.fill: parent
            visible: control.loading
        }
    }

    onPageCountChanged: normalizePage()
    onCurrentPageChanged: {
        normalizePage()
        pageChanged(currentPage)
    }

    Component {
        id: listView

        EListy {
            rowKey: control.rowKey
            items: control.pageItems
            indexOffset: control.pageOffset
            itemDelegate: control.itemDelegate || defaultItem

            onItemClicked: function(item, index) {
                control.itemClicked(item, index)
            }
        }
    }
    Component {
        id: gridView

        GridView {
            clip: true
            model: control.pageItems
            cellWidth: width / control.columns
            ScrollBar.vertical: ScrollHandle {
            }
            boundsBehavior: Flickable.StopAtBounds
            cellHeight: control.grid && isFinite(control.grid.itemHeight)
                ? Math.max(1, control.grid.itemHeight)
                : 120
            delegate: Item {
                id: gridItem

                property var itemData: modelData
                property int itemIndex: index + control.pageOffset

                width: Math.max(0, GridView.view.cellWidth - control.gutter)
                height: Math.max(0, GridView.view.cellHeight - control.gutter)

                MouseArea {
                    anchors.fill: parent

                    onClicked: control.itemClicked(gridItem.itemData, gridItem.itemIndex)
                }
                Loader {
                    anchors.fill: parent
                    sourceComponent: control.itemDelegate || defaultItem

                    onLoaded: {
                        if ("itemData" in item) {
                            item.itemData = Qt.binding(function() {
                                return gridItem.itemData
                            })
                        }
                        if ("itemIndex" in item) {
                            item.itemIndex = Qt.binding(function() {
                                return gridItem.itemIndex
                            })
                        }
                    }
                }
            }
        }
    }
    Component {
        id: defaultItem

        EListItem {
            split: control.columns === 1 && control.split
        }
    }
}
