import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: body.data

    property bool once: false
    property real distance: 24
    property int duration: 300
    property Item target: body
    property Item viewport: null
    property string enterEffect: "fadeIn"
    property string leaveEffect: "fadeOut"

    readonly property bool inViewport: observer.inViewport

    signal exited()
    signal entered()

    function animate(inside) {
        if (!enabled || !target || once && state.played)
            return false
        const effect = inside ? enterEffect : leaveEffect
        if (inside)
            state.played = true
        if (inside)
            entered()
        else
            exited()
        return effect.length > 0 && EAnimation.play(target, effect, {duration: duration, distance: distance})
    }

    implicitWidth: body.childrenRect.width
    implicitHeight: body.childrenRect.height

    Item {
        id: body

        anchors.fill: parent
    }
    EDeferred {
        id: observer

        anchors.fill: parent
        viewport: control.viewport

        onEntered: control.animate(true)
        onExited: control.animate(false)
    }
    QtObject {
        id: state

        property bool played: false
    }
}
