import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

EButton {
    id: control

    property var predefine: []
    property bool clearable: true
    property bool showAlpha: false
    property bool showButtons: true
    property bool validateEvent: true
    property string colorFormat: "hex"
    property bool commitOnConfirm: false
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", "")
    property var value: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).toString()
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property alias popup: colorPopup

    signal cleared()
    signal changed(var value)
    signal confirmed(var value)
    signal picked(string value)
    signal activeChanged(var value)
    signal popupVisibleChanged(bool visible)

    function hide() {
        colorPopup.close()
    }

    function clear() {
        return colorPanel.clear()
    }

    function cancel() {
        return colorPanel.cancel()
    }

    function confirm() {
        return colorPanel.confirm()
    }

    function show() { if (enabled)
        colorPopup.open() }

    implicitWidth: 48
    Accessible.name: EControlConfig.textFor(control, "SelectColor1", ELocale.texts).arg(value)
    contentItem: ERectangle {
        radius: 2
        border.width: 1
        opacity: control.enabled ? 1 : 0.4
        color: colorPanel.parseColor(control.value) || "transparent"
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    onClicked: show()
    onEnabledChanged: if (!enabled)
        colorPopup.close()
    onValueChanged: if (colorPanel)
        colorPanel.value = value

    PickerPopup {
        id: colorPopup

        padding: 0
        contentItem: FormControls.EColorPickerPanel {
            id: colorPanel

            value: control.value
            clearable: control.clearable
            predefine: control.predefine
            showAlpha: control.showAlpha
            colorFormat: control.colorFormat
            showButtons: control.showButtons
            valueOnClear: control.valueOnClear
            commitOnConfirm: control.commitOnConfirm

            onCleared: {
                control.cleared()
                colorPopup.close()
            }
            onCanceled: {
                control.canceled()
                colorPopup.close()
            }
            onActiveChanged: function(value) { control.activeChanged(value) }
            onConfirmed: function(value) {
                control.confirmed(value)
                colorPopup.close()
            }
            onPicked: function(value) {
                control.value = colorPanel.value
                control.picked(value)
                control.changed(control.value)
            }
        }

        onClosed: colorPanel.cancel()
        onOpened: colorPanel.begin(control.value)
        onVisibleChanged: control.popupVisibleChanged(visible)
    }
}
