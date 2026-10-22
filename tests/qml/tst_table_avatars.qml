import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.dark = false
        ELocale.language = "en"
    }

    function namedItems(item, name) {
        const found = item.objectName === name ? [item] : []
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            Array.prototype.push.apply(found, namedItems(children[index], name))
        return found
    }

    function test_allImagesLoad() {
        const rows = exampleData.models.TableAvatars || []
        compare(rows.length, 190)
        const avatar = createTemporaryObject(avatarComponent, testCase)
        verify(avatar !== null)
        for (const row of rows) {
            avatar.source = row.avatar
            tryCompare(avatar, "loaded", true, 5000, row.name)
        }
    }

    function makeExample(width) {
        const definition = Qt.createComponent("../../example/qml/component/TableAvatarExample.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const example = createTemporaryObject(definition, testCase, {width: width || 1000})
        verify(example !== null)
        verify(waitForRendering(example))
        return example
    }

    function test_renderedAvatarAndNextButton() {
        const example = makeExample()
        const table = findChild(example, "avatarDataTable")
        const pagination = findChild(example, "avatarTablePagination")
        tryVerify(function() { return findChild(table, "avatarTableImage") !== null })
        const avatar = findChild(table, "avatarTableImage")
        tryCompare(avatar, "loaded", true)
        compare(avatar.size, 48)
        mouseClick(findChild(pagination, "paginationNext"))
        compare(pagination.currentPage, 2)
        compare(table.model[0].id, 11)
    }

    function test_galleryContainsNewExample() {
        const definition = Qt.createComponent("../../example/qml/component/DataExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {width: 1100, height: 900, selectedComponent: "ETable"})
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        tryVerify(function() { return findChild(page, "showcaseETableAvatars") !== null })
        tryVerify(function() { return page.exampleCount > 1 })
    }

    function test_renderedImageDetails() {
        const example = makeExample()
        const table = findChild(example, "avatarDataTable")
        tryVerify(function() { return namedItems(table, "tableRow").length > 0 })
        const first = namedItems(table, "tableRow").filter(function(row) { return row.displayIndex === 0 })[0]
        verify(first !== undefined)
        const cells = namedItems(first, "tableCell")
        compare(cells.length, 7)
        const row = table.model[0]
        compare(cells[4].text, row.imageWidth + " × " + row.imageHeight)
        compare(cells[5].text, (row.fileSize / 1024).toFixed(1) + " KB")
    }

    function test_pageSizeAndPartialLastPage() {
        const example = makeExample()
        const table = findChild(example, "avatarDataTable")
        const pagination = findChild(example, "avatarTablePagination")
        pagination.setPage(19)
        verify(pagination.setPageSize(20))
        compare(pagination.currentPage, 10)
        compare(table.rowCount, 10)
        compare(table.model[0].id, 181)
        verify(pagination.setPageSize(50))
        compare(pagination.currentPage, 4)
        compare(table.rowCount, 40)
        compare(table.model[0].id, 151)
        compare(table.model[39].id, 190)
        pagination.setPage(1)
        compare(table.rowCount, 50)
        table.setScrollTop(180)
        pagination.next()
        tryCompare(table, "scrollTop", 0)
        compare(table.model[0].id, 51)
    }

    function test_catalogComplete() {
        const rows = exampleData.models.TableAvatars || []
        compare(rows.length, 190)
        const seen = {}
        const categories = {heroes: 0, monsters: 0}
        for (let index = 0; index < rows.length; ++index) {
            const row = rows[index]
            compare(row.id, index + 1)
            verify(!seen[row.avatar], row.avatar)
            seen[row.avatar] = true
            verify(row.avatar.indexOf("qrc:/example/images/48/") === 0, row.avatar)
            compare(row.name, row.avatar.split("/").pop().replace(/\.png$/, ""))
            verify(row.fileSize > 0, row.name)
            verify(row.imageWidth > 0 && row.imageHeight > 0, row.name)
            compare(row.format, "PNG")
            verify(row.category in categories, row.category)
            ++categories[row.category]
        }
        compare(categories.heroes, 173)
        compare(categories.monsters, 17)
    }

    function test_localesAndSource() {
        const example = makeExample()
        const table = findChild(example, "avatarDataTable")
        const row = table.model[0]
        compare(table.cellText(row, table.columns[4], 0), row.imageWidth + " × " + row.imageHeight)
        compare(table.cellText(row, table.columns[5], 0), (row.fileSize / 1024).toFixed(1) + " KB")
        ELocale.language = "zh"
        compare(example.title, "头像数据与分页")
        compare(table.columns[1].label, "头像")
        compare(table.columns[2].label, "名称")
        ELocale.language = "en"
        compare(example.title, "Avatar data and pagination")
        verify(example.code.indexOf("cellDelegate: avatarCell") >= 0)
        verify(example.code.indexOf("EPagination") >= 0)
        const snippet = Qt.createQmlObject(example.code, testCase, "avatarTableSnippet")
        verify(snippet !== null)
        snippet.destroy()
    }

    function test_paginationCoversEveryRecord() {
        const example = makeExample()
        const table = findChild(example, "avatarDataTable")
        const pagination = findChild(example, "avatarTablePagination")
        verify(table !== null && pagination !== null)
        compare(table.columns.length, 7)
        compare(pagination.total, 190)
        compare(pagination.pageSize, 10)
        compare(pagination.pageCount, 19)
        const seen = []
        for (let page = 1; page <= pagination.pageCount; ++page) {
            pagination.setPage(page)
            compare(table.rowCount, 10)
            compare(table.model[0].id, (page - 1) * 10 + 1)
            for (const row of table.model)
                seen.push(row.avatar)
        }
        compare(seen, exampleData.models.TableAvatars.map(function(row) { return row.avatar }))
        compare(table.model[9].id, 190)
        compare(pagination.next(), false)
        pagination.previous()
        compare(table.model[0].id, 171)
    }

    width: 1200
    height: 1000
    visible: true
    when: windowShown
    name: "TableAvatars"

    Component {
        id: avatarComponent

        EAvatar {
            size: 48
        }
    }
}
