import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import "../../example/qml/component/PrimeSamples.js" as PrimeSamples
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ELocale.language = "en"
    }

    function test_galleryTranslations_data() {
        return [
            {tag: "english", language: "en", title: "EUI component playground"},
            {tag: "chinese", language: "zh", title: "EUI 组件演示工作台"}
        ]
    }

    function test_languageNormalization(data) {
        ELocale.language = data.input
        compare(ELocale.language, data.expected)
        compare(ELocale.texts.LowElevation, data.expected === "zh" ? "低层级阴影" : "Low elevation")
    }

    function test_exampleLanguageCoverage_data() {
        const cases = []
        for (const group of exampleCatalog.groups) {
            for (const entry of group.children)
                cases.push({tag: entry.index, entry: entry})
        }
        return cases
    }

    function test_languageNormalization_data() {
        return [
            {tag: "english", input: "en-US", expected: "en"},
            {tag: "chinese", input: "zh-CN", expected: "zh"},
            {tag: "case", input: "ZH_tw", expected: "zh"},
            {tag: "unsupported", input: "fr", expected: "en"},
            {tag: "empty", input: "", expected: "en"}
        ]
    }

    function test_liveShowcaseTranslation() {
        ELocale.language = "en"
        const showcase = createTemporaryObject(shadowShowcase, testCase)
        verify(showcase !== null)
        const example = findChild(showcase, "showcaseEShadow0")
        verify(example !== null)
        compare(example.title, "Low elevation")
        ELocale.language = "zh"
        compare(example.title, "低层级阴影")
        ELocale.language = "en"
        compare(example.title, "Low elevation")
    }

    function test_exampleLanguageCoverage(data) {
        ELocale.language = "en"
        const definition = Qt.createComponent("../../example/qml/component/" + data.entry.source)
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {
            width: 1040, height: 820, selectedComponent: data.entry.index
        })
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        verifyEnglishText(page)
        ELocale.language = "zh"
        ELocale.language = "en"
        verifyEnglishText(page)
        definition.destroy()
    }

    function test_documentationTaskTitles() {
        ELocale.language = "en"
        const sample = Qt.createQmlObject(PrimeSamples.definitions.ETaskBoard.cases[0].code, testCase, "documentationTasks")
        verify(sample !== null)
        try {
            compare(sample.tasks[0].title, "Design components")
            ELocale.language = "zh"
            compare(sample.tasks[0].title, "设计组件")
            compare(sample.tasks[1].title, "实现交互")
            compare(sample.tasks[2].title, "编写测试")
            compare(sample.tasks[3].title, "编写接口文档")
            ELocale.language = "en"
            compare(sample.tasks[0].title, "Design components")
        } finally {
            sample.destroy()
        }
    }

    function verifyEnglishText(root) {
        const pending = [root]
        const properties = ["text", "title", "subTitle", "description", "placeholderText",
            "validationMessage", "emptyText", "noDataText", "loadingText", "code"]
        while (pending.length > 0) {
            const item = pending.pop()
            for (const property of properties) {
                const value = item[property]
                if (typeof value === "string" && value !== ELocale.texts.SimplifiedChinese)
                    verify(!/[\u3400-\u9fff]/.test(value), item.objectName + "." + property + ": " + value)
            }
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
    }

    function test_localTableTranslations() {
        ELocale.language = "en"
        const provider = createTemporaryObject(localTable, testCase)
        verify(provider !== null)
        const table = findChild(provider, "localizedTable")
        verify(table !== null)
        compare(table.sumText, "合计")
        compare(table.columnSettingsText, "列设置")
        provider.locale = "en"
        compare(table.sumText, "Total")
        compare(table.columnSettingsText, "Columns")
        provider.locale = {name: "zh", texts: {Total: "自定义合计", Columns: "自定义列设置"}}
        compare(table.sumText, "自定义合计")
        compare(table.columnSettingsText, "自定义列设置")
        provider.locale = "zh"
        table.sumText = "Override"
        ELocale.language = "zh"
        compare(table.sumText, "Override")
    }

    function test_catalogs() {
        const english = ELocale.textsForLanguage("en")
        const chinese = ELocale.textsForLanguage("zh-CN")
        const keys = Object.keys(english).sort()
        compare(Object.keys(chinese).sort(), keys)
        verify(keys.length > 0)
        for (const key of keys) {
            compare(typeof english[key], "string", key)
            compare(typeof chinese[key], "string", key)
            verify(english[key].length > 0, key)
            verify(chinese[key].length > 0, key)
        }
        compare(english.PageSizeStatus.arg(2).arg(20), "Page 2; items per page: 20")
        compare(chinese.PageSizeStatus.arg(2).arg(20), "第 2 页，每页 20 条")
        compare(english.LowElevation, "Low elevation")
        compare(chinese.LowElevation, "低层级阴影")
        compare(chinese.Value1IsRequired.arg("名称"), "名称 不能为空")
        compare(ELocale.textsForLanguage("fr").LowElevation, english.LowElevation)
    }

    function test_documentationButtonLabels() {
        ELocale.language = "zh"
        const definition = Qt.createComponent("../../example/qml/component/BasicExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {
            width: 1040, height: 820, selectedComponent: "EButton"
        })
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        const pending = [page]
        const labels = []
        while (pending.length > 0) {
            const item = pending.pop()
            if (typeof item.text === "string")
                labels.push(item.text)
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        for (const label of ["主要", "朴素", "虚线", "背景", "链接"])
            verify(labels.indexOf(label) >= 0, label)
        for (const label of ["Primary", "Plain", "Dashed", "Background", "Link"])
            compare(labels.indexOf(label), -1, label)
        definition.destroy()
    }

    function test_liveSnippetTranslation() {
        ELocale.language = "en"
        const definition = Qt.createComponent("../../example/qml/component/LayoutExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {width: 640, height: 600, selectedComponent: "ESplitter"})
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        const pending = [page]
        let code = ""
        while (pending.length > 0) {
            const item = pending.pop()
            if (typeof item.code === "string" && item.code.indexOf("ELocale.texts.ResizeAfterRelease") >= 0) {
                code = item.code
                break
            }
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        verify(code.length > 0)
        const sample = Qt.createQmlObject(code, testCase, "localizedSnippet")
        verify(sample !== null)
        try {
            const toggle = sample.children[0]
            compare(toggle.text, "Resize after release")
            ELocale.language = "zh"
            compare(toggle.text, "释放后调整")
            ELocale.language = "en"
            compare(toggle.text, "Resize after release")
        } finally {
            sample.destroy()
            definition.destroy()
        }
    }

    function test_copyableParagraphTranslation() {
        ELocale.language = "en"
        const definition = Qt.createComponent("../../example/qml/component/BasicExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {
            width: 640, height: 600, selectedComponent: "ECopyableText"
        })
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        const example = findChild(page, "showcaseECopyableText0")
        verify(example !== null)
        const paragraph = findChild(example, "galleryPreviewContent").children[0]
        const english = "Select this paragraph and press Ctrl+C or Command+C to copy. The text wraps automatically as the window narrows."
        const chinese = "选中这段长文本并使用 Ctrl+C 或 Command+C 复制。窗口变窄时，内容会自动换行。"
        compare(paragraph.text, english)
        const snippet = Qt.createQmlObject(example.code, testCase, "copyableParagraphSnippet")
        verify(snippet !== null)
        try {
            compare(snippet.text, english)
            ELocale.language = "zh"
            compare(paragraph.text, chinese)
            compare(snippet.text, chinese)
            ELocale.language = "en"
            compare(paragraph.text, english)
            compare(snippet.text, english)
        } finally {
            snippet.destroy()
            definition.destroy()
        }
    }

    function test_galleryTranslations(data) {
        ELocale.language = data.language
        const required = ["AllComponents", "OpenExample", "FeaturedComponents",
            "QtQuickComponents", "PreviewInteractAndViewTheQMLSource",
            "LightDarkAndColorTransitions", "ComponentsInteractiveQtQuickExamples"]
        for (const key of required) {
            compare(typeof ELocale.texts[key], "string", key)
            verify(ELocale.texts[key].length > 0, key)
        }
        const component = Qt.createComponent("qrc:/example/qml/component/Overview.qml")
        compare(component.status, Component.Ready, component.errorString())
        const overview = createTemporaryObject(component, testCase, {width: 1000, height: 720})
        verify(overview !== null)
        compare(ELocale.texts.EUIComponentPlayground, data.title)
        compare(overview.featuredEntries.length, 3)
        for (const entry of overview.featuredEntries) {
            compare(typeof entry.title, "string", entry.component)
            compare(typeof entry.description, "string", entry.component)
            verify(entry.title.length > 0 && entry.description.length > 0, entry.component)
        }
        ELocale.language = data.language === "en" ? "zh" : "en"
        for (const entry of overview.featuredEntries)
            verify(entry.title.length > 0 && entry.description.length > 0, entry.component)
        ELocale.language = data.language
        compare(ELocale.texts.EUIComponentPlayground, data.title)
    }

    width: 640
    height: 600
    visible: true
    name: "EUILocale"
    when: windowShown

    Component {
        id: shadowShowcase

        Gallery.VisualEffectsShowcase {
            width: 640
        }
    }
    Component {
        id: localTable

        EConfigProvider {
            locale: "zh"

            ETable {
                objectName: "localizedTable"
            }
        }
    }
}
