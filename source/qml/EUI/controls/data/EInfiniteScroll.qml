import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

ListView {
    id: control

    property int delay: 200
    property int distance: 48
    property bool loading: false
    property bool finished: false
    property bool immediate: true

    readonly property bool nearEnd: contentY - originY + height >= contentHeight - Math.max(0, distance)

    signal loadMore()

    function finishLoad(done) {
        finished = !!done
        loading = false
        Qt.callLater(checkLoad)
    }

    function checkLoad() {
        if (!enabled || !visible || loading || finished || height <= 0 || !nearEnd)
            return false

        if (!immediate && !internal.interacted && contentY <= originY)
            return false
        const remaining = Math.max(0, delay) - (Date.now() - internal.lastLoad)
        if (remaining > 0) {
            throttle.interval = remaining
            throttle.restart()
            return false
        }
        internal.lastLoad = Date.now()
        loading = true
        loadMore()
        return true
    }

    clip: true
    implicitWidth: 320
    implicitHeight: 260
    ScrollBar.vertical: ScrollHandle {
    }
    boundsBehavior: Flickable.StopAtBounds
    delegate: EText {
        padding: 12
        font.pixelSize: 14
        width: control.width
        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        text: modelData && typeof modelData === "object" ? String(modelData.label || "")
            : modelData === null || modelData === undefined ? "" : String(modelData)
    }
    footer: EText {
        padding: 12
        font.pixelSize: 14
        width: control.width
        horizontalAlignment: Text.AlignHCenter
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        text: control.loading ? EControlConfig.textFor(control, "Loading3", ELocale.texts)
            : control.finished ? EControlConfig.textFor(control, "NoMoreData", ELocale.texts)
            : ""
    }

    onCountChanged: Qt.callLater(checkLoad)
    onHeightChanged: Qt.callLater(checkLoad)
    onEnabledChanged: Qt.callLater(checkLoad)
    onVisibleChanged: Qt.callLater(checkLoad)
    onMovementStarted: internal.interacted = true
    Component.onCompleted: Qt.callLater(checkLoad)
    onLoadingChanged: {
        if (loading) {
            internal.loadCount = count
            internal.loadPosition = contentY - originY
        }
    }
    onModelChanged: {
        if (loading) {
            forceLayout()
            contentY = originY + Math.min(internal.loadPosition, Math.max(0, contentHeight - height))
        }
    }
    onContentYChanged: {
        if (loading && count === internal.loadCount)
            internal.loadPosition = contentY - originY
        if (contentY > originY)
            internal.interacted = true
        checkLoad()
    }

    QtObject {
        id: internal

        property real lastLoad: 0
        property int loadCount: 0
        property real loadPosition: 0
        property bool interacted: false
    }
    Timer {
        id: throttle

        onTriggered: control.checkLoad()
    }
}
