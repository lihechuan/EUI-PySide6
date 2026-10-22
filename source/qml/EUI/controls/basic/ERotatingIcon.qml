import EUI 1.0
import QtQuick 2.15

EIcon {
    id: control

    property int duration: 1500
    property bool running: false
    property real originX: width / 2
    property real originY: height / 2

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    transform: Rotation {
        id: rotation

        origin.x: control.originX
        origin.y: control.originY
    }

    RotationAnimation {
        from: 0
        to: 360
        target: rotation
        running: control.running
        loops: Animation.Infinite
        duration: Math.max(1, control.duration)
    }
}
