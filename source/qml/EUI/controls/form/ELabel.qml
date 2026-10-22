import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

EText {
    id: control

    property Item target: null

    signal activated()

    function activate() {
        if (!enabled || !target || !target.enabled || !target.visible)
            return false
        target.forceActiveFocus(Qt.MouseFocusReason)
        if (target.checkable === true && typeof target.toggle === "function")
            target.toggle()
        activated()
        return true
    }

    Accessible.role: Accessible.StaticText

    MouseArea {
        anchors.fill: parent
        enabled: control.target !== null
        cursorShape: Qt.PointingHandCursor

        onClicked: control.activate()
    }
    Binding {
        value: control.text
        target: control.target
        property: "Accessible.name"
        when: control.target !== null
        restoreMode: Binding.RestoreBindingOrValue
    }
}
