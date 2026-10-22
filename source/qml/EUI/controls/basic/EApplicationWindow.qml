import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

ApplicationWindow {
    id: control
    default property alias applicationData: applicationContent.data

    property Item appBar
    property bool showAppBar: true
    property bool fitsAppBarWindows: false
    property int themeTransitionDuration: 420

    readonly property Item applicationContentItem: applicationContent
    readonly property bool themeTransitionRunning: inside.transitionRunning

    function commitThemeTransition() {
        if (!inside.transitionPreparing)
            return
        inside.transitionPreparing = false
        themeSnapshotFallbackTimer.stop()
        if (ETheme.dark !== inside.targetDark)
            ETheme.changeTheme()
        themeRevealAnimation.restart()
    }

    function startThemeTransition() {
        if (inside.transitionRunning)
            return
        inside.targetDark = !ETheme.dark
        inside.oldBackgroundColor = EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)
        inside.revealRadius = 0
        inside.transitionRunning = true
        inside.transitionPreparing = true
        themeTransitionSnapshot.live = false
        themeTransitionSnapshot.scheduleUpdate()
        themeSnapshotFallbackTimer.restart()
    }

    color: EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)

    onFrameSwapped: if (control) control.commitThemeTransition()

    QtObject {
        id: inside

        property real revealRadius: 0
        property bool targetDark: false
        property bool transitionRunning: false
        property bool transitionPreparing: false
        property color oldBackgroundColor: EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)

        readonly property real maximumRadius: Math.sqrt(windowContainer.width * windowContainer.width
            + windowContainer.height * windowContainer.height)
    }
    Item {
        id: windowContainer

        anchors.fill: parent

        Binding {
            property: "width"
            target: control.appBar
            value: appBarContainer.width
            when: control.appBar !== null
            restoreMode: Binding.RestoreBindingOrValue
        }
        Item {
            id: appBarContainer

            z: 1
            data: control.appBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            visible: control.showAppBar
            height: {
                if (!control.showAppBar || !control.appBar || control.fitsAppBarWindows)
                    return 0
                return control.appBar.height
            }
        }
        Item {
            id: applicationContent

            clip: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: control.fitsAppBarWindows ? parent.top : appBarContainer.bottom
        }
    }
    WindowActions {
        id: windowActions
    }
    Item {
        property bool frameless: false

        z: 100
        anchors.fill: windowContainer
        visible: frameless && control.visibility === Window.Windowed

        Component.onCompleted: frameless = (control.flags & Qt.FramelessWindowHint) !== 0

        Repeater {
            model: [Qt.LeftEdge, Qt.RightEdge, Qt.TopEdge, Qt.BottomEdge,
                Qt.LeftEdge | Qt.TopEdge, Qt.RightEdge | Qt.TopEdge,
                Qt.LeftEdge | Qt.BottomEdge, Qt.RightEdge | Qt.BottomEdge]

            MouseArea {
                id: resizeHandle

                property int edges: modelData
                property rect initialGeometry
                property point initialPosition
                property bool systemResize: false

                readonly property bool vertical: (edges & (Qt.TopEdge | Qt.BottomEdge)) !== 0
                readonly property bool horizontal: (edges & (Qt.LeftEdge | Qt.RightEdge)) !== 0

                function resizeTo(position) {
                    const dx = position.x - initialPosition.x
                    const dy = position.y - initialPosition.y
                    const nextWidth = horizontal
                        ? Math.max(1, control.minimumWidth, Math.min(control.maximumWidth,
                        initialGeometry.width + (edges & Qt.LeftEdge ? -dx : dx))) : initialGeometry.width
                    const nextHeight = vertical
                        ? Math.max(1, control.minimumHeight, Math.min(control.maximumHeight,
                        initialGeometry.height + (edges & Qt.TopEdge ? -dy : dy))) : initialGeometry.height
                    if (edges & Qt.LeftEdge)
                        control.x = initialGeometry.x + initialGeometry.width - nextWidth
                    if (edges & Qt.TopEdge)
                        control.y = initialGeometry.y + initialGeometry.height - nextHeight
                    control.width = nextWidth
                    control.height = nextHeight
                }

                objectName: "eWindowResizeHandle"
                height: vertical ? 6 : parent ? Math.max(0, parent.height - 12) : 0
                width: horizontal ? 6 : parent ? Math.max(0, parent.width - 12) : 0
                x: !parent ? 0 : edges & Qt.RightEdge ? parent.width - width : horizontal ? 0 : 6
                y: !parent ? 0 : edges & Qt.BottomEdge ? parent.height - height : vertical ? 0 : 6
                cursorShape: horizontal && vertical
                    ? (edges === (Qt.LeftEdge | Qt.TopEdge) || edges === (Qt.RightEdge | Qt.BottomEdge)
                        ? Qt.SizeFDiagCursor : Qt.SizeBDiagCursor)
                    : (horizontal ? Qt.SizeHorCursor : Qt.SizeVerCursor)

                onPositionChanged: {
                    if (pressed && !systemResize)
                        resizeTo(mapToGlobal(mouse.x, mouse.y))
                }
                onPressed: {
                    initialGeometry = Qt.rect(control.x, control.y, control.width, control.height)
                    initialPosition = mapToGlobal(mouse.x, mouse.y)
                    systemResize = windowActions.resize(resizeHandle, edges)
                }
            }
        }
    }
    Timer {
        id: themeSnapshotFallbackTimer

        interval: 50
        repeat: false

        onTriggered: control.commitThemeTransition()
    }
    NumberAnimation {
        id: themeRevealAnimation

        from: 0
        target: inside
        property: "revealRadius"
        to: inside.maximumRadius
        easing.type: Easing.InOutCubic
        duration: Math.max(0, control.themeTransitionDuration)

        onFinished: themeApplyTimer.restart()
    }
    Timer {
        id: themeApplyTimer

        interval: 16
        repeat: false

        onTriggered: {
            if (ETheme.dark !== inside.targetDark) {
                themeApplyTimer.restart()
                return
            }
            inside.transitionRunning = false
            inside.revealRadius = 0
            themeTransitionSnapshot.live = false
        }
    }
    ShaderEffectSource {
        id: themeTransitionSnapshot

        live: false
        visible: false
        recursive: false
        sourceItem: windowContainer
        anchors.fill: windowContainer
        objectName: "eApplicationWindowThemeSnapshot"
        textureMirroring: ShaderEffectSource.MirrorVertically
    }
    ShaderEffect {
        id: themeReveal

        property real revealRadius: inside.revealRadius
        property variant source: themeTransitionSnapshot
        property real sourceWidth: windowContainer.width
        property real sourceHeight: windowContainer.height
        property color oldBackgroundColor: inside.oldBackgroundColor

        z: 1000
        anchors.fill: windowContainer
        visible: inside.transitionRunning
        fragmentShader: "qrc:/qt/qml/EUI/Shaders/theme-reveal.frag.qsb"
    }
}
