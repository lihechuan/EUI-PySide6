import EUI 1.0
import EUI.Private 1.0 as Private
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property bool showToolbar: true
    property alias text: editor.text
    property string placeholderText: ""
    property alias readOnly: editor.readOnly

    readonly property alias editor: editor
    readonly property bool canRedo: editor.canRedo
    readonly property bool canUndo: editor.canUndo
    readonly property string plainText: editor.getText(0, editor.length)
    readonly property var currentFormat: {
        const position = editor.cursorPosition
        const revision = state.revision
        return document.formatAt(position)
    }

    signal formatApplied(string operation)

    function redo() {
        if (enabled && !readOnly)
            editor.redo()
    }

    function undo() {
        if (enabled && !readOnly)
            editor.undo()
    }

    function applyFormat(operation, value) {
        if (!enabled || readOnly)
            return false
        if (!document.apply(editor.selectionStart, editor.selectionEnd, operation, value))
            return false
        state.revision++
        editor.forceActiveFocus()
        formatApplied(operation)
        return true
    }

    padding: 16
    implicitWidth: 560
    implicitHeight: 300
    background: ERectangle {
        radius: 6
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    ERectangle {
        x: 1
        y: 1
        radius: 5
        height: toolbar.height + 16
        visible: control.showToolbar
        width: Math.max(0, control.width - 2)
        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
    }
    Flow {
        id: toolbar

        spacing: 4
        x: control.padding - 8
        y: control.padding - 8
        visible: control.showToolbar
        width: Math.max(0, control.availableWidth + 16)

        Repeater {
            model: [
                {icon: EIcons.BOLD, action: "bold", title: ELocale.texts.EditorBold},
                {icon: EIcons.ITALIC, action: "italic", title: ELocale.texts.EditorItalic},
                {icon: EIcons.UNDERLINE, action: "underline", title: ELocale.texts.EditorUnderline},
                {icon: EIcons.STRIKETHROUGH, action: "strike", title: ELocale.texts.EditorStrike},
                {icon: EIcons.TEXT_ALIGN_LEFT, action: "align", value: Qt.AlignLeft, title: ELocale.texts.EditorLeft},
                {icon: EIcons.TEXT_ALIGN_CENTER, action: "align", value: Qt.AlignHCenter, title: ELocale.texts.EditorCenter},
                {icon: EIcons.LIST_OL, action: "list", value: "ordered", title: ELocale.texts.EditorOrdered},
                {icon: EIcons.LIST_UL, action: "list", value: "bullet", title: ELocale.texts.EditorBullet},
                {icon: EIcons.ERASER, action: "clear", value: true, title: ELocale.texts.EditorClear}]

            ETextButton {
                id: action

                readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                width: 32
                height: 32
                iconSize: 18
                minHeight: 32
                leftPadding: 0
                rightPadding: 0
                enabled: !control.readOnly
                iconSource: modelData.icon
                Accessible.name: modelData.title
                checkable: modelData.value === undefined
                objectName: "textEditorFormat_" + modelData.action
                styleType: checked ? EStyle.Primary : EStyle.Default
                checked: checkable && !!control.currentFormat[modelData.action]
                background: ERectangle {
                    radius: 4
                    color: action.checked
                        ? Qt.rgba(action.accent.r, action.accent.g, action.accent.b, ETheme.dark ? 0.24 : 0.12)
                        : action.hovered ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark) : "transparent"
                }

                onClicked: control.applyFormat(modelData.action,
                    modelData.value === undefined ? !control.currentFormat[modelData.action] : modelData.value)

                EToolTip {
                    reference: parent
                    text: modelData.title
                    visible: parent.hovered
                }
            }
        }
        Rectangle {
            y: 6
            width: 1
            height: 20
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        ETextButton {
            width: 32
            height: 32
            iconSize: 18
            minHeight: 32
            iconSource: EIcons.ARROW_ROTATE_LEFT
            Accessible.name: ELocale.texts.EditorUndo
            enabled: !control.readOnly && control.canUndo

            onClicked: control.undo()

            EToolTip {
                reference: parent
                visible: parent.hovered
                text: ELocale.texts.EditorUndo
            }
        }
        ETextButton {
            width: 32
            height: 32
            iconSize: 18
            minHeight: 32
            iconSource: EIcons.ARROW_ROTATE_RIGHT
            Accessible.name: ELocale.texts.EditorRedo
            enabled: !control.readOnly && control.canRedo

            onClicked: control.redo()

            EToolTip {
                reference: parent
                visible: parent.hovered
                text: ELocale.texts.EditorRedo
            }
        }
    }
    Rectangle {
        x: 1
        height: 1
        visible: control.showToolbar
        y: toolbar.y + toolbar.height + 8
        width: Math.max(0, control.width - 2)
        color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    Flickable {
        id: scroll

        clip: true
        x: control.padding
        contentWidth: width
        width: control.availableWidth
        ScrollBar.vertical: Private.ScrollHandle {}
        contentHeight: Math.max(height, editor.contentHeight)
        height: Math.max(0, control.height - y - control.padding)
        y: control.showToolbar ? toolbar.y + toolbar.height + 24 : control.padding

        TextEdit {
            id: editor

            font.pixelSize: 14
            selectByMouse: true
            width: scroll.width
            activeFocusOnTab: true
            wrapMode: TextEdit.Wrap
            persistentSelection: true
            textFormat: TextEdit.RichText
            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            selectionColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

            onTextChanged: state.revision++
            onCursorRectangleChanged: {
                if (cursorRectangle.y < scroll.contentY)
                    scroll.contentY = cursorRectangle.y
                else if (cursorRectangle.y + cursorRectangle.height > scroll.contentY + scroll.height)
                    scroll.contentY = cursorRectangle.y + cursorRectangle.height - scroll.height
            }
        }
        EText {
            text: control.placeholderText
            visible: !editor.length && !editor.activeFocus
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
    }
    Private.TextDocument {
        id: document

        document: editor.textDocument
    }
    QtObject {
        id: state

        property int revision: 0
    }
}
