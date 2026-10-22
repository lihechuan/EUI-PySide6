import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property int max: 0
    property var value: []
    property bool closable: true
    property string delimiter: ""
    property bool draggable: true
    property bool clearable: false
    property int maxCollapseTags: 1
    property bool collapseTags: false
    property bool validateEvent: true
    property string placeholderText: ""
    property int trigger: Qt.Key_Return
    property Component tagDelegate: null
    property string validationMessage: ""
    property Component prefixComponent: null
    property Component suffixComponent: null
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None

    readonly property int rowHeight: size === EStyle.Small ? 20 : size === EStyle.Large ? 32 : 24

    signal cleared()
    signal added(string tag)
    signal removed(string tag)
    signal reordered(int from, int to)

    function clear() {
        if (!enabled || !clearable)
            return false
        value = []
        cleared()
        return true
    }

    function addTag(text) {
        const tag = String(text).trim()
        if (!enabled || !tag || value.indexOf(tag) >= 0 || (max > 0 && value.length >= max))
            return false
        value = value.concat([tag])
        added(tag)
        return true
    }

    function removeTag(index) {
        if (!enabled || !closable || index < 0 || index >= value.length)
            return false
        const items = value.slice(0)
        const tag = items.splice(index, 1)[0]
        value = items
        removed(tag)
        return true
    }

    function moveTag(from, to) {
        if (!enabled || from < 0 || to < 0 || from >= value.length || to >= value.length)
            return false
        const items = value.slice(0)
        const tag = items.splice(from, 1)[0]
        items.splice(to, 0, tag)
        value = items
        reordered(from, to)
        return true
    }

    padding: 4
    hoverEnabled: true
    implicitWidth: 320
    implicitHeight: tagFlow.implicitHeight + topPadding + bottomPadding
    rightPadding: clearButton.visible ? clearButton.width + 8 : padding
    background: FieldSurface {
        hovered: control.hovered
        focused: editor.activeFocus
        validationState: control.validationState
    }
    contentItem: Flow {
        id: tagFlow

        spacing: 6

        Loader {
            height: control.rowHeight
            active: control.prefixComponent !== null
            sourceComponent: control.prefixComponent
        }
        Repeater {
            id: tagRepeater

            objectName: "inputTagRepeater"
            model: control.collapseTags ? control.value.slice(0, Math.max(1, control.maxCollapseTags))
                : control.value
            delegate: Item {
                id: tagItem

                property int tagIndex: index

                readonly property string tag: modelData
                readonly property real contentWidth: tagLoader.item ? tagLoader.item.implicitWidth : 0
                readonly property real contentHeight: tagLoader.item ? tagLoader.item.implicitHeight : 0

                height: contentHeight
                width: Math.min(tagFlow.width, contentWidth)

                Loader {
                    id: tagLoader

                    readonly property string tag: tagItem.tag
                    readonly property int tagIndex: tagItem.tagIndex

                    function remove() {
                        return control.removeTag(tagIndex)
                    }

                    anchors.fill: parent
                    sourceComponent: control.tagDelegate || standardTag
                }
                DragHandler {
                    id: dragHandler

                    target: null
                    acceptedButtons: Qt.LeftButton
                    enabled: control.enabled && control.draggable

                    onActiveChanged: {
                        if (active)
                            dragState.sourceIndex = tagItem.tagIndex
                        else {
                            const from = tagItem.tagIndex
                            const target = dragState.targetIndex
                            dragState.sourceIndex = -1
                            dragState.targetIndex = -1
                            if (target >= 0)
                                Qt.callLater(function() {
                                    control.moveTag(from, target)
                                })
                        }
                    }
                    onCentroidChanged: {
                        if (!active)
                            return
                        const point = tagItem.mapToItem(tagFlow, centroid.position.x, centroid.position.y)
                        dragState.targetIndex = -1
                        const siblings = tagRepeater.count
                        for (let position = 0; position < siblings; ++position) {
                            const item = tagRepeater.itemAt(position)
                            if (item && point.x >= item.x && point.x <= item.x + item.width
                                    && point.y >= item.y
                                        && point.y <= item.y + item.height) dragState.targetIndex = position
                        }
                    }
                }
                ERectangle {
                    radius: 4
                    border.width: 1
                    anchors.fill: parent
                    color: "transparent"
                    border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    visible: dragState.sourceIndex >= 0 && dragState.targetIndex === tagItem.tagIndex
                }
            }
        }
        ETag {
            text: "+" + Math.max(0, control.value.length - Math.max(1, control.maxCollapseTags))
            visible: control.collapseTags && control.value.length > Math.max(1, control.maxCollapseTags)
        }
        Loader {
            height: control.rowHeight
            active: control.suffixComponent !== null
            sourceComponent: control.suffixComponent
        }
        EInput {
            id: editor

            background: null
            size: control.size
            height: control.rowHeight
            width: Math.min(120, tagFlow.width)
            placeholderText: control.placeholderText
            enabled: control.enabled && (control.max <= 0 || control.value.length < control.max)

            onTextEdited: {
                if (control.delimiter && text.indexOf(control.delimiter) >= 0) {
                    const parts = text.split(control.delimiter)
                    for (let index = 0; index < parts.length - 1; ++index)
                        control.addTag(parts[index])
                    text = parts[parts.length - 1]
                }
            }
            Keys.onPressed: {
                if (event.key === control.trigger
                    || (control.trigger === Qt.Key_Return && event.key === Qt.Key_Enter)) {
                    if (control.addTag(text))
                        clear()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace && text.length === 0 && control.value.length > 0) {
                    control.removeTag(control.value.length - 1)
                    event.accepted = true
                }
            }
        }
    }

    onValueChanged: if (!EDataUtils.isArray(value))
        value = []

    ETextButton {
        id: clearButton

        width: 24
        height: 24
        iconSize: 12
        minHeight: 24
        anchors.rightMargin: 4
        iconSource: EIcons.XMARK
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: control.clearable && control.value.length > 0
        accessibleName: EControlConfig.textFor(control, "ClearAll", ELocale.texts)

        onClicked: control.clear()
    }
    Component {
        id: standardTag

        ETag {
            text: parent.tag
            size: control.size
            closable: control.closable

            onClosed: parent.remove()
        }
    }
    QtObject {
        id: dragState

        property int sourceIndex: -1
        property int targetIndex: -1
    }
}
