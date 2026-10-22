import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: control

    property string componentName: ""

    readonly property var sections: {
        if (!componentName || typeof exampleCatalog === "undefined")
            return []
        exampleCatalog.groups
        const related = {
            ERow: ["ECol"],
            EContainer: ["EHeader", "EAside", "EMain", "EFooter", "EApplicationWindow"]
        }
        return [componentName].concat(related[componentName] || []).map(function(name) {
            return {name: name, api: exampleCatalog.documentation(name)}
        })
    }

    function defaultSummary(entry) {
        const value = String(entry.defaultValue || "").trim()
        const component = value.match(/^([\w.]+)\s*\{/)
        if (entry.type === "Component" && component)
            return component[1] + " { \u2026 }"
        if (!entry.readonly && value.length > 48
            && value.replace(/\s+/g, "") === String(entry.binding || "").replace(/\s+/g, ""))
            return ELocale.texts.ApiDynamicDefault
        return value || "—"
    }

    spacing: 32
    visible: sections.length > 0
    objectName: "galleryApiDocumentation"

    Repeater {
        model: control.sections

        Column {
            id: section

            readonly property var documentation: modelData.api
            readonly property string componentName: modelData.name

            spacing: 16
            width: control.width
            objectName: "galleryApiSection"

            Column {
                spacing: 8
                width: parent.width

                Flow {
                    spacing: 12
                    width: parent.width

                    EText {
                        height: 32
                        font.pixelSize: 22
                        color: GalleryStyle.text
                        font.weight: Font.DemiBold
                        objectName: "galleryApiTitle"
                        text: ELocale.texts.ApiAttributes
                        verticalAlignment: Text.AlignVCenter
                        font.family: EDefaultConfig.primaryFontFamily
                    }
                    EText {
                        height: 32
                        font.pixelSize: 14
                        color: GalleryStyle.muted
                        text: section.componentName
                        verticalAlignment: Text.AlignVCenter
                        objectName: "galleryApiComponentName"
                        font.family: EDefaultConfig.primaryFontFamily
                    }
                    EText {
                        height: 32
                        font.pixelSize: 14
                        color: GalleryStyle.muted
                        verticalAlignment: Text.AlignVCenter
                        objectName: "galleryApiPropertyCount"
                        font.family: EDefaultConfig.primaryFontFamily
                        text: ELocale.texts.ApiPropertyCount.arg((section.documentation.properties || []).length)
                    }
                }
                EText {
                    font.pixelSize: 14
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: GalleryStyle.muted
                    text: ELocale.texts.ApiPropertiesNote
                    lineHeight: GalleryStyle.bodyLineHeight
                    font.family: EDefaultConfig.primaryFontFamily
                }
            }
            Rectangle {
                radius: 12
                border.width: 1
                width: parent.width
                color: GalleryStyle.surface
                border.color: GalleryStyle.line
                height: tableViewport.height + 2
                objectName: "galleryApiTableFrame"

                Flickable {
                    id: tableViewport

                    x: 1
                    y: 1
                    clip: true
                    width: parent.width - 2
                    contentWidth: table.width
                    contentHeight: table.height
                    objectName: "galleryApiTableViewport"
                    ScrollBar.horizontal: ScrollHandle { }
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.HorizontalFlick
                    height: table.height + (contentWidth > width ? ScrollBar.horizontal.height : 0)

                    Column {
                        id: table

                        readonly property var columnWidths: [220, width - 720, 260, 240]

                        width: Math.max(960, tableViewport.width)

                        Rectangle {
                            height: 48
                            radius: 11
                            width: parent.width
                            color: GalleryStyle.preview
                            objectName: "galleryApiTableHeader"

                            Rectangle {
                                height: 12
                                color: parent.color
                                width: parent.width
                                anchors.bottom: parent.bottom
                            }
                            Row {
                                width: parent.width
                                height: parent.height

                                Repeater {
                                    model: [ELocale.texts.ApiName, ELocale.texts.ApiDescription,
                                        ELocale.texts.ApiDetails, ELocale.texts.ApiDefault]

                                    EText {
                                        leftPadding: 16
                                        text: modelData
                                        rightPadding: 16
                                        font.pixelSize: 14
                                        height: parent.height
                                        color: GalleryStyle.text
                                        font.weight: Font.Medium
                                        width: table.columnWidths[index]
                                        verticalAlignment: Text.AlignVCenter
                                        font.family: EDefaultConfig.primaryFontFamily
                                    }
                                }
                            }
                            Rectangle {
                                height: 1
                                width: parent.width
                                color: GalleryStyle.line
                                anchors.bottom: parent.bottom
                            }
                        }
                        Repeater {
                            model: section.documentation.properties || []

                            Item {
                                id: row

                                readonly property var entry: modelData
                                readonly property string defaultText: control.defaultSummary(entry)

                                width: table.width
                                objectName: "galleryApiRow"
                                height: Math.max(76, nameColumn.implicitHeight + 32,
                                    descriptionLabel.implicitHeight + 32, detailsLabel.implicitHeight + 32,
                                    defaultColumn.implicitHeight + 32)

                                Rectangle {
                                    radius: 11
                                    anchors.fill: parent
                                    color: rowHover.hovered ? GalleryStyle.preview : "transparent"

                                    Rectangle {
                                        height: 11
                                        color: parent.color
                                        width: parent.width
                                    }
                                    Rectangle {
                                        height: 11
                                        color: parent.color
                                        width: parent.width
                                        anchors.bottom: parent.bottom
                                        visible: index < (section.documentation.properties || []).length - 1
                                    }
                                }
                                HoverHandler { id: rowHover }
                                Column {
                                    id: nameColumn

                                    x: 16
                                    y: 16
                                    spacing: 6
                                    width: table.columnWidths[0] - 32

                                    TextEdit {
                                        readOnly: true
                                        font.pixelSize: 14
                                        selectByMouse: true
                                        width: parent.width
                                        text: row.entry.name
                                        wrapMode: TextEdit.Wrap
                                        color: GalleryStyle.text
                                        font.weight: Font.Medium
                                        objectName: "galleryApiPropertyName"
                                        selectedTextColor: GalleryStyle.text
                                        selectionColor: GalleryStyle.accentSoft
                                        font.family: EDefaultConfig.primaryFontFamily
                                    }
                                    Flow {
                                        spacing: 6
                                        width: parent.width

                                        TextEdit {
                                            readOnly: true
                                            font.pixelSize: 13
                                            selectByMouse: true
                                            text: row.entry.type
                                            width: implicitWidth
                                            height: implicitHeight
                                            color: GalleryStyle.muted
                                            objectName: "galleryApiPropertyType"
                                            selectedTextColor: GalleryStyle.text
                                            selectionColor: GalleryStyle.accentSoft
                                            font.family: EDefaultConfig.primaryFontFamily
                                        }
                                        EText {
                                            height: 18
                                            font.pixelSize: 13
                                            text: row.entry.owner
                                            color: GalleryStyle.muted
                                            verticalAlignment: Text.AlignVCenter
                                            objectName: "galleryApiPropertyOwner"
                                            font.family: EDefaultConfig.primaryFontFamily
                                        }
                                        Rectangle {
                                            radius: 4
                                            height: 18
                                            border.width: 1
                                            color: "transparent"
                                            visible: row.entry.readonly
                                            border.color: GalleryStyle.line
                                            width: readonlyLabel.implicitWidth + 12

                                            EText {
                                                id: readonlyLabel

                                                font.pixelSize: 11
                                                anchors.centerIn: parent
                                                color: GalleryStyle.muted
                                                text: ELocale.texts.ApiReadOnly
                                                font.family: EDefaultConfig.primaryFontFamily
                                            }
                                        }
                                    }
                                }
                                TextEdit {
                                    id: descriptionLabel

                                    y: 16
                                    readOnly: true
                                    font.pixelSize: 14
                                    selectByMouse: true
                                    wrapMode: TextEdit.Wrap
                                    color: GalleryStyle.text
                                    text: row.entry.description
                                    x: table.columnWidths[0] + 16
                                    width: table.columnWidths[1] - 32
                                    objectName: "galleryApiDescription"
                                    selectedTextColor: GalleryStyle.text
                                    selectionColor: GalleryStyle.accentSoft
                                    font.family: EDefaultConfig.primaryFontFamily
                                }
                                TextEdit {
                                    id: detailsLabel

                                    y: 16
                                    readOnly: true
                                    font.pixelSize: 14
                                    selectByMouse: true
                                    wrapMode: TextEdit.WordWrap
                                    text: row.entry.details || "—"
                                    objectName: "galleryApiDetails"
                                    width: table.columnWidths[2] - 32
                                    selectedTextColor: GalleryStyle.text
                                    selectionColor: GalleryStyle.accentSoft
                                    font.family: EDefaultConfig.primaryFontFamily
                                    x: table.columnWidths[0] + table.columnWidths[1] + 16
                                    color: row.entry.details ? GalleryStyle.text : GalleryStyle.muted
                                }
                                Column {
                                    id: defaultColumn

                                    y: 16
                                    spacing: 8
                                    width: table.columnWidths[3] - 32
                                    x: table.width - table.columnWidths[3] + 16

                                    TextEdit {
                                        id: defaultLabel

                                        readOnly: true
                                        font.pixelSize: 14
                                        selectByMouse: true
                                        width: parent.width
                                        text: row.defaultText
                                        wrapMode: TextEdit.Wrap
                                        objectName: "galleryApiDefaultValue"
                                        selectedTextColor: GalleryStyle.text
                                        selectionColor: GalleryStyle.accentSoft
                                        font.family: EDefaultConfig.primaryFontFamily
                                        color: row.entry.readonly ? GalleryStyle.muted : GalleryStyle.text
                                    }
                                }
                                Rectangle {
                                    height: 1
                                    color: GalleryStyle.line
                                    width: parent.width - 32
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: index < (section.documentation.properties || []).length - 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
