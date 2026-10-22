import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15

CaptchaRenderer {
    id: control

    color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
    backgroundColor: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: control.refresh()
    }
}
