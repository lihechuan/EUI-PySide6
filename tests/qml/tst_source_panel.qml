import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property var panel: null

    function pasteClipboard() {
        pasteTarget.clear()
        pasteTarget.paste()
        return pasteTarget.text
    }

    function plainText(text) {
        return text.replace(/\r\n?/g, "\n").replace(/[\u2028\u2029]/g, "\n").replace(/\u00a0/g, " ")
    }

    function cleanup() {
        if (panel) {
            panel.destroy()
            panel = null
        }
        pasteTarget.clear()
        ETheme.dark = false
        ELocale.language = "en"
    }

    function test_echartsStructuredSource_data() {
        return exampleData.models.EChartsTypes.map(function(type, index) {
            return {tag: type.value, index: index}
        })
    }

    function makePanel(code, width) {
        panel = createTemporaryObject(panelComponent, testCase, {code: code, width: width})
        verify(panel !== null)
        verify(waitForRendering(panel))
        return panel
    }

    function test_layoutAndScrolling_data() {
        return [
            {tag: "light-narrow", dark: false, width: 340},
            {tag: "light-wide", dark: false, width: 760},
            {tag: "dark-narrow", dark: true, width: 340},
            {tag: "dark-wide", dark: true, width: 760}
        ]
    }

    function test_previewWheelIsolation_data() {
        return [
            {tag: "case-scroll-view", card: false, scrollView: true},
            {tag: "case-flickable", card: false, scrollView: false},
            {tag: "card-scroll-view", card: true, scrollView: true},
            {tag: "card-flickable", card: true, scrollView: false}
        ]
    }

    function test_staticPreviewAllowsPageWheel() {
        const frame = createTemporaryObject(previewComponent, testCase, {useStaticPreview: true})
        verify(frame !== null)
        const preview = findChild(frame, "staticPreview")
        mouseWheel(preview, 80, 60, 0, -120)
        tryVerify(function() { return frame.contentY > 0 })
    }

    function test_multilineSourceFormatting() {
        const code = Gallery.GalleryStyle.sourceCode(`
            EText {
                text: "C:\\temp | \${value} | \`quoted\` | line1\\nline2"

                width: 120
            }
            `)
        compare(code, 'EText {\n    text: "C:\\temp | ${value} | `quoted` | line1\\nline2"\n\n    width: 120\n}\n')
        compare(Gallery.GalleryStyle.sourceCode(""), "")
        compare(Gallery.GalleryStyle.sourceCode("EText {}"), "EText {}")
        compare(Gallery.GalleryStyle.sourceCode("\n    EText {}"), "EText {}")
        makePanel(code, 560)
        panel.expanded = true
        const source = findChild(panel, "gallerySourceText")
        tryVerify(function() { return source.contentHeight > 0 })
        compare(plainText(source.getText(0, source.length)), code)
        mouseClick(findChild(panel, "gallerySourceCopy"))
        compare(pasteClipboard(), code)
    }

    function test_themeUpdatesWhileExpanded() {
        ETheme.dark = false
        makePanel('ETag {\n    text: "示例"\n    closable: true\n    width: 120\n}', 560)
        panel.expanded = true
        const source = findChild(panel, "gallerySourceText")
        const pane = findChild(panel, "gallerySourcePane")
        const numbers = findChild(panel, "gallerySourceLineNumbers")
        tryVerify(function() {
            return source.contentHeight > 0
        })
        const lightText = source.text
        const lightBackground = pane.color.toString()
        const lightNumbers = numbers.color.toString()
        const height = panel.implicitHeight
        ETheme.dark = true
        tryVerify(function() {
            return source.text !== lightText
        })
        verify(pane.color.toString() !== lightBackground)
        verify(numbers.color.toString() !== lightNumbers)
        compare(panel.implicitHeight, height)
        ETheme.dark = false
        tryCompare(source, "text", lightText)
        compare(pane.color.toString(), lightBackground)
    }

    function test_nestedWheelIsolation() {
        const frame = createTemporaryObject(nestedComponent, testCase)
        verify(frame !== null)
        const sourcePanel = findChild(frame, "nestedSource")
        const viewport = findChild(sourcePanel, "gallerySourceViewport")
        tryVerify(function() { return viewport.contentHeight > viewport.height })
        const outer = frame.contentY
        mouseWheel(viewport, viewport.width / 2, 50, 0, -120)
        tryVerify(function() { return viewport.contentY > 0 })
        compare(frame.contentY, outer, "A wheel over source must not scroll the page")
        viewport.contentY = viewport.contentHeight - viewport.height
        mouseWheel(viewport, viewport.width / 2, 50, 0, -120)
        wait(50)
        compare(frame.contentY, outer, "Source wheel events must remain isolated at the boundary")
        const cursor = findChild(sourcePanel, "gallerySourcePointer")
        verify(cursor !== null, "Every source panel must explicitly keep a visible pointer")
        compare(cursor.cursorShape, Qt.ArrowCursor)
        mouseMove(viewport, 70, 40)
        tryCompare(cursor, "containsMouse", true)
        compare(galleryTest.cursorShape(cursor), Qt.ArrowCursor)
    }

    function test_copySourceAndKeyboardSelection() {
        const code = 'ETag {\r\n\ttext: "<示例>&值"\r\n\tclosable: true\r\n}\r\n'
        makePanel(code, 560)
        const copy = findChild(panel, "gallerySourceCopy")
        mouseClick(copy)
        compare(pasteClipboard(), plainText(code))
        panel.expanded = true
        const source = findChild(panel, "gallerySourceText")
        tryVerify(function() {
            return source.contentHeight > 0
        })
        verify(waitForRendering(source))
        const start = source.positionToRectangle(0)
        const end = source.positionToRectangle(4)
        mouseDrag(source, start.x + 1, start.y + start.height / 2, end.x - start.x - 1, 0)
        compare(plainText(source.selectedText), "ETag")
        source.forceActiveFocus()
        keySequence(StandardKey.SelectAll)
        const displayed = plainText(code).replace(/\t/g, "    ")
        compare(plainText(source.selectedText), displayed)
        keySequence(StandardKey.Copy)
        compare(pasteClipboard(), displayed)
        keyClick(Qt.Key_X)
        compare(plainText(source.getText(0, source.length)), displayed)
        mouseClick(copy)
        compare(pasteClipboard(), plainText(code))
        panel.expanded = false
        mouseClick(copy)
        compare(pasteClipboard(), plainText(code))
    }

    function test_multipleFilesAndCopy() {
        const first = "EText {\n" + ('    text: "' + 'source '.repeat(50) + '"\n').repeat(80) + "}"
        const second = 'Node {\n    objectName: "asset"\n}'
        makePanel("Usage.qml", 760)
        panel.sourceFiles = [{path: "TokyoScene.qml", code: first}, {path: "assets/LittlestTokyo.qml", code: second}]
        const explorer = findChild(panel, "gallerySourceFiles")
        compare(explorer.visible, false)
        mouseClick(findChild(panel, "gallerySourceToggle"))
        tryCompare(explorer, "visible", true)
        compare(panel.displayedCode, first)
        const viewport = findChild(panel, "gallerySourceViewport")
        tryVerify(function() { return viewport.contentHeight > viewport.height && viewport.contentWidth > viewport.width })
        viewport.contentX = 120
        viewport.contentY = 60
        const fileButton = findChild(panel, "gallerySourceFile1")
        verify(waitForRendering(fileButton))
        mouseClick(fileButton)
        compare(panel.displayedCode, second)
        compare(viewport.contentX, 0)
        compare(viewport.contentY, 0)
        compare(findChild(panel, "gallerySourceText").selectedText, "")
        mouseClick(findChild(panel, "gallerySourceCopy"))
        compare(panel.exampleClipboard.lastText, second)
        mouseClick(findChild(panel, "gallerySourceToggle"))
        tryCompare(explorer, "visible", false)
    }

    function test_previewWheelIsolation(data) {
        const frame = createTemporaryObject(data.card ? previewCardComponent : previewComponent,
            testCase, {useScrollView: data.scrollView})
        const scroll = findChild(frame, "nestedPreviewScroll")
        verify(frame !== null && scroll !== null)
        if (data.scrollView) {
            tryVerify(function() { return scroll.scrollTarget !== null })
            scroll.setScrollTop(0)
        } else {
            scroll.contentY = 0
        }
        const outer = frame.contentY
        mouseWheel(scroll, 80, 60, 0, -120)
        tryVerify(function() { return (data.scrollView ? scroll.scrollTop : scroll.contentY) > 0 })
        compare(frame.contentY, outer, "Scrolling the preview must not scroll the page")
        if (data.scrollView)
            scroll.setScrollTop(scroll.contentHeight)
        else
            scroll.contentY = scroll.contentHeight - scroll.height
        mouseWheel(scroll, 80, 60, 0, -120)
        wait(50)
        compare(frame.contentY, outer, "A preview at its boundary must not scroll the page")
        if (data.scrollView) {
            scroll.setScrollTop(0)
            const bar = scroll.ScrollBar.vertical
            mouseDrag(bar, bar.width / 2, bar.contentItem.y + bar.contentItem.height / 2, 0, 50)
            tryVerify(function() { return scroll.scrollTop > 0 })
            compare(frame.contentY, outer, "Dragging the preview scrollbar must not drag the page")
        }
    }

    function test_echartsStructuredSource(data) {
        const showcase = createTemporaryObject(showcaseComponent, testCase, {width: 760})
        verify(showcase !== null)
        const scenario = findChild(showcase, "showcaseEECharts" + data.index)
        verify(scenario !== null)
        const code = scenario.code
        verify(/\n {8}"series": \[\n/.test(code), "Chart series must use indented multiline source")
        verify(code.split("\n").every(function(line) { return line.length <= 100 }),
            "Chart configuration must not contain long single lines")
        const sample = createTemporaryQmlObject(code, testCase, scenario.objectName)
        verify(sample !== null)
        const chart = findChild(scenario, "galleryPreviewContent").children[0].item
        verify(chart !== null)
        compare(JSON.stringify(sample.option), JSON.stringify(chart.option))
        makePanel(code, 760)
        panel.expanded = true
        const source = findChild(panel, "gallerySourceText")
        const viewport = findChild(panel, "gallerySourceViewport")
        tryVerify(function() { return source.contentHeight > 0 })
        compare(plainText(source.getText(0, source.length)), code)
        compare(panel.sourceLineCount, code.split("\n").length)
        verify(viewport.contentWidth <= viewport.width)
        mouseClick(findChild(panel, "gallerySourceCopy"))
        compare(pasteClipboard(), code)
    }

    function test_sourceScrollHandlesAndHorizontalWheel() {
        const frame = createTemporaryObject(nestedComponent, testCase)
        const sourcePanel = findChild(frame, "nestedSource")
        sourcePanel.code = "EText {\n" + ('    text: "' + 'source '.repeat(80) + '"\n').repeat(80) + "}"
        const viewport = findChild(sourcePanel, "gallerySourceViewport")
        tryVerify(function() { return viewport.contentHeight > viewport.height && viewport.contentWidth > viewport.width })
        const outer = frame.contentY
        mouseWheel(viewport, 90, 50, -120, 0)
        tryVerify(function() { return viewport.contentX > 0 })
        compare(viewport.contentY, 0)
        compare(frame.contentY, outer)
        viewport.contentX = 0
        mouseWheel(viewport, 90, 50, 0, -120, Qt.NoButton, Qt.ShiftModifier)
        tryVerify(function() { return viewport.contentX > 0 })
        compare(viewport.contentY, 0)
        compare(frame.contentY, outer)
        const vertical = findChild(sourcePanel, "gallerySourceVerticalScroll")
        vertical.active = true
        mouseDrag(vertical, vertical.width / 2, 4, 0, 90)
        tryVerify(function() { return viewport.contentY > 0 })
        compare(frame.contentY, outer, "Dragging the source scrollbar must not drag the page")
        viewport.contentX = 0
        const horizontal = findChild(sourcePanel, "gallerySourceHorizontalScroll")
        horizontal.active = true
        mouseDrag(horizontal, 4, horizontal.height / 2, 90, 0)
        tryVerify(function() { return viewport.contentX > 0 })
        compare(frame.contentY, outer)
    }

    function test_layoutAndScrolling(data) {
        ETheme.dark = data.dark
        const lines = []
        for (let index = 0; index < 42; ++index)
            lines.push('    text: "' + index + ' ' + 'source '.repeat(30) + '"')
        const code = "ETag {\n" + lines.join("\n") + "\n}\n"
        makePanel(code, data.width)
        const collapsedHeight = panel.implicitHeight
        const source = findChild(panel, "gallerySourceText")
        const pane = findChild(panel, "gallerySourcePane")
        const viewport = findChild(panel, "gallerySourceViewport")
        const numbers = findChild(panel, "gallerySourceLineNumbers")
        compare(source.length, 0)
        panel.expanded = true
        tryVerify(function() {
            return source.contentHeight > panel.maximumSourceHeight
        })
        compare(source.font.pixelSize, 14)
        compare(source.font.family, Gallery.GalleryStyle.codeFamily)
        compare(source.wrapMode, TextEdit.NoWrap)
        compare(source.readOnly, true)
        compare(source.selectByMouse, true)
        compare(pane.height, panel.maximumSourceHeight)
        compare(panel.implicitHeight, collapsedHeight + pane.height)
        const first = source.positionToRectangle(0)
        const second = source.positionToRectangle(code.indexOf("\n") + 1)
        verify(Math.abs(second.y - first.y - 22) <= 1)
        verify(viewport.contentWidth > viewport.width)
        verify(viewport.contentHeight > viewport.height)
        verify(numbers.width > 0)
        const gutterBefore = numbers.mapToItem(pane, 0, 0)
        const sourceBefore = source.mapToItem(pane, 0, 0)
        compare(gutterBefore.y, sourceBefore.y)
        compare(gutterBefore.y + numbers.baselineOffset, sourceBefore.y + source.baselineOffset)
        viewport.contentX = Math.min(120, viewport.contentWidth - viewport.width)
        viewport.contentY = 66
        const gutterAfter = numbers.mapToItem(pane, 0, 0)
        const sourceAfter = source.mapToItem(pane, 0, 0)
        compare(gutterAfter.x, gutterBefore.x)
        compare(gutterAfter.y, gutterBefore.y - 66)
        compare(sourceAfter.x, sourceBefore.x - viewport.contentX)
        compare(sourceAfter.y, sourceBefore.y - 66)
        panel.expanded = false
        tryCompare(panel, "implicitHeight", collapsedHeight)
        compare(source.length, 0)
        compare(pane.visible, false)
        panel.expanded = true
        tryVerify(function() {
            return source.contentHeight > panel.maximumSourceHeight
        })
        compare(panel.code, code)
    }

    width: 820
    height: 520
    visible: true
    when: windowShown
    name: "SourcePanel"

    TextEdit {
        id: pasteTarget

        y: 460
        height: 40
        width: 800
        textFormat: TextEdit.PlainText
    }
    Component {
        id: panelComponent

        Gallery.CodeExpander {
            property QtObject exampleClipboard: QtObject {
                property string lastText: ""

                function setText(code) {
                    lastText = code
                    pasteTarget.text = code
                    pasteTarget.selectAll()
                    pasteTarget.copy()
                    pasteTarget.clear()
                }
            }

            x: 24
            y: 24
            height: implicitHeight
        }
    }
    Component {
        id: showcaseComponent

        Gallery.EEChartsShowcase { }
    }
    Component {
        id: nestedComponent

        Flickable {
            width: 780
            height: 480
            contentHeight: 1600
            boundsBehavior: Flickable.StopAtBounds

            Gallery.CodeExpander {
                y: 30
                expanded: true
                width: parent.width
                height: implicitHeight
                objectName: "nestedSource"
                code: "EText {\n" + '    text: "source"\n'.repeat(80) + "}"
            }
        }
    }
    Component {
        id: scrollPreviewComponent

        EScrollbar {
            contentWidth: 500
            contentHeight: 1000
            objectName: "nestedPreviewScroll"

            Rectangle {
                width: 500
                height: 1000
                color: "#777777"
            }
        }
    }
    Component {
        id: flickPreviewComponent

        Flickable {
            contentHeight: 1000
            objectName: "nestedPreviewScroll"
            boundsBehavior: Flickable.StopAtBounds

            Rectangle {
                width: 500
                height: 1000
                color: "#777777"
            }
        }
    }
    Component {
        id: previewComponent

        Flickable {
            id: previewFrame

            property bool useScrollView: true
            property bool useStaticPreview: false

            width: 780
            height: 480
            contentHeight: 1600
            boundsBehavior: Flickable.StopAtBounds

            Gallery.ExampleCase {
                width: parent.width

                Loader {
                    width: 500
                    height: 160
                    sourceComponent: previewFrame.useStaticPreview ? staticPreviewComponent
                        : previewFrame.useScrollView ? scrollPreviewComponent : flickPreviewComponent
                }
            }
        }
    }
    Component {
        id: staticPreviewComponent

        Rectangle {
            color: "#777777"
            objectName: "staticPreview"
        }
    }
    Component {
        id: previewCardComponent

        Flickable {
            id: previewCardFrame

            property bool useScrollView: true

            width: 780
            height: 480
            contentHeight: 1600
            boundsBehavior: Flickable.StopAtBounds

            Gallery.ExampleCard {
                code: "EText {}"
                width: parent.width

                Loader {
                    width: 500
                    height: 160
                    sourceComponent: previewCardFrame.useScrollView ? scrollPreviewComponent : flickPreviewComponent
                }
            }
        }
    }
}
