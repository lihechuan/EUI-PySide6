import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property real value: 50
    property bool hover: false
    property url afterSource: ""
    property url beforeSource: ""
    property bool vertical: false
    property Component afterComponent: null
    property Component beforeComponent: null
    property Component handleComponent: null

    readonly property real fraction: isFinite(value) ? Math.max(0, Math.min(100, value)) / 100 : 0.5

    signal moved(real value)

    function setValue(next) {
        if (!enabled || !isFinite(next))
            return false
        const normalized = Math.max(0, Math.min(100, next))
        if (normalized === value)
            return false
        value = normalized
        moved(value)
        return true
    }

    implicitWidth: 480
    implicitHeight: 280
    activeFocusOnTab: true
    Accessible.name: "Compare"
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Slider

    Keys.onUpPressed: setValue(value - 1)
    Keys.onDownPressed: setValue(value + 1)
    Keys.onLeftPressed: setValue(value - 1)
    Keys.onRightPressed: setValue(value + 1)
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Home || event.key === Qt.Key_End) {
            setValue(event.key === Qt.Key_Home ? 0 : 100)
            event.accepted = true
        }
    }

    Item {
        clip: true
        anchors.fill: parent

        Image {
            anchors.fill: parent
            source: control.afterSource
            visible: !control.afterComponent
            fillMode: Image.PreserveAspectCrop
        }
        Loader {
            anchors.fill: parent
            sourceComponent: control.afterComponent
        }
    }
    Item {
        clip: true
        width: control.vertical ? control.width : control.width * control.fraction
        height: control.vertical ? control.height * control.fraction : control.height

        Item {
            width: control.width
            height: control.height

            Image {
                anchors.fill: parent
                source: control.beforeSource
                visible: !control.beforeComponent
                fillMode: Image.PreserveAspectCrop
            }
            Loader {
                anchors.fill: parent
                sourceComponent: control.beforeComponent
            }
        }
    }
    Rectangle {
        color: "white"
        width: control.vertical ? control.width : 2
        height: control.vertical ? 2 : control.height
        x: control.vertical ? 0 : control.width * control.fraction - 1
        y: control.vertical ? control.height * control.fraction - 1 : 0
    }
    ERectangle {
        width: 36
        height: 36
        radius: 18
        border.width: control.activeFocus ? 2 : 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        x: (control.vertical ? control.width / 2 : control.width * control.fraction) - width / 2
        y: (control.vertical ? control.height * control.fraction : control.height / 2) - height / 2

        EIcon {
            iconSize: 18
            anchors.centerIn: parent
            visible: !control.handleComponent
            rotation: control.vertical ? 90 : 0
            iconSource: EIcons.ARROW_RIGHT_ARROW_LEFT
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        }
        Loader {
            anchors.fill: parent
            sourceComponent: control.handleComponent
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: control.hover
        cursorShape: control.vertical ? Qt.SplitVCursor : Qt.SplitHCursor

        onPressed: function(mouse) {
            control.forceActiveFocus()
            control.setValue(control.vertical ? mouse.y / Math.max(1, height) * 100
                : mouse.x / Math.max(1, width) * 100)
        }
        onPositionChanged: function(mouse) {
            if (pressed || control.hover)
                control.setValue(control.vertical ? mouse.y / Math.max(1, height) * 100
                    : mouse.x / Math.max(1, width) * 100)
        }
    }
}
