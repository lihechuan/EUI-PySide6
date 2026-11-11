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

    function openComponent(source, properties) {
        if (!enabled || !source || typeof source.createObject !== "function" || source.status !== Component.Ready)
            return false
        dialogState.updating = true
        parameters = properties || ({})
        component = source
        resultData = undefined
        dialogState.updating = false
        if (loadedContent)
            loadedContent.create()
        return open()
    }

    function finish(accepted, completion) {
        const pending = completion || dialogState.completion
        if (pending.finished)
            return
        pending.finished = true
        const value = pending.closed ? pending.result : resultData
        const handler = pending.closed ? pending.callback : callback
        finished(value, accepted)
        if (typeof handler === "function")
            handler(value, accepted)
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
            enabled: !dialogState.updating
        }
    }

    onAboutToShow: dialogState.completion = ({finished: false})
    onAccepted: finish(true, visible ? dialogState.completion : dialogState.closing)
    onRejected: finish(false, visible ? dialogState.completion : dialogState.closing)
    onClosed: {
        const completion = dialogState.closing
        if (!completion.finished)
            Qt.callLater(function() { if (control) control.finish(false, completion) })
    }
    onAboutToHide: {
        dialogState.closing = dialogState.completion
        dialogState.closing.closed = true
        dialogState.closing.result = resultData
        dialogState.closing.callback = callback
    }

    QtObject {
        id: dialogState

        property var closing: null
        property bool updating: false
        property var completion: ({finished: false})
    }
}
