import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15

Item {
    id: control
    default property alias content: loader.sourceComponent

    property real margin: 0
    property bool once: true
    property Item viewport: null
    property bool activated: false
    property bool asynchronous: false
    property real placeholderHeight: 120

    readonly property alias item: loader.item
    readonly property int status: loader.status
    readonly property bool inViewport: intersectsViewport()

    signal exited()
    signal loaded()
    signal entered()

    function reset() {
        activated = false
        updateActivation()
    }

    function updateActivation() {
        if (inViewport) {
            activated = true
            entered()
        } else {
            if (!once)
                activated = false
            exited()
        }
    }

    function intersectsViewport() {
        if (!visible || width <= 0 || height <= 0)
            return false
        if (viewport) {
            const position = mapToItem(viewport, 0, 0)
            if (!viewport.visible || position.x + width <= -margin || position.y + height <= -margin
                || position.x >= viewport.width + margin || position.y >= viewport.height + margin)
                return false
        }
        let ancestor = control
        while (ancestor) {
            ancestor.x
            ancestor.y
            ancestor.width
            ancestor.height
            ancestor.visible
            if (!ancestor.visible)
                return false
            if (ancestor !== control && (ancestor.clip || ancestor === viewport || !ancestor.parent)) {
                const position = control.mapToItem(ancestor, 0, 0)
                if (position.x + width <= -margin || position.y + height <= -margin
                    || position.x >= ancestor.width + margin || position.y >= ancestor.height + margin)
                    return false
            }
            ancestor = ancestor.parent
        }
        return true
    }

    implicitWidth: loader.item ? loader.item.implicitWidth : 240
    implicitHeight: loader.item ? loader.item.implicitHeight : placeholderHeight

    onInViewportChanged: Qt.callLater(function() { if (control) control.updateActivation() })
    Component.onCompleted: Qt.callLater(function() { if (control) control.updateActivation() })

    Loader {
        id: loader

        width: parent.width
        active: control.activated
        asynchronous: control.asynchronous

        onLoaded: control.loaded()
    }
}
