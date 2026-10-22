import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

EDialog {
    id: control

    property var callback: null
    property var parameters: ({})
    property Component component: null
    property var resultData: undefined

    readonly property var instance: loadedContent ? loadedContent.item : null

    signal loadFailed(string message)
    signal finished(var result, bool accepted)

    function resolve(value) {
        resultData = value
        accept()
    }

    function finish(accepted) {
        if (state.finished)
            return
        state.finished = true
        finished(resultData, accepted)
        if (typeof callback === "function")
            callback(resultData, accepted)
    }

    function openComponent(source, properties) {
        if (!enabled || !source || typeof source.createObject !== "function" || source.status !== Component.Ready)
            return false
        parameters = properties || ({})
        component = source
        resultData = undefined
        return open()
    }

    showFooter: false
    destroyOnClose: true
    contentComponent: Item {
        id: content

        property var item: null

        function create() {
            if (item) {
                item.destroy()
                item = null
            }
            if (!control.component)
                return
            const properties = {}
            Object.keys(control.parameters || {}).forEach(function(key) {
                properties[key] = control.parameters[key]
            })
            item = control.component.createObject(content, properties)
            if (!item) {
                control.loadFailed("component-creation-failed")
                return
            }
            if ("dialogRef" in item)
                item.dialogRef = control
            item.width = Qt.binding(function() { return content.width })
        }

        implicitHeight: item ? Math.max(item.implicitHeight || 0, item.height || 0) : 0

        Component.onCompleted: create()

        Connections {
            function onComponentChanged() { content.create() }

            function onParametersChanged() { content.create() }

            target: control
        }
    }

    onClosed: finish(false)
    onAccepted: finish(true)
    onRejected: finish(false)
    onAboutToShow: state.finished = false

    QtObject {
        id: state

        property bool finished: false
    }
}
