import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: contentHost.data

    property real offset: 0
    property int revision: 0
    property int zIndex: 100
    property Item target: null
    property Item appendTo: null
    property bool teleported: false
    property int position: EPlacement.Top

    readonly property bool fixed: target && (position === EPlacement.Bottom
        ? targetPosition.y + height > target.height - Math.max(0, offset)
        : targetPosition.y < Math.max(0, offset))
    readonly property point targetPosition: {
        if (!target)
            return Qt.point(0, 0)
        const update = revision
        const scrollY = target.contentY
        const scrollX = target.contentX
        return control.mapToItem(target, 0, 0)
    }

    signal changed(bool fixed)
    signal scrolled(real top, bool fixed)

    function update() {
        ++revision
    }

    function updateRoot() {
        update()
    }

    z: fixed ? zIndex : 0
    implicitWidth: contentHost.childrenRect.width
    implicitHeight: contentHost.childrenRect.height

    onFixedChanged: changed(fixed)

    Connections {
        function onContentYChanged() {
            control.scrolled(control.target.contentY, control.fixed)
        }

        target: control.target
        ignoreUnknownSignals: true
    }
    Item {
        id: contentHost

        width: control.width
        height: control.height
        z: control.fixed ? control.zIndex : 0
        x: parent === control ? 0 : control.mapToItem(parent, 0, 0).x
        parent: control.fixed && control.teleported && control.appendTo ? control.appendTo : control
        y: (parent === control ? 0 : control.mapToItem(parent, 0, 0).y)
            + (!control.fixed ? 0 : control.position === EPlacement.Bottom
            ? control.target.height - Math.max(0, control.offset) - control.height - control.targetPosition.y
            : Math.max(0, control.offset) - control.targetPosition.y)
    }
}
