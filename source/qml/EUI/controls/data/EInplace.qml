import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias editor: editorLoader.sourceComponent

    property string text: ""
    property bool active: false
    property bool closable: true
    property Component displayComponent: null

    readonly property alias item: editorLoader.item

    signal closed()
    signal opened()

    function close() {
        if (!active)
            return false
        active = false
        return true
    }

    function open() {
        if (!enabled || active)
            return false
        active = true
        return true
    }

    implicitHeight: Math.max(32, active && item ? item.implicitHeight
        : displayLoader.item ? displayLoader.item.implicitHeight : displayButton.implicitHeight)
    implicitWidth: active && item ? item.implicitWidth + (closable ? 40 : 0)
        : displayLoader.item ? displayLoader.item.implicitWidth : displayButton.implicitWidth

    Keys.onEscapePressed: close()
    onActiveChanged: {
        if (active) {
            opened()
            Qt.callLater(function() { if (control && editorLoader.item) editorLoader.item.forceActiveFocus() })
        } else {
            closed()
        }
    }

    ETextButton {
        id: displayButton

        text: control.text
        anchors.fill: parent
        visible: !control.active && !control.displayComponent

        onClicked: control.open()
    }
    Loader {
        id: displayLoader

        anchors.fill: parent
        active: !control.active
        sourceComponent: control.displayComponent

        MouseArea {
            z: 1
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            visible: displayLoader.item !== null

            onClicked: control.open()
        }
    }
    Loader {
        id: editorLoader

        active: control.active
        width: Math.max(0, parent.width - (control.closable ? 40 : 0))
    }
    ETextButton {
        width: 32
        iconSize: 16
        iconSource: EIcons.XMARK
        anchors.right: parent.right
        Accessible.name: ELocale.texts.Close
        visible: control.active && control.closable

        onClicked: control.close()
    }
}
