import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: extraContent.data

    property var model: []
    property bool open: true
    property string title: ""
    property string mode: "icon"
    property bool overlay: false
    property string side: "left"
    property real breakpoint: 768
    property bool collapsed: false
    property bool responsive: true
    property real collapsedWidth: 64
    property string currentIndex: ""
    property real expandedWidth: 240
    property bool openOnHover: false
    property bool closeOnSelect: true
    property string variant: "sidebar"
    property Component footerComponent: null
    property Component headerComponent: null

    readonly property bool iconMode: !overlayMode && collapsed && mode === "icon"
    readonly property bool overlayMode: overlay || mode === "offcanvas"
        || responsive && Window.window !== null && Window.window.width < breakpoint

    signal selected(string index, var item)

    function toggle() {
        if (!enabled)
            return false
        if (overlayMode)
            open = !open
        else
            collapsed = !collapsed
        return true
    }

    implicitHeight: 480
    implicitWidth: overlayMode || !open ? 0 : iconMode ? collapsedWidth : expandedWidth

    Item {
        id: panel

        anchors.fill: parent
        visible: control.open
        parent: control.overlayMode ? overlayHost : control

        ERectangle {
            anchors.fill: parent
            radius: control.variant === "floating" ? 12 : 0
            border.width: control.variant === "inset" ? 0 : 1
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        HoverHandler {
            enabled: control.openOnHover && !control.overlayMode

            onHoveredChanged: control.collapsed = !hovered
        }
        ETextButton {
            id: trigger

            x: 8
            y: 8
            iconSize: 18
            leftIcon: true
            leftPadding: 12
            Accessible.name: control.title
            iconSource: EIcons.BARS_UNALIGNED
            visible: !control.headerComponent
            width: Math.max(0, parent.width - 16)
            text: control.iconMode ? "" : control.title
            contentItem: Row {
                spacing: 10

                EIcon {
                    iconSize: 18
                    iconSource: trigger.iconSource
                    anchors.verticalCenter: parent.verticalCenter
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                }
                EText {
                    font.bold: true
                    text: trigger.text
                    height: parent.height
                    elide: Text.ElideRight
                    visible: !control.iconMode
                    verticalAlignment: Text.AlignVCenter
                    width: Math.max(0, parent.width - x)
                }
            }

            onClicked: control.toggle()
        }
        Loader {
            id: header

            width: parent.width
            sourceComponent: control.headerComponent
        }
        EMenu {
            id: menu

            x: 4
            model: control.model
            collapse: control.iconMode
            currentIndex: control.currentIndex
            width: Math.max(0, parent.width - 8)
            y: control.headerComponent ? header.height + 8 : trigger.y + trigger.height + 8

            onItemSelected: {
                control.currentIndex = index
                control.selected(index, item)
                if (control.closeOnSelect && control.overlayMode)
                    control.open = false
            }
        }
        Item {
            id: extraContent

            x: 8
            y: menu.y + menu.height + 12
            height: Math.max(0, footer.y - y)
            width: Math.max(0, parent.width - 16)
        }
        Loader {
            id: footer

            width: parent.width
            anchors.bottom: parent.bottom
            sourceComponent: control.footerComponent
        }
    }
    EDrawer {
        id: drawer

        title: control.title
        drawerSize: control.expandedWidth
        visible: control.overlayMode && control.open
        edge: control.side === "right" ? Qt.RightEdge : Qt.LeftEdge

        onClosed: if (control.overlayMode)
            control.open = false

        Item {
            id: overlayHost

            width: parent.width
            height: Math.max(0, drawer.height - 64)
        }
    }
}
