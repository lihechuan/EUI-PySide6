import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls

Pane {
    id: control

    readonly property string containerSection: "header"

    padding: 20
    implicitHeight: 60
    background: Item {}
    Layout.fillWidth: true
    Layout.minimumHeight: Layout.fillHeight || Layout.preferredHeight >= 0 ? 0 : control.height
    Layout.maximumHeight: Layout.fillHeight || Layout.preferredHeight >= 0 ? Infinity : control.height
}
