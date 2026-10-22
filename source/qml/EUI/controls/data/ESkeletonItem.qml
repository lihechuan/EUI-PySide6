import EUI 1.0
import QtQuick 2.15

ERectangle {
    id: control

    property bool animated: false
    property string variant: "text"

    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    radius: variant === "circle" ? Math.min(width, height) / 2 : variant === "button" ? 4 : 2
    implicitWidth: variant === "circle" ? 40 : variant === "image" ? 160 : variant === "button" ? 64 : 100
    implicitHeight: variant === "circle" ? 40 : variant === "image" ? 100 : variant === "button" ? 32
        : variant === "caption" ? 12 : variant === "h1" ? 28 : variant === "h3" ? 20 : 16

    EIcon {
        anchors.centerIn: parent
        iconSource: EIcons.PICTURE
        visible: control.variant === "image"
        iconSize: Math.min(48, parent.height * 0.4)
        color: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
    }
    SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: control.animated && control.visible && control.enabled

        NumberAnimation {
            to: 0.4
            duration: 700
        }
        NumberAnimation {
            to: 1
            duration: 700
        }
    }
}
