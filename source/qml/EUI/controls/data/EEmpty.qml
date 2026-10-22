import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: actions.data

    property url image: ""
    property int imageSize: 88
    property Component imageDelegate: null
    property Component descriptionDelegate: null
    property string description: EControlConfig.textFor(control, "NoData", ELocale.texts)

    padding: 20
    implicitWidth: 240
    implicitHeight: emptyColumn.implicitHeight + topPadding + bottomPadding
    contentItem: Column {
        id: emptyColumn

        spacing: 16

        Item {
            height: width
            width: Math.max(0, control.imageSize)
            anchors.horizontalCenter: parent.horizontalCenter

            EIcon {
                iconSize: parent.width
                anchors.centerIn: parent
                iconSource: EIcons.FOLDER_OPEN
                color: EPaletteManager.ThemePalette.borderDisabled(ETheme.dark)
                visible: emptyImage.status !== Image.Ready && !imageSlot.active
            }
            Image {
                id: emptyImage

                anchors.fill: parent
                source: control.image
                fillMode: Image.PreserveAspectFit
                visible: status === Image.Ready && !imageSlot.active
            }
            Loader {
                id: imageSlot

                anchors.fill: parent
                active: sourceComponent !== null
                sourceComponent: control.imageDelegate
            }
        }
        EText {
            font.pixelSize: 14
            width: parent.width
            wrapMode: Text.WordWrap
            text: control.description
            visible: !descriptionSlot.active
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
        Loader {
            id: descriptionSlot

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.descriptionDelegate
        }
        Row {
            id: actions

            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
