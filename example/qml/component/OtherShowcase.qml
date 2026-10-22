import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EDivider"

        ExampleCase {
            objectName: "showcaseEDivider0"
            title: ELocale.texts.DividerLabels
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EDivider {
                        text: ELocale.texts.Group
                        contentPosition: EPlacement.Left
                        width: Math.min(240, parent.width)
                    }
                    EDivider {
                        text: ELocale.texts.Group
                        contentPosition: EPlacement.Center
                        width: Math.min(240, parent.width)
                    }
                    EDivider {
                        text: ELocale.texts.Group
                        contentPosition: EPlacement.Right
                        width: Math.min(240, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EDivider {
                    text: ELocale.texts.Group
                    contentPosition: EPlacement.Left
                    width: Math.min(240, parent.width)
                }
                EDivider {
                    text: ELocale.texts.Group
                    contentPosition: EPlacement.Center
                    width: Math.min(240, parent.width)
                }
                EDivider {
                    text: ELocale.texts.Group
                    contentPosition: EPlacement.Right
                    width: Math.min(240, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDivider"

        ExampleCase {
            objectName: "showcaseEDivider1"
            title: ELocale.texts.DividerPatterns
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EDivider {
                        lineWidth: 2
                        color: "#409EFF"
                        borderStyle: "solid"
                        width: Math.min(240, parent.width)
                    }
                    EDivider {
                        lineWidth: 2
                        color: "#409EFF"
                        borderStyle: "dashed"
                        width: Math.min(240, parent.width)
                    }
                    EDivider {
                        lineWidth: 2
                        color: "#409EFF"
                        borderStyle: "dotted"
                        width: Math.min(240, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EDivider {
                    lineWidth: 2
                    color: "#409EFF"
                    borderStyle: "solid"
                    width: Math.min(240, parent.width)
                }
                EDivider {
                    lineWidth: 2
                    color: "#409EFF"
                    borderStyle: "dashed"
                    width: Math.min(240, parent.width)
                }
                EDivider {
                    lineWidth: 2
                    color: "#409EFF"
                    borderStyle: "dotted"
                    width: Math.min(240, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDivider"

        ExampleCase {
            objectName: "showcaseEDivider2"
            title: ELocale.texts.VerticalDivider2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EText {
                        text: ELocale.texts.Design
                    }
                    EDivider {
                        verticalHeight: 24
                        direction: EOrientation.Vertical
                    }
                    EText {
                        text: ELocale.texts.Engineering
                    }
                    EDivider {
                        verticalHeight: 24
                        direction: EOrientation.Vertical
                    }
                    EText {
                        text: ELocale.texts.Publish
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EText {
                    text: ELocale.texts.Design
                }
                EDivider {
                    verticalHeight: 24
                    direction: EOrientation.Vertical
                }
                EText {
                    text: ELocale.texts.Engineering
                }
                EDivider {
                    verticalHeight: 24
                    direction: EOrientation.Vertical
                }
                EText {
                    text: ELocale.texts.Publish
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDivider"

        ExampleCase {
            objectName: "showcaseEDivider3"
            title: ELocale.texts.DividerContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDivider {
                    width: parent.width
                    contentComponent: Component {
                        Row {
                            spacing: 8

                            EIcon {
                                iconSize: 18
                                iconSource: EIcons.PALETTE
                            }
                            EText {
                                text: ELocale.texts.AdvancedSettings
                            }
                        }
                    }
                }
            `)

            EDivider {
                width: parent.width
                contentComponent: Component {
                    Row {
                        spacing: 8

                        EIcon {
                            iconSize: 18
                            iconSource: EIcons.PALETTE
                        }
                        EText {
                            text: ELocale.texts.AdvancedSettings
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EWatermark"

        ExampleCase {
            objectName: "showcaseEWatermark0"
            title: ELocale.texts.MultilineWatermark
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 180
                    width: Math.min(480, parent.width)

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.ProjectDocument

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                        }
                    }
                    EWatermark {
                        anchors.fill: parent
                        content: ["EUI / INTERNAL", "2026"]
                    }
                }
            `)

            Item {
                height: 180
                width: Math.min(480, parent.width)

                ECard {
                    anchors.fill: parent
                    header: ELocale.texts.ProjectDocument

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                    }
                }
                EWatermark {
                    anchors.fill: parent
                    content: ["EUI / INTERNAL", "2026"]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EWatermark"

        ExampleCase {
            objectName: "showcaseEWatermark1"
            title: ELocale.texts.WatermarkSpacing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 180
                    width: Math.min(480, parent.width)

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.ProjectDocument

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                        }
                    }
                    EWatermark {
                        rotate: -35
                        content: "EUI"
                        tileHeight: 64
                        tileWidth: 100
                        anchors.fill: parent
                        gap: Qt.point(32, 24)
                    }
                }
            `)

            Item {
                height: 180
                width: Math.min(480, parent.width)

                ECard {
                    anchors.fill: parent
                    header: ELocale.texts.ProjectDocument

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                    }
                }
                EWatermark {
                    rotate: -35
                    content: "EUI"
                    tileHeight: 64
                    tileWidth: 100
                    anchors.fill: parent
                    gap: Qt.point(32, 24)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EWatermark"

        ExampleCase {
            objectName: "showcaseEWatermark2"
            title: ELocale.texts.ImageWatermark
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 180
                    width: Math.min(480, parent.width)

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.ProjectDocument

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                        }
                    }
                    EWatermark {
                        tileWidth: 72
                        tileHeight: 72
                        anchors.fill: parent
                        image: "qrc:/example/eui-mark.svg"
                    }
                }
            `)

            Item {
                height: 180
                width: Math.min(480, parent.width)

                ECard {
                    anchors.fill: parent
                    header: ELocale.texts.ProjectDocument

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                    }
                }
                EWatermark {
                    tileWidth: 72
                    tileHeight: 72
                    anchors.fill: parent
                    image: "qrc:/example/eui-mark.svg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EWatermark"

        ExampleCase {
            objectName: "showcaseEWatermark3"
            title: ELocale.texts.WatermarkOffset
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 180
                    width: Math.min(480, parent.width)

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.ProjectDocument

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                        }
                    }
                    EWatermark {
                        rotate: 0
                        color: "#409EFF"
                        font.pixelSize: 18
                        anchors.fill: parent
                        content: "CONFIDENTIAL"
                        offset: Qt.point(30, 10)
                    }
                }
            `)

            Item {
                height: 180
                width: Math.min(480, parent.width)

                ECard {
                    anchors.fill: parent
                    header: ELocale.texts.ProjectDocument

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheWatermarkCoversTheDocumentContent
                    }
                }
                EWatermark {
                    rotate: 0
                    color: "#409EFF"
                    font.pixelSize: 18
                    anchors.fill: parent
                    content: "CONFIDENTIAL"
                    offset: Qt.point(30, 10)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenu"

        ExampleCase {
            objectName: "showcaseEMenu0"
            title: ELocale.texts.HorizontalMenu
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EMenu {
                    width: parent.width
                    currentIndex: "home"
                    direction: EOrientation.Horizontal
                    model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
                }
            `)

            EMenu {
                width: parent.width
                currentIndex: "home"
                direction: EOrientation.Horizontal
                model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "EMenu"

        ExampleCase {
            objectName: "showcaseEMenu1"
            title: ELocale.texts.CollapsibleMenu
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: collapsed

                        text: ELocale.texts.CollapseMenu
                    }
                    EMenu {
                        uniqueOpened: true
                        collapse: collapsed.checked
                        width: Math.min(480, parent.width)
                        model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: collapsed

                    text: ELocale.texts.CollapseMenu
                }
                EMenu {
                    uniqueOpened: true
                    collapse: collapsed.checked
                    width: Math.min(480, parent.width)
                    model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenu"

        ExampleCase {
            objectName: "showcaseEMenu2"
            title: ELocale.texts.MenuInitialState
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EMenu {
                    currentIndex: "design"
                    openedIndexes: ["work"]
                    activeTextColor: "#67c23a"
                    width: Math.min(480, parent.width)
                    model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
                }
            `)

            EMenu {
                currentIndex: "design"
                openedIndexes: ["work"]
                activeTextColor: "#67c23a"
                width: Math.min(480, parent.width)
                model: [{index: "home", text: ELocale.texts.Overview, iconSource: EIcons.HOUSE}, {index: "work", text: ELocale.texts.Workspace, children: [{index: "design", text: ELocale.texts.Design}, {index: "dev", text: ELocale.texts.Engineering}]}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]
            }
        }
    }
}
