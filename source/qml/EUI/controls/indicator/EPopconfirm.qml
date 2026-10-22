import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15

EPopover {
    id: control

    property bool hideIcon: false
    property bool cancelDisabled: false
    property bool confirmDisabled: false
    property Component actionsComponent: null
    property int cancelStyleType: EStyle.Default
    property int confirmStyleType: EStyle.Primary
    property int iconSource: EIcons.CIRCLE_QUESTION
    property string cancelText: EControlConfig.textFor(control, "Cancel", ELocale.texts)
    property string confirmText: EControlConfig.textFor(control, "Confirm3", ELocale.texts)
    property color iconColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)

    signal canceled()
    signal confirmed()

    function reject() {
        if (!enabled || cancelDisabled)
            return false
        close()
        canceled()
        return true
    }

    function accept() {
        if (!enabled || confirmDisabled)
            return false
        close()
        confirmed()
        return true
    }

    title: EControlConfig.textFor(control, "ConfirmAction", ELocale.texts)

    Row {
        spacing: 8
        width: parent.width

        EIcon {
            iconSize: 20
            color: control.iconColor
            visible: !control.hideIcon
            iconSource: control.iconSource
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            width: Math.max(0, parent.width - (!control.hideIcon ? 28 : 0))
            height: actionsLoader.item ? actionsLoader.implicitHeight : actions.implicitHeight

            Loader {
                id: actionsLoader

                width: parent.width
                sourceComponent: control.actionsComponent
            }
            Row {
                id: actions

                spacing: 8
                anchors.right: parent.right
                visible: !control.actionsComponent

                EButton {
                    size: EStyle.Small
                    text: control.cancelText
                    objectName: "cancelButton"
                    enabled: !control.cancelDisabled
                    styleType: control.cancelStyleType

                    onClicked: control.reject()
                }
                EButton {
                    size: EStyle.Small
                    text: control.confirmText
                    objectName: "confirmButton"
                    enabled: !control.confirmDisabled
                    styleType: control.confirmStyleType

                    onClicked: control.accept()
                }
            }
        }
    }
}
