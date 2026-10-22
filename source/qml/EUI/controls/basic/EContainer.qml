import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15

Item {
    id: control
    default property alias content: layout.data

    property var direction: null
    property size contentSize: Qt.size(0, 0)

    readonly property int effectiveDirection: direction === Qt.Horizontal || direction === "horizontal"
        ? Qt.Horizontal
        : direction === Qt.Vertical || direction === "vertical" ? Qt.Vertical
        : hasVerticalSections() ? Qt.Vertical : Qt.Horizontal

    function updateContentSize() {
        contentSize = Qt.size(layout.implicitWidth, layout.implicitHeight)
    }

    function hasVerticalSections() {
        for (let index = 0; index < layout.children.length; ++index)
            if (layout.children[index].containerSection === "header"
                || layout.children[index].containerSection === "footer")
                return true
        return false
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    implicitWidth: contentSize.width
    implicitHeight: contentSize.height

    Component.onCompleted: Qt.callLater(updateContentSize)

    GridLayout {
        id: layout

        rowSpacing: 0
        columnSpacing: 0
        anchors.fill: parent
        columns: control.effectiveDirection === Qt.Horizontal ? Math.max(1, children.length) : 1

        onImplicitWidthChanged: Qt.callLater(control.updateContentSize)
        onImplicitHeightChanged: Qt.callLater(control.updateContentSize)
    }
}
