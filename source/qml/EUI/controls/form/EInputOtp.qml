import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property int length: 6
    property string value: ""
    property bool masked: false
    property bool numericOnly: true
    property int size: EControlConfig.sizeFor(control)

    signal completed(string value)

    function normalized(text) {
        return (numericOnly ? text.replace(/\D/g, "") : text).slice(0, Math.max(1, length))
    }

    function inputAt(index, text) {
        if (!enabled || index < 0 || index >= Math.max(1, length))
            return false
        const token = normalized(text)
        if (text.length > 0 && token.length === 0)
            return false
        const position = Math.min(index, value.length)
        value = normalized(value.slice(0, position)
            + token
            + value.slice(position + Math.max(1, token.length)))
        const next = Math.min(Math.max(0, length - 1), position + token.length)
        if (cells.itemAt(next))
            cells.itemAt(next).forceActiveFocus()
        if (value.length === Math.max(1, length))
            completed(value)
        return true
    }

    implicitWidth: digitRow.implicitWidth
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    contentItem: Row {
        id: digitRow

        spacing: 8

        Repeater {
            id: cells

            model: Math.max(1, control.length)
            delegate: EInput {
                leftPadding: 4
                rightPadding: 4
                size: control.size
                width: implicitHeight
                objectName: "otpDigit" + index
                text: control.value.charAt(index)
                horizontalAlignment: Text.AlignHCenter
                maximumLength: Math.max(1, control.length)
                echoMode: control.masked ? TextInput.Password : TextInput.Normal
                inputMethodHints: control.numericOnly ? Qt.ImhDigitsOnly : Qt.ImhNone

                onActiveFocusChanged: if (activeFocus)
                    selectAll()
                onTextEdited: {
                    control.inputAt(index, text)
                    text = Qt.binding(function() {
                        return control.value.charAt(index)
                    })
                }
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Backspace && text.length === 0 && index > 0) {
                        cells.itemAt(index - 1).forceActiveFocus()
                        event.accepted = true
                    }
                }
            }
        }
    }

    onLengthChanged: value = normalized(value)
    onNumericOnlyChanged: value = normalized(value)
    onValueChanged: {
        const result = normalized(value)
        if (result !== value)
            value = result
    }
}
