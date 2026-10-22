import EUI 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var value
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

    function select(key) {
        if (!enabled)
            return false
        const option = effectiveOptions.find(function(item) {
            return (typeof item === "object" ? item[props.value || "value"] : item) === key
        })
        if (option === undefined || typeof option === "object" && option[props.disabled || "disabled"])
            return false
        value = key
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
                readonly property bool selected: control.value === key
                readonly property var key: typeof option === "object" ? option[control.props.value || "value"]
                    : option
                readonly property string label: String(typeof option === "object"
                    ? option[control.props.label || "label"]
                    : option)

                function select(selected) {
                    return control.select(key)
                }

                width: item ? item.implicitWidth : 0
                height: item ? item.implicitHeight : 0
                sourceComponent: control.optionDelegate || (control.buttonStyle ? buttonChoice : plainChoice)
            }
        }
    }

    Component {
        id: plainChoice

        FormControls.ERadio {
            size: control.size
            text: parent.label
            autoExclusive: false
            borderVisible: false
            checked: control.value === parent.key
            enabled: control.enabled
                && !(typeof parent.option === "object" && parent.option[control.props.disabled || "disabled"])

            onClicked: {
                control.select(parent.key)
                checked = Qt.binding(function() {
                    return control.value === parent.key
                })
            }
        }
    }
    Component {
        id: buttonChoice

        FormControls.ERadioButton {
            radius: 4
            size: control.size
            text: parent.label
            autoExclusive: false
            checked: control.value === parent.key
            enabled: control.enabled
                && !(typeof parent.option === "object" && parent.option[control.props.disabled || "disabled"])

            onClicked: {
                control.select(parent.key)
                checked = Qt.binding(function() {
                    return control.value === parent.key
                })
            }
        }
    }
}
