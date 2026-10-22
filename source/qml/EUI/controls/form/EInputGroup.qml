import EUI 1.0
import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: control
    default property alias content: layout.data

    property real spacing: 8

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.fill: parent
        spacing: control.spacing
    }
}
