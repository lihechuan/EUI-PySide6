import QtQuick 2.15

MouseArea {
    id: control

    property bool dragging: false
    property point origin: Qt.point(0, 0)

    signal tapped()
    signal dropped(real x, real y)

    preventStealing: true
    acceptedButtons: Qt.LeftButton

    onCanceled: dragging = false
    onClicked: if (!dragging)
        tapped()
    onReleased: function(mouse) {
        if (dragging)
            dropped(mouse.x, mouse.y)
    }
    onPressed: function(mouse) {
        dragging = false
        origin = Qt.point(mouse.x, mouse.y)
    }
    onPositionChanged: function(mouse) {
        if (pressed && Math.abs(mouse.x - origin.x) + Math.abs(mouse.y - origin.y) >= Qt.styleHints.startDragDistance)
            dragging = true
    }
}
