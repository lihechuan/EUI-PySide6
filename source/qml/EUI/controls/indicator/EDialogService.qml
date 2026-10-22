import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control

    readonly property var dialogs: state.dialogs

    signal opened(var dialog)
    signal closed(var result, bool accepted)

    function closeAll() {
        state.dialogs.slice().forEach(function(dialog) { dialog.reject() })
    }

    function open(component, properties, options) {
        if (!enabled || !component || typeof component.createObject !== "function" || component.status !== Component.Ready)
            return null
        const settings = options || ({})
        const dialog = dialogComponent.createObject(control, {
            title: settings.title || "",
            width: settings.width || 480,
            parameters: properties || ({}),
            component: component,
            callback: settings.onClose || null
        })
        if (!dialog)
            return null
        state.dialogs = state.dialogs.concat([dialog])
        dialog.finished.connect(function(value, accepted) {
            control.closed(value, accepted)
        })
        dialog.closed.connect(function() {
            state.dialogs = state.dialogs.filter(function(item) { return item !== dialog })
            dialog.destroy()
        })
        if (!dialog.open()) {
            state.dialogs = state.dialogs.filter(function(item) { return item !== dialog })
            dialog.destroy()
            return null
        }
        opened(dialog)
        return dialog
    }

    Component {
        id: dialogComponent

        EDynamicDialog {}
    }
    QtObject {
        id: state

        property var dialogs: []
    }
}
