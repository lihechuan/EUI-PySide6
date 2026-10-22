import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property string code: ""
    property real lineHeight: 22
    property bool showCopy: true
    property bool highlight: true
    property string language: "qml"
    property bool showLineNumbers: true
    property color backgroundColor: ETheme.dark ? "#1D2129" : "#F6F8FC"
    property var syntaxColors: ({
        plain: EPaletteManager.ThemePalette.textPrimary(ETheme.dark),
        type: ETheme.dark ? "#71CED1" : "#087F8C",
        property: ETheme.dark ? "#89B4FA" : "#315EB5",
        keyword: ETheme.dark ? "#C4A7E7" : "#8255AD",
        literal: ETheme.dark ? "#C4A7E7" : "#8255AD",
        string: ETheme.dark ? "#A6D3A0" : "#27775B",
        number: ETheme.dark ? "#E6B673" : "#A15C21",
        member: ETheme.dark ? "#89B4FA" : "#315EB5",
        comment: EPaletteManager.ThemePalette.textSecondary(ETheme.dark),
        punctuation: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
    })

    readonly property alias textItem: sourceText
    readonly property alias viewport: codeViewport
    readonly property string selectedText: sourceText.selectedText
    readonly property int lineCount: code.split(/\r\n|\r|\n/).length
    readonly property real contentHeight: sourceText.contentHeight + 40

    signal copied(string text)

    function copy() {
        if (!codeTools.copyText(code))
            return false
        copied(code)
        return true
    }

    function resetScroll() {
        codeViewport.cancelFlick()
        codeViewport.contentX = 0
        codeViewport.contentY = 0
        sourceText.deselect()
    }

    function paragraph(contents) {
        return '<p style="margin:0; line-height:' + Math.max(font.pixelSize, lineHeight)
            + 'px; -qt-line-height-type:fixed">' + contents + '</p>'
    }

    padding: 0
    font.pixelSize: 14
    implicitWidth: 480
    implicitHeight: 240
    font.family: EDefaultConfig.secondaryFontFamily
    background: ERectangle { color: control.backgroundColor }
    contentItem: Item {
        Item {
            id: gutter

            clip: true
            height: parent.height
            visible: control.showLineNumbers
            width: visible ? Math.max(52, String(control.lineCount).length * control.font.pixelSize * 0.65 + 24) : 0

            Text {
                x: 8
                font: control.font
                width: parent.width - 22
                textFormat: Text.RichText
                renderType: Text.QtRendering
                objectName: "codeLineNumbers"
                horizontalAlignment: Text.AlignRight
                color: ETheme.dark ? "#777F8F" : "#8992A3"
                y: sourceText.y + codeViewport.y - codeViewport.contentY
                text: control.paragraph(control.code.split(/\r\n|\r|\n/)
                    .map(function(line, index) { return index + 1 }).join("<br/>"))
            }
            ERectangle {
                y: 12
                width: 1
                height: parent.height - 24
                anchors.right: parent.right
                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            }
        }
        Flickable {
            id: codeViewport

            clip: true
            anchors.margins: 1
            interactive: false
            anchors.fill: parent
            objectName: "codeViewport"
            anchors.leftMargin: gutter.width
            contentHeight: control.contentHeight
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: Math.max(width, sourceText.contentWidth + 40)
            ScrollBar.vertical: ScrollHandle { objectName: "codeVerticalScroll" }
            ScrollBar.horizontal: ScrollHandle { objectName: "codeHorizontalScroll" }

            ECopyableText {
                id: sourceText

                x: 20
                y: 20
                font: control.font
                selectByMouse: true
                objectName: "codeText"
                wrapMode: TextEdit.NoWrap
                textFormat: TextEdit.RichText
                width: Math.max(codeViewport.width - 40, contentWidth)
                text: control.paragraph(codeTools.highlight(control.code,
                    control.highlight && ["qml", "javascript", "js"].indexOf(control.language) >= 0
                        ? control.syntaxColors : {plain: control.syntaxColors.plain}))
            }
        }
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            objectName: "codePointer"
            cursorShape: Qt.ArrowCursor
            acceptedButtons: Qt.NoButton

            onWheel: function(wheel) {
                codeViewport.cancelFlick()
                let dx = wheel.pixelDelta.x || wheel.angleDelta.x / 120 * 60
                let dy = wheel.pixelDelta.y || wheel.angleDelta.y / 120 * 60
                if ((wheel.modifiers & Qt.ShiftModifier) && dx === 0) {
                    dx = dy
                    dy = 0
                }
                codeViewport.contentX = Math.max(0, Math.min(codeViewport.contentX - dx,
                    codeViewport.contentWidth - codeViewport.width))
                codeViewport.contentY = Math.max(0, Math.min(codeViewport.contentY - dy,
                    codeViewport.contentHeight - codeViewport.height))
                wheel.accepted = true
            }
        }
        ETextButton {
            plain: true
            iconSize: 14
            minHeight: 28
            anchors.top: parent.top
            iconSource: EIcons.COPY
            visible: control.showCopy
            anchors.right: parent.right
            objectName: "codeCopyButton"
            accessibleName: EControlConfig.textFor(control, "CopySource", ELocale.texts)

            onClicked: control.copy()
        }
    }

    onCodeChanged: resetScroll()

    CodeTools { id: codeTools }
}
