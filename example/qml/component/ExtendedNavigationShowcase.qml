import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EAffix"

        ExampleCase {
            objectName: "showcaseEAffix0"
            title: ELocale.texts.TopAffixOffset
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 20
                        width: parent.width

                        Item {
                            width: 1
                            height: 60
                        }
                        EAffix {
                            offset: 12
                            target: view

                            EButton {
                                styleType: EStyle.Primary
                                text: ELocale.texts.AffixedAction
                            }
                        }
                        EText {
                            height: 400
                            text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                        }
                    }
                }
            `)

            Flickable {
                id: view

                clip: true
                height: 200
                contentHeight: 600
                width: Math.min(480, parent.width)

                Column {
                    spacing: 20
                    width: parent.width

                    Item {
                        width: 1
                        height: 60
                    }
                    EAffix {
                        offset: 12
                        target: view

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.AffixedAction
                        }
                    }
                    EText {
                        height: 400
                        text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAffix"

        ExampleCase {
            objectName: "showcaseEAffix1"
            title: ELocale.texts.BottomAffix
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 20
                        width: parent.width

                        Item {
                            width: 1
                            height: 60
                        }
                        EAffix {
                            offset: 12
                            target: view
                            position: EPlacement.Bottom

                            EButton {
                                styleType: EStyle.Primary
                                text: ELocale.texts.AffixedAction
                            }
                        }
                        EText {
                            height: 400
                            text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                        }
                    }
                }
            `)

            Flickable {
                id: view

                clip: true
                height: 200
                contentHeight: 600
                width: Math.min(480, parent.width)

                Column {
                    spacing: 20
                    width: parent.width

                    Item {
                        width: 1
                        height: 60
                    }
                    EAffix {
                        offset: 12
                        target: view
                        position: EPlacement.Bottom

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.AffixedAction
                        }
                    }
                    EText {
                        height: 400
                        text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAffix"

        ExampleCase {
            objectName: "showcaseEAffix2"
            title: ELocale.texts.AffixedContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 20
                        width: parent.width

                        Item {
                            width: 1
                            height: 60
                        }
                        EAffix {
                            target: view

                            EButton {
                                styleType: EStyle.Primary
                                text: ELocale.texts.AffixedAction
                            }
                        }
                        EText {
                            height: 400
                            text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                        }
                    }
                }
            `)

            Flickable {
                id: view

                clip: true
                height: 200
                contentHeight: 600
                width: Math.min(480, parent.width)

                Column {
                    spacing: 20
                    width: parent.width

                    Item {
                        width: 1
                        height: 60
                    }
                    EAffix {
                        target: view

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.AffixedAction
                        }
                    }
                    EText {
                        height: 400
                        text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAffix"

        ExampleCase {
            objectName: "showcaseEAffix3"
            title: ELocale.texts.AffixStatus
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 20
                            width: parent.width

                            Item {
                                width: 1
                                height: 60
                            }
                            EAffix {
                                target: view

                                onChanged: result.text = fixed ? ELocale.texts.Affixed : ELocale.texts.FollowingContent

                                EButton {
                                    styleType: EStyle.Primary
                                    text: ELocale.texts.AffixedAction
                                }
                            }
                            EText {
                                height: 400
                                text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                            }
                        }
                    }
                    EText {
                        id: result

                        text: ELocale.texts.FollowingContent
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 20
                        width: parent.width

                        Item {
                            width: 1
                            height: 60
                        }
                        EAffix {
                            target: view

                            onChanged: result.text = fixed ? ELocale.texts.Affixed : ELocale.texts.FollowingContent

                            EButton {
                                styleType: EStyle.Primary
                                text: ELocale.texts.AffixedAction
                            }
                        }
                        EText {
                            height: 400
                            text: ELocale.texts.ScrollTheContainerToSeeTheAffixBehavior
                        }
                    }
                }
                EText {
                    id: result

                    text: ELocale.texts.FollowingContent
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnchor"

        ExampleCase {
            objectName: "showcaseEAnchor0"
            title: ELocale.texts.LinkedSections
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EAnchor {
                        marker: true
                        target: view
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                    }
                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                id: first

                                height: 200
                                text: ELocale.texts.DesignGuidelines
                            }
                            EText {
                                id: second

                                height: 200
                                text: ELocale.texts.DevelopmentGuidelines
                            }
                            EText {
                                id: third

                                height: 200
                                text: ELocale.texts.ReleaseGuidelines
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EAnchor {
                    marker: true
                    target: view
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                }
                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            id: first

                            height: 200
                            text: ELocale.texts.DesignGuidelines
                        }
                        EText {
                            id: second

                            height: 200
                            text: ELocale.texts.DevelopmentGuidelines
                        }
                        EText {
                            id: third

                            height: 200
                            text: ELocale.texts.ReleaseGuidelines
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnchor"

        ExampleCase {
            objectName: "showcaseEAnchor1"
            title: ELocale.texts.HorizontalAnchor
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EAnchor {
                        target: view
                        direction: EOrientation.Horizontal
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                    }
                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                id: first

                                height: 200
                                text: ELocale.texts.DesignGuidelines
                            }
                            EText {
                                id: second

                                height: 200
                                text: ELocale.texts.DevelopmentGuidelines
                            }
                            EText {
                                id: third

                                height: 200
                                text: ELocale.texts.ReleaseGuidelines
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EAnchor {
                    target: view
                    direction: EOrientation.Horizontal
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                }
                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            id: first

                            height: 200
                            text: ELocale.texts.DesignGuidelines
                        }
                        EText {
                            id: second

                            height: 200
                            text: ELocale.texts.DevelopmentGuidelines
                        }
                        EText {
                            id: third

                            height: 200
                            text: ELocale.texts.ReleaseGuidelines
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnchor"

        ExampleCase {
            objectName: "showcaseEAnchor2"
            title: ELocale.texts.AnimatedAnchor
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EAnchor {
                        offset: 12
                        target: view
                        duration: 350
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                    }
                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                id: first

                                height: 200
                                text: ELocale.texts.DesignGuidelines
                            }
                            EText {
                                id: second

                                height: 200
                                text: ELocale.texts.DevelopmentGuidelines
                            }
                            EText {
                                id: third

                                height: 200
                                text: ELocale.texts.ReleaseGuidelines
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EAnchor {
                    offset: 12
                    target: view
                    duration: 350
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                }
                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            id: first

                            height: 200
                            text: ELocale.texts.DesignGuidelines
                        }
                        EText {
                            id: second

                            height: 200
                            text: ELocale.texts.DevelopmentGuidelines
                        }
                        EText {
                            id: third

                            height: 200
                            text: ELocale.texts.ReleaseGuidelines
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnchor"

        ExampleCase {
            objectName: "showcaseEAnchor3"
            title: ELocale.texts.DisabledAnchor
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EAnchor {
                        target: view
                        enabled: false
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                    }
                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                id: first

                                height: 200
                                text: ELocale.texts.DesignGuidelines
                            }
                            EText {
                                id: second

                                height: 200
                                text: ELocale.texts.DevelopmentGuidelines
                            }
                            EText {
                                id: third

                                height: 200
                                text: ELocale.texts.ReleaseGuidelines
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EAnchor {
                    target: view
                    enabled: false
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, target: first}, {title: ELocale.texts.Engineering, target: second}, {title: ELocale.texts.Publish, target: third}]
                }
                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            id: first

                            height: 200
                            text: ELocale.texts.DesignGuidelines
                        }
                        EText {
                            id: second

                            height: 200
                            text: ELocale.texts.DevelopmentGuidelines
                        }
                        EText {
                            id: third

                            height: 200
                            text: ELocale.texts.ReleaseGuidelines
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBacktop"

        ExampleCase {
            objectName: "showcaseEBacktop0"
            title: ELocale.texts.VisibilityThreshold
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentY: 120
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(1)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(2)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(3)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(4)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(5)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(6)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(7)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(8)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(9)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(10)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(11)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(12)
                            }
                        }
                    }
                    EBacktop {
                        target: view
                        visibilityHeight: 80
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentY: 120
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(1)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(2)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(3)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(4)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(5)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(6)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(7)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(8)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(9)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(10)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(11)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(12)
                        }
                    }
                }
                EBacktop {
                    target: view
                    visibilityHeight: 80
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBacktop"

        ExampleCase {
            objectName: "showcaseEBacktop1"
            title: ELocale.texts.AlwaysVisibleBacktop
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentY: 120
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(1)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(2)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(3)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(4)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(5)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(6)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(7)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(8)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(9)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(10)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(11)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(12)
                            }
                        }
                    }
                    EBacktop {
                        target: view
                        visibilityHeight: 0
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentY: 120
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(1)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(2)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(3)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(4)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(5)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(6)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(7)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(8)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(9)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(10)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(11)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(12)
                        }
                    }
                }
                EBacktop {
                    target: view
                    visibilityHeight: 0
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBacktop"

        ExampleCase {
            objectName: "showcaseEBacktop2"
            title: ELocale.texts.BacktopIcon
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentY: 120
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(1)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(2)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(3)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(4)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(5)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(6)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(7)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(8)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(9)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(10)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(11)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(12)
                            }
                        }
                    }
                    EBacktop {
                        target: view
                        visibilityHeight: 0
                        iconSource: EIcons.ARROW_UP_FROM_LINE
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentY: 120
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(1)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(2)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(3)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(4)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(5)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(6)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(7)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(8)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(9)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(10)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(11)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(12)
                        }
                    }
                }
                EBacktop {
                    target: view
                    visibilityHeight: 0
                    iconSource: EIcons.ARROW_UP_FROM_LINE
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBacktop"

        ExampleCase {
            objectName: "showcaseEBacktop3"
            title: ELocale.texts.DisabledBacktop
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flickable {
                        id: view

                        clip: true
                        height: 200
                        contentY: 120
                        contentHeight: 600
                        width: Math.min(480, parent.width)

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(1)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(2)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(3)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(4)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(5)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(6)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(7)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(8)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(9)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(10)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(11)
                            }
                            EText {
                                height: 48
                                text: ELocale.texts.ProjectNumber.arg(12)
                            }
                        }
                    }
                    EBacktop {
                        target: view
                        enabled: false
                        visibilityHeight: 0
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flickable {
                    id: view

                    clip: true
                    height: 200
                    contentY: 120
                    contentHeight: 600
                    width: Math.min(480, parent.width)

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(1)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(2)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(3)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(4)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(5)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(6)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(7)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(8)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(9)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(10)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(11)
                        }
                        EText {
                            height: 48
                            text: ELocale.texts.ProjectNumber.arg(12)
                        }
                    }
                }
                EBacktop {
                    target: view
                    enabled: false
                    visibilityHeight: 0
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPageHeader"

        ExampleCase {
            objectName: "showcaseEPageHeader0"
            title: ELocale.texts.HeaderWithoutBack
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EPageHeader {
                    showBack: false
                    width: parent.width
                    title: ELocale.texts.Workspace2
                    content: ELocale.texts.ProjectDetails
                }
            `)

            EPageHeader {
                showBack: false
                width: parent.width
                title: ELocale.texts.Workspace2
                content: ELocale.texts.ProjectDetails
            }
        }
    }
    ExampleSection {
        componentName: "EPageHeader"

        ExampleCase {
            title: ELocale.texts.HeaderIcon
            objectName: "showcaseEPageHeader1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EPageHeader {
                    width: parent.width
                    iconSource: EIcons.HOUSE
                    title: ELocale.texts.Workspace2
                    content: ELocale.texts.ProjectDetails
                }
            `)

            EPageHeader {
                width: parent.width
                iconSource: EIcons.HOUSE
                title: ELocale.texts.Workspace2
                content: ELocale.texts.ProjectDetails
            }
        }
    }
    ExampleSection {
        componentName: "EPageHeader"

        ExampleCase {
            objectName: "showcaseEPageHeader2"
            title: ELocale.texts.HeaderActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EPageHeader {
                    width: parent.width
                    title: ELocale.texts.Workspace2
                    content: ELocale.texts.ProjectDetails

                    EButton {
                        size: EStyle.Small
                        text: ELocale.texts.Edit
                        styleType: EStyle.Primary
                    }
                }
            `)

            EPageHeader {
                width: parent.width
                title: ELocale.texts.Workspace2
                content: ELocale.texts.ProjectDetails

                EButton {
                    size: EStyle.Small
                    text: ELocale.texts.Edit
                    styleType: EStyle.Primary
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPageHeader"

        ExampleCase {
            title: ELocale.texts.HeaderBody
            objectName: "showcaseEPageHeader3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EPageHeader {
                    width: parent.width
                    title: ELocale.texts.Workspace2
                    content: ELocale.texts.ProjectDetails
                    bodyComponent: Component {
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ShowTheCurrentProjectDescriptionAndStatusBelow
                        }
                    }
                }
            `)

            EPageHeader {
                width: parent.width
                title: ELocale.texts.Workspace2
                content: ELocale.texts.ProjectDetails
                bodyComponent: Component {
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ShowTheCurrentProjectDescriptionAndStatusBelow
                    }
                }
            }
        }
    }
}
