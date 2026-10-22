import EUI 1.0
import EUI.Private 1.0
import "../form" as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property string title: ""
    property var checkedKeys: []
    property bool draggable: false
    property bool filterable: true
    property var filterMethod: null
    property bool reorderable: false
    property Component optionDelegate: null
    property Component footerComponent: null

    readonly property int selectedCount: availableKeys.filter(function(key) {
        return control.checkedKeys.indexOf(key) >= 0
    }).length
    readonly property var availableKeys: filteredItems.filter(function(item) {
        return !item.disabled
    })
        .map(function(item) {
            return item.key
        })
    readonly property var filteredItems: model.filter(function(item) {
        return typeof control.filterMethod === "function"
            ? control.filterMethod(filter.text, item.raw || item)
            : String(item.label).toLowerCase().indexOf(filter.text.toLowerCase()) >= 0
    })

    signal moveSelection(int delta)
    signal toggled(var key, bool checked)
    signal allToggled(var keys, bool checked)
    signal dragFinished(var key, real x, real y)

    padding: 1
    implicitHeight: 280
    background: FieldSurface {}
    contentItem: Item {
        ERectangle {
            id: header

            height: 40
            width: parent.width
            color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)

            ECheckBox {
                width: 28
                borderVisible: false
                anchors.leftMargin: 8
                anchors.left: parent.left
                objectName: "transferCheckAll"
                enabled: control.availableKeys.length > 0
                anchors.verticalCenter: parent.verticalCenter
                checkState: control.selectedCount === 0 ? Qt.Unchecked
                    : control.selectedCount === control.availableKeys.length ? Qt.Checked
                        : Qt.PartiallyChecked

                onClicked: {
                    control.allToggled(
                        control.availableKeys,
                        control.selectedCount !== control.availableKeys.length
                    )
                    checkState = Qt.binding(function() {
                        return control.selectedCount === 0 ? Qt.Unchecked
                            : control.selectedCount === control.availableKeys.length ? Qt.Checked
                                : Qt.PartiallyChecked
                    })
                }
            }
            EText {
                font.pixelSize: 14
                text: control.title
                anchors.leftMargin: 40
                anchors.rightMargin: 8
                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.right: count.left
                anchors.verticalCenter: parent.verticalCenter
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            }
            EText {
                id: count

                font.pixelSize: 12
                anchors.rightMargin: 14
                text: control.model.length
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            }
            ERectangle {
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            }
        }
        FormControls.EInput {
            id: filter

            x: 12
            clearable: true
            y: header.height + 12
            width: parent.width - 24
            visible: control.filterable
            objectName: "transferSearch"
            prefixIcon: EIcons.MAGNIFIER
            placeholderText: EControlConfig.textFor(control, "Search2", ELocale.texts)
        }
        Loader {
            id: footerLoader

            readonly property var panel: control
            readonly property var checkedKeys: control.checkedKeys
            readonly property real contentHeight: active && item ? item.implicitHeight : 0

            width: parent.width
            height: contentHeight
            anchors.bottom: parent.bottom
            active: control.footerComponent !== null
            sourceComponent: control.footerComponent
        }
        ListView {
            id: list

            clip: true
            width: parent.width
            objectName: "transferList"
            model: control.filteredItems
            ScrollBar.vertical: ScrollHandle {}
            y: control.filterable ? filter.y + filter.height + 12 : header.height + 6
            height: Math.max(0, parent.height - y - 6 - footerLoader.height
                - (control.reorderable ? 36 : 0))
            delegate: ECheckBox {
                id: checkBox

                borderVisible: false
                text: modelData.label
                width: ListView.view.width
                enabled: !modelData.disabled
                checked: control.checkedKeys.indexOf(modelData.key) >= 0
                contentItem: EText {
                    font: checkBox.font
                    text: checkBox.text
                    elide: Text.ElideRight
                    visible: !control.optionDelegate
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: checkBox.indicator.width + checkBox.spacing + 10
                    color: !checkBox.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        : checkBox.hovered ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                        : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }

                onClicked: {
                    control.toggled(modelData.key, checked)
                    checked = Qt.binding(function() {
                        return control.checkedKeys.indexOf(modelData.key) >= 0
                    })
                }

                Loader {
                    readonly property var option: modelData.raw || modelData
                    readonly property bool selected: control.checkedKeys.indexOf(modelData.key) >= 0

                    function toggle() {
                        control.toggled(modelData.key, !selected)
                    }

                    anchors.fill: parent
                    active: control.optionDelegate !== null
                    sourceComponent: control.optionDelegate
                    anchors.leftMargin: checkBox.indicator.width + checkBox.spacing + 10
                }
                DragGesture {
                    anchors.fill: parent
                    enabled: control.draggable && !modelData.disabled

                    onTapped: control.toggled(modelData.key, !checkBox.checked)
                    onDropped: function(x, y) {
                        const position = mapToItem(control, x, y)
                        control.dragFinished(modelData.key, position.x, position.y)
                    }
                }
            }

            EText {
                anchors.centerIn: parent
                visible: control.filteredItems.length === 0
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                text: EControlConfig.textFor(control, "NoOptions", ELocale.texts)
            }
        }
        Row {
            height: 32
            spacing: 6
            visible: control.reorderable
            y: parent.height - footerLoader.height - height
            anchors.horizontalCenter: parent.horizontalCenter

            ETextButton {
                text: "↑"
                enabled: control.checkedKeys.length > 0

                onClicked: control.moveSelection(-1)
            }
            ETextButton {
                text: "↓"
                enabled: control.checkedKeys.length > 0

                onClicked: control.moveSelection(1)
            }
        }
    }
}
