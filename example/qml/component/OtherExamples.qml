import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: page

    property string lastMenuSelection: ELocale.texts.Home

    title: ELocale.texts.OtherComponents
    description: ELocale.texts.MenusDividersAndWatermarksWithTheirState

    ExampleSection {
        componentName: "EMenu"

        ExampleCase {
            title: ELocale.texts.NestedMenusAndOverflow
            description: ELocale.texts.HoverOpensSubmenusNarrowWidthsMoveEntriesInto
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EApplicationWindow {
                    width: 640
                    height: 480
                    visible: true

                    Column {
                        width: parent.width - 48
                        spacing: 16
                        anchors.centerIn: parent

                        EMenu {
                            width: parent.width
                            direction: EOrientation.Horizontal
                            objectName: "webNavigationMenu"
                            model: [{index: "workspace", text: ELocale.texts.Workspace, children: [
                                {index: "open", text: ELocale.texts.OpenProject},
                                {index: "recent", text: ELocale.texts.Recent, children: [{index: "gallery", text: "EUI Gallery"}]}]},
                                {index: "settings", text: ELocale.texts.Settings},
                                {index: "restricted", text: ELocale.texts.Restricted, disabled: true}]
                        }
                    }
                }
            `)

            EMenu {
                width: parent.width
                objectName: "webNavigationMenu"
                direction: EOrientation.Horizontal
                model: [{index: "workspace", text: ELocale.texts.Workspace, children
                    : [
                    {index: "open", text: ELocale.texts.OpenProject},
                    {index: "recent", text: ELocale.texts.Recent, children
                        : [{index: "gallery", text: "EUI Gallery"}]}]},
                    {index: "settings", text: ELocale.texts.Settings},
                    {index: "restricted", text: ELocale.texts.Restricted, disabled
                        : true}]
            }
        }
    }
    ExampleSection {
        componentName: "EMenu"

        ExampleCard {
            code: exampleData.samples.OtherExamplesSample0
            description: ELocale.texts.VerticalMultilevelMenusHorizontalNavigationCollapseDisabled

            Row {
                spacing: 24

                EMenu {
                    id: verticalMenu

                    width: 260
                    uniqueOpened: true
                    currentIndex: "home"
                    model: exampleData.models.VerticalMenu

                    onItemSelected: function(index, indexPath, item) {
                        page.lastMenuSelection = item.text
                    }
                }
                Column {
                    spacing: 14

                    EText {
                        font.pixelSize: 14
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        text: ELocale.texts.CurrentSelection1.arg(page.lastMenuSelection)
                    }
                    EText {
                        font.pixelSize: 14
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        text: ELocale.texts.CurrentPath1.arg(verticalMenu.currentIndex)
                    }
                    EText {
                        font.pixelSize: 14
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        text: ELocale.texts.ExpandedItems1.arg(
                            verticalMenu.openedIndexes.join(ELocale.texts.Symbol8))
                    }
                    EButton {
                        text: ELocale.texts.ExpandWorkspace

                        onClicked: verticalMenu.open("workspace")
                    }
                    EButton {
                        text: ELocale.texts.SelectProjects

                        onClicked: verticalMenu.select("projects")
                    }
                    EButton {
                        text: ELocale.texts.CloseWorkspace

                        onClicked: verticalMenu.close("workspace")
                    }
                }
            }
            EMenu {
                width: parent.width
                styleType: EStyle.Success
                direction: EOrientation.Horizontal
                currentIndex: ELocale.texts.Products2
                model: exampleData.models.HorizontalMenu

                onItemSelected: function(index, indexPath, item) {
                    page.lastMenuSelection = item.text
                }
            }
            EMenu {
                width: 64
                indent: 18
                iconSize: 20
                duration: 260
                collapse: true
                itemHeight: 48
                uniqueOpened: false
                styleType: EStyle.Warning
                currentIndex: ELocale.texts.Favorites2
                model: exampleData.models.CollapsedMenu
                textColor: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                hoverColor: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                backgroundColor: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                activeTextColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
            }
        }
    }
    ExampleSection {
        componentName: "EDivider"

        ExampleCard {
            code: exampleData.samples.OtherExamplesSample1
            description: ELocale.texts.DirectionLabelPlacementBordersSpacingFontAnd

            Column {
                spacing: 22
                width: parent.width

                EDivider {
                    width: parent.width
                }
                EDivider {
                    width: parent.width
                    text: ELocale.texts.DividerLabel
                }
                EDivider {
                    width: parent.width
                    contentPosition: EPlacement.Left
                    text: ELocale.texts.VerticalDivider
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
                Row {
                    height: 84
                    spacing: 24

                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.LeftLabel
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    EDivider {
                        lineWidth: 2
                        verticalHeight: 84
                        direction: EOrientation.Vertical
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                    }
                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.RightLabel
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EWatermark"

        ExampleCard {
            code: exampleData.samples.OtherExamplesSample2
            description: ELocale.texts.TextOrArraysStackingRotationTileSize

            Item {
                height: 260
                width: parent.width

                ERectangle {
                    radius: 8
                    anchors.fill: parent
                    color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                    border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                    EText {
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        anchors.centerIn: parent
                        width: parent.width - 80
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        text: ELocale.texts.WatermarksOverlayContentWithoutTakingUpLayout
                    }
                }
                EWatermark {
                    id: detailedWatermark

                    zIndex: 9
                    rotate: -18
                    tileHeight: 72
                    tileWidth: 150
                    anchors.fill: parent
                    gap: Qt.point(42, 30)
                    offset: Qt.point(16, 10)
                    content: exampleData.models.Watermark
                    font: Qt.font({
                        "pixelSize": 15,
                        "bold": true
                    })
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
            }
            EText {
                font.pixelSize: 14
                width: parent.width
                wrapMode: Text.WordWrap
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                text: ELocale.texts.TheWatermarkOverlaysTheContentWhileButtonsAnd
            }
        }
    }
    OtherShowcase { }
}
