import EUI 1.0
import QtQuick 2.15

Item {
    id: control
    default property alias content: fieldContainer.data

    property string text: ""
    property bool fixed: false
    property Item target: fieldContainer.children.length ? fieldContainer.children[0] : null
    property bool filled: target ? target.text !== undefined ? String(target.text).length > 0
        : target.value !== undefined && target.value !== null && String(target.value).length > 0 : false

    readonly property bool raised: fixed || filled || !!(target && target.activeFocus)

    implicitWidth: target ? target.implicitWidth : 180
    implicitHeight: (target ? target.implicitHeight : 32) + 20

    Item {
        id: fieldContainer

        width: parent.width
        y: control.fixed ? 0 : 18
        height: Math.max(0, parent.height - y)
    }
    ELabel {
        z: 1
        text: control.text
        target: control.target
        x: control.fixed ? 12 : 8
        font.pixelSize: control.raised ? 11 : 14
        y: control.raised ? control.fixed ? 5 : 0 : 18 + (fieldContainer.height - height) / 2
        color: control.target && control.target.activeFocus
            ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
            : EPaletteManager.ThemePalette.textSecondary(ETheme.dark)

        Behavior on y { NumberAnimation { duration: 120 } }
        Behavior on font.pixelSize { NumberAnimation { duration: 120 } }
    }
}
