import EUI 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property int max: 0
    property int min: 0
    property var value: []
    property var options: []
    property bool buttonStyle: false
    property bool validateEvent: true
    property Component optionDelegate: null
    property int size: EControlConfig.sizeFor(control)
    property var props: ({value: "value", label: "label", disabled: "disabled"})

    readonly property var effectiveOptions: EDataUtils.isArray(options)
        ? options.filter(function(option) {
            return option !== null && option !== undefined
        }) : []

    signal changed(var value)

    function toggle(key, selected) {
        if (!enabled)
            return false
        const option = effectiveOptions.find(function(item) {
            return (typeof item === "object" ? item[props.value || "value"] : item) === key
        })
        if (option === undefined || typeof option === "object" && option[props.disabled || "disabled"])
            return false
        const items = value.slice(0)
        const index = items.indexOf(key)
        if (selected && index < 0) {
            if (max > 0 && items.length >= max)
                return false
            items.push(key)
        } else if (!selected && index >= 0) {
            if (items.length <= min)
                return false
            items.splice(index, 1)
        }
        value = items
        changed(value)
        return true
    }

    implicitWidth: choices.implicitWidth
    implicitHeight: choices.implicitHeight
    contentItem: Flow {
        id: choices

        spacing: 12

        Repeater {
            model: control.effectiveOptions
            delegate: Loader {
                readonly property var option: modelData
                readonly property bool selected: control.value.indexOf(key) >= 0
                readonly property real contentWidth: item ? item.implicitWidth : 0
                readonly property real contentHeight: item ? item.implicitHeight : 0
                readonly property var key: typeof option === "object" ? option[control.props.value || "value"]
                    : option
                readonly property string label: String(typeof option === "object"
                    ? option[control.props.label || "label"]
                    : option)

                function select(selected) {
                    return control.toggle(key, selected)
                }

                width: contentWidth
                height: contentHeight
                sourceComponent: control.optionDelegate || (control.buttonStyle ? buttonChoice : plainChoice)
            }
        }
    }

    onValueChanged: if (!EDataUtils.isArray(value))
        value = []

    Component {
        id: plainChoice

        FormControls.ECheckBox {
            size: control.size
            text: parent.label
            autoExclusive: false
            borderVisible: false
            checked: control.value.indexOf(parent.key) >= 0
            enabled: control.enabled
                && !(typeof parent.option === "object" && parent.option[control.props.disabled || "disabled"])

            onClicked: {
                control.toggle(parent.key, checked)
                checked = Qt.binding(function() {
                    return control.value.indexOf(parent.key) >= 0
                })
            }
        }
    }
    Component {
        id: buttonChoice

        FormControls.ECheckBoxButton {
            radius: 4
            size: control.size
            text: parent.label
            autoExclusive: false
            checked: control.value.indexOf(parent.key) >= 0
            enabled: control.enabled
                && !(typeof parent.option === "object" && parent.option[control.props.disabled || "disabled"])

            onClicked: {
                control.toggle(parent.key, checked)
                checked = Qt.binding(function() {
                    return control.value.indexOf(parent.key) >= 0
                })
            }
        }
    }
}
