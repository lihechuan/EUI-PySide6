import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property bool reverse: false
    property string mode: "start"
    property Component dotDelegate: null
    property Component contentDelegate: null

    readonly property var displayEvents: EDataUtils.isArray(model) ? (reverse ? model.slice().reverse() : model)
        : []

    implicitWidth: 360
    implicitHeight: events.implicitHeight
    contentItem: Column {
        id: events

        Repeater {
            model: control.displayEvents

            Item {
                id: entry

                property var event: modelData || ({})

                readonly property real dotSize: event.size === "large" ? 20 : 12
                readonly property real dotY: event.center ? (height - 24 - dotSize) / 2 : 4
                readonly property real lineX: alternate ? width / 2 : control.mode === "end" ? width - 6 : 6
                readonly property int styleType: event.styleType === undefined ? EStyle.Primary
                    : event.styleType
                readonly property bool alternate: control.mode === "alternate"
                    || control.mode === "alternate-reverse"
                readonly property color accent: event.color
                    || EPaletteManager.ThemePalette.fetchColorForStyle(styleType)
                readonly property bool leftSide: control.mode === "end"
                    || alternate && (index % 2 === (control.mode === "alternate" ? 1 : 0))

                width: events.width
                objectName: "timelineItem_" + index
                height: eventColumn.implicitHeight + 24

                ERectangle {
                    width: 2
                    x: entry.lineX - 1
                    y: entry.dotY + entry.dotSize / 2
                    height: Math.max(0, parent.height - y)
                    visible: index < control.displayEvents.length - 1
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
                ERectangle {
                    y: entry.dotY
                    radius: width / 2
                    width: entry.dotSize
                    height: entry.dotSize
                    visible: !dotSlot.active
                    border.color: entry.accent
                    x: entry.lineX - width / 2
                    border.width: entry.event.hollow ? 2 : 0
                    color: entry.event.hollow ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                        : entry.accent

                    EIcon {
                        anchors.centerIn: parent
                        iconSize: parent.width - 4
                        visible: entry.event.icon !== undefined
                        color: EPaletteManager.BasePalette.white
                        iconSource: entry.event.icon === undefined ? 0 : entry.event.icon
                    }
                }
                Loader {
                    id: dotSlot

                    property var event: entry.event

                    y: entry.dotY
                    x: entry.lineX - width / 2
                    active: sourceComponent !== null
                    sourceComponent: entry.event.dotDelegate || control.dotDelegate
                }
                Column {
                    id: eventColumn

                    spacing: 8
                    x: entry.leftSide ? 0 : entry.lineX + 22
                    width: entry.alternate ? Math.max(0, entry.width / 2 - 22) : Math.max(0, entry.width - 28)

                    EText {
                        font.pixelSize: 12
                        width: parent.width
                        text: String(entry.event.timestamp || "")
                        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                        horizontalAlignment: entry.leftSide ? Text.AlignRight : Text.AlignLeft
                        visible: !entry.event.hideTimestamp && entry.event.placement === "top"
                    }
                    EText {
                        font: control.font
                        width: parent.width
                        wrapMode: Text.WordWrap
                        visible: !contentSlot.active
                        text: String(entry.event.content || "")
                        color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                        horizontalAlignment: entry.leftSide ? Text.AlignRight : Text.AlignLeft
                    }
                    Loader {
                        id: contentSlot

                        property var event: entry.event

                        width: parent.width
                        active: sourceComponent !== null
                        sourceComponent: entry.event.contentDelegate || control.contentDelegate
                    }
                    EText {
                        font.pixelSize: 12
                        width: parent.width
                        text: String(entry.event.timestamp || "")
                        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                        horizontalAlignment: entry.leftSide ? Text.AlignRight : Text.AlignLeft
                        visible: !entry.event.hideTimestamp && entry.event.placement !== "top"
                    }
                }
            }
        }
    }
}
