import EUI 1.0
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property int activeIndex: -1
    property int columnWidth: 180
    property bool vertical: false

    readonly property var groups: activeIndex >= 0 && EDataUtils.isArray(model) && model[activeIndex]
        && EDataUtils.isArray(model[activeIndex].children) ? model[activeIndex].children : []

    signal command(var command, var item)

    function close() {
        popup.close()
        activeIndex = -1
    }

    function trigger(item) {
        if (!enabled || !item || item.disabled)
            return false
        close()
        command(item.command === undefined ? item.value : item.command, item)
        if (typeof item.command === "function")
            item.command(item)
        return true
    }

    function open(index) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(index) || Math.floor(index) !== index || index < 0 || index >= model.length
            || !model[index] || model[index].disabled)
            return false
        activeIndex = index
        popup.open()
        return true
    }

    padding: 4
    implicitWidth: menu.implicitWidth + padding * 2
    implicitHeight: menu.implicitHeight + padding * 2
    background: ERectangle {
        radius: 6
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    Grid {
        id: menu

        spacing: 4
        x: control.padding
        y: control.padding
        columns: control.vertical ? 1 : Math.max(1, entries.count)

        Repeater {
            id: entries

            model: EDataUtils.isArray(control.model) ? control.model : []

            ETextButton {
                id: menuButton

                readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                leftPadding: 12
                rightPadding: 12
                enabled: !modelData.disabled
                text: String(modelData.label || modelData.text || "")
                styleType: control.activeIndex === index ? EStyle.Primary : EStyle.Default
                width: control.vertical ? control.columnWidth - control.padding * 2 : implicitWidth
                background: ERectangle {
                    radius: 6
                    color: control.activeIndex === index
                        ? Qt.rgba(menuButton.accent.r, menuButton.accent.g, menuButton.accent.b, ETheme.dark ? 0.2 : 0.1)
                        : menuButton.hovered ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark) : "transparent"
                }
                contentItem: Row {
                    spacing: 8

                    EText {
                        font: menuButton.font
                        height: parent.height
                        text: menuButton.text
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        width: control.vertical ? Math.max(0, parent.width - 24) : implicitWidth
                        color: !menuButton.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                            : control.activeIndex === index ? menuButton.accent
                            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    EIcon {
                        iconSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                        iconSource: control.vertical ? EIcons.CHEVRON_RIGHT : EIcons.CHEVRON_DOWN
                    }
                }

                onClicked: control.activeIndex === index ? control.close() : control.open(index)
            }
        }
    }
    Popup {
        id: popup

        focus: true
        padding: 16
        x: control.vertical ? control.width + 4 : 0
        y: control.vertical ? 0 : control.height + 4
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: ERectangle {
            radius: 6
            border.width: 1
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        contentItem: Row {
            spacing: 20

            Repeater {
                model: control.groups

                Column {
                    spacing: 6
                    width: control.columnWidth

                    EText {
                        topPadding: 4
                        font.bold: true
                        leftPadding: 10
                        bottomPadding: 6
                        font.pixelSize: 12
                        text: String(modelData.label || modelData.text || "")
                        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    }
                    Repeater {
                        model: EDataUtils.isArray(modelData.children) ? modelData.children : []

                        ETextButton {
                            id: menuItem

                            leftPadding: 10
                            font.bold: false
                            rightPadding: 10
                            width: control.columnWidth
                            enabled: !modelData.disabled
                            text: String(modelData.label || modelData.text || "")
                            contentItem: EText {
                                font: menuItem.font
                                text: menuItem.text
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                color: !menuItem.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                                    : menuItem.hovered ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                                    : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                            }

                            onClicked: control.trigger(modelData)
                        }
                    }
                }
            }
        }

        onClosed: control.activeIndex = -1
    }
}
