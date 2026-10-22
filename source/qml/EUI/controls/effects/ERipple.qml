import EUI 1.0
import QtQuick 2.15

Item {
    id: control
    default property alias content: body.data

    property int duration: 450
    property Item target: null
    property color color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

    signal triggered(real x, real y)

    function pulse(x, y) {
        if (!enabled || !isFinite(x) || !isFinite(y))
            return false
        animation.stop()
        wave.x = x - wave.width / 2
        wave.y = y - wave.height / 2
        animation.start()
        triggered(x, y)
        return true
    }

    implicitWidth: body.childrenRect.width
    implicitHeight: body.childrenRect.height

    Item {
        id: body

        anchors.fill: parent
    }
    Item {
        id: surface

        z: 100
        clip: true
        width: parent ? parent.width : 0
        parent: control.target || control
        height: parent ? parent.height : 0

        TapHandler {
            enabled: control.enabled

            onTapped: control.pulse(point.position.x, point.position.y)
        }
        Rectangle {
            id: wave

            opacity: 0
            height: width
            radius: width / 2
            color: control.color
            width: Math.sqrt(surface.width * surface.width + surface.height * surface.height) * 2
        }
    }
    ParallelAnimation {
        id: animation

        NumberAnimation {
            to: 1
            from: 0
            target: wave
            property: "scale"
            duration: control.duration
        }
        NumberAnimation {
            to: 0
            from: 0.25
            target: wave
            property: "opacity"
            duration: control.duration
        }
    }
}
