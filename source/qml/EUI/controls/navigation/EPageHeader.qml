import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias extra: extraContent.data

    property string content: ""
    property bool showBack: true
    property Component bodyComponent: null
    property Component iconComponent: null
    property Component titleComponent: null
    property Component contentComponent: null
    property int iconSource: EIcons.ARROW_LEFT
    property Component breadcrumbComponent: null
    property string title: EControlConfig.textFor(control, "Back", ELocale.texts)

    signal back()

    padding: 0
    implicitWidth: 400
    implicitHeight: 40 + (breadcrumbLoader.item ? breadcrumbLoader.implicitHeight + 12 : 0)
        + (bodyLoader.item ? bodyLoader.implicitHeight + 16 : 0)
    contentItem: Item {
        Loader {
            id: breadcrumbLoader

            width: parent.width
            sourceComponent: control.breadcrumbComponent
        }
        Loader {
            id: bodyLoader

            width: parent.width
            y: heading.y + heading.height + 16
            sourceComponent: control.bodyComponent
        }
        Row {
            id: heading

            height: 40
            spacing: 16
            y: breadcrumbLoader.item ? breadcrumbLoader.implicitHeight + 12 : 0

            ETextButton {
                id: backButton

                iconSize: 16
                leftIcon: true
                text: control.title
                visible: control.showBack
                iconSource: control.iconSource
                implicitWidth: backContent.implicitWidth + leftPadding + rightPadding
                contentItem: Row {
                    id: backContent

                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter

                    EIcon {
                        iconSize: 16
                        iconSource: control.iconSource
                        visible: !control.iconComponent
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                    }
                    Loader {
                        sourceComponent: control.iconComponent
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    EText {
                        text: control.title
                        font: backButton.font
                        visible: !control.titleComponent
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                    }
                    Loader {
                        sourceComponent: control.titleComponent
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: control.back()
            }
            ERectangle {
                width: 1
                height: 16
                visible: control.showBack
                anchors.verticalCenter: parent.verticalCenter
                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            }
            Loader {
                sourceComponent: control.contentComponent
                anchors.verticalCenter: parent.verticalCenter
            }
            EText {
                font.pixelSize: 18
                text: control.content
                elide: Text.ElideRight
                visible: !control.contentComponent
                anchors.verticalCenter: parent.verticalCenter
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                width: Math.max(0, control.availableWidth - extraContent.width - x - 16)
            }
        }
        Item {
            id: extraContent

            height: 40
            y: heading.y
            width: childrenRect.width
            anchors.right: parent.right
        }
    }
}
