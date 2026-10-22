import EUI 1.0
import QtQuick 2.15

Item {
    id: step

    property var entry
    property var owner
    property int stepIndex: 0

    readonly property bool vertical: owner.vertical
    readonly property bool failed: status === "error"
    readonly property bool waiting: status === "wait"
    readonly property bool processing: status === "process"
    readonly property bool simple: owner.simple && !vertical
    readonly property bool last: stepIndex === owner.count - 1
    readonly property string status: owner.statusAt(stepIndex)
    readonly property bool completed: status === "finish" || status === "success"
    readonly property bool itemEnabled: owner.enabled && !(entry && entry.disabled)
    readonly property string description: entry && typeof entry === "object" ? String(entry.description || "")
        : ""
    readonly property string title: typeof entry === "string" ? entry
        : String(entry && (entry.title || entry.text) || "")
    readonly property int styleType: failed ? EStyle.Danger
        : status === "success" ? EStyle.Success : status === "finish" ? EStyle.Primary : EStyle.Default
    readonly property color statusColor: waiting
        ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
        : EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(step, EStyle.Color)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setEnabled(itemEnabled)
                .setComponentStyle(styleType)
        )

    height: implicitHeight
    implicitHeight: simple ? 32 : vertical ? Math.max(owner.stepHeight, labels.implicitHeight + 24)
        : labels.y + labels.implicitHeight + 12

    ERectangle {
        y: step.vertical ? 28 : 13
        visible: !step.last && !step.simple
        x: step.vertical ? 13 : marker.x + 28
        width: step.vertical ? 2 : Math.max(0, step.width - 28)
        height: step.vertical ? Math.max(0, step.height - 28) : 2
        color: step.completed ? step.statusColor : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    EButton {
        id: marker

        width: 28
        height: 28
        padding: 0
        circle: true
        iconSize: 16
        minHeight: 28
        accessibleName: step.title
        enabled: step.itemEnabled && step.owner.clickable
        focusPolicy: step.owner.clickable ? Qt.StrongFocus : Qt.NoFocus
        text: step.completed || step.failed ? "" : String(step.stepIndex + 1)
        x: step.owner.alignCenter && !step.vertical && !step.simple ? (step.width - width) / 2 : 0
        iconSource: step.entry && step.entry.iconSource ? step.entry.iconSource
            : step.completed ? EIcons.CHECK : step.failed ? EIcons.XMARK : 0
        background: ERectangle {
            radius: width / 2
            visible: !step.simple
            border.width: step.simple ? 0 : 2
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: marker.activeFocus
                ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary) : step.statusColor
        }
        contentItem: Item {
            Loader {
                anchors.fill: parent
                sourceComponent: step.entry && step.entry.iconComponent || null
            }
            EIcon {
                iconSize: 16
                color: step.statusColor
                anchors.centerIn: parent
                iconSource: marker.iconSource
                visible: marker.iconSource > 0 && !(step.entry && step.entry.iconComponent)
            }
            EText {
                font.bold: true
                text: marker.text
                font.pixelSize: 14
                anchors.fill: parent
                color: step.statusColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                visible: marker.iconSource === 0 && !(step.entry && step.entry.iconComponent)
            }
        }

        onClicked: step.owner.select(step.stepIndex)
    }
    Column {
        id: labels

        spacing: 6
        x: step.vertical || step.simple ? 40 : 0
        y: step.vertical || step.simple ? 4 : 36
        width: step.owner.alignCenter && !step.vertical && !step.simple
            ? step.width : Math.max(0, step.width - x - (step.simple ? 24 : 12))

        Loader {
            width: parent.width
            sourceComponent: step.entry && step.entry.titleComponent || null
        }
        EText {
            text: step.title
            font.pixelSize: 16
            width: parent.width
            color: step.statusColor
            wrapMode: Text.WordWrap
            font.bold: step.processing
            visible: !(step.entry && step.entry.titleComponent)
            horizontalAlignment: step.owner.alignCenter && !step.vertical && !step.simple
                ? Text.AlignHCenter : Text.AlignLeft
        }
        Loader {
            width: parent.width
            visible: !step.simple
            sourceComponent: step.entry && step.entry.descriptionComponent || null
        }
        EText {
            font.pixelSize: 12
            width: parent.width
            text: step.description
            wrapMode: Text.WordWrap
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            visible: !step.simple && text.length > 0 && !(step.entry && step.entry.descriptionComponent)
            horizontalAlignment: step.owner.alignCenter && !step.vertical
                ? Text.AlignHCenter : Text.AlignLeft
        }
    }
    EIcon {
        iconSize: 16
        anchors.right: parent.right
        iconSource: EIcons.CHEVRON_RIGHT
        visible: step.simple && !step.last
        anchors.verticalCenter: parent.verticalCenter
        color: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
    }
}
