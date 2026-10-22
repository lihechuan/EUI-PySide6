import EUI 1.0
import QtQuick 2.15

Item {
    id: control

    property var model: []
    property int iconSize: 24
    property int itemSize: 48
    property real magnification: 1.35
    property string placement: "bottom"

    readonly property bool vertical: placement === "left" || placement === "right"

    signal command(var command, var item)

    function trigger(index) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(index) || Math.floor(index) !== index || index < 0 || index >= model.length
            || !model[index] || model[index].disabled)
            return false
        const item = model[index]
        command(item.command === undefined ? index : item.command, item)
        if (typeof item.command === "function")
            item.command(item)
        return true
    }

    implicitWidth: (vertical ? itemSize : layout.implicitWidth) + 16 + itemSize * (Math.max(1, magnification) - 1)
    implicitHeight: (vertical ? layout.implicitHeight : itemSize) + 16 + itemSize * (Math.max(1, magnification) - 1)

    ERectangle {
        radius: 12
        border.width: 1
        anchors.fill: parent
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    Grid {
        id: layout

        spacing: 8
        anchors.centerIn: parent
        columns: control.vertical ? 1 : Math.max(1, actions.count)

        Repeater {
            id: actions

            model: EDataUtils.isArray(control.model) ? control.model : []

            ETextButton {
                id: action

                hoverEnabled: true
                z: hovered ? 1 : 0
                width: control.itemSize
                height: control.itemSize
                iconSize: control.iconSize
                enabled: !modelData.disabled
                iconSource: modelData.iconSource || 0
                scale: hovered ? Math.max(1, control.magnification) : 1
                Accessible.name: String(modelData.label || modelData.text || "")
                text: iconSource ? "" : String(modelData.label || modelData.text || "")
                background: ERectangle {
                    radius: 8
                    color: action.hovered || action.visualFocus
                        ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark) : "transparent"
                }

                onClicked: control.trigger(index)

                Behavior on scale { NumberAnimation { duration: 120 } }
                EToolTip {
                    reference: parent
                    text: String(modelData.label || modelData.text || "")
                }
            }
        }
    }
}
