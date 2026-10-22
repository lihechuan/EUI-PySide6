import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property string title: ""
    property int iconSource: 0
    property bool center: false
    property bool closable: true
    property bool showIcon: true
    property string closeText: ""
    property string description: ""
    property string effect: "light"
    property int styleType: EStyle.Info
    property Component iconComponent: null
    property Component titleComponent: null
    property Component descriptionComponent: null

    readonly property bool darkEffect: effect === "dark"
    readonly property color accentColor: EPaletteManager.StatePalette.computeEffectiveTextColor(
        EPaletteManager.createStateObject(this, EStyle.TextColor)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
            .setTextButton(!control.darkEffect)
            .setComponentStyle(control.styleType)
    )

    signal closed()

    padding: 16
    implicitWidth: 400
    rightPadding: closable ? Math.max(44, dismissButton.implicitWidth + 20) : padding
    implicitHeight: Math.max(40, contentColumn.implicitHeight + topPadding + bottomPadding)
    background: ERectangle {
        radius: 4
        color: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setPlain(!control.darkEffect)
                .setComponentStyle(control.styleType)
        )
    }
    contentItem: Item {
        EIcon {
            id: statusIcon

            width: 20
            height: 20
            iconSize: 20
            color: control.accentColor
            anchors.verticalCenter: parent.verticalCenter
            visible: control.showIcon && !control.iconComponent
            iconSource: control.iconSource > 0 ? control.iconSource
                : control.styleType === EStyle.Success ? EIcons.CIRCLE_CHECK_FILL
                : control.styleType === EStyle.Warning ? EIcons.TRIANGLE_EXCLAMATION_FILL
                : control.styleType === EStyle.Danger ? EIcons.CIRCLE_XMARK_FILL : EIcons.CIRCLE_Info_FILL
        }
        Loader {
            id: iconLoader

            width: 20
            height: 20
            sourceComponent: control.iconComponent
            anchors.verticalCenter: parent.verticalCenter
        }
        Column {
            id: contentColumn

            spacing: 6
            width: Math.max(0, parent.width - x)
            anchors.verticalCenter: parent.verticalCenter
            x: statusIcon.visible || iconLoader.item ? 30 : 0

            Loader {
                width: parent.width
                sourceComponent: control.titleComponent
            }
            EText {
                font.pixelSize: 14
                text: control.title
                width: parent.width
                wrapMode: Text.WordWrap
                color: control.accentColor
                font.bold: control.description.length > 0
                visible: text.length > 0 && !control.titleComponent
                horizontalAlignment: control.center ? Text.AlignHCenter : Text.AlignLeft
            }
            Loader {
                width: parent.width
                sourceComponent: control.descriptionComponent
            }
            EText {
                font.pixelSize: 12
                width: parent.width
                wrapMode: Text.WordWrap
                text: control.description
                visible: text.length > 0 && !control.descriptionComponent
                horizontalAlignment: control.center ? Text.AlignHCenter : Text.AlignLeft
                color: control.darkEffect ? control.accentColor
                    : EPaletteManager.StatePalette.defaultTextColor(
                    EPaletteManager.createStateObject(this, EStyle.TextColor)
                        .setDark(ETheme.dark)
                        .setEnabled(control.enabled)
                )
            }
        }
    }

    ETextButton {
        id: dismissButton

        height: 24
        circle: true
        iconSize: 12
        anchors.rightMargin: 10
        text: control.closeText
        visible: control.closable
        anchors.right: parent.right
        width: control.closeText.length > 0 ? implicitWidth : 24
        iconSource: control.closeText.length > 0 ? 0 : EIcons.XMARK
        accessibleName: EControlConfig.textFor(control, "DismissAlert", ELocale.texts)
        y: Math.max(0, (control.description.length > 0 ? 40 : control.height) - height) / 2
        background: ERectangle {
            radius: 4
            color: parent.hovered ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                : EPaletteManager.BasePalette.transparent
        }

        onClicked: {
            control.visible = false
            control.closed()
        }
    }
}
