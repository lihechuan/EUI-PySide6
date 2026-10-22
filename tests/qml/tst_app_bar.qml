import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function namedItems(item, name) {
        let items = item.objectName === name ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            items = items.concat(namedItems(item.children[index], name))
        return items
    }

    function windowForTest() {
        const window = createTemporaryObject(windowComponent, null)
        verify(window !== null)
        window.requestActivate()
        waitForRendering(window.contentItem)
        tryCompare(window, "visibility", Window.Windowed)
        return window
    }

    function test_themeSnapshotStopsWhenIdle() {
        const window = windowForTest()
        const snapshot = findChild(window, "eApplicationWindowThemeSnapshot")
        verify(snapshot !== null)
        const dark = ETheme.dark
        window.startThemeTransition()
        tryCompare(window, "themeTransitionRunning", true)
        tryCompare(window, "themeTransitionRunning", false, 3000)
        compare(snapshot.live, false)
        ETheme.setDark(dark)
        window.close()
    }

    function test_resizeDrag() {
        if (Qt.platform.os === "windows")
            skip("Native window manager owns the resize gesture")
        const window = windowForTest()
        const handle = namedItems(window.contentItem, "eWindowResizeHandle").find(function(item) {
            return item.edges === Qt.RightEdge
        })
        mousePress(handle, 3, handle.height / 2)
        if (handle.systemResize) {
            mouseRelease(handle, 3, handle.height / 2)
            skip("Native window manager owns the resize gesture")
        }
        mouseMove(window.contentItem, 677, 180)
        mouseRelease(window.contentItem, 677, 180)
        compare(window.width, 680)
        compare(window.height, 360)
    }

    function test_resizeFallbackKeepsOppositeEdges_data() {
        return [
            { tag: "left", edges: Qt.LeftEdge, widths: [600, 320, 900], heights: [360, 360, 360] },
            { tag: "right", edges: Qt.RightEdge, widths: [680, 900, 320], heights: [360, 360, 360] },
            { tag: "top", edges: Qt.TopEdge, widths: [640, 640, 640], heights: [330, 200, 700] },
            { tag: "bottom", edges: Qt.BottomEdge, widths: [640, 640, 640], heights: [390, 700, 200] },
            { tag: "topLeft", edges: Qt.TopEdge | Qt.LeftEdge, widths: [600, 320, 900], heights: [330, 200, 700] },
            { tag: "topRight", edges: Qt.TopEdge | Qt.RightEdge, widths: [680, 900, 320], heights: [330, 200, 700] },
            { tag: "bottomLeft", edges: Qt.BottomEdge | Qt.LeftEdge, widths: [600, 320, 900], heights: [390, 700, 200] },
            { tag: "bottomRight", edges: Qt.BottomEdge | Qt.RightEdge, widths: [680, 900, 320], heights: [390, 700, 200] }
        ]
    }

    function test_appBarContentLayout() {
        const window = windowForTest()
        const appBar = window.appBar
        compare(appBar.width, window.width)
        compare(window.applicationContentItem.mapToItem(window.contentItem, 0, 0).y, appBar.height)
        compare(window.applicationContentItem.height, window.height - appBar.height)
        window.fitsAppBarWindows = true
        tryCompare(window.applicationContentItem, "height", window.height)
        compare(window.applicationContentItem.mapToItem(window.contentItem, 0, 0).y, 0)
        window.fitsAppBarWindows = false
        tryCompare(window.applicationContentItem, "height", window.height - appBar.height)
        window.showAppBar = false
        tryCompare(window.applicationContentItem, "height", window.height)
        compare(window.applicationContentItem.mapToItem(window.contentItem, 0, 0).y, 0)
        window.showAppBar = true
        tryCompare(window.applicationContentItem, "height", window.height - appBar.height)
        window.width = 720
        tryCompare(appBar, "width", 720)
    }

    function test_resizeFallbackKeepsOppositeEdges(data) {
        const window = windowForTest()
        window.x = 400
        window.y = 400
        const geometry = Qt.rect(window.x, window.y, window.width, window.height)
        const handles = namedItems(window.contentItem, "eWindowResizeHandle")
        const handle = handles.find(function(item) {
            return item.edges === data.edges
        })
        verify(handle !== undefined)
        handle.systemResize = false
        handle.initialGeometry = geometry
        handle.initialPosition = Qt.point(100, 100)
        const positions = [Qt.point(140, 130), Qt.point(1100, 1100), Qt.point(-900, -900)]
        for (let index = 0; index < positions.length; ++index) {
            handle.resizeTo(positions[index])
            compare(window.width, data.widths[index])
            compare(window.height, data.heights[index])
            compare(window.x + (data.edges & Qt.LeftEdge ? window.width : 0),
                geometry.x + (data.edges & Qt.LeftEdge ? geometry.width : 0))
            compare(window.y + (data.edges & Qt.TopEdge ? window.height : 0),
                geometry.y + (data.edges & Qt.TopEdge ? geometry.height : 0))
        }
    }

    function test_resizeRejectsDetachedAndInvalidEdges() {
        const detached = createTemporaryObject(detachedComponent, null)
        compare(windowActions.resize(null, Qt.RightEdge), false)
        compare(windowActions.resize(detached, Qt.RightEdge), false)
        const window = windowForTest()
        compare(windowActions.resize(window.appBar, 0), false)
        compare(windowActions.resize(window.appBar, 16), false)
        compare(windowActions.resize(window.appBar, Qt.LeftEdge | Qt.RightEdge), false)
        compare(windowActions.resize(window.appBar, Qt.TopEdge | Qt.BottomEdge), false)
        compare(window.width, 640)
        compare(window.height, 360)
        const handles = namedItems(window.contentItem, "eWindowResizeHandle")
        compare(handles.length, 8)
        const edges = handles.map(function(handle) {
            return handle.edges
        }).sort(function(a, b) {
            return a - b
        })
        compare(edges, [Qt.LeftEdge, Qt.RightEdge, Qt.TopEdge, Qt.BottomEdge,
            Qt.LeftEdge | Qt.TopEdge, Qt.LeftEdge | Qt.BottomEdge,
            Qt.RightEdge | Qt.TopEdge, Qt.RightEdge | Qt.BottomEdge].sort(function(a, b) {
                return a - b
            }))
        for (const handle of handles) {
            verify(handle.width > 0 && handle.height > 0)
            verify(handle.enabled)
        }
    }

    function test_titleAndActionSlotReserveSpace() {
        const window = windowForTest()
        const appBar = window.appBar
        const slot = findChild(appBar, "customAppBarAction")
        const title = findChild(appBar, "eAppBarTitle")
        const actions = findChild(appBar, "eAppBarActions")
        const dragArea = findChild(appBar, "eAppBarDragArea")
        const buttons = findChild(appBar, "eAppBarWindowButtons")
        verify(slot !== null && title !== null && actions !== null && dragArea !== null && buttons !== null)
        compare(slot.parent, actions)
        compare(title.text, window.title)
        compare(title.elide, Text.ElideRight)
        verify(title.width > 0)
        const titlePosition = title.mapToItem(appBar, 0, 0)
        verify(titlePosition.x >= dragArea.x)
        verify(titlePosition.x + title.width <= dragArea.x + dragArea.width)
        verify(dragArea.x + dragArea.width <= actions.x)
        verify(actions.x + actions.width <= buttons.x || buttons.x + buttons.width <= actions.x)
        mouseClick(slot)
        compare(window.actionCount, 1)
        compare(window.visibility, Window.Windowed)
        const buttonWidth = buttons.width
        appBar.showClose = false
        verify(!findChild(appBar, "eAppBarCloseButton").visible)
        verify(buttons.width < buttonWidth)
        appBar.showMinimize = false
        appBar.showMaximize = false
        tryCompare(buttons, "width", 0)
        appBar.showClose = true
        appBar.showMinimize = true
        appBar.showMaximize = true
        tryCompare(buttons, "width", buttonWidth)
    }

    function test_windowButtonsAndDoubleClick() {
        const window = windowForTest()
        const appBar = window.appBar
        const dragArea = findChild(appBar, "eAppBarDragArea")
        const minimize = findChild(appBar, "eAppBarMinimizeButton")
        const maximize = findChild(appBar, "eAppBarMaximizeButton")
        const close = findChild(appBar, "eAppBarCloseButton")
        const handles = namedItems(window.contentItem, "eWindowResizeHandle")
        verify(dragArea !== null && minimize !== null && maximize !== null && close !== null)
        const closeSpy = createTemporaryObject(closeSpyComponent, testCase, { target: appBar })
        mouseClick(minimize)
        tryCompare(window, "visibility", Window.Minimized)
        window.showNormal()
        tryCompare(window, "visibility", Window.Windowed)
        window.requestActivate()
        waitForRendering(window.contentItem)
        dragArea.doubleClicked(null)
        tryCompare(window, "visibility", Window.Maximized)
        for (const handle of handles)
            verify(!handle.visible)
        dragArea.doubleClicked(null)
        tryCompare(window, "visibility", Window.Windowed)
        for (const handle of handles)
            verify(handle.visible)
        appBar.showMaximize = false
        dragArea.doubleClicked(null)
        compare(window.visibility, Window.Windowed)
        appBar.showMaximize = true
        window.requestActivate()
        waitForRendering(window.contentItem)
        mouseClick(maximize)
        tryCompare(window, "visibility", appBar.macOS ? Window.FullScreen : Window.Maximized, 5000)
        for (const handle of handles)
            verify(!handle.visible)
        window.requestActivate()
        waitForRendering(window.contentItem)
        mouseClick(maximize)
        tryCompare(window, "visibility", Window.Windowed, 5000)
        window.requestActivate()
        waitForRendering(window.contentItem)
        mouseClick(close)
        compare(closeSpy.count, 1)
        tryCompare(window, "visible", false)
    }

    width: 640
    height: 480
    visible: true
    name: "EUIAppBar"
    when: windowShown

    WindowActions {
        id: windowActions
    }
    Component {
        id: detachedComponent

        Item { }
    }
    Component {
        id: closeSpyComponent

        SignalSpy {
            signalName: "closeRequested"
        }
    }
    Component {
        id: windowComponent

        EApplicationWindow {
            id: window

            property int actionCount: 0

            width: 640
            height: 360
            visible: true
            maximumWidth: 900
            minimumWidth: 320
            maximumHeight: 700
            minimumHeight: 200
            flags: Qt.Window | Qt.FramelessWindowHint
            title: "A deliberately long application title that must stay clear of actions and window buttons"
            appBar: EAppBar {
                ETextButton {
                    width: 80
                    height: 28
                    text: "Action"
                    objectName: "customAppBarAction"

                    onClicked: ++window.actionCount
                }
            }

            EText {
                text: "Content"
                anchors.centerIn: parent
            }
        }
    }
}
