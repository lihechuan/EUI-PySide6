import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls

Pane {
    id: control

    readonly property string containerSection: "aside"

    padding: 20
    implicitWidth: 200
    background: Item {}
    Layout.fillHeight: true
    Layout.minimumWidth: Layout.fillWidth || Layout.preferredWidth >= 0 ? 0 : control.width
    Layout.maximumWidth: Layout.fillWidth || Layout.preferredWidth >= 0 ? Infinity : control.width
}
