import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property bool hit: false
    property string text: ""
    property int iconSource: 0
    property bool round: false
    property bool checked: false
    property url avatarSource: ""
    property bool closable: false
    property bool checkable: false
    property string effect: "light"
    property int styleType: EStyle.Primary
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent

    readonly property bool darkEffect: effect === "dark" || checkable && checked

    signal closed()
    signal clicked()
    signal changed(bool checked)

    topPadding: 0
    leftPadding: 8
    rightPadding: 8
    bottomPadding: 0
    implicitHeight: size === EStyle.Small ? 20 : size === EStyle.Large ? 32 : 24
    implicitWidth: label.implicitWidth + leftPadding + rightPadding
        + (avatarSource.toString().length || iconSource > 0 ? implicitHeight : 0)
    background: ERectangle {
        border.color: inside.borderColor
        border.width: control.hit ? 2 : 1
        radius: control.round ? height / 2 : 4
        color: control.color.a > 0 ? control.color : inside.backgroundColor
    }
    contentItem: Item {
        Loader {
            id: avatar

            height: width
            visible: active
            objectName: "tagAvatarLoader"
            width: control.implicitHeight - 4
            anchors.verticalCenter: parent.verticalCenter
            active: control.avatarSource.toString().length > 0
            sourceComponent: EAvatar {
                source: control.avatarSource
            }
        }
        EIcon {
            id: icon

            color: inside.textColor
            iconSource: control.iconSource
            iconSize: control.implicitHeight - 8
            visible: !avatar.visible && iconSource > 0
            anchors.verticalCenter: parent.verticalCenter
        }
        EText {
            id: label

            text: control.text
            height: parent.height
            elide: Text.ElideRight
            color: inside.textColor
            verticalAlignment: Text.AlignVCenter
            width: Math.max(0, parent.width - x)
            rightPadding: control.closable ? 20 : 0
            font.pixelSize: control.size === EStyle.Small ? 12 : 14
            x: avatar.visible || icon.visible ? control.implicitHeight : 0
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            control.clicked()
            if (control.checkable) {
                control.checked = !control.checked
                control.changed(control.checked)
            }
        }
    }
    ETextButton {
        width: 16
        height: 16
        circle: true
        iconSize: 12
        minHeight: 16
        color: inside.textColor
        iconSource: EIcons.XMARK
        visible: control.closable
        anchors.right: control.right
        anchors.rightMargin: control.rightPadding
        anchors.verticalCenter: control.verticalCenter
        accessibleName: EControlConfig.textFor(control, "Close", ELocale.texts)

        onClicked: control.closed()
    }
    QtObject {
        id: inside

        readonly property color textColor: EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setPlain(!control.darkEffect)
                .setEnabled(control.enabled)
                .setComponentStyle(control.styleType)
        )
        readonly property color borderColor: EPaletteManager.StatePalette.computeBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setBorder(true)
                .setPlain(!control.darkEffect)
                .setEnabled(control.enabled)
                .setComponentStyle(control.styleType)
        )
        readonly property color backgroundColor: control.effect === "plain"
            ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            : EPaletteManager.StatePalette.computeBackgroundColor(
                EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                    .setDark(ETheme.dark)
                    .setPlain(!control.darkEffect)
                    .setEnabled(control.enabled)
                    .setComponentStyle(control.styleType)
            )
    }
}
