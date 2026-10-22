import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

EApplicationWindow {
    id: window

    property string currentComponent: ""
    property string openedGroup: "basic"
    property bool navigationExpanded: true
    property string currentSource: "Overview.qml"
    property bool asynchronousLoading: typeof galleryAsyncLoading === "undefined" || galleryAsyncLoading

    readonly property int navigationWidth: navigationExpanded ? 232 : 64
    readonly property var pages: {
        exampleCatalog.groups
        return exampleCatalog.filtered(searchInput.text)
    }

    function showOverview() {
        currentComponent = ""
        if (currentSource === "Overview.qml" && exampleLoader.item) {
            exampleLoader.item.contentY = 0
            syncNavigation()
            return
        }
        currentSource = "Overview.qml"
        exampleLoader.setSource(currentSource)
    }

    function showComponent(item) {
        if (!item || !item.source)
            return
        if (currentComponent === item.index && exampleLoader.item) {
            exampleLoader.item.contentY = 0
            return
        }
        currentComponent = item.index
        currentSource = item.source
        exampleLoader.source = ""
        exampleLoader.setSource(currentSource, { selectedComponent: currentComponent })
    }

    function syncNavigation() {
        for (let group = 0; group < pages.length && currentComponent.length > 0; ++group) {
            for (let index = 0; index < pages[group].children.length; ++index) {
                if (pages[group].children[index].index !== currentComponent)
                    continue
                openedGroup = pages[group].index
                group = pages.length
                break
            }
        }
        Qt.callLater(syncNavigationEntry)
    }

    function syncNavigationEntry() {
        for (let group = 0; group < navigationGroups.count; ++group) {
            const category = navigationGroups.itemAt(group)
            for (let index = 0; index < category.entries.count; ++index) {
                const entry = category.entries.itemAt(index)
                if (entry.entry.index !== window.currentComponent || !entry.visible)
                    continue
                const top = entry.mapToItem(navigationColumn, 0, 0).y
                const bottom = top + entry.height
                if (top < navigationViewport.contentY)
                    navigationViewport.contentY = top
                else if (bottom > navigationViewport.contentY + navigationViewport.height)
                    navigationViewport.contentY = Math.max(0, bottom - navigationViewport.height)
                return
            }
        }
    }

    height: 840
    width: 1280
    visible: true
    minimumWidth: 820
    minimumHeight: 600
    font.weight: Font.Normal
    objectName: "euiGallery"
    color: GalleryStyle.sidebar
    font.pixelSize: GalleryStyle.bodySize
    title: ELocale.texts.EuiComponentGallery
    flags: Qt.Window | Qt.FramelessWindowHint
    appBar: EAppBar {
        id: appBar

        objectName: "galleryAppBar"
        textColor: GalleryStyle.muted
        backgroundColor: GalleryStyle.sidebar

        UpdateControl {
            anchors.verticalCenter: parent.verticalCenter
        }
        ETextButton {
            id: repositoryButton

            text: ""
            width: 32
            iconSize: 22
            minHeight: 28
            accessibleName: "GitHub"
            objectName: "galleryRepositoryLink"
            anchors.verticalCenter: parent.verticalCenter
            iconSource: ETheme.dark ? EIcons.GITHUB_DARK : EIcons.GITHUB_LIGHT
            background: ERectangle {
                radius: 4
                color: !repositoryButton.enabled ? "transparent"
                    : repositoryButton.pressed ? appBar.buttonPressedColor
                    : repositoryButton.hovered ? appBar.buttonHoverColor : "transparent"
            }

            onClicked: Qt.openUrlExternally("https://github.com/lihechuan/EUI")
        }
        ETextButton {
            id: languageButton

            minHeight: 28
            font.bold: false
            objectName: "galleryLanguageSwitch"
            text: ELocale.language === "en" ? ELocale.texts.SimplifiedChinese : ELocale.texts.English
            background: ERectangle {
                radius: 4
                color: !languageButton.enabled ? "transparent"
                    : languageButton.pressed ? appBar.buttonPressedColor
                    : languageButton.hovered ? appBar.buttonHoverColor : "transparent"
            }

            onClicked: ELocale.language = ELocale.language === "en" ? "zh" : "en"
        }
        EThemeSwitch {
            objectName: "galleryThemeSwitch"
            anchors.verticalCenter: parent.verticalCenter
            accessibleName: ETheme.dark ? ELocale.texts.Light : ELocale.texts.Dark
        }
    }

    onPagesChanged: syncNavigation()
    onClosing: exampleLoader.active = false
    onCurrentComponentChanged: syncNavigation()

    Shortcut {
        sequence: "Ctrl+K"

        onActivated: {
            window.navigationExpanded = true
            searchInput.forceActiveFocus()
        }
    }
    ERectangle {
        anchors.fill: parent
        color: GalleryStyle.sidebar
        objectName: "gallerySurface"

        Item {
            id: navigationPane

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: window.navigationWidth

            Behavior on width {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.InOutCubic
                }
            }
            Row {
                x: 16
                y: 22
                spacing: 10

                ERectangle {
                    radius: 6
                    width: 34
                    height: 34
                    color: GalleryStyle.accentSoft

                    Image {
                        width: 30
                        height: 30
                        anchors.centerIn: parent
                        source: "qrc:/example/eui-mark.svg"
                    }
                }
                Column {
                    spacing: 3
                    visible: window.navigationExpanded

                    EText {
                        font.pixelSize: 18
                        text: "EUI Gallery"
                        color: GalleryStyle.text
                        font.weight: Font.DemiBold
                    }
                    EText {
                        color: GalleryStyle.muted
                        text: ELocale.texts.QtQuickComponents
                        font.pixelSize: GalleryStyle.captionSize
                    }
                }
            }
            Column {
                id: sidebarColumn

                y: 82
                spacing: 10
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height - y - sidebarFooter.height - 28

                EInput {
                    id: searchInput

                    clearable: true
                    implicitHeight: 32
                    width: parent.width
                    objectName: "gallerySearch"
                    prefixIcon: EIcons.MAGNIFIER
                    visible: window.navigationExpanded
                    placeholderText: ELocale.texts.SearchComponents
                    background: ERectangle {
                        radius: 5
                        border.width: 1
                        color: GalleryStyle.surface
                        border.color: searchInput.activeFocus ? GalleryStyle.accent : GalleryStyle.line
                    }

                    onAccepted: {
                        if (window.pages.length > 0 && window.pages[0].children.length > 0)
                            window.showComponent(window.pages[0].children[0])
                    }
                }
                ETextButton {
                    id: overviewButton

                    minHeight: 36
                    leftPadding: 12
                    rightPadding: 12
                    width: parent.width
                    objectName: "galleryOverviewButton"
                    text: ELocale.texts.ComponentOverview
                    background: ERectangle {
                        radius: 5
                        color: window.currentComponent.length === 0 ? GalleryStyle.selection
                            : overviewButton.hovered ? GalleryStyle.hover : "transparent"
                    }
                    contentItem: Row {
                        spacing: 12

                        EIcon {
                            iconSize: 16
                            iconSource: EIcons.HOUSE
                            color: GalleryStyle.accent
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        EText {
                            color: GalleryStyle.text
                            text: overviewButton.text
                            visible: window.navigationExpanded
                            font.pixelSize: GalleryStyle.bodySize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    onClicked: window.showOverview()
                }
                Flickable {
                    id: navigationViewport

                    clip: true
                    pixelAligned: true
                    contentWidth: width
                    width: parent.width
                    objectName: "galleryNavigation"
                    ScrollBar.vertical: ScrollHandle { }
                    boundsBehavior: Flickable.StopAtBounds
                    contentHeight: navigationColumn.implicitHeight
                    height: Math.max(0, sidebarColumn.height - overviewButton.height
                        - (searchInput.visible ? searchInput.height + sidebarColumn.spacing : 0) - sidebarColumn.spacing)

                    Column {
                        id: navigationColumn

                        spacing: 3
                        width: parent.width

                        Repeater {
                            id: navigationGroups

                            model: window.pages

                            Column {
                                id: category

                                property var group: modelData

                                readonly property alias entries: childEntries
                                readonly property bool expanded: window.navigationExpanded
                                    && (window.openedGroup === group.index || searchInput.text.trim().length > 0)

                                spacing: 2
                                width: navigationColumn.width

                                ETextButton {
                                    id: categoryButton

                                    minHeight: 34
                                    leftPadding: 12
                                    rightPadding: 12
                                    width: parent.width
                                    text: category.group.text
                                    background: ERectangle {
                                        radius: 5
                                        color: categoryButton.hovered ? GalleryStyle.hover : "transparent"
                                    }
                                    contentItem: Item {
                                        EIcon {
                                            iconSize: 16
                                            color: GalleryStyle.muted
                                            anchors.verticalCenter: parent.verticalCenter
                                            iconSource: GalleryStyle.groupIcon(category.group.index)
                                        }
                                        EText {
                                            x: 28
                                            elide: Text.ElideRight
                                            color: GalleryStyle.text
                                            width: parent.width - 48
                                            text: category.group.text
                                            visible: window.navigationExpanded
                                            font.pixelSize: GalleryStyle.bodySize
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        EIcon {
                                            iconSize: 10
                                            color: GalleryStyle.muted
                                            anchors.right: parent.right
                                            iconSource: EIcons.CHEVRON_DOWN
                                            visible: window.navigationExpanded
                                            rotation: category.expanded ? 180 : 0
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    onClicked: {
                                        if (!window.navigationExpanded)
                                            window.navigationExpanded = true
                                        window.openedGroup = window.openedGroup === category.group.index ? "" : category.group.index
                                    }
                                }
                                Column {
                                    spacing: 1
                                    width: parent.width
                                    visible: category.expanded

                                    Repeater {
                                        id: childEntries

                                        model: category.expanded ? category.group.children : []

                                        ETextButton {
                                            id: entryButton

                                            property var entry: modelData

                                            readonly property bool selected: window.currentComponent === entry.index

                                            minHeight: 32
                                            leftPadding: 40
                                            rightPadding: 12
                                            text: entry.label
                                            width: parent.width
                                            Accessible.selected: selected
                                            objectName: "galleryNavEntry"
                                            Accessible.description: entry.isNew ? ELocale.texts.ComponentNewVersion.arg(entry.introducedIn)
                                                : entry.demo ? ELocale.texts.GalleryDemoDescription : ""
                                            background: ERectangle {
                                                radius: 5
                                                color: entryButton.selected ? GalleryStyle.selection
                                                    : entryButton.hovered ? GalleryStyle.hover : "transparent"

                                                ERectangle {
                                                    x: 0
                                                    width: 3
                                                    radius: 1
                                                    height: 16
                                                    color: GalleryStyle.accent
                                                    visible: entryButton.selected
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                            }
                                            contentItem: Item {
                                                EText {
                                                    font.bold: false
                                                    elide: Text.ElideRight
                                                    text: entryButton.text
                                                    color: GalleryStyle.text
                                                    font.pixelSize: GalleryStyle.bodySize
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: Math.max(0, parent.width - (demoBadge.visible ? demoBadge.width + 8 : 0)
                                                        - (newBadge.visible ? newBadge.width + 8 : 0))
                                                }
                                                ETag {
                                                    id: newBadge

                                                    leftPadding: 6
                                                    rightPadding: 6
                                                    size: EStyle.Small
                                                    styleType: EStyle.Success
                                                    anchors.right: parent.right
                                                    objectName: "galleryNavNewBadge"
                                                    text: ELocale.texts.ComponentNew
                                                    visible: entryButton.entry.isNew
                                                    anchors.verticalCenter: parent.verticalCenter

                                                    onClicked: window.showComponent(entryButton.entry)
                                                }
                                                ETag {
                                                    id: demoBadge

                                                    leftPadding: 6
                                                    rightPadding: 6
                                                    size: EStyle.Small
                                                    styleType: EStyle.Warning
                                                    anchors.right: parent.right
                                                    visible: entryButton.entry.demo
                                                    objectName: "galleryNavDemoBadge"
                                                    text: ELocale.texts.GalleryDemoLabel
                                                    anchors.verticalCenter: parent.verticalCenter

                                                    onClicked: window.showComponent(entryButton.entry)
                                                }
                                            }

                                            onClicked: window.showComponent(entry)

                                            EToolTip {
                                                showAfter: 500
                                                showArrow: false
                                                placement: EPlacement.Right
                                                objectName: "galleryNavDemoTooltip"
                                                text: ELocale.texts.GalleryDemoDescription
                                                visible: entryButton.entry.demo && entryButton.hovered
                                                    && entryButton.Window.window && entryButton.Window.window.visible
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: GalleryStyle.muted
                            visible: window.pages.length === 0
                            font.pixelSize: GalleryStyle.bodySize
                            text: ELocale.texts.NoMatchingResults
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton

                        onWheel: function(wheel) {
                            const delta = wheel.pixelDelta.y || wheel.angleDelta.y / 120 * 128
                            if (delta === 0) {
                                wheel.accepted = false
                                return
                            }
                            navigationViewport.cancelFlick()
                            navigationViewport.contentY = Math.max(0, Math.min(navigationViewport.contentY - delta,
                                navigationViewport.contentHeight - navigationViewport.height))
                            wheel.accepted = true
                        }
                    }
                }
            }
            Column {
                id: sidebarFooter

                x: 12
                spacing: 10
                anchors.bottomMargin: 16
                width: parent.width - 24
                anchors.bottom: parent.bottom

                Row {
                    height: 36
                    spacing: 10

                    ETextButton {
                        width: 36
                        height: 36
                        minHeight: 36
                        iconSource: EIcons.BARS
                        objectName: "galleryNavigationToggle"
                        background: ERectangle {
                            radius: 5
                            color: GalleryStyle.hover
                        }
                        accessibleName: window.navigationExpanded ? ELocale.texts.CollapseNavigation : ELocale.texts.ExpandNavigation

                        onClicked: window.navigationExpanded = !window.navigationExpanded
                    }
                    Column {
                        spacing: 3
                        visible: window.navigationExpanded
                        anchors.verticalCenter: parent.verticalCenter

                        EText {
                            color: GalleryStyle.text
                            text: "Qt Quick \u00b7 QML"
                            font.pixelSize: GalleryStyle.bodySize
                        }
                        EText {
                            color: GalleryStyle.muted
                            objectName: "galleryVersion"
                            font.pixelSize: GalleryStyle.captionSize
                            text: "EUI PySide6 " + galleryVersion
                        }
                    }
                }
            }
        }
        ERectangle {
            id: workspace

            anchors.top: parent.top
            color: GalleryStyle.canvas
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: navigationPane.right

            ERectangle {
                width: 1
                height: parent.height
                color: GalleryStyle.line
            }
            Item {
                id: headerBar

                height: 44
                width: parent.width
                objectName: "galleryBreadcrumbHeader"

                EBreadcrumb {
                    anchors.leftMargin: 28
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    model: {
                        exampleCatalog.groups
                        return exampleCatalog.breadcrumb(window.currentComponent)
                    }

                    onClicked: window.showOverview()
                }
                ERectangle {
                    x: 0
                    height: 1
                    width: parent.width
                    color: GalleryStyle.line
                    anchors.bottom: parent.bottom
                }
            }
            Loader {
                id: exampleLoader

                anchors.left: parent.left
                anchors.right: parent.right
                objectName: "galleryLoader"
                anchors.bottom: parent.bottom
                anchors.top: headerBar.bottom
                asynchronous: window.asynchronousLoading
                opacity: status === Loader.Ready ? 1 : 0

                onLoaded: {
                    if (item.componentSelected)
                        item.componentSelected.connect(window.showComponent)
                }
                Component.onCompleted: setSource(window.currentSource,
                    window.currentComponent.length > 0 ? { selectedComponent: window.currentComponent } : {})

                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
