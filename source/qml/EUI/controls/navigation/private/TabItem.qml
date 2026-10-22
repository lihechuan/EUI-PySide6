import EUI 1.0
import "../../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

TabButton {
    id: tab

    property var entry
    property var owner
    property int tabIndex: 0

    readonly property bool card: owner.type === "card" || owner.type === "border-card"
    readonly property bool closeVisible: owner.closable || owner.editable || !!entry.closable

    padding: 0
    checkable: false
    Accessible.name: text
    enabled: !entry.disabled
    focusPolicy: Qt.StrongFocus
    leftPadding: card ? 16 : 20
    checked: tabIndex === owner.currentIndex
    rightPadding: leftPadding + (closeVisible ? 24 : 0)
    implicitHeight: EDefaultConfig.controlHeight(owner.size) + 8
    text: typeof entry === "string" ? entry : String(entry.text || entry.label || "")
    implicitWidth: Math.max(label.implicitWidth, labelLoader.implicitWidth) + leftPadding + rightPadding
    contentItem: EText {
        id: label

        text: tab.text
        elide: Text.ElideRight
        font.bold: tab.checked
        visible: !tab.entry.labelComponent
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: EDefaultConfig.controlFontPixelSize(tab.owner.size)
        color: EPaletteManager.StatePalette.computeTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setTextButton(true)
                .setEnabled(tab.enabled)
                .setHovered(tab.hovered)
                .setIsFound(tab.checked)
                .setComponentStyle(EStyle.Primary)
        )
    }
    background: ERectangle {
        border.width: tab.card ? 1 : 0
        color: !tab.card && tab.activeFocus
            ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
            : tab.card && !tab.checked
            ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
            : EPaletteManager.BasePalette.transparent
        border.color: EPaletteManager.StatePalette.resolveRectBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setEnabled(tab.enabled)
                .setActiveFocus(tab.activeFocus)
                .setComponentStyle(EStyle.Primary)
        )

        ERectangle {
            height: 2
            width: parent.width
            anchors.bottom: parent.bottom
            visible: tab.checked && !tab.card
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        }
    }

    Keys.onUpPressed: owner.selectAdjacent(tabIndex, -1)
    Keys.onDownPressed: owner.selectAdjacent(tabIndex, 1)
    Keys.onLeftPressed: owner.selectAdjacent(tabIndex, -1)
    Keys.onRightPressed: owner.selectAdjacent(tabIndex, 1)
    onClicked: {
        owner.select(tabIndex)
        owner.tabClicked(tabIndex, entry)
    }

    Loader {
        id: labelLoader

        anchors.fill: tab.contentItem
        sourceComponent: tab.entry.labelComponent || null
    }
    MouseArea {
        id: pointer

        property real pressX: 0
        property real pressY: 0
        property bool dragging: false

        anchors.fill: parent
        enabled: tab.owner.movable
        cursorShape: dragging ? Qt.ClosedHandCursor : Qt.ArrowCursor

        onCanceled: dragging = false
        onPressed: function(mouse) {
            pressX = mouse.x
            pressY = mouse.y
            dragging = false
        }
        onPositionChanged: function(mouse) {
            if (pressed && Math.abs(tab.owner.vertical ? mouse.y - pressY : mouse.x - pressX) > 12)
                dragging = true
        }
        onReleased: function(mouse) {
            if (dragging) {
                const position = mapToItem(tab.owner.contentItem, mouse.x, mouse.y)
                tab.owner.moveTab(tab.tabIndex, tab.owner.indexAt(tab.owner.vertical ? position.y
                    : position.x))
            } else {
                tab.owner.select(tab.tabIndex)
                tab.owner.tabClicked(tab.tabIndex, tab.entry)
            }
            dragging = false
        }
    }
    ETextButton {
        width: 24
        height: 24
        circle: true
        iconSize: 12
        anchors.rightMargin: 4
        iconSource: EIcons.XMARK
        visible: tab.closeVisible
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        accessibleName: EControlConfig.textFor(tab, "Close", ELocale.texts) + tab.text
        background: ERectangle {
            radius: 4
            color: parent.hovered ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                : EPaletteManager.BasePalette.transparent
        }

        onClicked: tab.owner.closeTab(tab.tabIndex)
    }
}
