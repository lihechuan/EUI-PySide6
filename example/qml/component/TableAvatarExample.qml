import EUI 1.0
import QtQuick 2.15

ExampleCase {
    title: ELocale.texts.AvatarTable
    objectName: "showcaseETableAvatars"
    description: ELocale.texts.AvatarTableDescription
    code: GalleryStyle.sourceCode(`
        import EUI 1.0
        import QtQuick 2.15

        Column {
            id: avatarExample

            readonly property var rows: exampleData.models.TableAvatars || []

            spacing: 16
            width: parent.width

            ETable {
                id: avatarTable

                border: true
                stripe: true
                rowHeight: 64
                rowKey: "avatar"
                width: parent.width
                objectName: "avatarDataTable"
                height: effectiveHeaderHeight + Math.min(rowCount, 7) * rowHeight + 2
                model: avatarExample.rows.slice((avatarPagination.currentPage - 1) * avatarPagination.effectivePageSize,
                    avatarPagination.currentPage * avatarPagination.effectivePageSize)
                columns: [
                    {prop: "id", label: ELocale.texts.RecordId, width: 76},
                    {prop: "avatar", label: ELocale.texts.Avatar, width: 88, align: "center", cellDelegate: avatarCell},
                    {prop: "name", label: ELocale.texts.Name2, minWidth: 180},
                    {prop: "category", label: ELocale.texts.AvatarCategory, width: 120, cellDelegate: categoryCell},
                    {prop: "dimensions", label: ELocale.texts.ImageDimensions, width: 140,
                        formatter: function(row, column, value) { return row.imageWidth + " × " + row.imageHeight }},
                    {prop: "fileSize", label: ELocale.texts.FileSize, width: 128, align: "right",
                        formatter: function(row, column, value) { return (value / 1024).toFixed(1) + " KB" }},
                    {prop: "format", label: ELocale.texts.ImageFormat, width: 90, align: "center"}
                ]
            }
            EPagination {
                id: avatarPagination

                pageSize: 10
                pageSizes: [10, 20, 50]
                total: avatarExample.rows.length
                objectName: "avatarTablePagination"
                pagerCount: parent.width >= 720 ? 7 : 5
                layout: parent.width >= 720 ? "total, sizes, prev, pager, next, jumper"
                    : "total, sizes, prev, pager, next"

                onSizeChange: avatarTable.setScrollTop(0)
                onCurrentChange: avatarTable.setScrollTop(0)
            }
            Component {
                id: avatarCell

                Item {
                    property var row

                    EAvatar {
                        size: 48
                        shape: "square"
                        alt: row ? row.name : ""
                        anchors.centerIn: parent
                        source: row ? row.avatar : ""
                        objectName: "avatarTableImage"
                    }
                }
            }
            Component {
                id: categoryCell

                Item {
                    property var row

                    ETag {
                        effect: "light"
                        size: EStyle.Small
                        anchors.leftMargin: 16
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        styleType: row && row.category === "heroes" ? EStyle.Primary : EStyle.Warning
                        text: row && row.category === "heroes" ? ELocale.texts.AvatarHeroes : ELocale.texts.AvatarMonsters
                    }
                }
            }
        }
    `)

    Column {
        id: avatarExample

        readonly property var rows: exampleData.models.TableAvatars || []

        spacing: 16
        width: parent.width

        ETable {
            id: avatarTable

            border: true
            stripe: true
            rowHeight: 64
            rowKey: "avatar"
            width: parent.width
            objectName: "avatarDataTable"
            height: effectiveHeaderHeight + Math.min(rowCount, 7) * rowHeight + 2
            model: avatarExample.rows.slice((avatarPagination.currentPage - 1) * avatarPagination.effectivePageSize,
                avatarPagination.currentPage * avatarPagination.effectivePageSize)
            columns: [
                {prop: "id", label: ELocale.texts.RecordId, width: 76},
                {prop: "avatar", label: ELocale.texts.Avatar, width: 88, align: "center", cellDelegate: avatarCell},
                {prop: "name", label: ELocale.texts.Name2, minWidth: 180},
                {prop: "category", label: ELocale.texts.AvatarCategory, width: 120, cellDelegate: categoryCell},
                {prop: "dimensions", label: ELocale.texts.ImageDimensions, width: 140,
                    formatter: function(row, column, value) { return row.imageWidth + " × " + row.imageHeight }},
                {prop: "fileSize", label: ELocale.texts.FileSize, width: 128, align: "right",
                    formatter: function(row, column, value) { return (value / 1024).toFixed(1) + " KB" }},
                {prop: "format", label: ELocale.texts.ImageFormat, width: 90, align: "center"}
            ]
        }
        EPagination {
            id: avatarPagination

            pageSize: 10
            pageSizes: [10, 20, 50]
            total: avatarExample.rows.length
            objectName: "avatarTablePagination"
            pagerCount: parent.width >= 720 ? 7 : 5
            layout: parent.width >= 720 ? "total, sizes, prev, pager, next, jumper"
                : "total, sizes, prev, pager, next"

            onSizeChange: avatarTable.setScrollTop(0)
            onCurrentChange: avatarTable.setScrollTop(0)
        }
        Component {
            id: avatarCell

            Item {
                property var row

                EAvatar {
                    size: 48
                    shape: "square"
                    alt: row ? row.name : ""
                    anchors.centerIn: parent
                    source: row ? row.avatar : ""
                    objectName: "avatarTableImage"
                }
            }
        }
        Component {
            id: categoryCell

            Item {
                property var row

                ETag {
                    effect: "light"
                    size: EStyle.Small
                    anchors.leftMargin: 16
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    styleType: row && row.category === "heroes" ? EStyle.Primary : EStyle.Warning
                    text: row && row.category === "heroes" ? ELocale.texts.AvatarHeroes : ELocale.texts.AvatarMonsters
                }
            }
        }
    }
}
