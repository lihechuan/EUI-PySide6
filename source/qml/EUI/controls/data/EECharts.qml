import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtWebChannel 1.0
import QtWebEngine 1.10
import QtQuick.Controls

Control {
    id: control

    property var option: ({})
    property alias renderer: bridge.renderer

    readonly property alias ready: bridge.ready
    readonly property alias supported: bridge.supported
    readonly property alias errorString: bridge.errorString

    signal finished()
    signal failed(string message)
    signal clicked(var parameters)
    signal dataZoomed(var parameters)
    signal legendSelected(var parameters)

    function clear() {
        bridge.clear()
    }

    function resize() {
        bridge.resize()
    }

    function appendData(data) {
        bridge.appendData(data)
    }

    function dispatchAction(action) {
        bridge.dispatchAction(action)
    }

    function setOption(option, settings) {
        bridge.setOption(option, settings || { notMerge: true })
    }

    implicitWidth: 640
    implicitHeight: 360
    background: ERectangle {
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    }
    contentItem: Loader {
        active: control.visible || status === Loader.Ready
        sourceComponent: bridge.supported ? chartView : fallback
    }

    EChartsBridge {
        id: bridge

        dark: ETheme.dark
        option: control.option
        language: ELocale.language
        WebChannel.id: "chartBridge"

        onFinished: control.finished()
        onFailed: function(message) { control.failed(message) }
        onClicked: function(parameters) { control.clicked(parameters) }
        onDataZoomed: function(parameters) { control.dataZoomed(parameters) }
        onLegendSelected: function(parameters) { control.legendSelected(parameters) }
    }
    WebChannel {
        id: channel

        registeredObjects: [bridge]
    }
    Component {
        id: fallback

        EText {
            wrapMode: Text.WordWrap
            text: control.errorString
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
    }
    Component {
        id: chartView

        WebEngineView {
            url: bridge.pageUrl
            webChannel: channel
            backgroundColor: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

            onContextMenuRequested: request.accepted = true
            onRenderProcessTerminated: bridge.terminate(exitCode)
            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineView.LoadFailedStatus)
                    bridge.report("error", loadRequest.errorString)
            }
        }
    }
}
