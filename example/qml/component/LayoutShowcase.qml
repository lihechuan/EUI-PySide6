import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EConfigProvider"

        ExampleCase {
            objectName: "showcaseEConfigProvider0"
            title: ELocale.texts.InheritedSizeAndDisabledState
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EConfigProvider {
                    disabled: true
                    size: EStyle.Small
                    width: parent.width
                    height: content.implicitHeight

                    Column {
                        id: content

                        spacing: 12
                        width: parent.width

                        EButton {
                            text: ELocale.texts.ProjectActions
                        }
                        EInput {
                            width: Math.min(480, parent.width)
                            text: ELocale.texts.InheritTheDisabledState
                        }
                        ESelect {
                            model: ["QML", "Qt"]
                            width: Math.min(480, parent.width)
                        }
                    }
                }
            `)

            EConfigProvider {
                disabled: true
                size: EStyle.Small
                width: parent.width
                height: content.implicitHeight

                Column {
                    id: content

                    spacing: 12
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ProjectActions
                    }
                    EInput {
                        width: Math.min(480, parent.width)
                        text: ELocale.texts.InheritTheDisabledState
                    }
                    ESelect {
                        model: ["QML", "Qt"]
                        width: Math.min(480, parent.width)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EConfigProvider"

        ExampleCase {
            objectName: "showcaseEConfigProvider1"
            title: ELocale.texts.LocalComponentDefaults
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EConfigProvider {
                    width: parent.width
                    card: ({shadow: "never"})
                    height: content.implicitHeight
                    button: ({plain: true, round: true, type: "primary"})

                    Column {
                        id: content

                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.LocalButtonDefaults
                        }
                        ECard {
                            header: ELocale.texts.LocalCard
                            width: Math.min(480, parent.width)

                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.TheConfigurationAppliesOnlyToThisSubtree
                            }
                        }
                    }
                }
            `)

            EConfigProvider {
                width: parent.width
                card: ({shadow: "never"})
                height: content.implicitHeight
                button: ({plain: true, round: true, type: "primary"})

                Column {
                    id: content

                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.LocalButtonDefaults
                    }
                    ECard {
                        header: ELocale.texts.LocalCard
                        width: Math.min(480, parent.width)

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TheConfigurationAppliesOnlyToThisSubtree
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EConfigProvider"

        ExampleCase {
            title: ELocale.texts.LocalLanguage
            objectName: "showcaseEConfigProvider2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EConfigProvider {
                    width: parent.width
                    height: content.implicitHeight
                    locale: ({name: "en", texts: {NoData: "No projects yet"}})

                    Column {
                        id: content

                        width: parent.width

                        EEmpty {
                            width: parent.width
                        }
                    }
                }
            `)

            EConfigProvider {
                width: parent.width
                height: content.implicitHeight
                locale: ({name: "en", texts: {NoData: "No projects yet"}})

                Column {
                    id: content

                    width: parent.width

                    EEmpty {
                        width: parent.width
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELink"

        ExampleCase {
            objectName: "showcaseELink0"
            title: ELocale.texts.SemanticLinks
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ELink {
                        styleType: EStyle.Primary
                        text: ELocale.texts.ViewDocumentation
                    }
                    ELink {
                        styleType: EStyle.Success
                        text: ELocale.texts.ViewDocumentation
                    }
                    ELink {
                        styleType: EStyle.Warning
                        text: ELocale.texts.ViewDocumentation
                    }
                    ELink {
                        styleType: EStyle.Danger
                        text: ELocale.texts.ViewDocumentation
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ELink {
                    styleType: EStyle.Primary
                    text: ELocale.texts.ViewDocumentation
                }
                ELink {
                    styleType: EStyle.Success
                    text: ELocale.texts.ViewDocumentation
                }
                ELink {
                    styleType: EStyle.Warning
                    text: ELocale.texts.ViewDocumentation
                }
                ELink {
                    styleType: EStyle.Danger
                    text: ELocale.texts.ViewDocumentation
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELink"

        ExampleCase {
            objectName: "showcaseELink1"
            title: ELocale.texts.DisabledLinks
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ELink {
                        enabled: true
                        underline: true
                        text: ELocale.texts.ProjectDetails
                    }
                    ELink {
                        enabled: false
                        underline: true
                        text: ELocale.texts.ProjectDetails
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ELink {
                    enabled: true
                    underline: true
                    text: ELocale.texts.ProjectDetails
                }
                ELink {
                    enabled: false
                    underline: true
                    text: ELocale.texts.ProjectDetails
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELink"

        ExampleCase {
            objectName: "showcaseELink2"
            title: ELocale.texts.IconLink
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ELink {
                    leftIcon: true
                    iconSource: EIcons.PENCIL
                    styleType: EStyle.Primary
                    text: ELocale.texts.OpenSettings
                }
            `)

            ELink {
                leftIcon: true
                iconSource: EIcons.PENCIL
                styleType: EStyle.Primary
                text: ELocale.texts.OpenSettings
            }
        }
    }
    ExampleSection {
        componentName: "ELink"

        ExampleCase {
            objectName: "showcaseELink3"
            title: ELocale.texts.ClickFeedback
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ELink {
                        text: ELocale.texts.ViewTheLatestVersion

                        onClicked: result.text = ELocale.texts.CurrentVersion10
                    }
                    EText {
                        id: result

                        text: ELocale.texts.ClickTheLinkToViewInformation
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ELink {
                    text: ELocale.texts.ViewTheLatestVersion

                    onClicked: result.text = ELocale.texts.CurrentVersion10
                }
                EText {
                    id: result

                    text: ELocale.texts.ClickTheLinkToViewInformation
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERow"

        ExampleCase {
            objectName: "showcaseERow0"
            title: ELocale.texts.GridOffsets
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERow {
                    gutter: [16, 16]
                    width: parent.width

                    ECol {
                        span: 8
                        offset: 4
                        height: 64

                        ERectangle {
                            radius: 8
                            color: "#409eff"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                text: "8 / offset 4"
                                anchors.centerIn: parent
                            }
                        }
                    }
                    ECol {
                        span: 8
                        height: 64

                        ERectangle {
                            radius: 8
                            color: "#67c23a"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                text: "8 / 24"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            `)

            ERow {
                gutter: [16, 16]
                width: parent.width

                ECol {
                    span: 8
                    offset: 4
                    height: 64

                    ERectangle {
                        radius: 8
                        color: "#409eff"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            text: "8 / offset 4"
                            anchors.centerIn: parent
                        }
                    }
                }
                ECol {
                    span: 8
                    height: 64

                    ERectangle {
                        radius: 8
                        color: "#67c23a"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            text: "8 / 24"
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERow"

        ExampleCase {
            objectName: "showcaseERow1"
            title: ELocale.texts.RowAlignment
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERow {
                    gutter: 16
                    align: "middle"
                    width: parent.width
                    justify: "space-between"

                    EButton {
                        text: ELocale.texts.ActionA
                    }
                    EButton {
                        size: EStyle.Large
                        styleType: EStyle.Primary
                        text: ELocale.texts.PrimaryAction
                    }
                    EButton {
                        text: ELocale.texts.ActionB
                    }
                }
            `)

            ERow {
                gutter: 16
                align: "middle"
                width: parent.width
                justify: "space-between"

                EButton {
                    text: ELocale.texts.ActionA
                }
                EButton {
                    size: EStyle.Large
                    styleType: EStyle.Primary
                    text: ELocale.texts.PrimaryAction
                }
                EButton {
                    text: ELocale.texts.ActionB
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERow"

        ExampleCase {
            objectName: "showcaseERow2"
            title: ELocale.texts.ResponsiveRow
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERow {
                    gutter: [12, 12]
                    width: parent.width
                    viewportWidth: width

                    ECol {
                        md: 8
                        sm: 12
                        xs: 24
                        height: 60

                        ERectangle {
                            radius: 8
                            color: "#409eff"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.ResponsiveLabel
                            }
                        }
                    }
                    ECol {
                        md: 8
                        sm: 12
                        xs: 24
                        height: 60

                        ERectangle {
                            radius: 8
                            color: "#67c23a"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.ResponsiveLabel
                            }
                        }
                    }
                    ECol {
                        md: 8
                        sm: 12
                        xs: 24
                        height: 60

                        ERectangle {
                            radius: 8
                            color: "#f56c6c"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.ResponsiveLabel
                            }
                        }
                    }
                }
            `)

            ERow {
                gutter: [12, 12]
                width: parent.width
                viewportWidth: width

                ECol {
                    md: 8
                    sm: 12
                    xs: 24
                    height: 60

                    ERectangle {
                        radius: 8
                        color: "#409eff"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.ResponsiveLabel
                        }
                    }
                }
                ECol {
                    md: 8
                    sm: 12
                    xs: 24
                    height: 60

                    ERectangle {
                        radius: 8
                        color: "#67c23a"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.ResponsiveLabel
                        }
                    }
                }
                ECol {
                    md: 8
                    sm: 12
                    xs: 24
                    height: 60

                    ERectangle {
                        radius: 8
                        color: "#f56c6c"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.ResponsiveLabel
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpace"

        ExampleCase {
            objectName: "showcaseESpace0"
            title: ELocale.texts.VerticalSpacing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESpace {
                    size: 20
                    alignment: "start"
                    direction: "vertical"
                    width: Math.min(480, parent.width)

                    EButton {
                        text: ELocale.texts.Design
                    }
                    EButton {
                        text: ELocale.texts.Engineering
                    }
                    EButton {
                        text: ELocale.texts.Publish
                    }
                }
            `)

            ESpace {
                size: 20
                alignment: "start"
                direction: "vertical"
                width: Math.min(480, parent.width)

                EButton {
                    text: ELocale.texts.Design
                }
                EButton {
                    text: ELocale.texts.Engineering
                }
                EButton {
                    text: ELocale.texts.Publish
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpace"

        ExampleCase {
            objectName: "showcaseESpace1"
            title: ELocale.texts.WrappingAndSeparators
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESpace {
                    wrap: true
                    spacer: "·"
                    size: [12, 20]
                    width: Math.min(360, parent.width)

                    ETag {
                        text: "QML"
                    }
                    ETag {
                        text: "Qt Quick"
                    }
                    ETag {
                        text: "C++"
                    }
                    ETag {
                        text: ELocale.texts.Design
                    }
                    ETag {
                        text: "Windows"
                    }
                    ETag {
                        text: "macOS"
                    }
                }
            `)

            ESpace {
                wrap: true
                spacer: "·"
                size: [12, 20]
                width: Math.min(360, parent.width)

                ETag {
                    text: "QML"
                }
                ETag {
                    text: "Qt Quick"
                }
                ETag {
                    text: "C++"
                }
                ETag {
                    text: ELocale.texts.Design
                }
                ETag {
                    text: "Windows"
                }
                ETag {
                    text: "macOS"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpace"

        ExampleCase {
            objectName: "showcaseESpace2"
            title: ELocale.texts.EqualWidthSpace
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESpace {
                    size: 12
                    fill: true
                    fillRatio: 100
                    width: Math.min(480, parent.width)

                    EButton {
                        text: ELocale.texts.Design
                    }
                    EButton {
                        text: ELocale.texts.Engineering
                    }
                    EButton {
                        text: ELocale.texts.Publish
                    }
                }
            `)

            ESpace {
                size: 12
                fill: true
                fillRatio: 100
                width: Math.min(480, parent.width)

                EButton {
                    text: ELocale.texts.Design
                }
                EButton {
                    text: ELocale.texts.Engineering
                }
                EButton {
                    text: ELocale.texts.Publish
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAppBar"

        ExampleCase {
            objectName: "showcaseEAppBar0"
            title: ELocale.texts.TitleIcon
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAppBar {
                    showClose: false
                    showMaximize: false
                    showMinimize: false
                    width: parent.width
                    iconSource: EIcons.PALETTE
                    title: ELocale.texts.EUIWorkspace
                }
            `)

            EAppBar {
                showClose: false
                showMaximize: false
                showMinimize: false
                width: parent.width
                iconSource: EIcons.PALETTE
                title: ELocale.texts.EUIWorkspace
            }
        }
    }
    ExampleSection {
        componentName: "EAppBar"

        ExampleCase {
            objectName: "showcaseEAppBar1"
            title: ELocale.texts.AppBarColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAppBar {
                    showClose: false
                    showMaximize: false
                    showMinimize: false
                    width: parent.width
                    textColor: "#E7F0FF"
                    backgroundColor: "#173958"
                    title: ELocale.texts.EUIWorkspace
                }
            `)

            EAppBar {
                showClose: false
                showMaximize: false
                showMinimize: false
                width: parent.width
                textColor: "#E7F0FF"
                backgroundColor: "#173958"
                title: ELocale.texts.EUIWorkspace
            }
        }
    }
    ExampleSection {
        componentName: "EAppBar"

        ExampleCase {
            objectName: "showcaseEAppBar2"
            title: ELocale.texts.AppBarActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAppBar {
                    showClose: false
                    showMaximize: false
                    showMinimize: false
                    width: parent.width
                    title: ELocale.texts.EUIWorkspace

                    ETextButton {
                        text: ELocale.texts.Help
                    }
                }
            `)

            EAppBar {
                showClose: false
                showMaximize: false
                showMinimize: false
                width: parent.width
                title: ELocale.texts.EUIWorkspace

                ETextButton {
                    text: ELocale.texts.Help
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAppBar"

        ExampleCase {
            objectName: "showcaseEAppBar3"
            title: ELocale.texts.AppBarTruncation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAppBar {
                    showClose: false
                    showMaximize: false
                    showMinimize: false
                    width: parent.width
                    title: ELocale.texts.EUIDesignSystemAProjectNameThatShould
                }
            `)

            EAppBar {
                showClose: false
                showMaximize: false
                showMinimize: false
                width: parent.width
                title: ELocale.texts.EUIDesignSystemAProjectNameThatShould
            }
        }
    }
    ExampleSection {
        componentName: "ESplitter"

        ExampleCase {
            objectName: "showcaseESplitter0"
            title: ELocale.texts.VerticalSplitter
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 200
                    width: parent.width
                    orientation: Qt.Vertical

                    ESplitterPanel {
                        size: "40%"

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            `)

            ESplitter {
                height: 200
                width: parent.width
                orientation: Qt.Vertical

                ESplitterPanel {
                    size: "40%"

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Resources
                    }
                }
                ESplitterPanel {
                    min: 80

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Workspace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitter"

        ExampleCase {
            objectName: "showcaseESplitter1"
            title: ELocale.texts.PanelConstraints
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 200
                    width: parent.width

                    ESplitterPanel {
                        min: 100
                        max: "70%"
                        size: "35%"

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            `)

            ESplitter {
                height: 200
                width: parent.width

                ESplitterPanel {
                    min: 100
                    max: "70%"
                    size: "35%"

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Resources
                    }
                }
                ESplitterPanel {
                    min: 80

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Workspace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitter"

        ExampleCase {
            objectName: "showcaseESplitter2"
            title: ELocale.texts.PanelCollapse
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.CollapseRestore

                        onClicked: firstPanel.setCollapsed(!firstPanel.collapsed)
                    }
                    ESplitter {
                        height: 200
                        width: parent.width

                        ESplitterPanel {
                            id: firstPanel

                            size: "35%"
                            collapsible: true

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Resources
                            }
                        }
                        ESplitterPanel {
                            min: 80

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Workspace
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.CollapseRestore

                    onClicked: firstPanel.setCollapsed(!firstPanel.collapsed)
                }
                ESplitter {
                    height: 200
                    width: parent.width

                    ESplitterPanel {
                        id: firstPanel

                        size: "35%"
                        collapsible: true

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EScrollbar"

        ExampleCase {
            objectName: "showcaseEScrollbar0"
            title: ELocale.texts.PersistentScrollbar
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EScrollbar {
                        id: scroll

                        height: 200
                        always: true
                        contentHeight: 600
                        contentWidth: width
                        width: Math.min(480, parent.width)

                        EText {
                            height: 600
                            text: ELocale.texts.ScrollableContentSample
                        }
                    }
                    EButton {
                        text: ELocale.texts.ScrollToTheEnd

                        onClicked: scroll.setScrollTop(400)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EScrollbar {
                    id: scroll

                    height: 200
                    always: true
                    contentHeight: 600
                    contentWidth: width
                    width: Math.min(480, parent.width)

                    EText {
                        height: 600
                        text: ELocale.texts.ScrollableContentSample
                    }
                }
                EButton {
                    text: ELocale.texts.ScrollToTheEnd

                    onClicked: scroll.setScrollTop(400)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EScrollbar"

        ExampleCase {
            objectName: "showcaseEScrollbar1"
            title: ELocale.texts.HorizontalScrolling
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EScrollbar {
                    mask: true
                    height: 140
                    maskSize: 32
                    contentWidth: 900
                    contentHeight: 100
                    width: Math.min(480, parent.width)

                    EText {
                        width: 900
                        font.pixelSize: 24
                        text: ELocale.texts.DesignDevelopDeploy
                    }
                }
            `)

            EScrollbar {
                mask: true
                height: 140
                maskSize: 32
                contentWidth: 900
                contentHeight: 100
                width: Math.min(480, parent.width)

                EText {
                    width: 900
                    font.pixelSize: 24
                    text: ELocale.texts.DesignDevelopDeploy
                }
            }
        }
    }
    ExampleSection {
        componentName: "EScrollbar"

        ExampleCase {
            objectName: "showcaseEScrollbar2"
            title: ELocale.texts.ScrollPosition
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EScrollbar {
                        id: scroll

                        height: 180
                        contentHeight: 500
                        contentWidth: width
                        width: Math.min(480, parent.width)

                        EText {
                            height: 500
                            text: ELocale.texts.ScrollToSeeTheCurrentPosition
                        }
                    }
                    EText {
                        text: ELocale.texts.ScrollPosition2 + Math.round(scroll.scrollTop)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EScrollbar {
                    id: scroll

                    height: 180
                    contentHeight: 500
                    contentWidth: width
                    width: Math.min(480, parent.width)

                    EText {
                        height: 500
                        text: ELocale.texts.ScrollToSeeTheCurrentPosition
                    }
                }
                EText {
                    text: ELocale.texts.ScrollPosition2 + Math.round(scroll.scrollTop)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EContainer"

        ExampleCase {
            objectName: "showcaseEContainer0"
            title: ELocale.texts.HeaderAndMain
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EContainer {
                    height: 200
                    width: parent.width

                    EHeader {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.WorkspaceHeader
                        }
                    }
                    EMain {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.MainContentArea
                        }
                    }
                }
            `)

            EContainer {
                height: 200
                width: parent.width

                EHeader {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.WorkspaceHeader
                    }
                }
                EMain {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.MainContentArea
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EContainer"

        ExampleCase {
            objectName: "showcaseEContainer1"
            title: ELocale.texts.AsideAndMain
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EContainer {
                    height: 200
                    width: parent.width

                    EAside {
                        implicitWidth: 120

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ResourceDirectory
                        }
                    }
                    EMain {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ProjectContent
                        }
                    }
                }
            `)

            EContainer {
                height: 200
                width: parent.width

                EAside {
                    implicitWidth: 120

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ResourceDirectory
                    }
                }
                EMain {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ProjectContent
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EContainer"

        ExampleCase {
            objectName: "showcaseEContainer2"
            title: ELocale.texts.MainAndFooter
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EContainer {
                    height: 200
                    width: parent.width

                    EMain {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.MainWorkspace
                        }
                    }
                    EFooter {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.StatusBar
                        }
                    }
                }
            `)

            EContainer {
                height: 200
                width: parent.width

                EMain {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.MainWorkspace
                    }
                }
                EFooter {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.StatusBar
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EContainer"

        ExampleCase {
            objectName: "showcaseEContainer3"
            title: ELocale.texts.NestedWorkspace
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EContainer {
                    height: 200
                    width: parent.width

                    EHeader {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ProjectName
                        }
                    }
                    EContainer {
                        direction: "horizontal"

                        EAside {
                            implicitWidth: 120

                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.Directory
                            }
                        }
                        EMain {
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.Canvas
                            }
                        }
                    }
                    EFooter {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.Saved2
                        }
                    }
                }
            `)

            EContainer {
                height: 200
                width: parent.width

                EHeader {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ProjectName
                    }
                }
                EContainer {
                    direction: "horizontal"

                    EAside {
                        implicitWidth: 120

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.Directory
                        }
                    }
                    EMain {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.Canvas
                        }
                    }
                }
                EFooter {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.Saved2
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETypography"

        ExampleCase {
            objectName: "showcaseETypography0"
            title: ELocale.texts.HeadingHierarchy
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETypography {
                        level: 1
                        text: ELocale.texts.Title
                    }
                    ETypography {
                        level: 2
                        text: ELocale.texts.Title
                    }
                    ETypography {
                        level: 3
                        text: ELocale.texts.Title
                    }
                    ETypography {
                        level: 4
                        text: ELocale.texts.Title
                    }
                    ETypography {
                        level: 5
                        text: ELocale.texts.Title
                    }
                    ETypography {
                        level: 6
                        text: ELocale.texts.Title
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETypography {
                    level: 1
                    text: ELocale.texts.Title
                }
                ETypography {
                    level: 2
                    text: ELocale.texts.Title
                }
                ETypography {
                    level: 3
                    text: ELocale.texts.Title
                }
                ETypography {
                    level: 4
                    text: ELocale.texts.Title
                }
                ETypography {
                    level: 5
                    text: ELocale.texts.Title
                }
                ETypography {
                    level: 6
                    text: ELocale.texts.Title
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETypography"

        ExampleCase {
            objectName: "showcaseETypography1"
            title: ELocale.texts.ParagraphSpacing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETypography {
                    level: 0
                    lineHeight: 1.65
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.GiveComponentsAClearReadingHierarchyComfortableLine
                }
            `)

            ETypography {
                level: 0
                lineHeight: 1.65
                width: Math.min(480, parent.width)
                text: ELocale.texts.GiveComponentsAClearReadingHierarchyComfortableLine
            }
        }
    }
    ExampleSection {
        componentName: "ETypography"

        ExampleCase {
            objectName: "showcaseETypography2"
            title: ELocale.texts.HeadingAndCaption
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ETypography {
                        level: 3
                        text: ELocale.texts.ProjectDetails
                    }
                    ETypography {
                        width: Math.min(480, parent.width)
                        text: ELocale.texts.UpdatedTodayStatusPublished
                        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ETypography {
                    level: 3
                    text: ELocale.texts.ProjectDetails
                }
                ETypography {
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.UpdatedTodayStatusPublished
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETypography"

        ExampleCase {
            objectName: "showcaseETypography3"
            title: ELocale.texts.MixedLanguageHeading
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETypography {
                    level: 2
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.EUIDesignSystemCrossPlatformComponentPlayground
                }
            `)

            ETypography {
                level: 2
                width: Math.min(480, parent.width)
                text: ELocale.texts.EUIDesignSystemCrossPlatformComponentPlayground
            }
        }
    }
    ExampleSection {
        componentName: "ESplitterPanel"

        ExampleCase {
            objectName: "showcaseESplitterPanel0"
            title: ELocale.texts.VerticalSplitter
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 200
                    width: parent.width
                    orientation: Qt.Vertical

                    ESplitterPanel {
                        size: "40%"

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            `)

            ESplitter {
                height: 200
                width: parent.width
                orientation: Qt.Vertical

                ESplitterPanel {
                    size: "40%"

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Resources
                    }
                }
                ESplitterPanel {
                    min: 80

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Workspace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitterPanel"

        ExampleCase {
            objectName: "showcaseESplitterPanel1"
            title: ELocale.texts.PanelConstraints
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 200
                    width: parent.width

                    ESplitterPanel {
                        min: 100
                        max: "70%"
                        size: "35%"

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            `)

            ESplitter {
                height: 200
                width: parent.width

                ESplitterPanel {
                    min: 100
                    max: "70%"
                    size: "35%"

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Resources
                    }
                }
                ESplitterPanel {
                    min: 80

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.Workspace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitterPanel"

        ExampleCase {
            title: ELocale.texts.PanelCollapse
            objectName: "showcaseESplitterPanel2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.CollapseRestore

                        onClicked: firstPanel.setCollapsed(!firstPanel.collapsed)
                    }
                    ESplitter {
                        height: 200
                        width: parent.width

                        ESplitterPanel {
                            id: firstPanel

                            size: "35%"
                            collapsible: true

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Resources
                            }
                        }
                        ESplitterPanel {
                            min: 80

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Workspace
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.CollapseRestore

                    onClicked: firstPanel.setCollapsed(!firstPanel.collapsed)
                }
                ESplitter {
                    height: 200
                    width: parent.width

                    ESplitterPanel {
                        id: firstPanel

                        size: "35%"
                        collapsible: true

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitterPanel"

        ExampleCase {
            title: ELocale.texts.FixedPanel
            objectName: "showcaseESplitterPanel3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 180
                    width: parent.width

                    ESplitterPanel {
                        size: 160
                        resizable: false

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.FixedResourceSidebar
                        }
                    }
                    ESplitterPanel {
                        min: 80

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.AdaptiveWorkspace
                        }
                    }
                }
            `)

            ESplitter {
                height: 180
                width: parent.width

                ESplitterPanel {
                    size: 160
                    resizable: false

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.FixedResourceSidebar
                    }
                }
                ESplitterPanel {
                    min: 80

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.AdaptiveWorkspace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStaggeredLayout"

        ExampleCase {
            title: ELocale.texts.TwoColumns
            objectName: "showcaseEStaggeredLayout0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStaggeredLayout {
                    columns: 2
                    spacing: 12
                    width: parent.width

                    Repeater {
                        model: [80, 120, 100, 64, 110, 90]

                        ERectangle {
                            radius: 12
                            height: modelData
                            color: index % 2 ? "#67c23a" : "#409eff"

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.PanelNumber.arg(index + 1)
                            }
                        }
                    }
                }
            `)

            EStaggeredLayout {
                columns: 2
                spacing: 12
                width: parent.width

                Repeater {
                    model: [80, 120, 100, 64, 110, 90]

                    ERectangle {
                        radius: 12
                        height: modelData
                        color: index % 2 ? "#67c23a" : "#409eff"

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.PanelNumber.arg(index + 1)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStaggeredLayout"

        ExampleCase {
            title: ELocale.texts.CompactMasonry
            objectName: "showcaseEStaggeredLayout1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStaggeredLayout {
                    columns: 3
                    spacing: 8
                    width: parent.width

                    Repeater {
                        model: [80, 120, 100, 64, 110, 90]

                        ERectangle {
                            radius: 12
                            height: modelData
                            color: index % 2 ? "#67c23a" : "#409eff"

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.PanelNumber.arg(index + 1)
                            }
                        }
                    }
                }
            `)

            EStaggeredLayout {
                columns: 3
                spacing: 8
                width: parent.width

                Repeater {
                    model: [80, 120, 100, 64, 110, 90]

                    ERectangle {
                        radius: 12
                        height: modelData
                        color: index % 2 ? "#67c23a" : "#409eff"

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.PanelNumber.arg(index + 1)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStaggeredLayout"

        ExampleCase {
            title: ELocale.texts.ResponsiveColumns
            objectName: "showcaseEStaggeredLayout2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStaggeredLayout {
                    spacing: 16
                    width: parent.width
                    columns: width < 500 ? 2 : 4

                    Repeater {
                        model: [80, 120, 100, 64, 110, 90]

                        ERectangle {
                            radius: 12
                            height: modelData
                            color: index % 2 ? "#67c23a" : "#409eff"

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.PanelNumber.arg(index + 1)
                            }
                        }
                    }
                }
            `)

            EStaggeredLayout {
                spacing: 16
                width: parent.width
                columns: width < 500 ? 2 : 4

                Repeater {
                    model: [80, 120, 100, 64, 110, 90]

                    ERectangle {
                        radius: 12
                        height: modelData
                        color: index % 2 ? "#67c23a" : "#409eff"

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.PanelNumber.arg(index + 1)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStaggeredLayout"

        ExampleCase {
            title: ELocale.texts.SingleColumn
            objectName: "showcaseEStaggeredLayout3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStaggeredLayout {
                    columns: 1
                    spacing: 20
                    width: parent.width

                    Repeater {
                        model: [80, 120, 100, 64, 110, 90]

                        ERectangle {
                            radius: 12
                            height: modelData
                            color: index % 2 ? "#67c23a" : "#409eff"

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: ELocale.texts.PanelNumber.arg(index + 1)
                            }
                        }
                    }
                }
            `)

            EStaggeredLayout {
                columns: 1
                spacing: 20
                width: parent.width

                Repeater {
                    model: [80, 120, 100, 64, 110, 90]

                    ERectangle {
                        radius: 12
                        height: modelData
                        color: index % 2 ? "#67c23a" : "#409eff"

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.PanelNumber.arg(index + 1)
                        }
                    }
                }
            }
        }
    }
}
