import EUI 1.0
import QtQuick 2.15

Item {
    id: control

    property real hue: 0
    property real brightness: 1
    property real saturation: 0

    signal moved(real saturation, real brightness)

    function updatePosition(x, y) {
        if (enabled && width > 0 && height > 0)
            moved(Math.max(0, Math.min(1, x / width)), Math.max(0, Math.min(1, 1 - y / height)))
    }

    implicitHeight: 150
    activeFocusOnTab: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Right)
            moved(Math.max(0, Math.min(1, saturation
                + (event.key === Qt.Key_Right ? 0.01 : -0.01))), brightness)
        else if (event.key === Qt.Key_Up || event.key === Qt.Key_Down)
            moved(saturation, Math.max(0, Math.min(1, brightness + (event.key === Qt.Key_Up ? 0.01 : -0.01))))
        else
            return
        event.accepted = true
    }

    ERectangle {
        anchors.fill: parent
        color: Qt.hsva(control.hue, 1, 1, 1)

        ERectangle {
            rotation: -90
            height: parent.width
            width: parent.height
            anchors.centerIn: parent
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: EPaletteManager.BasePalette.white
                }
                GradientStop {
                    position: 1
                    color: EPaletteManager.BasePalette.transparent
                }
            }
        }
        ERectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: EPaletteManager.BasePalette.transparent
                }
                GradientStop {
                    position: 1
                    color: EPaletteManager.BasePalette.black
                }
            }
        }
        ERectangle {
            radius: 5
            width: 10
            height: 10
            border.width: 2
            color: EPaletteManager.BasePalette.transparent
            border.color: EPaletteManager.BasePalette.white
            x: Math.max(0, Math.min(parent.width - width, control.saturation * parent.width - width / 2))
            y: Math.max(
                0,
                Math.min(parent.height - height, (1 - control.brightness) * parent.height - height / 2)
            )
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.CrossCursor

        onPositionChanged: if (pressed)
            control.updatePosition(mouse.x, mouse.y)
        onPressed: {
            control.forceActiveFocus()
            control.updatePosition(mouse.x, mouse.y)
        }
    }
}
