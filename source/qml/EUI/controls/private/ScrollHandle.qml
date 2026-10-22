import EUI 1.0
import QtQuick 2.15
import QtQuick.Controls

ScrollBar {
    id: control

    z: 1
    padding: 4
    implicitWidth: 16
    hoverEnabled: true
    implicitHeight: 16
    visible: policy !== ScrollBar.AlwaysOff && size > 0 && size < 1
    minimumSize: Math.min(0.9, 36 / Math.max(1, orientation === Qt.Vertical ? availableHeight : availableWidth))
    background: ERectangle {
        radius: Math.min(width, height) / 2
        opacity: control.pressed ? 0.12 : control.hovered ? 0.08 : 0
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
    }
    contentItem: ERectangle {
        implicitWidth: 8
        implicitHeight: 8
        radius: Math.min(width, height) / 2
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        opacity: !control.enabled ? 0.2 : control.pressed ? 0.9 : control.hovered ? 0.75
            : control.active ? 0.6 : 0.45

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }
    }
}
