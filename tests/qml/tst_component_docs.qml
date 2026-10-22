import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function init() {
        ELocale.language = "zh"
        ETheme.setDark(false)
    }

    function cleanup() {
        ELocale.language = "en"
        ETheme.setDark(false)
    }

    function test_valuesAndFields_data() {
        return ["zh", "en"].map(function(language) { return {tag: language, language: language} })
    }

    function test_enumWordsStayTogether_data() {
        return [960, 1040, 1680].map(function(width) { return {tag: String(width), width: width} })
    }

    function test_defaultWordsStayTogether_data() {
        return [960, 1040, 1680].map(function(width) { return {tag: String(width), width: width} })
    }

    function test_pagePlacement_data() {
        return ["EButton", "ETable", "EUpload", "EQRCode", "EContainer", "EECharts"].map(function(name) {
            return {tag: name, entry: exampleCatalog.find(name)}
        })
    }

    function test_compactComponentDefault_data() {
        const rows = []
        for (const component of ["EFilePicker", "EFolderPicker"]) {
            for (const language of ["zh", "en"])
                rows.push({tag: component + "-" + language, component: component, language: language})
        }
        return rows
    }

    function namedItems(root, name) {
        const result = []
        const pending = [root]
        while (pending.length > 0) {
            const item = pending.pop()
            if (item.objectName === name)
                result.push(item)
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        return result
    }

    function test_catalogCoverage_data() {
        const result = []
        for (const language of ["zh", "en"]) {
            for (const group of exampleCatalog.groups) {
                for (const entry of group.children) {
                    if (!entry.demo)
                        result.push({tag: language + "-" + entry.index, language: language, entry: entry})
                }
            }
        }
        compare(result.length, 304)
        return result
    }

    function test_invalidComponent() {
        compare(exampleCatalog.documentation("invalid").properties.length, 0)
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 760})
        verify(api !== null)
        compare(api.visible, false)
        compare(api.sections.length, 0)
    }

    function test_longDefaultExpression() {
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 1040, componentName: "EIcon"})
        verify(api !== null)
        verify(waitForItemPolished(api))
        const row = namedItems(api, "galleryApiRow").filter(function(item) { return item.entry.name === "text" })[0]
        verify(row !== undefined)
        verify(row.entry.defaultValue.length > 48)
        compare(findChild(row, "galleryApiDefaultValue").text, "动态绑定")
        compare(findChild(api, "galleryApiBindingDialog"), null)
        compare(findChild(row, "galleryApiDefaultBinding"), null)
        definition.destroy()
    }

    function test_enumWordsStayTogether(data) {
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: data.width, componentName: "EInput"})
        verify(api !== null)
        verify(waitForItemPolished(api))
        for (const row of namedItems(api, "galleryApiRow")) {
            const label = findChild(row, "galleryApiDetails")
            const words = label.text.match(/(?:EStyle|TextInput|EValidationState)\.\w+/g) || []
            for (const word of words) {
                const offset = label.text.indexOf(word)
                const end = label.positionToRectangle(offset + word.length - 1)
                compare(label.positionToRectangle(offset).y, end.y, "Enum name splits: " + word)
                verify(end.x < label.width, "Enum name overflows: " + word)
            }
        }
        definition.destroy()
    }

    function test_defaultWordsStayTogether(data) {
        ELocale.language = "en"
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: data.width, componentName: "EButton"})
        verify(api !== null)
        verify(waitForItemPolished(api))
        const row = namedItems(api, "galleryApiRow").filter(function(item) { return item.entry.name === "size" })[0]
        verify(row !== undefined)
        const label = findChild(row, "galleryApiDefaultValue")
        verify(label !== null)
        let offset = 0
        for (const word of label.text.match(/\S+/g)) {
            offset = label.text.indexOf(word, offset)
            compare(label.positionToRectangle(offset).y, label.positionToRectangle(offset + word.length - 1).y,
                "Default value splits the word: " + word)
            offset += word.length
        }
        definition.destroy()
    }

    function test_availableValues(data) {
        ELocale.language = data.language
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 960, componentName: data.component})
        verify(api !== null)
        verify(waitForItemPolished(api))
        const row = namedItems(api, "galleryApiRow").filter(function(item) { return item.entry.name === data.property })[0]
        verify(row !== undefined)
        const details = findChild(row, "galleryApiDetails")
        verify(details !== null)
        for (const value of data.values)
            verify(details.text.indexOf(value) >= 0, data.component + "." + data.property + " misses " + value)
        verify(row.height >= details.y + details.implicitHeight + 16)
        compare(namedItems(api, "galleryApiDefaultBinding").length, 0)
        compare(findChild(api, "galleryApiBindingDialog"), null)
        definition.destroy()
    }

    function test_pagePlacement(data) {
        const definition = Qt.createComponent("../../example/qml/component/" + data.entry.source)
        tryCompare(definition, "status", Component.Ready)
        const page = createTemporaryObject(definition, testCase, {
            width: 1040,
            height: 720,
            selectedComponent: data.entry.index
        })
        verify(page !== null, definition.errorString())
        verify(waitForItemPolished(page))
        const apiSection = findChild(page, "galleryApiLoader")
        verify(apiSection !== null)
        compare(apiSection.loadedCard, null)
        page.contentY = apiSection.y - 16
        tryVerify(function() { return apiSection.loadedCard !== null })
        const api = apiSection.loadedCard
        const examples = findChild(page, "galleryPageColumn")
        verify(api !== null && examples !== null)
        verify(waitForItemPolished(page))
        verify(apiSection.y >= examples.y + examples.implicitHeight)
        verify(page.contentHeight >= apiSection.y + api.implicitHeight)
        page.showComponent("EInput")
        tryCompare(api, "componentName", "EInput")
        tryVerify(function() { return namedItems(api, "galleryApiSection").length === 1 })
        definition.destroy()
    }

    function test_compactComponentDefault(data) {
        ELocale.language = data.language
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 1000, componentName: data.component})
        verify(api !== null)
        verify(waitForItemPolished(api))
        const rows = namedItems(api, "galleryApiRow")
        const append = rows.filter(function(row) { return row.entry.name === "appendComponent" })[0]
        const value = findChild(append, "galleryApiDefaultValue")
        compare(value.text, "ETextButton { \u2026 }")
        verify(append.height < 160, "Component source makes the property row too tall")
        const icon = rows.filter(function(row) { return row.entry.name === "clearIcon" })[0]
        const iconValue = findChild(icon, "galleryApiDefaultValue")
        compare(iconValue.text, "EIcons.CIRCLE_XMARK")
        compare(iconValue.positionToRectangle(0).y, iconValue.positionToRectangle(iconValue.text.length - 1).y)
        verify(iconValue.positionToRectangle(iconValue.text.length - 1).x < iconValue.width)
        const font = rows.filter(function(row) { return row.entry.name === "font" })[0]
        compare(font.entry.owner, "TextField")
        compare(font.entry.defaultValue, data.language === "zh" ? "应用字体" : "application font")
        definition.destroy()
    }

    function test_availableValues_data() {
        const cases = [
            {component: "EAffix", property: "position", values: ["EPlacement.Top", "EPlacement.Bottom"]},
            {component: "ECarousel", property: "cardScale", values: ["0.1–1"]},
            {component: "ECarousel", property: "currentIndex", values: ["-1", "0"]},
            {component: "EImage", property: "fillMode", values: ["Image.Tile", "Image.Pad", "Image.PreserveAspectCrop"]},
            {component: "EImage", property: "status", values: ["Image.Null", "Image.Ready", "Image.Loading", "Image.Error"]},
            {component: "EDatePicker", property: "type", values: ["quarter", "quarters", "quarterrange", "daterange"]},
            {component: "EDivider", property: "borderStyle", values: ["solid", "dashed", "dotted", "double", "outset"]},
            {component: "ETabs", property: "type", values: ["line", "card", "border-card"]},
            {component: "EForm", property: "rules", values: ["required", "validator", "pattern", "trigger"]},
            {component: "ETable", property: "treeProps", values: ["children", "hasChildren", "checkStrictly"]},
            {component: "EPopover", property: "closePolicy", values: ["NoAutoClose", "CloseOnEscape", "CloseOnPressOutside"]},
            {component: "EWatermark", property: "gap", values: ["x", "y"]},
            {component: "EMediaPlayer", property: "muted", values: ["true", "false"]}
        ]
        const result = []
        for (const language of ["zh", "en"]) {
            for (const entry of cases)
                result.push(Object.assign({tag: language + "-" + entry.component + "." + entry.property, language: language}, entry))
        }
        return result
    }

    function test_catalogCoverage(data) {
        ELocale.language = data.language
        const documented = exampleCatalog.documentation(data.entry.index).properties
        verify(documented.length > 0, data.entry.index)
        const names = []
        for (const row of documented) {
            verify(row.description.length > 0 && row.type.length > 0 && row.defaultValue.length > 0)
            verify(names.indexOf(row.name) < 0, "Duplicate: " + row.name)
            names.push(row.name)
        }
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        tryCompare(definition, "status", Component.Ready)
        const api = createTemporaryObject(definition, testCase, {
            width: 1040,
            componentName: data.entry.index
        })
        verify(api !== null, definition.errorString())
        compare(api.componentName, data.entry.index)
        tryVerify(function() { return api.implicitHeight > 100 })
        verify(waitForItemPolished(api))
        const sections = namedItems(api, "galleryApiSection")
        compare(sections.length, data.entry.index === "EContainer" ? 6 : data.entry.index === "ERow" ? 2 : 1)
        const section = sections.filter(function(item) { return item.componentName === data.entry.index })[0]
        verify(section !== undefined)
        const rows = namedItems(section, "galleryApiRow")
        compare(rows.length, documented.length)
        compare(namedItems(api, "galleryApiDefaultBinding").length, 0)
        compare(findChild(api, "galleryApiBindingDialog"), null)
        for (const row of rows) {
            compare(findChild(row, "galleryApiDescription").text, row.entry.description)
            compare(findChild(row, "galleryApiDetails").text, row.entry.details || "—")
            compare(findChild(row, "galleryApiDefaultValue").text,
                row.defaultText)
        }
        definition.destroy()
    }

    function test_valuesAndFields(data) {
        ELocale.language = data.language
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 1040, componentName: "EIcon"})
        verify(api !== null)
        verify(waitForItemPolished(api))
        const rows = namedItems(api, "galleryApiRow")
        const font = rows.filter(function(row) { return row.entry.name === "font" })[0]
        const size = rows.filter(function(row) { return row.entry.name === "size" })[0]
        verify(font !== undefined && size !== undefined)
        const fields = findChild(font, "galleryApiDetails")
        for (const name of ["family", "pixelSize", "bold"])
            verify(fields.text.indexOf(name) >= 0, "Missing font field: " + name)
        compare(font.entry.description.indexOf("pixelSize"), -1)
        compare(findChild(size, "galleryApiDetails").text, "EStyle.Small\nEStyle.Medium\nEStyle.Large")
        compare(size.entry.description.indexOf("EStyle.Small"), -1)
        for (const row of [font, size]) {
            const description = findChild(row, "galleryApiDescription")
            const type = findChild(row, "galleryApiPropertyType")
            const details = findChild(row, "galleryApiDetails")
            const value = findChild(row, "galleryApiDefaultValue")
            verify(details.x >= type.mapToItem(row, type.width, 0).x)
            verify(details.x + details.width <= value.parent.x)
            verify(row.height >= details.y + details.implicitHeight + 16)
            compare(description.font.pixelSize, 14)
            for (const item of [description, type, details, value, findChild(row, "galleryApiPropertyName")])
                compare(item.font.family, EDefaultConfig.primaryFontFamily)
        }
        definition.destroy()
    }

    function test_languageThemeAndDefaults() {
        const definition = Qt.createComponent("../../example/qml/component/ExampleApi.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const api = createTemporaryObject(definition, testCase, {width: 1040, componentName: "EButton"})
        verify(api !== null)
        tryVerify(function() { return namedItems(api, "galleryApiRow").length > 0 })
        const zh = exampleCatalog.documentation("EButton").properties
        const title = findChild(api, "galleryApiTitle")
        compare(title.text, "属性文档")
        compare(findChild(api, "galleryApiComponentName").text, "EButton")
        verify(zh.some(function(row) { return row.name === "plain" && row.owner === "EBaseButton" }))
        ELocale.language = "en"
        tryVerify(function() { return findChild(api, "galleryApiTitle").text === "Attributes" })
        const en = exampleCatalog.documentation("EButton").properties
        compare(zh.length, en.length)
        verify(zh[0].description !== en[0].description)
        const rows = namedItems(api, "galleryApiRow")
        verify(rows.every(function(row) { return row.entry.description === en.filter(function(entry) {
            return entry.name === row.entry.name
        })[0].description }))
        ETheme.setDark(true)
        tryVerify(function() { return findChild(api, "galleryApiTitle").color.toString() === "#f3f3f3" })
        const viewport = findChild(api, "galleryApiTableViewport")
        api.width = 540
        const frame = findChild(api, "galleryApiTableFrame")
        verify(frame !== null)
        tryCompare(frame, "width", 540)
        compare(viewport.width, frame.width - 2)
        verify(viewport.contentWidth > viewport.width)
        viewport.contentX = 120
        compare(viewport.contentX, 120)
        compare(findChild(api, "galleryApiBindingDialog"), null)
        compare(namedItems(api, "galleryApiDefaultBinding").length, 0)
        definition.destroy()
    }

    height: 780
    width: 1100
    visible: true
    when: windowShown
    name: "EUIComponentDocumentation"
}
