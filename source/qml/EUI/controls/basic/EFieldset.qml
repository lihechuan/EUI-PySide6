import EUI 1.0
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: body.data

    property string title: ""
    property bool collapsed: false
    property bool collapsible: false

    signal toggled(bool collapsed)

    function toggle() {
        if (!enabled || !collapsible)
            return false
        collapsed = !collapsed
        toggled(collapsed)
        return true
    }

    padding: 16
    topPadding: 28
    implicitWidth: 320
    implicitHeight: collapsed ? 36 : body.childrenRect.height + topPadding + bottomPadding
    contentItem: Item {
        id: body

        visible: !control.collapsed
        implicitHeight: childrenRect.height
    }
    background: ERectangle {
        y: 12
        radius: 6
        border.width: 1
        height: parent.height - y
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    ETextButton {
        y: 0
        x: 12
        plain: true
        iconSize: 14
        minHeight: 26
        leftIcon: true
        leftPadding: 8
        rightPadding: 8
        text: control.title
        objectName: "fieldsetToggle"
        Accessible.description: control.collapsed ? "collapsed" : "expanded"
        background: ERectangle { color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark) }
        iconSource: control.collapsible ? control.collapsed ? EIcons.CHEVRON_RIGHT : EIcons.CHEVRON_DOWN : 0

        onClicked: control.toggle()
    }
}
