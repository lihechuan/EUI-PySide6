import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property int separatorIcon: 0
    property bool clickableLast: false
    property string separator: EControlConfig.textFor(control, "PathSeparator", ELocale.texts).trim()

    readonly property int count: items.length
    readonly property var items: EDataUtils.isArray(model) ? model : []

    signal clicked(int index, var item)

    padding: 0
    implicitHeight: 32
    implicitWidth: crumbs.implicitWidth
    contentItem: Row {
        id: crumbs

        spacing: 8

        Repeater {
            model: control.items

            Row {
                readonly property var entry: modelData || ({})
                readonly property bool last: index === control.count - 1
                readonly property string label: typeof entry === "string" ? entry : String(entry.text || "")

                spacing: 8

                Loader {
                    sourceComponent: entry.contentComponent || null
                }
                ETextButton {
                    plain: true
                    text: label
                    leftPadding: 0
                    rightPadding: 0
                    font: control.font
                    enabled: !entry.disabled
                    Accessible.role: Accessible.Link
                    visible: (!last || control.clickableLast) && !entry.contentComponent

                    onClicked: control.clicked(index, modelData)
                }
                EText {
                    height: 32
                    text: label
                    font: control.font
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    visible: last && !control.clickableLast && !entry.contentComponent
                    color: entry.disabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        : EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                }
                EIcon {
                    iconSize: 14
                    iconSource: control.separatorIcon
                    visible: !last && control.separatorIcon > 0
                    anchors.verticalCenter: parent.verticalCenter
                    color: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                }
                EText {
                    font: control.font
                    text: control.separator
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !last && control.separatorIcon === 0
                    color: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                }
            }
        }
    }
}
