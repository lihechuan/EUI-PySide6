import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: normalContent.data

    property string errorText: ""
    property string state: "normal"
    property string retryText: EControlConfig.textFor(control, "Retry", ELocale.texts)
    property string emptyText: EControlConfig.textFor(control, "NoData", ELocale.texts)
    property string errorTitle: EControlConfig.textFor(control, "FailedToLoad", ELocale.texts)

    readonly property Item activeView: {
        switch (state) {
        case "loading": return loadingView
        case "empty": return emptyView
        case "error": return errorView
        default: return normalContent
        }
    }

    signal retry()

    implicitWidth: 360
    implicitHeight: Math.max(120, activeView.implicitHeight)
    contentItem: Item {
        Item {
            id: normalContent

            anchors.fill: parent
            implicitHeight: childrenRect.height
            visible: control.activeView === this
        }
        Column {
            id: loadingView

            spacing: 16
            anchors.centerIn: parent
            visible: control.activeView === this

            ELoading {
                width: 32
                height: 32
                material: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            EText {
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                text: EControlConfig.textFor(control, "Loading3", ELocale.texts)
            }
        }
        EEmpty {
            id: emptyView

            width: parent.width
            anchors.centerIn: parent
            description: control.emptyText
            visible: control.activeView === this
        }
        EResult {
            id: errorView

            width: parent.width
            anchors.centerIn: parent
            styleType: EStyle.Danger
            title: control.errorTitle
            subTitle: control.errorText
            visible: control.activeView === this

            EButton {
                text: control.retryText
                styleType: EStyle.Primary

                onClicked: control.retry()
            }
        }
    }
}
