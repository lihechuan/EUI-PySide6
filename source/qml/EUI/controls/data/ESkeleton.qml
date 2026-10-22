import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: loadedContent.data

    property int rows: 3
    property int count: 1
    property var throttle: 0
    property bool loading: true
    property bool animated: false
    property Component templateDelegate: null

    readonly property bool displayedLoading: internal.displayedLoading

    function updateLoading() {
        if (!internal)
            return
        const value = typeof throttle === "number" ? Math.max(0, throttle)
            : throttle && Number(loading ? throttle.leading : throttle.trailing) || 0
        delayTimer.stop()
        if (value > 0) {
            delayTimer.interval = value
            delayTimer.start()
        } else {
            internal.displayedLoading = loading
        }
    }

    implicitWidth: 320
    implicitHeight: displayedLoading ? skeletonColumn.implicitHeight : loadedContent.childrenRect.height
    contentItem: Item {
        Column {
            id: skeletonColumn

            spacing: 24
            width: parent.width
            visible: control.displayedLoading

            Repeater {
                model: Math.max(0, control.count)

                Loader {
                    property int skeletonIndex: index

                    width: skeletonColumn.width
                    sourceComponent: control.templateDelegate || defaultTemplate
                }
            }
        }
        Item {
            id: loadedContent

            width: parent.width
            height: childrenRect.height
            visible: !control.displayedLoading
        }
    }

    onLoadingChanged: updateLoading()
    onThrottleChanged: updateLoading()
    Component.onCompleted: {
        internal.displayedLoading = throttle && typeof throttle === "object" && throttle.initVal !== undefined
            ? !!throttle.initVal : loading
        updateLoading()
    }

    QtObject {
        id: internal

        property bool displayedLoading: true
    }
    Timer {
        id: delayTimer

        onTriggered: internal.displayedLoading = control.loading
    }
    Component {
        id: defaultTemplate

        Column {
            spacing: 16

            Repeater {
                model: Math.max(0, control.rows) + 1

                ERectangle {
                    radius: 4
                    height: 16
                    objectName: "skeletonBar"
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                    width: parent.width * (index === 0 ? 0.33 : index === control.rows ? 0.61 : 1)

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: control.animated
                            && control.displayedLoading
                            && control.visible
                            && control.enabled

                        NumberAnimation {
                            to: 0.4
                            duration: 700
                        }
                        NumberAnimation {
                            to: 1
                            duration: 700
                        }
                    }
                }
            }
        }
    }
}
