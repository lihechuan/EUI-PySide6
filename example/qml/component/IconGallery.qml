import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control

    property string query: ""
    property string feedback: ""
    property var selectedIcon: allIcons.length > 0 ? allIcons[0] : null

    readonly property var allIcons: exampleData.icons
    readonly property string reference: selectedIcon ? "EIcons." + selectedIcon.name : ""
    readonly property string exampleCode: selectedIcon
        ? "EIcon {\n    iconSize: 24\n    iconSource: " + reference + "\n}" : ""
    readonly property var filteredIcons: {
        const keyword = query.trim().replace(/^EIcons\./i, "").replace(/\s+/g, "_").toLowerCase()
        return keyword.length === 0 ? allIcons : allIcons.filter(function(icon) {
            return icon.name.toLowerCase().indexOf(keyword) >= 0
        })
    }

    function copyIcon(icon, completeCode) {
        if (!icon)
            return
        selectedIcon = icon
        exampleClipboard.setText(completeCode ? exampleCode : reference)
        feedback = ELocale.texts.Copied
            + (completeCode ? "EIcon QML" : reference)
        feedbackTimer.restart()
        copyMessage.open(feedback)
    }

    objectName: "galleryIconBrowser"
    width: parent ? parent.width : 0
    implicitHeight: content.implicitHeight

    Column {
        id: content

        spacing: 16
        width: parent.width

        EText {
            width: parent.width
            wrapMode: Text.WordWrap
            color: GalleryStyle.muted
            objectName: "galleryIconDescription"
            font.pixelSize: GalleryStyle.bodySize
            lineHeight: GalleryStyle.bodyLineHeight
            lineHeightMode: Text.ProportionalHeight
            text: ELocale.texts.ClickAnIconToCopyItsEIconsName
        }
        Row {
            spacing: 12
            width: parent.width

            EInput {
                clearable: true
                prefixIcon: EIcons.MAGNIFIER
                objectName: "galleryIconSearch"
                placeholderText: ELocale.texts.SearchIconsEGArrow
                width: Math.max(0, Math.min(360, parent.width - 100))

                onTextChanged: {
                    control.query = text
                    iconGrid.positionViewAtBeginning()
                }
            }
            EText {
                color: GalleryStyle.muted
                objectName: "galleryIconResultCount"
                font.pixelSize: GalleryStyle.captionSize
                anchors.verticalCenter: parent.verticalCenter
                text: control.filteredIcons.length + " / " + control.allIcons.length
            }
        }
        GridView {
            id: iconGrid

            readonly property int columnCount: Math.max(1, Math.floor(width / 144))

            clip: true
            cellHeight: 96
            width: parent.width
            activeFocusOnTab: true
            cacheBuffer: cellHeight
            model: control.filteredIcons
            objectName: "galleryIconGrid"
            cellWidth: width / columnCount
            ScrollBar.vertical: ScrollHandle { }
            boundsBehavior: Flickable.StopAtBounds
            height: count === 0 ? emptyState.implicitHeight
                : Math.min(4, Math.ceil(count / columnCount)) * cellHeight
            delegate: ETextButton {
                id: tile

                readonly property var entry: modelData
                readonly property bool selected: control.selectedIcon
                    && control.selectedIcon.name === entry.name

                padding: 10
                leftPadding: 8
                rightPadding: 8
                text: entry.name
                ToolTip.delay: 400
                ToolTip.visible: hovered
                objectName: "galleryIconTile"
                width: iconGrid.cellWidth - 8
                height: iconGrid.cellHeight - 8
                ToolTip.text: "EIcons." + entry.name
                Accessible.description: ELocale.texts.CopyIconName
                background: ERectangle {
                    radius: 8
                    border.width: 1
                    color: tile.selected ? GalleryStyle.accentSoft
                        : tile.hovered ? GalleryStyle.hover : GalleryStyle.surface
                    border.color: tile.selected
                        || tile.activeFocus
                        || (iconGrid.activeFocus && iconGrid.currentIndex === index)
                        ? GalleryStyle.accent : GalleryStyle.line
                }
                contentItem: Column {
                    spacing: 6

                    EIcon {
                        height: 28
                        iconSize: 24
                        width: parent.width
                        iconSource: tile.entry.value
                        color: tile.selected ? GalleryStyle.accent : GalleryStyle.text
                    }
                    EText {
                        font.bold: false
                        maximumLineCount: 2
                        width: parent.width
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        color: GalleryStyle.muted
                        objectName: "galleryIconName"
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: GalleryStyle.captionSize
                        text: tile.entry.name.replace(/_/g, "_\u200b")
                    }
                }

                onClicked: {
                    iconGrid.currentIndex = index
                    control.copyIcon(entry, false)
                }
            }

            Keys.onEnterPressed: control.copyIcon(control.filteredIcons[currentIndex], false)
            Keys.onReturnPressed: control.copyIcon(control.filteredIcons[currentIndex], false)

            EEmpty {
                id: emptyState

                imageSize: 48
                width: parent.width
                anchors.centerIn: parent
                visible: iconGrid.count === 0
                objectName: "galleryIconEmptyState"
                description: ELocale.texts.NoMatchingIconsTryAnotherName
            }
        }
        ERectangle {
            radius: 8
            border.width: 1
            width: parent.width
            color: GalleryStyle.surface
            border.color: GalleryStyle.line
            height: selection.implicitHeight + 32

            Column {
                id: selection

                x: 16
                y: 16
                spacing: 12
                width: parent.width - 32

                Row {
                    spacing: 12
                    width: parent.width

                    EIcon {
                        width: 32
                        height: 32
                        iconSize: 24
                        color: GalleryStyle.accent
                        iconSource: control.selectedIcon ? control.selectedIcon.value : 0
                    }
                    EText {
                        text: control.reference
                        color: GalleryStyle.text
                        width: parent.width - 44
                        wrapMode: Text.WrapAnywhere
                        objectName: "galleryIconReference"
                        font.family: GalleryStyle.codeFamily
                        font.pixelSize: GalleryStyle.captionSize
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Row {
                    spacing: 8

                    EButton {
                        font.bold: false
                        iconSource: EIcons.COPY
                        text: ELocale.texts.CopyName
                        objectName: "galleryIconCopyName"

                        onClicked: control.copyIcon(control.selectedIcon, false)
                    }
                    EButton {
                        plain: true
                        font.bold: false
                        iconSource: EIcons.CODE
                        text: ELocale.texts.CopyQML
                        objectName: "galleryIconCopyCode"

                        onClicked: control.copyIcon(control.selectedIcon, true)
                    }
                }
                EText {
                    width: parent.width
                    text: control.feedback
                    visible: text.length > 0
                    color: GalleryStyle.muted
                    wrapMode: Text.WrapAnywhere
                    objectName: "galleryIconCopyFeedback"
                    Accessible.role: Accessible.StaticText
                    font.pixelSize: GalleryStyle.captionSize
                }
            }
        }
    }
    EMessage {
        id: copyMessage

        duration: 2400
        grouping: true
        showClose: false
        styleType: EStyle.Success
        objectName: "galleryIconCopyMessage"
    }
    Timer {
        id: feedbackTimer

        interval: 2400

        onTriggered: control.feedback = ""
    }
}
