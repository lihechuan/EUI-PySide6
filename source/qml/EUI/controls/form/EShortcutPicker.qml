import EUI 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15

FormControls.EInput {
    id: control

    property string sequence: ""
    property bool capturing: false

    signal captured(string sequence)

    function cancel() {
        capturing = false
    }

    function captureKey(key, modifiers) {
        if (!enabled || !capturing)
            return false
        const next = EValueUtils.shortcutText(key, modifiers)
        if (!next)
            return false
        sequence = next
        capturing = false
        captured(sequence)
        return true
    }

    readOnly: true
    text: sequence
    clearable: true
    implicitWidth: 240
    selectByMouse: false
    Keys.priority: Keys.BeforeItem
    placeholderText: capturing ? EControlConfig.textFor(control, "PressShortcut", ELocale.texts)
        : EControlConfig.textFor(control, "CaptureShortcut", ELocale.texts)

    onEnabledChanged: if (!enabled)
        cancel()
    onActiveFocusChanged: if (!activeFocus)
        cancel()
    onCleared: {
        sequence = ""
        cancel()
        captured(sequence)
    }
    Keys.onPressed: function(event) {
        if (capturing && event.key === Qt.Key_Escape)
            cancel()
        else if (capturing)
            captureKey(event.key, event.modifiers)
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space)
            capturing = true
        else
            return
        event.accepted = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        anchors.rightMargin: control.clearable && control.text.length > 0 ? 34 : 0

        onClicked: {
            control.forceActiveFocus()
            control.capturing = true
        }
    }
}
