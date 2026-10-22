import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "ETag"

        ExampleCase {
            objectName: "showcaseETag0"
            title: ELocale.texts.SemanticFeedback
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETag {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Status
                    }
                    ETag {
                        styleType: EStyle.Success
                        text: ELocale.texts.Status
                    }
                    ETag {
                        styleType: EStyle.Warning
                        text: ELocale.texts.Status
                    }
                    ETag {
                        styleType: EStyle.Danger
                        text: ELocale.texts.Status
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETag {
                    styleType: EStyle.Primary
                    text: ELocale.texts.Status
                }
                ETag {
                    styleType: EStyle.Success
                    text: ELocale.texts.Status
                }
                ETag {
                    styleType: EStyle.Warning
                    text: ELocale.texts.Status
                }
                ETag {
                    styleType: EStyle.Danger
                    text: ELocale.texts.Status
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETag"

        ExampleCase {
            objectName: "showcaseETag1"
            title: ELocale.texts.Effects
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETag {
                        effect: "light"
                        text: ELocale.texts.Status
                    }
                    ETag {
                        effect: "dark"
                        text: ELocale.texts.Status
                    }
                    ETag {
                        effect: "plain"
                        text: ELocale.texts.Status
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETag {
                    effect: "light"
                    text: ELocale.texts.Status
                }
                ETag {
                    effect: "dark"
                    text: ELocale.texts.Status
                }
                ETag {
                    effect: "plain"
                    text: ELocale.texts.Status
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETag"

        ExampleCase {
            objectName: "showcaseETag2"
            title: ELocale.texts.InteractiveTags
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETag {
                        closable: true
                        text: ELocale.texts.Closable
                    }
                    ETag {
                        checkable: true
                        text: ELocale.texts.Selectable
                    }
                    ETag {
                        round: true
                        text: ELocale.texts.Round
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETag {
                    closable: true
                    text: ELocale.texts.Closable
                }
                ETag {
                    checkable: true
                    text: ELocale.texts.Selectable
                }
                ETag {
                    round: true
                    text: ELocale.texts.Round
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECard"

        ExampleCase {
            objectName: "showcaseECard0"
            title: ELocale.texts.HeaderAndFooter
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECard {
                    footer: ELocale.texts.UpdatedToday
                    width: Math.min(480, parent.width)
                    header: ELocale.texts.ProjectDetails

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.CardsCanContainATitleBodyAndFooter
                    }
                }
            `)

            ECard {
                footer: ELocale.texts.UpdatedToday
                width: Math.min(480, parent.width)
                header: ELocale.texts.ProjectDetails

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.CardsCanContainATitleBodyAndFooter
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECard"

        ExampleCase {
            objectName: "showcaseECard1"
            title: ELocale.texts.CardShadows
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECard {
                        shadow: "always"
                        header: ELocale.texts.Project
                        width: Math.min(220, parent.width)
                    }
                    ECard {
                        shadow: "hover"
                        header: ELocale.texts.Project
                        width: Math.min(220, parent.width)
                    }
                    ECard {
                        shadow: "never"
                        header: ELocale.texts.Project
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECard {
                    shadow: "always"
                    header: ELocale.texts.Project
                    width: Math.min(220, parent.width)
                }
                ECard {
                    shadow: "hover"
                    header: ELocale.texts.Project
                    width: Math.min(220, parent.width)
                }
                ECard {
                    shadow: "never"
                    header: ELocale.texts.Project
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECard"

        ExampleCase {
            objectName: "showcaseECard2"
            title: ELocale.texts.CustomCardHeader
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECard {
                    width: Math.min(480, parent.width)
                    headerDelegate: Component {
                        Row {
                            spacing: 12

                            EText {
                                font.bold: true
                                text: ELocale.texts.TaskList
                            }
                            EButton {
                                size: EStyle.Small
                                text: ELocale.texts.Add
                            }
                        }
                    }

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheHeaderCanContainFiltersActionsAndStatus
                    }
                }
            `)

            ECard {
                width: Math.min(480, parent.width)
                headerDelegate: Component {
                    Row {
                        spacing: 12

                        EText {
                            font.bold: true
                            text: ELocale.texts.TaskList
                        }
                        EButton {
                            size: EStyle.Small
                            text: ELocale.texts.Add
                        }
                    }
                }

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheHeaderCanContainFiltersActionsAndStatus
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBadge"

        ExampleCase {
            objectName: "showcaseEBadge0"
            title: ELocale.texts.CountLimits
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EBadge {
                        max: 99
                        value: 0

                        EButton {
                            text: ELocale.texts.Messages
                        }
                    }
                    EBadge {
                        max: 99
                        value: 8

                        EButton {
                            text: ELocale.texts.Messages
                        }
                    }
                    EBadge {
                        max: 99
                        value: 120

                        EButton {
                            text: ELocale.texts.Messages
                        }
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EBadge {
                    max: 99
                    value: 0

                    EButton {
                        text: ELocale.texts.Messages
                    }
                }
                EBadge {
                    max: 99
                    value: 8

                    EButton {
                        text: ELocale.texts.Messages
                    }
                }
                EBadge {
                    max: 99
                    value: 120

                    EButton {
                        text: ELocale.texts.Messages
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBadge"

        ExampleCase {
            objectName: "showcaseEBadge1"
            title: ELocale.texts.DotsAndText
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EBadge {
                        isDot: true
                        color: "#67c23a"
                        offset: Qt.point(4, -4)

                        EAvatar {
                            text: "UI"
                        }
                    }
                    EBadge {
                        value: "NEW"
                        styleType: EStyle.Warning

                        EButton {
                            text: ELocale.texts.Version
                        }
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EBadge {
                    isDot: true
                    color: "#67c23a"
                    offset: Qt.point(4, -4)

                    EAvatar {
                        text: "UI"
                    }
                }
                EBadge {
                    value: "NEW"
                    styleType: EStyle.Warning

                    EButton {
                        text: ELocale.texts.Version
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBadge"

        ExampleCase {
            objectName: "showcaseEBadge2"
            title: ELocale.texts.BadgeVisibility
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: hide

                        text: ELocale.texts.HideBadge
                    }
                    EBadge {
                        value: 12
                        hidden: hide.checked

                        EButton {
                            text: ELocale.texts.Notifications
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: hide

                    text: ELocale.texts.HideBadge
                }
                EBadge {
                    value: 12
                    hidden: hide.checked

                    EButton {
                        text: ELocale.texts.Notifications
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"

        ExampleCase {
            objectName: "showcaseETable0"
            title: ELocale.texts.CompactSummaryTable
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETable {
                    stripe: true
                    rowHeight: 32
                    headerHeight: 36
                    showSummary: true
                    width: parent.width
                    columns: [{prop: "name", label: ELocale.texts.Project, width: 180}, {prop: "version", label: ELocale.texts.Version, width: 120}, {prop: "score", label: ELocale.texts.Score2, sortable: true}]
                    model: [{id: 1, name: ELocale.texts.Desktop, version: "1.0", score: 92}, {id: 2, name: ELocale.texts.Web, version: "2.0", score: 86}, {id: 3, name: ELocale.texts.Mobile, version: "1.5", score: 78}]
                }
            `)

            ETable {
                stripe: true
                rowHeight: 32
                headerHeight: 36
                showSummary: true
                width: parent.width
                columns: [{prop: "name", label: ELocale.texts.Project, width: 180}, {prop: "version", label: ELocale.texts.Version, width: 120}, {prop: "score", label: ELocale.texts.Score2, sortable: true}]
                model: [{id: 1, name: ELocale.texts.Desktop, version: "1.0", score: 92}, {id: 2, name: ELocale.texts.Web, version: "2.0", score: 86}, {id: 3, name: ELocale.texts.Mobile, version: "1.5", score: 78}]
            }
        }
    }
    ExampleSection {
        componentName: "ETable"

        ExampleCase {
            objectName: "showcaseETable1"
            title: ELocale.texts.ColumnsAndCurrentRow
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETable {
                    border: true
                    currentRowIndex: 1
                    width: parent.width
                    showColumnSettings: true
                    highlightCurrentRow: true
                    columns: [{prop: "name", label: ELocale.texts.Project, width: 180}, {prop: "version", label: ELocale.texts.Version, width: 120}, {prop: "score", label: ELocale.texts.Score2, sortable: true}]
                    model: [{id: 1, name: ELocale.texts.Desktop, version: "1.0", score: 92}, {id: 2, name: ELocale.texts.Web, version: "2.0", score: 86}, {id: 3, name: ELocale.texts.Mobile, version: "1.5", score: 78}]
                }
            `)

            ETable {
                border: true
                currentRowIndex: 1
                width: parent.width
                showColumnSettings: true
                highlightCurrentRow: true
                columns: [{prop: "name", label: ELocale.texts.Project, width: 180}, {prop: "version", label: ELocale.texts.Version, width: 120}, {prop: "score", label: ELocale.texts.Score2, sortable: true}]
                model: [{id: 1, name: ELocale.texts.Desktop, version: "1.0", score: 92}, {id: 2, name: ELocale.texts.Web, version: "2.0", score: 86}, {id: 3, name: ELocale.texts.Mobile, version: "1.5", score: 78}]
            }
        }
    }
    ExampleSection {
        componentName: "ETree"

        ExampleCase {
            objectName: "showcaseETree0"
            title: ELocale.texts.IndependentTreeChecks
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETree {
                    nodeKey: "id"
                    showCheckbox: true
                    checkStrictly: true
                    checkedKeys: ["icon"]
                    defaultExpandAll: true
                    width: Math.min(480, parent.width)
                    model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ETree {
                nodeKey: "id"
                showCheckbox: true
                checkStrictly: true
                checkedKeys: ["icon"]
                defaultExpandAll: true
                width: Math.min(480, parent.width)
                model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ETree"

        ExampleCase {
            objectName: "showcaseETree1"
            title: ELocale.texts.TreeFiltering
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: query

                        clearable: true
                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.FilterNodes2
                    }
                    ETree {
                        nodeKey: "id"
                        defaultExpandAll: true
                        filterValue: query.text
                        width: Math.min(480, parent.width)
                        model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: query

                    clearable: true
                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.FilterNodes2
                }
                ETree {
                    nodeKey: "id"
                    defaultExpandAll: true
                    filterValue: query.text
                    width: Math.min(480, parent.width)
                    model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETree"

        ExampleCase {
            objectName: "showcaseETree2"
            title: ELocale.texts.AccordionTree
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETree {
                    nodeKey: "id"
                    accordion: true
                    currentKey: "icon"
                    highlightCurrent: true
                    expandedKeys: ["design"]
                    width: Math.min(480, parent.width)
                    model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ETree {
                nodeKey: "id"
                accordion: true
                currentKey: "icon"
                highlightCurrent: true
                expandedKeys: ["design"]
                width: Math.min(480, parent.width)
                model: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "EEmpty"

        ExampleCase {
            objectName: "showcaseEEmpty0"
            title: ELocale.texts.EmptyAction
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EEmpty {
                    width: Math.min(480, parent.width)
                    description: ELocale.texts.NoProjectsYet2

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.CreateProject
                    }
                }
            `)

            EEmpty {
                width: Math.min(480, parent.width)
                description: ELocale.texts.NoProjectsYet2

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.CreateProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EEmpty"

        ExampleCase {
            objectName: "showcaseEEmpty1"
            title: ELocale.texts.EmptyIllustration
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EEmpty {
                    imageSize: 64
                    width: Math.min(480, parent.width)
                    description: ELocale.texts.NoSearchResults
                    imageDelegate: Component {
                        EIcon {
                            iconSize: 64
                            color: "#409EFF"
                            iconSource: EIcons.MAGNIFIER
                        }
                    }
                }
            `)

            EEmpty {
                imageSize: 64
                width: Math.min(480, parent.width)
                description: ELocale.texts.NoSearchResults
                imageDelegate: Component {
                    EIcon {
                        iconSize: 64
                        color: "#409EFF"
                        iconSource: EIcons.MAGNIFIER
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EEmpty"

        ExampleCase {
            objectName: "showcaseEEmpty2"
            title: ELocale.texts.CompactEmptyState
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EEmpty {
                    width: 240
                    imageSize: 48
                    description: ELocale.texts.NoRecords
                }
            `)

            EEmpty {
                width: 240
                imageSize: 48
                description: ELocale.texts.NoRecords
            }
        }
    }
    ExampleSection {
        componentName: "EAvatar"

        ExampleCase {
            objectName: "showcaseEAvatar0"
            title: ELocale.texts.AvatarSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAvatar {
                        size: 32
                        text: "UI"
                        backgroundColor: "#409eff"
                    }
                    EAvatar {
                        size: 48
                        text: "UI"
                        backgroundColor: "#409eff"
                    }
                    EAvatar {
                        size: 64
                        text: "UI"
                        backgroundColor: "#409eff"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAvatar {
                    size: 32
                    text: "UI"
                    backgroundColor: "#409eff"
                }
                EAvatar {
                    size: 48
                    text: "UI"
                    backgroundColor: "#409eff"
                }
                EAvatar {
                    size: 64
                    text: "UI"
                    backgroundColor: "#409eff"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatar"

        ExampleCase {
            objectName: "showcaseEAvatar1"
            title: ELocale.texts.AvatarContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAvatar {
                        size: 56
                        text: "Qt"
                        shape: "square"
                    }
                    EAvatar {
                        size: 56
                        iconSource: EIcons.HOUSE
                    }
                    EAvatar {
                        size: 56
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAvatar {
                    size: 56
                    text: "Qt"
                    shape: "square"
                }
                EAvatar {
                    size: 56
                    iconSource: EIcons.HOUSE
                }
                EAvatar {
                    size: 56
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatar"

        ExampleCase {
            objectName: "showcaseEAvatar2"
            title: ELocale.texts.AvatarFallback
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatar {
                    size: 64
                    alt: "UI"
                    text: "UI"
                }
            `)

            EAvatar {
                size: 64
                alt: "UI"
                text: "UI"
            }
        }
    }
    ExampleSection {
        componentName: "ESkeleton"

        ExampleCase {
            objectName: "showcaseESkeleton0"
            title: ELocale.texts.LoadingTransition
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: loading

                        checked: true
                        text: ELocale.texts.Loading
                    }
                    ESkeleton {
                        rows: 3
                        animated: true
                        loading: loading.checked
                        width: Math.min(480, parent.width)

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ShowTheActualContentWhenLoadingFinishes
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: loading

                    checked: true
                    text: ELocale.texts.Loading
                }
                ESkeleton {
                    rows: 3
                    animated: true
                    loading: loading.checked
                    width: Math.min(480, parent.width)

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ShowTheActualContentWhenLoadingFinishes
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeleton"

        ExampleCase {
            objectName: "showcaseESkeleton1"
            title: ELocale.texts.MultipleSkeletons
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESkeleton {
                    rows: 2
                    count: 3
                    throttle: 200
                    width: Math.min(480, parent.width)
                }
            `)

            ESkeleton {
                rows: 2
                count: 3
                throttle: 200
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ESkeleton"

        ExampleCase {
            objectName: "showcaseESkeleton2"
            title: ELocale.texts.SkeletonTemplate
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESkeleton {
                    animated: false
                    width: Math.min(480, parent.width)
                    templateDelegate: Component {
                        Column {
                            spacing: 12
                            width: parent.width

                            ESkeletonItem {
                                width: 64
                                height: 64
                                variant: "circle"
                            }
                            ESkeletonItem {
                                height: 20
                                width: parent.width
                            }
                        }
                    }
                }
            `)

            ESkeleton {
                animated: false
                width: Math.min(480, parent.width)
                templateDelegate: Component {
                    Column {
                        spacing: 12
                        width: parent.width

                        ESkeletonItem {
                            width: 64
                            height: 64
                            variant: "circle"
                        }
                        ESkeletonItem {
                            height: 20
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPagination"

        ExampleCase {
            objectName: "showcaseEPagination0"
            title: ELocale.texts.FullPagination
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EPagination {
                    total: 240
                    pageSize: 20
                    width: parent.width
                    buttonBackground: true
                    pageSizes: [10, 20, 50]
                    layout: width < 760 ? "sizes, prev, pager, next"
                        : "total, sizes, prev, pager, next, jumper"
                }
            `)

            EPagination {
                total: 240
                pageSize: 20
                width: parent.width
                buttonBackground: true
                pageSizes: [10, 20, 50]
                layout: width < 760 ? "sizes, prev, pager, next"
                    : "total, sizes, prev, pager, next, jumper"
            }
        }
    }
    ExampleSection {
        componentName: "EPagination"

        ExampleCase {
            objectName: "showcaseEPagination1"
            title: ELocale.texts.CompactPagination
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EPagination {
                        total: 80
                        pageSize: 10
                        pagerCount: 5
                        size: EStyle.Small
                    }
                    EPagination {
                        total: 5
                        hideOnSinglePage: true
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EPagination {
                    total: 80
                    pageSize: 10
                    pagerCount: 5
                    size: EStyle.Small
                }
                EPagination {
                    total: 5
                    hideOnSinglePage: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPagination"

        ExampleCase {
            objectName: "showcaseEPagination2"
            title: ELocale.texts.PaginationState
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EPagination {
                        id: pages

                        total: 360
                        pageSize: 20
                        currentPage: 3
                        showTotal: true
                    }
                    EText {
                        text: ELocale.texts.CurrentPageAndSize.arg(pages.currentPage).arg(pages.pageSize)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EPagination {
                    id: pages

                    total: 360
                    pageSize: 20
                    currentPage: 3
                    showTotal: true
                }
                EText {
                    text: ELocale.texts.CurrentPageAndSize.arg(pages.currentPage).arg(pages.pageSize)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatarGroup"

        ExampleCase {
            objectName: "showcaseEAvatarGroup0"
            title: ELocale.texts.CollapsedAvatars
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatarGroup {
                    size: 48
                    overlap: 14
                    collapseAvatars: true
                    maxCollapseAvatars: 3

                    EAvatar {
                        text: "A"
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        text: "B"
                        source: "qrc:/example/images/gallery/avatar-02.jpg"
                    }
                    EAvatar {
                        text: "C"
                        source: "qrc:/example/images/gallery/avatar-03.jpg"
                    }
                    EAvatar {
                        text: "D"
                        source: "qrc:/example/images/gallery/avatar-04.jpg"
                    }
                    EAvatar {
                        text: "E"
                        source: "qrc:/example/images/gallery/avatar-05.jpg"
                    }
                }
            `)

            EAvatarGroup {
                size: 48
                overlap: 14
                collapseAvatars: true
                maxCollapseAvatars: 3

                EAvatar {
                    text: "A"
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    text: "B"
                    source: "qrc:/example/images/gallery/avatar-02.jpg"
                }
                EAvatar {
                    text: "C"
                    source: "qrc:/example/images/gallery/avatar-03.jpg"
                }
                EAvatar {
                    text: "D"
                    source: "qrc:/example/images/gallery/avatar-04.jpg"
                }
                EAvatar {
                    text: "E"
                    source: "qrc:/example/images/gallery/avatar-05.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatarGroup"

        ExampleCase {
            title: ELocale.texts.SquareAvatars
            objectName: "showcaseEAvatarGroup1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatarGroup {
                    size: 40
                    overlap: 8
                    shape: "square"
                    collapseAvatars: false

                    EAvatar {
                        text: "Qt"
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        text: "UI"
                        source: "qrc:/example/images/gallery/avatar-02.jpg"
                    }
                    EAvatar {
                        text: "C++"
                        source: "qrc:/example/images/gallery/avatar-03.jpg"
                    }
                }
            `)

            EAvatarGroup {
                size: 40
                overlap: 8
                shape: "square"
                collapseAvatars: false

                EAvatar {
                    text: "Qt"
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    text: "UI"
                    source: "qrc:/example/images/gallery/avatar-02.jpg"
                }
                EAvatar {
                    text: "C++"
                    source: "qrc:/example/images/gallery/avatar-03.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatarGroup"

        ExampleCase {
            title: ELocale.texts.CompactTeam
            objectName: "showcaseEAvatarGroup2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatarGroup {
                    size: 28
                    overlap: 6

                    EAvatar {
                        text: "A"
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        text: "B"
                        source: "qrc:/example/images/gallery/avatar-02.jpg"
                    }
                    EAvatar {
                        text: "C"
                        source: "qrc:/example/images/gallery/avatar-03.jpg"
                    }
                    EAvatar {
                        text: "D"
                        source: "qrc:/example/images/gallery/avatar-04.jpg"
                    }
                }
            `)

            EAvatarGroup {
                size: 28
                overlap: 6

                EAvatar {
                    text: "A"
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    text: "B"
                    source: "qrc:/example/images/gallery/avatar-02.jpg"
                }
                EAvatar {
                    text: "C"
                    source: "qrc:/example/images/gallery/avatar-03.jpg"
                }
                EAvatar {
                    text: "D"
                    source: "qrc:/example/images/gallery/avatar-04.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatarGroup"

        ExampleCase {
            objectName: "showcaseEAvatarGroup3"
            title: ELocale.texts.CollapsedAvatarPreview
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatarGroup {
                    collapseAvatars: true
                    maxCollapseAvatars: 2
                    collapseAvatarsTooltip: true

                    EAvatar {
                        text: "A"
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        text: "B"
                        source: "qrc:/example/images/gallery/avatar-02.jpg"
                    }
                    EAvatar {
                        text: "C"
                        source: "qrc:/example/images/gallery/avatar-03.jpg"
                    }
                    EAvatar {
                        text: "D"
                        source: "qrc:/example/images/gallery/avatar-04.jpg"
                    }
                }
            `)

            EAvatarGroup {
                collapseAvatars: true
                maxCollapseAvatars: 2
                collapseAvatarsTooltip: true

                EAvatar {
                    text: "A"
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    text: "B"
                    source: "qrc:/example/images/gallery/avatar-02.jpg"
                }
                EAvatar {
                    text: "C"
                    source: "qrc:/example/images/gallery/avatar-03.jpg"
                }
                EAvatar {
                    text: "D"
                    source: "qrc:/example/images/gallery/avatar-04.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeletonItem"

        ExampleCase {
            objectName: "showcaseESkeletonItem0"
            title: ELocale.texts.PlaceholderShapes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESkeletonItem {
                        height: 40
                        width: 100
                        variant: "text"
                    }
                    ESkeletonItem {
                        height: 40
                        width: 100
                        variant: "circle"
                    }
                    ESkeletonItem {
                        height: 40
                        width: 100
                        variant: "rect"
                    }
                    ESkeletonItem {
                        height: 40
                        width: 100
                        variant: "button"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESkeletonItem {
                    height: 40
                    width: 100
                    variant: "text"
                }
                ESkeletonItem {
                    height: 40
                    width: 100
                    variant: "circle"
                }
                ESkeletonItem {
                    height: 40
                    width: 100
                    variant: "rect"
                }
                ESkeletonItem {
                    height: 40
                    width: 100
                    variant: "button"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeletonItem"

        ExampleCase {
            objectName: "showcaseESkeletonItem1"
            title: ELocale.texts.StaticPlaceholder
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESkeletonItem {
                    height: 72
                    animated: false
                    variant: "rect"
                    width: Math.min(480, parent.width)
                }
            `)

            ESkeletonItem {
                height: 72
                animated: false
                variant: "rect"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ESkeletonItem"

        ExampleCase {
            objectName: "showcaseESkeletonItem2"
            title: ELocale.texts.AvatarPlaceholder2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESkeletonItem {
                        width: 48
                        height: 48
                        variant: "circle"
                    }
                    Column {
                        spacing: 16
                        width: parent.width

                        ESkeletonItem {
                            height: 18
                            width: Math.min(260, parent.width)
                        }
                        ESkeletonItem {
                            height: 18
                            width: Math.min(180, parent.width)
                        }
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESkeletonItem {
                    width: 48
                    height: 48
                    variant: "circle"
                }
                Column {
                    spacing: 16
                    width: parent.width

                    ESkeletonItem {
                        height: 18
                        width: Math.min(260, parent.width)
                    }
                    ESkeletonItem {
                        height: 18
                        width: Math.min(180, parent.width)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeletonItem"

        ExampleCase {
            objectName: "showcaseESkeletonItem3"
            title: ELocale.texts.ImagePlaceholder
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESkeletonItem {
                    height: 160
                    variant: "image"
                    width: Math.min(360, parent.width)
                }
            `)

            ESkeletonItem {
                height: 160
                variant: "image"
                width: Math.min(360, parent.width)
            }
        }
    }
}
