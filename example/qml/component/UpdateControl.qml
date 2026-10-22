import EUI 1.0
import QtQuick 2.15

Item {
    id: control

    property var updater: exampleUpdater

    readonly property bool updating: updater.busy && updater.stage !== "checking"
    readonly property string statusText: updater.error.length > 0 ? ELocale.texts["UpdateError_" + updater.error]
        : updater.stage === "available" ? ELocale.texts.UpdateAvailable.arg(updater.latestVersion)
        : ELocale.texts["UpdateStage_" + updater.stage] || ""

    implicitHeight: 28
    objectName: "galleryUpdateControl"
    implicitWidth: updateButton.implicitWidth

    ETextButton {
        id: updateButton

        iconSize: 16
        minHeight: 28
        leftIcon: true
        leftPadding: 8
        rightPadding: 8
        font.bold: false
        anchors.fill: parent
        objectName: "galleryUpdateButton"
        iconSource: EIcons.ARROW_DOWN_TO_LINE
        font.pixelSize: GalleryStyle.bodySize
        accessibleName: control.statusText || text
        color: control.updater.stage === "available" ? GalleryStyle.accent : GalleryStyle.muted
        background: ERectangle {
            radius: 4
            color: control.updater.stage === "available" ? GalleryStyle.accentSoft
                : updateButton.hovered ? GalleryStyle.hover : "transparent"
        }
        text: control.updating ? ELocale.texts.UpdateInProgress + " " + Math.floor(control.updater.progress * 100) + "%"
            : control.updater.stage === "checking" ? ELocale.texts.UpdateStage_checking
            : control.updater.stage === "available" ? ELocale.texts.UpdateNow
            : control.updater.stage === "failed" ? ELocale.texts.UpdateRetry
            : control.updater.stage === "completed" ? ELocale.texts.UpdateStage_completed
            : ELocale.texts.CheckForUpdates

        onClicked: {
            details.open()
            if (control.updater.busy || control.updater.stage === "completed")
                return
            if (control.updater.stage === "available")
                control.updater.install(ELocale.language, ETheme.dark)
            else
                control.updater.check()
        }
    }
    EPopover {
        id: details

        width: 280
        trigger: "manual"
        reference: updateButton
        placement: EPlacement.BottomRight
        objectName: "galleryUpdateDetails"

        Column {
            spacing: 12
            width: parent.width

            EText {
                width: parent.width
                color: GalleryStyle.text
                font.pixelSize: GalleryStyle.bodySize
                text: "EUI PySide6 " + control.updater.currentVersion
            }
            EProgress {
                showText: true
                width: parent.width
                objectName: "galleryUpdateProgress"
                indeterminate: control.updater.stage === "checksums"
                percentage: Math.floor(control.updater.progress * 100)
                status: control.updater.stage === "completed" ? "success" : ""
                visible: control.updating || control.updater.stage === "completed"
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: control.statusText
                visible: text.length > 0
                objectName: "galleryUpdateStatus"
                font.pixelSize: GalleryStyle.captionSize
                color: control.updater.stage === "failed" ? ETheme.dark ? "#ff7875" : "#cf1322" : GalleryStyle.muted
            }
        }
    }
}
