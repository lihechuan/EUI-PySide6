import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: control
    default property alias content: canvas.data

    property real radius: 0

    readonly property bool software: GraphicsInfo.api === GraphicsInfo.Software

    clip: true

    Item {
        id: canvas

        anchors.fill: parent
        opacity: control.software ? 0 : 1
        layer.enabled: !control.software && control.radius > 0
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                visible: false
                width: canvas.width
                height: canvas.height
                radius: control.radius
                color: EPaletteManager.BasePalette.white
            }
        }
    }
    Loader {
        anchors.fill: parent
        active: control.software
        sourceComponent: Component {
            BackdropRenderer {
                live: true
                blurRadius: 0
                tintOpacity: 0
                noiseOpacity: 0
                sourceItem: canvas
                anchors.fill: parent
                radius: control.radius
            }
        }
    }
}
