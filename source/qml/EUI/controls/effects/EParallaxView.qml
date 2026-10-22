import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: column.data

    property real speed: 0.35
    property alias flickable: flickable
    property alias backgroundComponent: backgroundLoader.sourceComponent

    clip: true
    spacing: 16
    implicitWidth: 400
    implicitHeight: 300
    background: Loader {
        id: backgroundLoader

        width: control.availableWidth
        y: -flickable.contentY * control.speed
        height: control.availableHeight
            + Math.max(0, flickable.contentHeight - control.availableHeight) * control.speed
    }
    contentItem: Flickable {
        id: flickable

        clip: true
        contentWidth: width
        contentHeight: column.height
        ScrollBar.vertical: ScrollHandle { }
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: column

            width: flickable.width
            spacing: control.spacing
        }
    }
}
