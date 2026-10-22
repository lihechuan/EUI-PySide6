import EUI 1.0
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    height: 850
    width: 1200
    visible: true
    minimumWidth: 640
    font.pixelSize: 14
    minimumHeight: 520
    title: "Littlest Tokyo · Qt Quick 3D"
    color: ETheme.dark ? "#1e2026" : "#e7e5e2"

    TokyoView { anchors.fill: parent }
}
