import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: actions.data

    property string extra: ""
    property bool split: true
    property int itemIndex: -1
    property var itemData: null
    property string avatarText: ""
    property Component actionsDelegate: null
    property url avatarSource: itemData && typeof itemData === "object" ? itemData.avatar || "" : ""
    property string description: itemData && typeof itemData === "object" ? String(itemData.description || "")
        : ""
    property string title: itemData && typeof itemData === "object"
        ? String(itemData.title === undefined ? itemData.label === undefined ? ""
            : itemData.label
            : itemData.title)
        : itemData === null || itemData === undefined ? ""
        : String(itemData)

    padding: 12
    implicitWidth: 320
    implicitHeight: Math.max(48, row.implicitHeight + topPadding + bottomPadding)
    contentItem: Row {
        id: row

        spacing: 12

        EAvatar {
            id: avatar

            size: 36
            text: control.avatarText
            source: control.avatarSource
            anchors.verticalCenter: parent.verticalCenter
            visible: source.toString().length > 0 || text.length > 0
        }
        Column {
            spacing: 4
            width: Math.max(0, row.width - (avatar.visible ? 48
                : 0) - (extraText.visible ? extraText.implicitWidth + 12
                : 0) - (actions.width > 0 ? actions.width + 12
                : 0) - (actionLoader.item ? actionLoader.width + 12
                : 0))

            EText {
                font.bold: true
                text: control.title
                width: parent.width
                wrapMode: Text.WordWrap
                visible: text.length > 0
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                visible: text.length > 0
                text: control.description
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            }
        }
        EText {
            id: extraText

            text: control.extra
            visible: text.length > 0
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            id: actions

            width: childrenRect.width
            height: childrenRect.height
            anchors.verticalCenter: parent.verticalCenter
        }
        Loader {
            id: actionLoader

            property var itemData: control.itemData
            property int itemIndex: control.itemIndex

            sourceComponent: control.actionsDelegate
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ERectangle {
        height: 1
        width: parent.width
        visible: control.split
        anchors.bottom: parent.bottom
        color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
}
