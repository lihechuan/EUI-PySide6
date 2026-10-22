import QtQuick 2.15

Item {
    id: control
    default property alias content: body.data

    property real grow: 0
    property int order: 0
    property real basis: -1
    property real shrink: 1
    property real minSize: 0
    property real maxSize: Infinity
    property string alignSelf: "auto"

    readonly property bool flexItem: true

    function contentExtent(horizontal) {
        let extent = 0
        for (let index = 0; index < body.children.length; ++index)
            extent = Math.max(extent, horizontal ? body.children[index].implicitWidth
                : body.children[index].implicitHeight)
        return extent
    }

    implicitWidth: contentExtent(true)
    implicitHeight: contentExtent(false)

    Item {
        id: body

        anchors.fill: parent
    }
}
