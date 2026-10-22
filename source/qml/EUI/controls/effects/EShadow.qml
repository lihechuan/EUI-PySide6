import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15

Item {
    id: control

    property real radius: 4
    property int elevation: 8
    property color color: EPaletteManager.ThemePalette.shadowColor(ETheme.dark)

    anchors.fill: parent

    ShadowRenderer {
        anchors.fill: parent
        color: control.color
        radius: control.radius
        elevation: control.elevation
        anchors.margins: -Math.max(0, Math.min(32, control.elevation))
    }
}
