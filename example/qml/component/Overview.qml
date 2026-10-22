import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Flickable {
    id: control

    property var groups: exampleCatalog.groups

    readonly property var componentIcons: GalleryStyle.componentIcons
    readonly property int componentCount: groups.reduce(function(total, group) {
        return total + group.children.length
    }, 0)
    readonly property var newComponents: groups.reduce(function(items, group) {
        return items.concat(group.children.filter(function(entry) { return entry.isNew }))
    }, [])
    readonly property var featuredEntries: [{
        "component": "EInput",
        "color": GalleryStyle.accent,
        "name": "galleryFeaturedInput",
        "icon": EIcons.KEYBOARD,
        "title": ELocale.texts.Input2,
        "description": ELocale.texts.TextEntryIconsAndValidation
    }, {
        "component": "ETable",
        "color": GalleryStyle.teal,
        "name": "galleryFeaturedTable",
        "icon": EIcons.LAYOUT_LIST,
        "title": ELocale.texts.Table,
        "description": ELocale.texts.DataSortingAndRowSelection
    }, {
        "component": "EThemeSwitch",
        "color": GalleryStyle.violet,
        "name": "galleryFeaturedTheme",
        "icon": EIcons.PALETTE,
        "title": ELocale.texts.ThemeSwitch,
        "description": ELocale.texts.LightDarkAndColorTransitions
    }]

    signal componentSelected(var item)

    clip: true
    contentWidth: width
    ScrollBar.vertical: ScrollHandle { }
    boundsBehavior: Flickable.StopAtBounds
    contentHeight: content.y + content.implicitHeight + 32

    Column {
        id: content

        x: 24
        y: 24
        spacing: 24
        width: Math.max(0, control.width - 48)

        Column {
            spacing: 6
            width: parent.width

            EText {
                color: GalleryStyle.text
                font.weight: Font.DemiBold
                font.pixelSize: GalleryStyle.titleSize
                text: ELocale.texts.EUIComponentPlayground
            }
            EText {
                color: GalleryStyle.muted
                font.pixelSize: GalleryStyle.captionSize
                text: control.componentCount + ELocale.texts.ComponentsInteractiveQtQuickExamples
            }
        }
        Column {
            spacing: 12
            width: parent.width
            objectName: "galleryNewComponents"
            visible: control.newComponents.length > 0

            EText {
                color: GalleryStyle.text
                font.weight: Font.DemiBold
                font.pixelSize: GalleryStyle.headingSize
                text: ELocale.texts.ComponentNewVersion.arg(control.newComponents.length > 0
                    ? control.newComponents[0].introducedIn : "")
            }
            Flow {
                spacing: 8
                width: parent.width

                Repeater {
                    model: control.newComponents

                    EButton {
                        property var entry: modelData

                        plain: true
                        size: EStyle.Small
                        styleType: EStyle.Success
                        objectName: "galleryNewComponentLink"
                        text: entry.index + " · " + ELocale.texts.ComponentNew

                        onClicked: control.componentSelected(entry)
                    }
                }
            }
        }
        Item {
            id: hero

            width: parent.width
            objectName: "galleryOverviewHero"
            implicitHeight: featuredGrid.y + featuredGrid.implicitHeight

            ERectangle {
                radius: 8
                clip: true
                height: 132
                width: parent.width
                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0
                        color: GalleryStyle.dark ? "#233F87" : "#264FC1"
                    }
                    GradientStop {
                        position: 1
                        color: GalleryStyle.dark ? "#3C3680" : "#5B4EBF"
                    }
                }

                EText {
                    x: 20
                    y: 20
                    color: "#FFFFFF"
                    font.weight: Font.DemiBold
                    text: ELocale.texts.FeaturedComponents
                    font.pixelSize: GalleryStyle.headingSize
                }
                EText {
                    x: 20
                    y: 45
                    color: "#DDE5FF"
                    font.pixelSize: GalleryStyle.captionSize
                    text: ELocale.texts.PreviewInteractAndViewTheQMLSource
                }
                Canvas {
                    height: parent.height
                    x: parent.width * 0.3
                    width: parent.width * 0.7

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onPaint: {
                        const context = getContext("2d")
                        context.reset()
                        const w = width
                        const h = height
                        const tones = ["rgba(55, 207, 222, 0.5)", "rgba(104, 151, 255, 0.5)", "rgba(171, 116, 235, 0.6)"]
                        for (let layer = 0; layer < tones.length; ++layer) {
                            const offset = layer * 18
                            const fill = context.createLinearGradient(0, h, w, 0)
                            fill.addColorStop(0, "rgba(78, 137, 242, 0)")
                            fill.addColorStop(0.45, tones[layer])
                            fill.addColorStop(1, tones[layer])
                            context.beginPath()
                            context.moveTo(w * 1.03, -h * 0.22 + offset)
                            context.bezierCurveTo(w * 0.75, -h * 0.42 + offset,
                                w * 0.79, h * 0.68 + offset, w * 0.45, h * 0.57 + offset)
                            context.bezierCurveTo(w * 0.23, h * 0.48 + offset,
                                w * 0.14, h * 0.87 + offset, -w * 0.12, h * 0.99 + offset)
                            context.lineTo(-w * 0.12, h * 1.25 + offset)
                            context.bezierCurveTo(w * 0.18, h * 1.15 + offset,
                                w * 0.25, h * 0.72 + offset, w * 0.48, h * 0.84 + offset)
                            context.bezierCurveTo(w * 0.8, h * 1.04 + offset,
                                w * 0.9, h * 0.05 + offset, w * 1.03, h * 0.14 + offset)
                            context.closePath()
                            context.fillStyle = fill
                            context.fill()
                            context.beginPath()
                            context.moveTo(w * 1.03, -h * 0.22 + offset)
                            context.bezierCurveTo(w * 0.75, -h * 0.42 + offset,
                                w * 0.79, h * 0.68 + offset, w * 0.45, h * 0.57 + offset)
                            context.bezierCurveTo(w * 0.23, h * 0.48 + offset,
                                w * 0.14, h * 0.87 + offset, -w * 0.12, h * 0.99 + offset)
                            context.strokeStyle = "rgba(193, 231, 255, 0.32)"
                            context.lineWidth = 1
                            context.stroke()
                        }
                    }
                }
            }
            Flow {
                id: featuredGrid

                readonly property int columns: width >= 660 ? 3 : width >= 480 ? 2 : 1

                x: 12
                y: 82
                spacing: 12
                width: parent.width - 24
                objectName: "galleryFeaturedGrid"

                Repeater {
                    model: control.featuredEntries

                    ETextButton {
                        id: featuredCard

                        property var entry: modelData

                        padding: 16
                        font.bold: false
                        text: entry.title
                        objectName: entry.name
                        Accessible.description: entry.component
                        height: Math.max(264, implicitContentHeight + topPadding + bottomPadding)
                        width: (featuredGrid.width - featuredGrid.spacing * (featuredGrid.columns - 1)) / featuredGrid.columns
                        background: ERectangle {
                            radius: 8
                            border.width: 1
                            color: featuredCard.hovered ? Qt.tint(GalleryStyle.surface, "#063267E8") : GalleryStyle.surface
                            border.color: featuredCard.hovered || featuredCard.activeFocus ? featuredCard.entry.color : GalleryStyle.line
                        }
                        contentItem: Column {
                            spacing: 10

                            Row {
                                height: 38
                                spacing: 10
                                width: parent.width

                                ERectangle {
                                    radius: 8
                                    width: 36
                                    height: 36
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: Qt.tint(GalleryStyle.surface, Qt.rgba(featuredCard.entry.color.r,
                                        featuredCard.entry.color.g, featuredCard.entry.color.b, GalleryStyle.dark ? 0.18 : 0.09))

                                    EIcon {
                                        iconSize: 20
                                        anchors.centerIn: parent
                                        color: featuredCard.entry.color
                                        iconSource: featuredCard.entry.icon
                                    }
                                }
                                EText {
                                    elide: Text.ElideRight
                                    color: GalleryStyle.text
                                    width: parent.width - 46
                                    font.weight: Font.DemiBold
                                    text: featuredCard.entry.title
                                    font.pixelSize: GalleryStyle.headingSize
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: GalleryStyle.muted
                                height: Math.max(40, implicitHeight)
                                text: featuredCard.entry.description
                                font.pixelSize: GalleryStyle.bodySize
                                lineHeight: GalleryStyle.bodyLineHeight
                            }
                            Item {
                                height: 110
                                width: parent.width

                                Loader {
                                    anchors.fill: parent
                                    sourceComponent: featuredCard.entry.component === "EInput" ? inputPreview
                                        : featuredCard.entry.component === "ETable" ? tablePreview : themePreview
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: featuredCard.clicked()
                                }
                            }
                            Row {
                                spacing: 6

                                EText {
                                    color: featuredCard.entry.color
                                    text: ELocale.texts.OpenExample
                                    font.pixelSize: GalleryStyle.captionSize
                                }
                                EIcon {
                                    iconSize: 12
                                    iconSource: EIcons.ARROW_RIGHT
                                    color: featuredCard.entry.color
                                }
                            }
                        }

                        onClicked: control.componentSelected(exampleCatalog.find(entry.component))

                        EToolTip {
                            showAfter: 500
                            showArrow: false
                            text: featuredCard.entry.component
                            font.pixelSize: GalleryStyle.captionSize
                            visible: featuredCard.hovered && featuredCard.Window.window && featuredCard.Window.window.visible
                        }
                    }
                }
            }
        }
        Column {
            spacing: 16
            width: parent.width

            EText {
                color: GalleryStyle.text
                font.weight: Font.DemiBold
                text: ELocale.texts.AllComponents
                font.pixelSize: GalleryStyle.sectionSize
            }
            Flow {
                id: categoryGrid

                readonly property int columns: width >= 900 ? 3 : width >= 580 ? 2 : 1

                spacing: 20
                width: parent.width
                objectName: "galleryCategoryGrid"

                Repeater {
                    model: control.groups

                    ERectangle {
                        id: category

                        property bool expanded: false
                        property var group: modelData

                        readonly property color accent: [GalleryStyle.accent, GalleryStyle.teal, GalleryStyle.violet][index % 3]
                            || GalleryStyle.accent

                        radius: 10
                        border.width: 1
                        color: GalleryStyle.surface
                        border.color: GalleryStyle.line
                        objectName: "galleryCategoryCard"
                        height: categoryContent.implicitHeight + 32
                        width: expanded ? categoryGrid.width
                            : (categoryGrid.width - categoryGrid.spacing * (categoryGrid.columns - 1)) / categoryGrid.columns

                        Column {
                            id: categoryContent

                            x: 16
                            y: 16
                            spacing: 14
                            width: parent.width - 32

                            Row {
                                height: 42
                                spacing: 12
                                width: parent.width

                                ERectangle {
                                    width: 42
                                    height: 42
                                    radius: 10
                                    color: Qt.tint(GalleryStyle.surface, Qt.rgba(category.accent.r,
                                        category.accent.g, category.accent.b, GalleryStyle.dark ? 0.18 : 0.09))

                                    EIcon {
                                        iconSize: 20
                                        color: category.accent
                                        anchors.centerIn: parent
                                        iconSource: GalleryStyle.groupIcon(category.group.index)
                                    }
                                }
                                Column {
                                    spacing: 4
                                    width: parent.width - 54
                                    anchors.verticalCenter: parent.verticalCenter

                                    EText {
                                        width: parent.width
                                        elide: Text.ElideRight
                                        color: GalleryStyle.text
                                        text: category.group.text
                                        font.weight: Font.DemiBold
                                        font.pixelSize: GalleryStyle.headingSize
                                    }
                                    EText {
                                        color: GalleryStyle.muted
                                        font.pixelSize: GalleryStyle.captionSize
                                        text: (category.group.children.length === 1 ? ELocale.texts.ComponentCount
                                            : ELocale.texts.ComponentsCount).arg(category.group.children.length)
                                    }
                                }
                            }
                            Flow {
                                id: categoryTiles

                                readonly property int columns: category.expanded ? Math.max(1, Math.floor((width + spacing) / 136))
                                    : Math.min(3, category.group.children.length)

                                spacing: 8
                                width: parent.width
                                objectName: "galleryCategoryTileGrid"

                                Repeater {
                                    model: category.expanded ? category.group.children : category.group.children.slice(0, 3)

                                    ETextButton {
                                        id: categoryLink

                                        property var entry: modelData

                                        height: 94
                                        padding: 8
                                        font.bold: false
                                        text: entry.label
                                        objectName: "galleryCategoryLink"
                                        Accessible.description: entry.index
                                        width: (categoryTiles.width - categoryTiles.spacing * (categoryTiles.columns - 1)) / categoryTiles.columns
                                        background: ERectangle {
                                            radius: 8
                                            border.width: 1
                                            border.color: categoryLink.hovered || categoryLink.activeFocus ? category.accent : "transparent"
                                            color: categoryLink.hovered || categoryLink.activeFocus ? GalleryStyle.accentSoft : GalleryStyle.canvas
                                        }
                                        contentItem: Item {
                                            ETag {
                                                leftPadding: 4
                                                rightPadding: 4
                                                size: EStyle.Small
                                                anchors.top: parent.top
                                                styleType: EStyle.Success
                                                anchors.right: parent.right
                                                text: ELocale.texts.ComponentNew
                                                visible: categoryLink.entry.isNew
                                                objectName: "galleryOverviewNewBadge"

                                                onClicked: control.componentSelected(categoryLink.entry)
                                            }
                                            EIcon {
                                                y: 10
                                                iconSize: 26
                                                color: category.accent
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                iconSource: control.componentIcons[categoryLink.entry.index] || EIcons.CUBE
                                            }
                                            EText {
                                                y: 45
                                                maximumLineCount: 2
                                                width: parent.width
                                                elide: Text.ElideRight
                                                wrapMode: Text.WordWrap
                                                text: categoryLink.entry.label
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pixelSize: GalleryStyle.captionSize
                                                color: categoryLink.hovered ? category.accent : GalleryStyle.text
                                            }
                                        }

                                        onClicked: control.componentSelected(entry)

                                        EToolTip {
                                            showAfter: 500
                                            showArrow: false
                                            text: categoryLink.entry.index
                                            font.pixelSize: GalleryStyle.captionSize
                                            visible: categoryLink.hovered && categoryLink.Window.window && categoryLink.Window.window.visible
                                        }
                                    }
                                }
                            }
                            ETextButton {
                                id: categoryToggle

                                height: 28
                                iconSize: 12
                                leftPadding: 0
                                rightPadding: 0
                                font.bold: false
                                width: parent.width
                                background: Item { }
                                color: category.accent
                                objectName: "galleryCategoryToggle"
                                font.pixelSize: GalleryStyle.captionSize
                                visible: category.group.children.length > 3
                                iconSource: category.expanded ? EIcons.CHEVRON_UP : EIcons.ARROW_RIGHT
                                text: category.expanded ? ELocale.texts.ShowLess
                                    : ELocale.texts.ShowAllComponents.arg(category.group.children.length)

                                onClicked: category.expanded = !category.expanded
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: inputPreview

        ERectangle {
            radius: 8
            color: GalleryStyle.preview

            EInput {
                readOnly: true
                prefixIcon: EIcons.AT
                text: "hello@eui.dev"
                activeFocusOnTab: false
                Accessible.ignored: true
                anchors.centerIn: parent
                width: parent.width - 24
            }
        }
    }
    Component {
        id: tablePreview

        ERectangle {
            radius: 8
            clip: true
            color: GalleryStyle.preview

            ETable {
                rowHeight: 32
                headerHeight: 30
                anchors.margins: 6
                anchors.fill: parent
                background: Item { }
                highlightCurrentRow: false
                objectName: "galleryTablePreview"
                font.pixelSize: GalleryStyle.captionSize
                model: [{name: "Aurora", ready: true}, {name: "Atlas", ready: false}]
                columns: [{
                    prop: "name",
                    label: ELocale.texts.Project
                }, {
                    prop: "ready",
                    cellDelegate: previewStatus,
                    label: ELocale.texts.Status
                }]
            }
            Component {
                id: previewStatus

                Item {
                    property var row

                    ETag {
                        round: true
                        size: EStyle.Small
                        anchors.leftMargin: 12
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        styleType: row && row.ready ? EStyle.Success : EStyle.Warning
                        text: row && row.ready ? ELocale.texts.Ready : ELocale.texts.Review
                    }
                }
            }
        }
    }
    Component {
        id: themePreview

        Item {
            ERectangle {
                radius: 8
                anchors.fill: parent
                color: GalleryStyle.preview
            }
            Row {
                spacing: 10
                anchors.centerIn: parent

                EThemeSwitch {
                    focusPolicy: Qt.NoFocus
                    Accessible.ignored: true
                }
                EIcon {
                    iconSize: 18
                    color: GalleryStyle.muted
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: GalleryStyle.dark ? EIcons.MOON : EIcons.SUN
                }
                EText {
                    color: GalleryStyle.text
                    font.pixelSize: GalleryStyle.captionSize
                    anchors.verticalCenter: parent.verticalCenter
                    text: GalleryStyle.dark ? ELocale.texts.Dark : ELocale.texts.Light
                }
            }
        }
    }
}
