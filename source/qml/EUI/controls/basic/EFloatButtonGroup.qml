import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: menu.content

    property real gap: 8
    property bool open: false
    property string tooltip: ""
    property string trigger: ""
    property real buttonSize: 48
    property string shape: "circle"
    property string placement: "top"
    property int closeIcon: EIcons.XMARK
    property int iconSource: EIcons.PLUS

    readonly property alias triggerButton: button
    readonly property bool menuMode: trigger === "click" || trigger === "hover"
    readonly property bool horizontal: placement === "left" || placement === "right"

    signal changed(bool opened)

    function close() {
        open = false
    }

    function toggle() {
        if (!enabled || !menuMode)
            return false

        open = !open
        return true
    }

    z: 100
    implicitWidth: menuMode ? buttonSize : menu.implicitWidth
    implicitHeight: menuMode ? buttonSize : menu.implicitHeight

    onOpenChanged: changed(open)
    onEnabledChanged: {
        if (!enabled)
            close()

    }
    Keys.onEscapePressed: function(event) {
        close()
        event.accepted = true
    }

    Item {
        x: Math.min(0, menu.visible ? menu.x : 0)
        y: Math.min(0, menu.visible ? menu.y : 0)
        width: Math.max(control.width, menu.visible ? menu.x + menu.width : 0) - x
        height: Math.max(control.height, menu.visible ? menu.y + menu.height : 0) - y

        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    hoverClose.stop()
                    if (control.enabled && control.trigger === "hover")
                        control.open = true

                } else if (control.trigger === "hover") {
                    hoverClose.restart()
                }
            }
        }
    }
    EFlex {
        id: menu

        gap: control.gap
        width: implicitWidth
        height: implicitHeight
        visible: !control.menuMode || control.open
        orientation: control.horizontal ? "horizontal" : "vertical"
        x: !control.menuMode ? 0
            : control.placement === "left" ? -width - control.gap
            : control.placement === "right" ? control.buttonSize + control.gap
            : 0
        y: !control.menuMode ? 0
            : control.placement === "bottom" ? control.buttonSize + control.gap
            : control.placement === "top" ? -height - control.gap
            : 0
    }
    Repeater {
        model: menu.contentChildren

        Item {
            Binding {
                property: "shape"
                target: modelData
                value: control.shape
                restoreMode: Binding.RestoreBindingOrValue
                when: modelData && modelData.shape !== undefined
            }
        }
    }
    EFloatButton {
        id: button

        shape: control.shape
        tooltip: control.tooltip
        visible: control.menuMode
        width: control.buttonSize
        height: control.buttonSize
        iconSource: control.open ? control.closeIcon : control.iconSource

        onClicked: control.toggle()
        onHoveredChanged: {
            if (control.trigger !== "hover")
                return
            if (hovered) {
                hoverClose.stop()
                control.open = true
            } else {
                hoverClose.restart()
            }
        }
    }
    Timer {
        id: hoverClose

        interval: 120

        onTriggered: control.close()
    }
}
