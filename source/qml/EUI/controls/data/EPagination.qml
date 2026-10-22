import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: customContent.data

    property int total: 0
    property int pageSize: 10
    property int pagerCount: 7
    property int currentPage: 1
    property string nextText: ""
    property string prevText: ""
    property bool showTotal: true
    property int explicitPageCount: 0
    property bool buttonBackground: true
    property bool hideOnSinglePage: false
    property var pageSizes: [10, 20, 50, 100]
    property string layout: "total, prev, pager, next"
    property int size: EControlConfig.sizeFor(control)

    readonly property var pages: visiblePages()
    readonly property var localizedTexts: ELocale.texts
    readonly property int splitIndex: layoutItems.indexOf("->")
    readonly property int effectivePageSize: Math.max(1, pageSize)
    readonly property var leftItems: splitIndex < 0 ? layoutItems : layoutItems.slice(0, splitIndex)
    readonly property var rightItems: splitIndex < 0 ? []
        : layoutItems.slice(splitIndex + 1).filter(function(item) {
            return item !== "->"
        })
    readonly property int pageCount: explicitPageCount > 0 ? explicitPageCount
        : Math.max(1, Math.ceil(Math.max(0, total) / effectivePageSize))
    readonly property var layoutItems: layout.split(",").map(function(item) {
        return item.trim()
    })
        .filter(function(item) {
            return ["total", "sizes", "prev", "pager", "next", "jumper", "slot", "->"].indexOf(item) >= 0
        })

    signal nextClicked(int page)
    signal currentChange(int page)
    signal sizeChange(int pageSize)
    signal previousClicked(int page)
    signal changed(int page, int pageSize)

    function normalizePage() {
        currentPage = Math.max(1, Math.min(pageCount, currentPage))
    }

    function visiblePages() {
        return EDataUtils.visiblePages(pageCount, currentPage, pagerCount)
    }

    function next() {
        if (!setPage(currentPage + 1))
            return false
        nextClicked(currentPage)
        return true
    }

    function previous() {
        if (!setPage(currentPage - 1))
            return false
        previousClicked(currentPage)
        return true
    }

    function setPage(page) {
        const value = Number(page)
        if (!enabled || !isFinite(value))
            return false
        const next = Math.max(1, Math.min(pageCount, Math.floor(value)))
        if (next === currentPage)
            return false
        currentPage = next
        currentChange(next)
        changed(currentPage, effectivePageSize)
        return true
    }

    function setPageSize(value) {
        const requested = Number(value)
        if (!enabled
            || !isFinite(requested)
            || requested < 1
            || Math.floor(requested) !== requested
            || requested === pageSize)
            return false
        const previous = currentPage
        pageSize = requested
        normalizePage()
        sizeChange(effectivePageSize)
        if (currentPage !== previous)
            currentChange(currentPage)
        changed(currentPage, effectivePageSize)
        return true
    }

    visible: !hideOnSinglePage || pageCount > 1
    implicitHeight: EDefaultConfig.controlHeight(size)
    implicitWidth: leftButtons.implicitWidth + rightButtons.implicitWidth + (rightItems.length > 0 ? 16 : 0)
    contentItem: Item {
        Row {
            id: leftButtons

            spacing: 6
            objectName: "paginationLeft"

            Repeater {
                delegate: layoutPart
                model: control.leftItems
            }
        }
        Row {
            id: rightButtons

            spacing: 6
            objectName: "paginationRight"
            x: Math.max(leftButtons.width + 16, parent.width - width)

            Repeater {
                delegate: layoutPart
                model: control.rightItems
            }
        }
    }

    onPageCountChanged: normalizePage()
    onCurrentPageChanged: normalizePage()

    Item {
        id: customContent

        visible: true
    }
    Component {
        id: layoutPart

        Loader {
            readonly property string part: modelData

            height: control.implicitHeight
            visible: part !== "total" || control.showTotal
            sourceComponent: part === "total" ? totalPart : part === "sizes" ? sizePart
                : part === "prev" ? previousPart : part === "pager" ? pagerPart
                : part === "next" ? nextPart : part === "jumper" ? jumpPart : slotPart
        }
    }
    Component {
        id: totalPart

        EText {
            font: control.font
            visible: control.showTotal
            height: control.implicitHeight
            verticalAlignment: Text.AlignVCenter
            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            text: control ? EControlConfig.textFor(
                control,
                "Total1Items",
                control.localizedTexts
            ).arg(Math.max(0, control.total)) : ""
        }
    }
    Component {
        id: previousPart

        EButton {
            implicitWidth: 32
            size: control.size
            enabled: control.currentPage > 1
            objectName: "paginationPrevious"
            textButton: !control.buttonBackground
            Accessible.name: control ? EControlConfig.textFor(control, "PreviousPage", control.localizedTexts) : ""
            text: control ? control.prevText || EControlConfig.textFor(control, "PreviousGlyph", control.localizedTexts) : ""

            onClicked: control.previous()
        }
    }
    Component {
        id: nextPart

        EButton {
            implicitWidth: 32
            size: control.size
            objectName: "paginationNext"
            textButton: !control.buttonBackground
            enabled: control.currentPage < control.pageCount
            Accessible.name: control ? EControlConfig.textFor(control, "NextPage", control.localizedTexts) : ""
            text: control ? control.nextText || EControlConfig.textFor(control, "NextGlyph", control.localizedTexts) : ""

            onClicked: control.next()
        }
    }
    Component {
        id: pagerPart

        Row {
            spacing: 6

            Repeater {
                model: control.pages

                EButton {
                    implicitWidth: 32
                    size: control.size
                    enabled: modelData > 0
                    textButton: !control.buttonBackground && modelData !== control.currentPage
                    styleType: modelData === control.currentPage ? EStyle.Primary : EStyle.Default
                    text: modelData === 0 && control ? EControlConfig.textFor(control, "EllipsisGlyph", control.localizedTexts)
                        : String(modelData)

                    onClicked: control.setPage(modelData)
                }
            }
        }
    }
    Component {
        id: sizePart

        ESelect {
            width: 108
            size: control.size
            model: control.pageSizes
            objectName: "paginationSizes"
            currentIndex: EDataUtils.isArray(control.pageSizes) ? control.pageSizes.indexOf(control.pageSize) : -1

            onActivated: function(index) {
                control.setPageSize(control.pageSizes[index])
            }
        }
    }
    Component {
        id: jumpPart

        ESpinBox {
            from: 1
            width: 116
            editable: true
            size: control.size
            to: control.pageCount
            value: control.currentPage
            objectName: "paginationJumper"

            onValueModified: control.setPage(value)
        }
    }
    Component {
        id: slotPart

        Item {
            implicitWidth: customContent.childrenRect.width
            implicitHeight: customContent.childrenRect.height

            Component.onCompleted: customContent.parent = this
        }
    }
}
