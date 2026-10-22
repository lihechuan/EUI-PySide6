import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control

    property string code: ""
    property int currentFile: 0
    property var sourceFiles: []
    property bool expanded: false
    property int maximumSourceHeight: 360

    readonly property bool hasFiles: sourceFiles.length > 0
    readonly property int sourceLineCount: displayedCode.split(/\r\n|\r|\n/).length
    readonly property string displayedCode: hasFiles && currentFile >= 0 && currentFile < sourceFiles.length
        ? sourceFiles[currentFile].code : code

    width: parent ? parent.width : 0
    objectName: "galleryCodeExpander"
    implicitHeight: toolbar.height + (expanded ? sourcePane.height : 0)

    ERectangle {
        id: toolbar

        height: 48
        width: parent.width
        color: "transparent"

        ERectangle {
            height: 1
            width: parent.width
            color: GalleryStyle.line
        }
        ETextButton {
            id: sourceToggle

            iconSize: 14
            minHeight: 32
            leftIcon: true
            font.bold: false
            anchors.leftMargin: 16
            anchors.left: parent.left
            objectName: "gallerySourceToggle"
            font.pixelSize: GalleryStyle.captionSize
            anchors.verticalCenter: parent.verticalCenter
            iconSource: control.expanded ? EIcons.CHEVRON_UP : EIcons.CODE
            text: control.expanded ? ELocale.texts.HideSource : ELocale.texts.ShowSource

            onClicked: control.expanded = !control.expanded
        }
        ERectangle {
            radius: 5
            width: 44
            height: 22
            anchors.leftMargin: 10
            color: GalleryStyle.accentSoft
            anchors.left: sourceToggle.right
            anchors.verticalCenter: parent.verticalCenter
            visible: control.expanded && toolbar.width >= 400

            EText {
                text: "QML"
                font.pixelSize: 11
                anchors.centerIn: parent
                color: GalleryStyle.accent
                font.weight: Font.DemiBold
            }
        }
        ETextButton {
            iconSize: 14
            minHeight: 32
            leftIcon: true
            font.bold: false
            anchors.rightMargin: 16
            iconSource: EIcons.COPY
            anchors.right: parent.right
            text: ELocale.texts.CopySource
            objectName: "gallerySourceCopy"
            font.pixelSize: GalleryStyle.captionSize
            anchors.verticalCenter: parent.verticalCenter

            onClicked: exampleClipboard.setText(control.displayedCode)
        }
    }
    ERectangle {
        id: sourcePane

        clip: true
        radius: 10
        width: parent.width
        visible: control.expanded
        anchors.top: toolbar.bottom
        objectName: "gallerySourcePane"
        color: GalleryStyle.dark ? "#1D2129" : "#F6F8FC"
        height: control.expanded ? Math.min(control.maximumSourceHeight, codeView.contentHeight
            + (control.hasFiles ? 34 : 0)) : 0

        ERectangle {
            height: 10
            width: parent.width
            color: sourcePane.color
        }
        ERectangle {
            height: 1
            width: parent.width
            color: GalleryStyle.line
        }
        Column {
            id: fileExplorer

            clip: true
            height: parent.height
            visible: control.hasFiles
            objectName: "gallerySourceFiles"
            width: visible ? Math.min(220, parent.width * 0.3) : 0

            EText {
                height: 34
                leftPadding: 12
                width: parent.width
                color: GalleryStyle.muted
                text: ELocale.texts.SourceFiles
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: GalleryStyle.captionSize
            }
            Repeater {
                model: control.sourceFiles

                Column {
                    width: fileExplorer.width

                    EText {
                        height: 28
                        leftPadding: 12
                        width: parent.width
                        color: GalleryStyle.muted
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: GalleryStyle.captionSize
                        text: modelData.path.split("/").slice(0, -1).join("/")
                        visible: text.length > 0 && (index === 0
                            || control.sourceFiles[index - 1].path.split("/").slice(0, -1).join("/") !== text)
                    }
                    ETextButton {
                        id: fileButton

                        minHeight: 32
                        leftPadding: 12
                        rightPadding: 8
                        font.bold: false
                        font.pixelSize: 12
                        width: parent.width
                        text: modelData.path.split("/").pop()
                        objectName: "gallerySourceFile" + index
                        styleType: control.currentFile === index ? EStyle.Primary : EStyle.Default
                        contentItem: EText {
                            font.pixelSize: 12
                            text: fileButton.text
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            color: control.currentFile === index ? GalleryStyle.accent : GalleryStyle.text
                        }

                        onClicked: control.currentFile = index
                    }
                }
            }
        }
        ERectangle {
            width: 1
            height: parent.height
            x: fileExplorer.width
            color: GalleryStyle.line
            visible: control.hasFiles
        }
        Item {
            id: editorArea

            height: parent.height
            x: fileExplorer.width
            width: parent.width - x

            ERectangle {
                id: fileTab

                height: 34
                width: parent.width
                visible: control.hasFiles
                color: GalleryStyle.surface
                objectName: "gallerySourceFileTab"

                EIcon {
                    x: 12
                    iconSize: 14
                    color: GalleryStyle.accent
                    iconSource: EIcons.FILE_CODE
                    anchors.verticalCenter: parent.verticalCenter
                }
                EText {
                    x: 34
                    elide: Text.ElideRight
                    color: GalleryStyle.text
                    width: parent.width - 46
                    font.pixelSize: GalleryStyle.captionSize
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.hasFiles && control.currentFile >= 0 && control.currentFile < control.sourceFiles.length
                        ? control.sourceFiles[control.currentFile].path : ""
                }
            }
            ECodeView {
                id: codeView

                showCopy: false
                font.pixelSize: 14
                width: parent.width
                height: parent.height - y
                backgroundColor: sourcePane.color
                font.family: GalleryStyle.codeFamily
                y: fileTab.visible ? fileTab.height : 0
                code: control.expanded ? control.displayedCode : ""

                Component.onCompleted: {
                    const names = {codeText: "gallerySourceText", codeViewport: "gallerySourceViewport",
                        codePointer: "gallerySourcePointer", codeLineNumbers: "gallerySourceLineNumbers",
                        codeVerticalScroll: "gallerySourceVerticalScroll",
                        codeHorizontalScroll: "gallerySourceHorizontalScroll"}
                    const pending = [codeView]
                    while (pending.length > 0) {
                        const item = pending.pop()
                        if (names[item.objectName])
                            item.objectName = names[item.objectName]
                        const children = item.children || []
                        for (let index = 0; index < children.length; ++index)
                            pending.push(children[index])
                    }
                }
            }
        }
    }
}
