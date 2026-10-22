import QtQuick 2.15

Item {
    id: control
    default property alias content: cardLoader.sourceComponent

    property int exampleCount: 1
    property bool activated: false
    property string componentName: ""

    readonly property alias loadedCard: cardLoader.item
    readonly property bool selected: !page || page.selectedComponent.length === 0
        || page.selectedComponent === componentName
    readonly property var page: {
        let ancestor = parent
        while (ancestor) {
            if (ancestor.examplePage === true)
                return ancestor
            ancestor = ancestor.parent
        }
        return null
    }
    readonly property bool inViewport: {
        if (!page)
            return true
        if (!page.previewsReady)
            return false
        page.contentY
        page.height
        let ancestor = control
        while (ancestor && ancestor !== page) {
            ancestor.y
            ancestor = ancestor.parent
        }
        const position = mapToItem(page, 0, 0)
        return position.y < page.height && position.y + implicitHeight > 0
    }

    function loadIfVisible() {
        if (selected && inViewport)
            activated = true
    }

    visible: selected
    width: parent ? parent.width : 0
    implicitHeight: !selected ? 0 : cardLoader.item ? cardLoader.item.implicitHeight : 400

    onInViewportChanged: Qt.callLater(loadIfVisible)
    Component.onCompleted: Qt.callLater(loadIfVisible)
    onSelectedChanged: {
        if (!selected)
            activated = false
        else
            Qt.callLater(loadIfVisible)
    }

    Loader {
        id: cardLoader

        width: parent.width
        active: control.selected && (control.activated || !control.page)

        onLoaded: {
            if (item.title !== undefined && item.title.length === 0)
                item.title = control.componentName
            const card = item
            Qt.callLater(function() {
                if (cardLoader && cardLoader.item === card && card && card.code !== undefined
                    && card.code.length === 0 && !card.hasSource && typeof exampleData !== "undefined")
                    card.code = exampleData.codeFor(control.componentName)
                if (control && control.page && typeof control.page.updateExampleCount === "function")
                    control.page.updateExampleCount()
            })
            if (item.titleVisible !== undefined)
                item.titleVisible = Qt.binding(function() {
                    return !control.page || control.page.selectedComponent.length === 0
                })
        }
    }
}
