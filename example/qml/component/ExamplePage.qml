import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    id: control
    default property alias content: pageColumn.data

    property string title: ""
    property int exampleCount: 0
    property string description: ""
    property bool layoutReady: false
    property string selectedComponent: ""

    readonly property bool examplePage: true
    readonly property bool previewsReady: layoutReady
        && (!parent || parent.status === undefined || parent.status === Loader.Ready)
    readonly property var componentEntry: {
        if (typeof exampleCatalog === "undefined")
            return null
        exampleCatalog.groups
        return control.selectedComponent.length > 0 ? exampleCatalog.find(control.selectedComponent) : null
    }

    function showComponent(componentName) {
        contentY = 0
        selectedComponent = componentName
    }

    function updateExampleCount() {
        let count = 0
        const pending = [pageColumn]
        while (pending.length > 0) {
            const item = pending.pop()
            if (item.loadedCard !== undefined && item.componentName !== undefined) {
                if (item.selected) {
                    if (item.loadedCard)
                        pending.push(item.loadedCard)
                    else
                        count += item.exampleCount
                }
                continue
            }
            if (item.objectName === "galleryCodeExpander" && item.code.length > 0)
                ++count
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        exampleCount = count
    }

    clip: true
    contentWidth: width
    ScrollBar.vertical: ScrollHandle { }
    boundsBehavior: Flickable.StopAtBounds
    contentHeight: apiDocumentation.y + (apiDocumentation.visible ? apiDocumentation.implicitHeight : 0) + 32

    onSelectedComponentChanged: Qt.callLater(updateExampleCount)
    Component.onCompleted: Qt.callLater(function() {
        pageColumn.forceLayout()
        layoutReady = true
        updateExampleCount()
    })

    Column {
        id: pageColumn

        x: 28
        y: 32
        spacing: 24
        objectName: "galleryPageColumn"
        width: Math.max(0, control.width - 56)

        Item {
            width: parent.width
            implicitHeight: Math.max(headerLabels.implicitHeight, componentTile.visible ? componentTile.height
                : 0)

            ERectangle {
                id: componentTile

                width: 56
                height: 56
                radius: 14
                border.width: 1
                color: GalleryStyle.accentSoft
                border.color: GalleryStyle.line
                visible: control.selectedComponent.length > 0

                EIcon {
                    iconSize: 28
                    anchors.centerIn: parent
                    color: GalleryStyle.accent
                    objectName: "galleryComponentIcon"
                    iconSource: GalleryStyle.componentIcons[control.selectedComponent] || EIcons.CODE
                }
            }
            Column {
                id: headerLabels

                spacing: 8
                width: parent.width - x
                x: componentTile.visible ? 76 : 0

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: GalleryStyle.text
                    font.weight: Font.DemiBold
                    objectName: "galleryComponentTitle"
                    font.pixelSize: GalleryStyle.titleSize
                    text: control.componentEntry ? control.componentEntry.label
                        : control.selectedComponent.length > 0 ? control.selectedComponent : control.title
                }
                ETag {
                    size: EStyle.Small
                    styleType: EStyle.Success
                    objectName: "galleryDetailNewBadge"
                    visible: !!control.componentEntry && control.componentEntry.isNew
                    text: control.componentEntry ? ELocale.texts.ComponentNewVersion.arg(
                        control.componentEntry.introducedIn) : ""
                }
                ERectangle {
                    radius: 5
                    height: 23
                    color: GalleryStyle.hover
                    width: componentName.implicitWidth + 16
                    visible: control.selectedComponent.length > 0

                    EText {
                        id: componentName

                        anchors.centerIn: parent
                        color: GalleryStyle.muted
                        text: control.selectedComponent
                        font.family: GalleryStyle.codeFamily
                        font.pixelSize: GalleryStyle.captionSize
                        objectName: "galleryComponentIdentifier"
                    }
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: GalleryStyle.muted
                    text: control.description
                    font.pixelSize: GalleryStyle.bodySize
                    lineHeight: GalleryStyle.bodyLineHeight
                    visible: control.selectedComponent.length === 0
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: GalleryStyle.muted
                    font.pixelSize: GalleryStyle.captionSize
                    visible: control.selectedComponent.length > 0
                    text: control.exampleCount + ELocale.texts.ExamplesInteractAndExploreTheSource
                }
            }
        }
    }
    ExampleSection {
        id: apiDocumentation

        x: pageColumn.x
        width: pageColumn.width
        objectName: "galleryApiLoader"
        componentName: control.selectedComponent
        y: pageColumn.y + pageColumn.implicitHeight + (visible ? 24 : 0)
        visible: control.selectedComponent.length > 0 && !(control.componentEntry && control.componentEntry.demo)

        ExampleApi { componentName: control.selectedComponent }
    }
}
