import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: actions.data

    property string title: ""
    property string subTitle: ""
    property Component iconDelegate: null
    property int styleType: EStyle.Success
    property Component titleDelegate: null
    property Component subTitleDelegate: null

    readonly property int iconSource: {
        switch (styleType) {
        case EStyle.Success: return EIcons.CIRCLE_CHECK
        case EStyle.Danger: return EIcons.CIRCLE_XMARK
        case EStyle.Warning: return EIcons.TRIANGLE_EXCLAMATION
        default: return EIcons.CIRCLE_Info
        }
    }

    padding: 24
    implicitWidth: 360
    implicitHeight: resultColumn.implicitHeight + 48
    contentItem: Column {
        id: resultColumn

        spacing: 16

        EIcon {
            iconSize: 64
            visible: !iconSlot.active
            iconSource: control.iconSource
            anchors.horizontalCenter: parent.horizontalCenter
            color: EPaletteManager.ThemePalette.fetchColorForStyle(control.styleType)
        }
        Loader {
            id: iconSlot

            active: sourceComponent !== null
            sourceComponent: control.iconDelegate
            anchors.horizontalCenter: parent.horizontalCenter
        }
        EText {
            font.pixelSize: 20
            text: control.title
            width: parent.width
            wrapMode: Text.WordWrap
            visible: !titleSlot.active
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
        }
        Loader {
            id: titleSlot

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.titleDelegate
        }
        EText {
            font.pixelSize: 14
            width: parent.width
            text: control.subTitle
            wrapMode: Text.WordWrap
            visible: !subTitleSlot.active
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        }
        Loader {
            id: subTitleSlot

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.subTitleDelegate
        }
        Row {
            id: actions

            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
