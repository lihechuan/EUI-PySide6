import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: body.data

    property string footer: ""
    property string header: ""
    property Component footerDelegate: null
    property Component headerDelegate: null
    property string shadow: EControlConfig.optionFor(control, "card", "shadow", "never")

    padding: 20
    hoverEnabled: true
    implicitWidth: 320
    implicitHeight: panel.implicitHeight + topPadding + bottomPadding
    background: ERectangle {
        radius: 4
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

        EShadow {
            z: -1
            elevation: 8
            radius: parent.radius
            visible: control.shadow === "always" || control.shadow === "hover" && control.hovered
        }
    }
    contentItem: Column {
        id: panel

        spacing: 16

        EText {
            font.bold: true
            font.pixelSize: 16
            width: parent.width
            text: control.header
            wrapMode: Text.WordWrap
            visible: text.length > 0 && !headerSlot.active
            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
        }
        Loader {
            id: headerSlot

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.headerDelegate
        }
        ERectangle {
            height: 1
            width: control.width
            x: -control.leftPadding
            visible: control.header.length > 0 || headerSlot.active
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        Item {
            id: body

            width: parent.width
            implicitHeight: childrenRect.height
        }
        ERectangle {
            height: 1
            width: control.width
            x: -control.leftPadding
            visible: control.footer.length > 0 || footerSlot.active
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        EText {
            font.pixelSize: 14
            width: parent.width
            text: control.footer
            wrapMode: Text.WordWrap
            visible: text.length > 0 && !footerSlot.active
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
        Loader {
            id: footerSlot

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.footerDelegate
        }
    }
}
