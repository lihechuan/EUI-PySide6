import EUI 1.0
import QtQuick 2.15

Item {
    id: control
    default property alias content: exampleContent.data

    property string code: ""
    property string title: ""
    property string description: ""
    property string introduction: ""
    property bool titleVisible: false
    property string sectionTitle: ELocale.texts.BasicUsage

    readonly property bool hasSource: {
        if (code.length > 0)
            return true
        for (let index = 0; index < exampleContent.children.length; ++index) {
            const child = exampleContent.children[index]
            if (child.loadedCard !== undefined || child.code !== undefined && child.code.length > 0)
                return true
        }
        return false
    }

    width: parent ? parent.width : 0
    implicitHeight: cardColumn.implicitHeight

    Column {
        id: cardColumn

        spacing: 20
        width: parent.width

        EText {
            text: control.title
            width: parent.width
            wrapMode: Text.WordWrap
            color: GalleryStyle.text
            font.weight: Font.DemiBold
            visible: control.titleVisible
            font.pixelSize: GalleryStyle.sectionSize
        }
        EText {
            width: parent.width
            wrapMode: Text.WordWrap
            visible: text.length > 0
            color: GalleryStyle.muted
            font.pixelSize: GalleryStyle.bodySize
            lineHeight: GalleryStyle.bodyLineHeight
            text: control.introduction.length > 0 ? control.introduction : control.description
        }
        ERectangle {
            radius: 12
            width: parent.width
            border.color: GalleryStyle.line
            objectName: "galleryExamplePanel"
            border.width: control.code.length > 0 ? 1 : 0
            color: control.code.length > 0 ? GalleryStyle.surface : "transparent"
            height: panelColumn.implicitHeight + (control.code.length > 0 ? 2 : 0)

            Column {
                id: panelColumn

                x: control.code.length > 0 ? 1 : 0
                y: control.code.length > 0 ? 1 : 0
                width: parent.width - (control.code.length > 0 ? 2 : 0)

                Item {
                    height: 54
                    width: parent.width
                    visible: control.code.length > 0

                    EIcon {
                        x: 24
                        iconSize: 16
                        iconSource: EIcons.CODE
                        color: GalleryStyle.accent
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    EText {
                        x: 50
                        elide: Text.ElideRight
                        color: GalleryStyle.text
                        width: parent.width - 74
                        font.weight: Font.DemiBold
                        text: control.sectionTitle
                        font.pixelSize: GalleryStyle.headingSize
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                ERectangle {
                    width: parent.width
                    objectName: "galleryPreview"
                    color: control.code.length > 0 ? GalleryStyle.preview : "transparent"
                    height: control.code.length > 0 ? Math.max(96, exampleContent.implicitHeight + 48)
                        : exampleContent.implicitHeight

                    ERectangle {
                        height: 1
                        width: parent.width
                        color: GalleryStyle.line
                        visible: control.code.length > 0
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        objectName: "galleryPreviewWheelGuard"

                        onWheel: function(wheel) {
                            wheel.accepted = GalleryStyle.previewScrollAt(parent, wheel.x, wheel.y,
                                wheel.pixelDelta.x || wheel.angleDelta.x, wheel.pixelDelta.y || wheel.angleDelta.y)
                        }
                    }
                    Column {
                        id: exampleContent

                        spacing: 20
                        anchors.left: parent.left
                        anchors.right: parent.right
                        objectName: "galleryPreviewContent"
                        y: control.code.length > 0 ? 24 : 0
                        anchors.leftMargin: control.code.length > 0 ? 24 : 0
                        anchors.rightMargin: control.code.length > 0 ? 24 : 0
                    }
                }
                CodeExpander {
                    code: control.code
                    width: parent.width
                    visible: control.code.length > 0
                }
            }
        }
    }
}
