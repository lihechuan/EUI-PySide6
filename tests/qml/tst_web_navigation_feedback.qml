import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property int callbacks: 0
    property int creations: 0
    property int destructions: 0

    function init() {
        callbacks = 0
        creations = 0
        destructions = 0
        window.requestActivate()
        mouseMove(window.contentItem, window.width - 8, window.height - 8)
        wait(0)
    }

    function test_menuHoverAcrossPopup_data() {
        return [{tag: "horizontal", direction: EOrientation.Horizontal, collapse: false},
            {tag: "collapsed", direction: EOrientation.Vertical, collapse: true}]
    }

    function matchingItems(item, propertyName) {
        let result = item[propertyName] !== undefined ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            result = result.concat(matchingItems(item.children[index], propertyName))
        return result
    }

    function managerCard(manager, key) {
        const overlay = manager.Overlay.overlay
        for (let index = 0; index < overlay.children.length; ++index) {
            const item = overlay.children[index]
            if (item.manager === manager && (item.key === key || item.notificationKey === key))
                return item
        }
        return null
    }

    function test_messageComponentContentDoesNotGroupByEmptyText() {
        const manager = createTemporaryObject(messageComponent, window.contentItem, {grouping: true})
        compare(manager.open({key: "first", contentComponent: paneComponent}), "first")
        compare(manager.open({key: "second", contentComponent: paneComponent}), "second")
        compare(manager.count, 2)
        manager.closeAll()
        tryCompare(manager, "count", 0)
    }

    function test_menuCollapseWidthTransition() {
        const menu = createTemporaryObject(menuComponent, window.contentItem,
            {collapseTransition: true, duration: 80})
        verify(waitForRendering(menu))
        compare(menu.implicitWidth, 240)
        menu.collapse = true
        verify(menu.implicitWidth > 64)
        tryCompare(menu, "implicitWidth", 64)
        menu.collapse = false
        verify(menu.implicitWidth < 240)
        tryCompare(menu, "implicitWidth", 240)
    }

    function test_dividerBorderStylesAndCustomContent() {
        const divider = createTemporaryObject(dividerComponent, window.contentItem)
        verify(divider.implicitHeight > 0)
        for (const style of ["solid", "dashed", "dotted", "double", "groove", "ridge", "inset", "outset", "none", "hidden"]) {
            divider.borderStyle = style
            verify(waitForRendering(divider))
        }
        divider.direction = EOrientation.Vertical
        compare(divider.height, divider.verticalHeight)
    }

    function test_notificationClickDoesNotRequireClose() {
        const manager = createTemporaryObject(notificationComponent, window.contentItem)
        const key = manager.open({title: "Build", message: "Ready", key: "click", duration: 0,
            closeOnClick: false, onClick: function() {
                ++testCase.callbacks
            }})
        const card = managerCard(manager, key)
        verify(card !== null)
        verify(waitForRendering(card))
        mouseClick(card, 20, card.height - 8)
        compare(callbacks, 1)
        compare(manager.count, 1)
        verify(manager.close(key))
        tryCompare(manager, "count", 0)
    }

    function test_stepsCustomIconsAndEvents() {
        const steps = createTemporaryObject(stepsComponent, window.contentItem)
        const spy = createTemporaryObject(spyComponent, testCase, {target: steps, signalName: "changed"})
        verify(steps.select(1))
        compare(steps.active, 1)
        compare(steps.statusAt(0), "success")
        compare(steps.statusAt(1), "error")
        compare(spy.count, 1)
        const marker = matchingItems(steps, "iconSource").find(function(item) {
            return item.iconSource === EIcons.STAR
        })
        verify(marker !== undefined)
        verify(!steps.select(2))
    }

    function test_messageLimitAndComponentContent() {
        const manager = createTemporaryObject(messageComponent, window.contentItem, {max: 1})
        const key = manager.open({message: "Custom", key: "custom", contentComponent: paneComponent})
        const card = managerCard(manager, key)
        verify(card !== null)
        compare(card.contentComponent, paneComponent)
        tryCompare(testCase, "creations", 1)
        compare(manager.open("Overflow"), "")
        compare(manager.count, 1)
        manager.closeAll()
        tryCompare(manager, "count", 0)
        tryCompare(testCase, "destructions", 1)
    }

    function test_tooltipReferenceAndPersistentContent() {
        const reference = createTemporaryObject(referenceComponent, window.contentItem)
        const tip = createTemporaryObject(tooltipComponent, window.contentItem, {reference: reference})
        reference.clicked()
        tryCompare(tip, "visible", true)
        verify(tip.isFocusInsideContent() === false)
        reference.enabled = false
        tryCompare(tip, "visible", false)
        reference.enabled = true
        tip.showAfter = 0
        verify(tip.showForReference())
        tryCompare(tip, "visible", true)
        tip.hide()
        tryCompare(tip, "visible", false)
    }

    function test_tabsDropPositionUsesScrolledCoordinates() {
        const tabs = createTemporaryObject(tabsComponent, window.contentItem,
            {width: 240, model: ["First long tab", "Second long tab", "Third long tab"]})
        tabs.select(2)
        tabs.scrollToActiveTab()
        verify(waitForItemPolished(tabs))
        verify(waitForRendering(tabs))
        verify(tabs.navigation.contentItem.contentX > 0)
        for (let index = 0; index < tabs.count; ++index) {
            const tab = tabs.navigation.itemAt(index)
            const origin = tab.mapToItem(tabs.contentItem, 0, 0)
            compare(tabs.indexAt(origin.x + tab.width / 2), index)
        }
    }

    function test_stepsResponsiveSpaceAndSimpleLayout() {
        const steps = createTemporaryObject(stepsComponent, window.contentItem, {space: "25%"})
        compare(steps.stepWidth, steps.availableWidth / 4)
        steps.width = 640
        compare(steps.stepWidth, steps.availableWidth / 4)
        steps.direction = EOrientation.Vertical
        steps.height = 400
        compare(steps.stepHeight, steps.availableHeight / 4)
        steps.space = 96
        compare(steps.stepHeight, 96)
        steps.simple = true
        compare(steps.vertical, false)
        compare(steps.stepWidth, steps.availableWidth / steps.count)
        steps.simple = false
        steps.space = "invalid"
        compare(steps.stepHeight, 86)
    }

    function test_anchorCustomLinkContentAndClick() {
        const fixture = createTemporaryObject(anchorComponent, window.contentItem)
        const entry = fixture.anchor.model[1]
        fixture.anchor.model = [{text: "First", target: fixture.anchor.model[0].target},
            {title: "Custom", target: entry.target, contentComponent: anchorContentComponent}]
        const content = findChild(fixture.anchor, "anchorCustomContent")
        verify(content !== null)
        verify(content.visible && content.width > 0)
        const link = content.parent.parent
        mouseClick(link, 24, link.height / 2)
        compare(fixture.scroll.contentY, 280)
        compare(fixture.anchor.currentIndex, 1)
    }

    function test_messageGroupingPlacementAndCallbacks() {
        const manager = createTemporaryObject(messageComponent, window.contentItem)
        const key = manager.open({message: "Saved", key: "group", duration: 0, placement: EPlacement.Bottom,
            onClose: function() {
                ++testCase.callbacks
            }})
        compare(manager.open({message: "Saved", grouping: true, placement: EPlacement.Bottom}), key)
        compare(manager.count, 1)
        const card = managerCard(manager, key)
        verify(card !== null)
        compare(card.repeatNum, 2)
        compare(card.messagePlacement, EPlacement.Bottom)
        verify(manager.close(key))
        tryCompare(manager, "count", 0)
        compare(callbacks, 1)
    }

    function test_notificationProgressAndHoverPolicy() {
        const manager = createTemporaryObject(notificationComponent, window.contentItem)
        const key = manager.open({message: "Countdown", duration: 1000, progress: {strokeWidth: 4, color: "#ff0000"}, pauseOnHover: false})
        const card = managerCard(manager, key)
        verify(card !== null)
        compare(card.progress, true)
        const progress = matchingItems(card, "percentage").find(function(item) {
            return item.strokeWidth === 4
        })
        verify(progress !== undefined)
        compare(String(progress.color), "#ff0000")
        tryVerify(function() {
            return card.remaining < 1
        })
        manager.close(key)
        tryCompare(manager, "count", 0)
    }

    function test_anchorDurationBoundaryAndChanges() {
        const fixture = createTemporaryObject(anchorComponent, window.contentItem)
        const anchor = fixture.anchor
        const scroll = fixture.scroll
        const changed = createTemporaryObject(spyComponent, testCase, {target: anchor, signalName: "changed"})
        anchor.duration = 30
        verify(anchor.scrollTo(1))
        tryCompare(scroll, "contentY", 280)
        compare(anchor.currentIndex, 1)
        verify(changed.count > 0)
        scroll.contentY = 0
        anchor.selectScrollTop = true
        anchor.updateCurrent()
        compare(anchor.currentIndex, 0)
        anchor.marker = false
        anchor.direction = EOrientation.Horizontal
        verify(anchor.implicitHeight > 0)
        verify(!anchor.scrollTo(2))
    }

    function test_menuProgrammaticSelectionHasNoActivationSideEffects() {
        const menu = createTemporaryObject(menuComponent, window.contentItem, {collapse: true})
        const selected = createTemporaryObject(
            spyComponent,
            testCase,
            {target: menu, signalName: "itemSelected"}
        )
        const closed = createTemporaryObject(spyComponent, testCase, {target: menu, signalName: "closed"})
        verify(menu.open("one"))
        const opened = menu.openedIndexes.slice()
        verify(menu.updateActiveIndex("leaf"))
        compare(menu.currentIndex, "leaf")
        compare(menu.openedIndexes, opened)
        compare(selected.count, 0)
        compare(closed.count, 0)
        verify(!menu.updateActiveIndex("blocked"))
        compare(menu.currentIndex, "leaf")
    }

    function test_tabsKeyboardSkipsDisabledAndWraps() {
        const tabs = createTemporaryObject(tabsComponent, window.contentItem,
            {model: [{text: "First"}, {text: "Disabled", disabled: true}, {text: "Third"}]})
        const first = tabs.navigation.itemAt(0)
        const last = tabs.navigation.itemAt(2)
        first.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(tabs.currentIndex, 2)
        compare(last.activeFocus, true)
        keyClick(Qt.Key_Right)
        compare(tabs.currentIndex, 0)
        compare(first.activeFocus, true)
        tabs.beforeLeave = function() {
            return false
        }
        keyClick(Qt.Key_Left)
        compare(tabs.currentIndex, 0)
        tabs.beforeLeave = null
        tabs.tabPosition = "left"
        keyClick(Qt.Key_Up)
        compare(tabs.currentIndex, 2)
    }

    function test_tooltipExposesContentHover() {
        const reference = createTemporaryObject(referenceComponent, window.contentItem)
        const tip = createTemporaryObject(tooltipComponent, window.contentItem,
            {reference: reference, trigger: "hover", showAfter: 0, hideAfter: 30})
        verify(waitForRendering(reference))
        mouseMove(reference, reference.width / 2, reference.height / 2)
        tryCompare(tip, "visible", true)
        mouseMove(tip.background, tip.background.width / 2, tip.background.height / 2)
        tryCompare(tip, "contentHovered", true)
        wait(40)
        compare(tip.visible, true)
        mouseMove(window.contentItem, 760, 560)
        tryCompare(tip, "contentHovered", false)
        tryCompare(tip, "visible", false)
    }

    function test_loadingOverlayHookAndLock() {
        const reference = createTemporaryObject(referenceComponent, window.contentItem)
        const loading = createTemporaryObject(loadingComponent, window.contentItem, {target: reference})
        verify(loading.overlayMode)
        loading.beforeClose = function() {
            return false
        }
        verify(!loading.close())
        compare(loading.loading, true)
        const clicked = createTemporaryObject(
            spyComponent,
            testCase,
            {target: reference, signalName: "clicked"}
        )
        mouseClick(reference, 12, 12)
        compare(clicked.count, 0)
        loading.lock = false
        mouseClick(reference, 12, 12)
        compare(clicked.count, 1)
        loading.beforeClose = null
        verify(loading.close())
        compare(loading.loading, false)
        compare(loading.visible, false)
    }

    function test_dropdownReferenceKeyboardAndAvailability() {
        const reference = createTemporaryObject(plainReferenceComponent, window.contentItem)
        const dropdown = createTemporaryObject(dropdownComponent, window.contentItem,
            {reference: reference, triggerKeys: [Qt.Key_Down]})
        reference.forceActiveFocus()
        keyClick(Qt.Key_Space)
        compare(dropdown.menu.visible, false)
        keyClick(Qt.Key_Down)
        tryCompare(dropdown.menu, "visible", true)
        dropdown.close()
        reference.visible = false
        dropdown.open()
        compare(dropdown.menu.visible, false)
        reference.visible = true
        reference.forceActiveFocus()
        dropdown.triggerKeys = [Qt.Key_Enter]
        keyClick(Qt.Key_Enter)
        tryCompare(dropdown.menu, "visible", true)
        reference.enabled = false
        tryCompare(dropdown.menu, "visible", false)
    }

    function test_dropdownTriggersAndItems() {
        const dropdown = createTemporaryObject(dropdownComponent, window.contentItem)
        dropdown.trigger = "hover"
        verify(waitForRendering(dropdown))
        mouseMove(dropdown, 12, 12)
        tryCompare(dropdown.menu, "visible", true)
        compare(dropdown.menu.count, 3)
        verify(!dropdown.menu.itemAt(1).enabled)
        dropdown.close()
        dropdown.trigger = "contextmenu"
        mouseClick(dropdown, 12, 12, Qt.RightButton)
        tryCompare(dropdown.menu, "visible", true)
        const spy = createTemporaryObject(spyComponent, testCase, {target: dropdown, signalName: "command"})
        dropdown.menu.itemAt(2).triggered()
        compare(spy.count, 1)
        compare(spy.signalArguments[0][0], "remove")
        dropdown.enabled = false
        dropdown.open()
        tryCompare(dropdown.menu, "visible", false)
    }

    function test_drawerPercentageSizeAndResize() {
        const drawer = createTemporaryObject(drawerComponent, window.contentItem,
            {drawerSize: "50%", resizable: true})
        drawer.open()
        tryCompare(drawer, "opened", true)
        compare(drawer.width, drawer.parent.width / 2)
        drawer.edge = Qt.TopEdge
        compare(drawer.height, drawer.parent.height / 2)
        drawer.edge = Qt.RightEdge
        const resizeHandle = findChild(drawer.contentItem.parent, "drawerResizeHandle")
        const previous = drawer.width
        mousePress(resizeHandle, 3, 100)
        mouseMove(resizeHandle, -20, 100)
        mouseRelease(resizeHandle, -20, 100)
        compare(typeof drawer.drawerSize, "number")
        verify(drawer.width > previous)
        drawer.drawerSize = "invalid"
        compare(drawer.resolvedSize, 0)
        drawer.close()
        tryCompare(drawer, "visible", false)
    }

    function test_dropdownURLAndFontIconSources() {
        const dropdown = createTemporaryObject(dropdownComponent, window.contentItem,
            {model: [{text: "Font", iconSource: EIcons.STAR},
                {text: "Image", icon: "qrc:/qt/qml/EUI/font/icons/APPLE_DARK.svg"}]})
        dropdown.open()
        tryCompare(dropdown.menu, "visible", true)
        const fontIcon = matchingItems(dropdown.menu.itemAt(0), "iconSource").find(function(item) {
            return item.iconSource === EIcons.STAR && item !== dropdown.menu.itemAt(0)
        })
        verify(fontIcon !== undefined && fontIcon.visible)
        const image = matchingItems(dropdown.menu.itemAt(1), "source").find(function(item) {
            return String(item.source).length > 0
        })
        verify(image !== undefined)
        tryCompare(image, "status", Image.Ready)
        verify(image.visible)
        dropdown.close()
    }

    function test_messageBoxIgnoresStaleCloseRejection() {
        const box = createTemporaryObject(messageBoxComponent, window.contentItem)
        let rejectOld = null
        box.beforeClose = function() {
            return new Promise(function(resolve, reject) {
                rejectOld = reject
            })
        }
        box.confirm("First")
        tryCompare(box, "opened", true)
        verify(box.accept())
        box.visible = false
        let resolveNew = null
        box.beforeClose = function() {
            return new Promise(function(resolve) {
                resolveNew = resolve
            })
        }
        box.confirm("Second")
        tryCompare(box, "opened", true)
        const rejected = createTemporaryObject(
            spyComponent,
            testCase,
            {target: box, signalName: "closeRejected"}
        )
        verify(box.accept())
        rejectOld("Old request")
        wait(0)
        compare(rejected.count, 0)
        verify(!box.accept())
        resolveNew(true)
        tryCompare(box, "visible", false)
    }

    function test_messagePlacementLimitAndTypeCloseAll() {
        const manager = createTemporaryObject(messageComponent, window.contentItem, {max: 1})
        compare(manager.open({message: "Saved", key: "saved", type: EStyle.Success}), "saved")
        compare(manager.open({message: "Full", key: "full"}), "")
        compare(manager.open({message: "Warning", key: "warning", type: EStyle.Warning,
            placement: EPlacement.Bottom}), "warning")
        compare(manager.count, 2)
        compare(manager.closeAll(EStyle.Success), 1)
        tryCompare(manager, "count", 1)
        compare(manager.clearing, false)
        const remaining = managerCard(manager, "warning")
        verify(remaining !== null && !remaining.closing)
        compare(manager.open({message: "Available", key: "available"}), "available")
        compare(manager.clear(), 2)
        tryCompare(manager, "count", 0)
    }

    function test_tabsFourPositionsAndEditable() {
        const tabs = createTemporaryObject(tabsComponent, window.contentItem, {height: 240, editable: true})
        for (const position of ["top", "bottom", "left", "right"]) {
            tabs.tabPosition = position
            verify(waitForItemPolished(tabs))
            verify(tabs.navigation.width > 0)
            verify(tabs.navigation.height > 0)
            verify(tabs.navigation.x >= 0)
            verify(tabs.navigation.y >= 0)
            verify(tabs.navigation.x + tabs.navigation.width <= tabs.availableWidth + 1)
            verify(tabs.navigation.y + tabs.navigation.height <= tabs.availableHeight + 1)
        }
        const spy = createTemporaryObject(spyComponent, testCase, {target: tabs, signalName: "edited"})
        verify(tabs.requestAdd())
        compare(spy.count, 1)
        verify(tabs.closeTab(1))
        compare(spy.count, 2)
        compare(spy.signalArguments[1][1], "remove")
    }

    function test_messageGroupingSeparatesPlacementAndUpdatesType() {
        const manager = createTemporaryObject(messageComponent, window.contentItem)
        const first = manager.open({message: "Status", key: "top", grouping: true, type: EStyle.Success})
        const second = manager.open({message: "Status", key: "bottom", grouping: true, placement: EPlacement.Bottom})
        compare(first, "top")
        compare(second, "bottom")
        compare(manager.count, 2)
        compare(manager.open({message: "Status", grouping: true, type: EStyle.Danger}), first)
        const top = managerCard(manager, first)
        const bottom = managerCard(manager, second)
        compare(top.repeatNum, 2)
        compare(bottom.repeatNum, 1)
        compare(top.messageStyleType, EStyle.Danger)
        compare(bottom.messagePlacement, EPlacement.Bottom)
        manager.closeAll()
        tryCompare(manager, "count", 0)
    }

    function test_drawerCloseHookAndHeader() {
        const drawer = createTemporaryObject(drawerComponent, window.contentItem)
        drawer.open()
        tryCompare(drawer, "opened", true)
        compare(creations, 1)
        drawer.resizable = true
        const resizeHandle = findChild(drawer.contentItem.parent, "drawerResizeHandle")
        verify(resizeHandle !== undefined)
        const resized = createTemporaryObject(spyComponent, testCase, {target: drawer, signalName: "resized"})
        mousePress(resizeHandle, 3, 100)
        mouseMove(resizeHandle, -37, 100)
        mouseRelease(resizeHandle, -37, 100)
        verify(resized.count > 0)
        verify(drawer.drawerSize > 320)
        drawer.beforeClose = function() {
            return false
        }
        verify(!drawer.handleClose())
        compare(drawer.visible, true)
        drawer.beforeClose = function(done) {
            done()
        }
        verify(drawer.handleClose())
        tryCompare(drawer, "visible", false)
        tryCompare(testCase, "destructions", 1)
    }

    function test_watermarkImageAndIndependentContent() {
        const watermark = createTemporaryObject(watermarkComponent, window.contentItem)
        const renderer = findChild(watermark, "watermarkRenderer")
        verify(renderer !== null)
        compare(renderer.parent, watermark)
        compare(renderer.fontGap, 5)
        compare(renderer.textAlign, "left")
        compare(renderer.textBaseline, "top")
        const pane = matchingItems(window.contentItem, "text").find(function(item) {
            return item.text === "Watermark content"
        })
        verify(pane !== undefined)
        compare(pane.opacity, 1)
        verify(pane.parent.parent !== watermark)
        watermark.image = "qrc:/qt/qml/EUI/font/icons/APPLE_DARK.svg"
        const canvas = findChild(watermark, "watermarkImageCanvas")
        verify(canvas !== null)
        tryVerify(function() {
            return canvas.isImageLoaded(watermark.image)
        })
        compare(renderer.visible, false)
        watermark.image = ""
        compare(renderer.visible, true)
    }

    function test_dialogCloseHookAndDestroyedContent() {
        const dialog = createTemporaryObject(dialogComponent, window.contentItem)
        dialog.openDelay = 20
        verify(dialog.open())
        compare(dialog.visible, false)
        tryCompare(dialog, "opened", true)
        compare(creations, 1)
        dialog.beforeClose = function() {
            return false
        }
        verify(!dialog.requestClose())
        compare(dialog.visible, true)
        keyClick(Qt.Key_Escape)
        compare(dialog.visible, true)
        mouseClick(window.contentItem, 4, 4)
        compare(dialog.visible, true)
        let complete = null
        dialog.beforeClose = function(done) {
            complete = done
        }
        verify(dialog.close())
        compare(dialog.visible, true)
        verify(complete !== null)
        complete()
        tryCompare(dialog, "visible", false)
        tryCompare(testCase, "destructions", 1)
        dialog.beforeClose = null
        dialog.openDelay = 0
        dialog.open()
        tryCompare(dialog, "opened", true)
        compare(creations, 2)
        keyClick(Qt.Key_Escape)
        tryCompare(dialog, "visible", false)
    }

    function test_messageBoxValidationAndActionHook() {
        const box = createTemporaryObject(messageBoxComponent, window.contentItem)
        box.prompt("Enter code", "Code", "bad")
        tryCompare(box, "opened", true)
        box.inputPattern = /^[A-Z]{3}$/
        verify(!box.accept())
        verify(box.inputErrorMessage.length > 0)
        box.inputValue = "EUI"
        let action = ""
        let complete = null
        box.beforeClose = function(value, instance, done) {
            action = value
            complete = done
        }
        verify(box.accept())
        compare(action, "confirm")
        compare(box.visible, true)
        const confirmed = createTemporaryObject(
            spyComponent,
            testCase,
            {target: box, signalName: "confirmed"}
        )
        complete()
        tryCompare(box, "visible", false)
        compare(confirmed.count, 1)
        compare(confirmed.signalArguments[0][0], "EUI")
        box.inputType = "textarea"
        box.beforeClose = null
        box.prompt("Notes", "Notes", "Line 1\nLine 2")
        tryCompare(box, "opened", true)
        verify(box.reject())
        tryCompare(box, "visible", false)
    }

    function test_tabsBeforeLeaveAndLazyContent() {
        const tabs = createTemporaryObject(tabsComponent, window.contentItem)
        tryCompare(tabs, "count", 3)
        tryVerify(function() {
            return tabs.paneAt(0) !== null
        })
        compare(tabs.paneAt(1), null)
        compare(creations, 1)
        tabs.beforeLeave = function() {
            return false
        }
        tabs.currentIndex = 1
        compare(tabs.currentIndex, 0)
        verify(!tabs.select(1))
        compare(tabs.currentIndex, 0)
        const second = matchingItems(tabs.contentItem, "tabIndex")[1]
        mouseClick(second, 12, second.height / 2)
        compare(tabs.currentIndex, 0)
        tabs.beforeLeave = function() {
            return Promise.resolve(true)
        }
        verify(tabs.selectName("second"))
        tryCompare(tabs, "currentIndex", 1)
        tryVerify(function() {
            return tabs.paneAt(1) !== null
        })
        compare(creations, 2)
        tabs.beforeLeave = function() {
            return Promise.reject("blocked")
        }
        verify(tabs.select(0))
        wait(0)
        compare(tabs.currentIndex, 1)
        tabs.beforeLeave = null
        verify(tabs.select(0))
        compare(tabs.paneAt(1) !== null, true)
        compare(creations, 2)
        verify(!tabs.select(2))
    }

    function test_menuPopupPreservesSubmenuAndGroupTitles() {
        const menu = createTemporaryObject(menuComponent, window.contentItem,
            {direction: EOrientation.Horizontal, model: [{index: "parent", text: "Parent", children: [
                {index: "submenu", text: "Submenu", iconSource: EIcons.STAR, titleComponent: anchorContentComponent,
                    children: [{index: "child", text: "Child"}]},
                {group: true, text: "Group", titleComponent: anchorContentComponent,
                    children: [{index: "group-child", text: "Group child"}]}]}]})
        verify(menu.open("parent"))
        const entry = matchingItems(menu, "entry").find(function(item) {
            return item.entry && item.entry.index === "parent" && item.menu !== undefined
        })
        verify(entry !== undefined)
        tryCompare(entry.menu, "visible", true)
        compare(entry.menu.count, 3)
        const submenu = entry.menu.itemAt(0)
        const group = entry.menu.itemAt(1)
        compare(submenu.titleComponent, anchorContentComponent)
        compare(submenu.iconSource, EIcons.STAR)
        compare(group.titleComponent, anchorContentComponent)
        compare(group.enabled, false)
        verify(findChild(submenu, "anchorCustomContent") !== null)
        verify(findChild(group, "anchorCustomContent") !== null)
        menu.close("parent")
    }

    function test_dropdownPlainReferenceAndURLIcon() {
        const reference = createTemporaryObject(plainReferenceComponent, window.contentItem)
        const source = "qrc:/qt/qml/EUI/font/icons/APPLE_DARK.svg"
        const dropdown = createTemporaryObject(dropdownComponent, window.contentItem,
            {reference: reference, model: [{text: "Apple", command: "apple", icon: source}]})
        mouseClick(reference, reference.width / 2, reference.height / 2)
        tryCompare(dropdown.menu, "visible", true)
        const action = dropdown.menu.itemAt(0)
        const graphic = matchingItems(action, "source").find(function(item) {
            return String(item.source) === source
        })
        verify(graphic !== undefined)
        tryCompare(graphic, "status", Image.Ready)
        verify(graphic.visible && graphic.width > 0 && graphic.height > 0)
        verify(action.contentItem.leftPadding >= graphic.width)
        verify(waitForRendering(graphic))
        const image = grabImage(graphic)
        verify(image.alpha(Math.floor(image.width / 2), Math.floor(image.height / 2)) > 0)
        dropdown.close()
        tryCompare(dropdown.menu, "visible", false)
        reference.enabled = false
        mouseClick(reference, 8, 8)
        compare(dropdown.menu.visible, false)
        dropdown.open()
        compare(dropdown.menu.visible, false)
    }

    function test_popoverPersistentContentAndPopconfirmDisabled() {
        const reference = createTemporaryObject(referenceComponent, window.contentItem)
        const popover = createTemporaryObject(popoverComponent, window.contentItem, {reference: reference})
        compare(popover.loadedContent, null)
        popover.showAfter = 20
        verify(popover.show())
        popover.hide()
        wait(30)
        compare(popover.visible, false)
        popover.showAfter = 0
        reference.x = 350
        popover.placement = EPlacement.Top
        popover.fallbackPlacements = [EPlacement.Bottom]
        verify(popover.show())
        tryCompare(popover, "opened", true)
        compare(popover.effectivePlacement, EPlacement.Bottom)
        verify(popover.loadedContent !== null)
        popover.hide()
        tryCompare(popover, "visible", false)
        tryCompare(popover, "loadedContent", null)
        const confirm = createTemporaryObject(confirmComponent, window.contentItem, {reference: reference})
        confirm.open()
        tryCompare(confirm, "opened", true)
        confirm.confirmDisabled = true
        verify(!confirm.accept())
        compare(confirm.visible, true)
        const spy = createTemporaryObject(spyComponent, testCase, {target: confirm, signalName: "confirmed"})
        confirm.confirmDisabled = false
        verify(confirm.accept())
        compare(spy.count, 1)
        tryCompare(confirm, "visible", false)
    }

    function test_tabsActivePaneTracksInitialLazyAndReplacedContent() {
        const tabs = createTemporaryObject(tabsComponent, window.contentItem,
            {model: [{text: "First", contentComponent: sizedPaneComponent},
                {text: "Second", contentComponent: sizedPaneComponent}]})
        verify(tabs !== null)
        tryVerify(function() {
            return tabs.paneAt(0) !== null
        })
        compare(tabs.activePane, tabs.paneAt(0))
        verify(tabs.implicitHeight >= tabs.navigation.implicitHeight + tabs.activePane.implicitHeight)
        const first = tabs.activePane
        first.implicitHeight = 64
        verify(tabs.implicitHeight >= tabs.navigation.implicitHeight + 64)
        verify(first.height >= first.implicitHeight)
        const compactHeight = tabs.implicitHeight
        verify(tabs.select(1))
        tryVerify(function() {
            return tabs.paneAt(1) !== null
        })
        compare(tabs.activePane, tabs.paneAt(1))
        tabs.activePane.implicitHeight = 180
        verify(tabs.implicitHeight > compactHeight)
        verify(tabs.implicitHeight >= tabs.navigation.implicitHeight + 180)
        verify(tabs.activePane.height >= tabs.activePane.implicitHeight)
        verify(tabs.select(0))
        compare(tabs.activePane, first)
        compare(tabs.implicitHeight, compactHeight)
        tabs.model = [{text: "Replacement", contentComponent: sizedPaneComponent}]
        tryCompare(tabs, "count", 1)
        tryVerify(function() {
            return tabs.paneAt(0) !== null
        })
        compare(tabs.activePane, tabs.paneAt(0))
        tabs.activePane.implicitHeight = 120
        verify(tabs.implicitHeight >= tabs.navigation.implicitHeight + 120)
        verify(tabs.activePane.height >= tabs.activePane.implicitHeight)
        tabs.model = []
        tryCompare(tabs, "count", 0)
        compare(tabs.activePane, null)
    }

    function test_menuHiddenDescendantsAndAccordionEvents() {
        const menu = createTemporaryObject(menuComponent, window.contentItem)
        const closed = createTemporaryObject(
            spyComponent,
            testCase,
            {target: menu, signalName: "branchClosed"}
        )
        verify(menu.select("leaf"))
        compare(menu.currentIndex, "leaf")
        verify(menu.open("nested"))
        compare(menu.openedIndexes, ["one", "nested"])
        verify(menu.open("two"))
        compare(menu.openedIndexes, ["two"])
        compare(closed.count, 2)
        verify(!menu.select("blocked"))
        menu.collapse = true
        compare(menu.implicitWidth, 64)
        menu.direction = EOrientation.Horizontal
        verify(menu.open("one"))
        const entry = matchingItems(menu, "entry").find(function(item) {
            return item.entry && item.entry.index === "one" && item.menu !== undefined
        })
        verify(entry !== undefined)
        tryCompare(entry.menu, "visible", true)
        compare(entry.menu.count, 1)
        menu.menuTrigger = "click"
        const nested = entry.menu.itemAt(0)
        mouseMove(nested, 12, 12)
        wait(200)
        compare(nested.subMenu.visible, false)
        mouseClick(nested, 12, 12)
        tryCompare(nested.subMenu, "visible", true)
        verify(menu.openedIndexes.indexOf("nested") >= 0)
        tryCompare(nested.subMenu, "opened", true)
        const leaf = nested.subMenu.itemAt(0)
        mouseMove(leaf, leaf.width / 2, leaf.height / 2)
        tryCompare(nested.subMenu, "hovered", true)
        wait(200)
        mouseMove(window.contentItem, window.width - 10, window.height - 10)
        tryCompare(nested.subMenu, "hovered", false)
        wait(200)
        compare(nested.subMenu.visible, true)
        compare(entry.menu.visible, true)
        verify(menu.close("one"))
        tryCompare(entry.menu, "visible", false)
        menu.width = 100
        verify(menu.overflowItems.length > 0)
        compare(menu.displayItems.length, 0)
    }

    function test_menuHoverAcrossPopup(data) {
        const menu = createTemporaryObject(menuComponent, window.contentItem,
            {direction: data.direction, collapse: data.collapse, showTimeout: 20, hideTimeout: 80, popperOffset: 8,
                model: [{index: "workspace", text: "Workspace", children: [{index: "open", text: "Open project"},
                    {index: "recent", text: "Recent", children: [{index: "gallery", text: "Gallery"}]}]},
                    {index: "settings", text: "Settings"}]})
        tryCompare(window, "active", true)
        verify(waitForItemPolished(menu))
        verify(waitForRendering(menu))
        function entryFor(index) {
            return matchingItems(menu, "entry").find(function(item) {
                return item.entry && item.entry.index === index && item.menu !== undefined
            })
        }
        const settings = entryFor("settings")
        mouseClick(settings, settings.width / 2, settings.height / 2)
        compare(menu.currentIndex, "settings")
        const workspace = entryFor("workspace")
        mouseMove(workspace, workspace.width / 2, workspace.height / 2)
        tryCompare(workspace.menu, "opened", true)
        const gap = workspace.mapToItem(window.contentItem,
            data.collapse ? workspace.width + 4 : workspace.width / 2,
            data.collapse ? workspace.height / 2 : workspace.height + 4)
        mouseMove(window.contentItem, gap.x, gap.y)
        wait(20)
        const direct = workspace.menu.itemAt(0)
        mouseMove(direct, direct.width / 2, direct.height / 2)
        wait(160)
        compare(workspace.menu.visible, true)
        compare(menu.currentIndex, "settings")
        const recent = workspace.menu.itemAt(1)
        mouseMove(recent, recent.width / 2, recent.height / 2)
        tryCompare(recent.subMenu, "opened", true)
        const leaf = recent.subMenu.itemAt(0)
        mouseMove(leaf, leaf.width / 2, leaf.height / 2)
        wait(160)
        compare(workspace.menu.visible, true)
        compare(recent.subMenu.visible, true)
        mouseMove(direct, direct.width / 2, direct.height / 2)
        tryCompare(recent.subMenu, "visible", false)
        compare(workspace.menu.visible, true)
        mouseMove(recent, recent.width / 2, recent.height / 2)
        tryCompare(recent.subMenu, "opened", true)
        mouseMove(leaf, leaf.width / 2, leaf.height / 2)
        wait(160)
        compare(workspace.menu.visible, true)
        compare(recent.subMenu.visible, true)
        mouseClick(leaf, leaf.width / 2, leaf.height / 2)
        compare(menu.currentIndex, "gallery")
        tryCompare(workspace.menu, "visible", false)
        mouseMove(workspace, workspace.width / 2, workspace.height / 2)
        tryCompare(workspace.menu, "opened", true)
        mouseMove(window.contentItem, window.width - 10, window.height - 10)
        tryCompare(workspace.menu, "visible", false)
    }

    width: 800
    height: 600
    visible: true
    when: windowShown
    name: "EUIWebNavigationFeedback"

    ApplicationWindow {
        id: window

        width: 800
        height: 600
        visible: true
    }
    Component {
        id: spyComponent

        SignalSpy {}
    }
    Component {
        id: sizedPaneComponent

        Item { implicitHeight: 48 }
    }
    Component {
        id: paneComponent

        EText {
            height: 80
            text: "Pane"

            Component.onCompleted: ++testCase.creations
            Component.onDestruction: ++testCase.destructions
        }
    }
    Component {
        id: tabsComponent

        ETabs {
            x: 20
            y: 20
            lazy: true
            width: 500
            model: [{text: "First", name: "first", contentComponent: paneComponent},
                {text: "Second", name: "second", lazy: true, contentComponent: paneComponent},
                {text: "Disabled", disabled: true}]
        }
    }
    Component {
        id: menuComponent

        EMenu {
            x: 20
            y: 20
            model: [{index: "one", text: "One", children: [{index: "nested", text: "Nested",
                children: [{index: "leaf", text: "Leaf"}]}]},
                {index: "two", text: "Two", children: [{index: "other", text: "Other"}]},
                {index: "disabled", text: "Disabled", disabled: true, children: [{index: "blocked"}]}]
        }
    }
    Component {
        id: stepsComponent

        ESteps {
            width: 500
            clickable: true
            finishStatus: "success"
            model: [{title: "Start", iconSource: EIcons.STAR}, {title: "Review", status: "error"},
                {title: "Blocked", disabled: true}]
        }
    }
    Component {
        id: anchorComponent

        Item {
            property alias anchor: anchor
            property alias scroll: scroll

            Flickable {
                id: scroll

                width: 400
                height: 200
                contentHeight: 700

                Item {
                    id: first

                    y: 40
                }
                Item {
                    id: second

                    y: 300
                }
            }
            EAnchor {
                id: anchor

                offset: 20
                target: scroll
                model: [{text: "First", target: first}, {text: "Second", target: second}]
            }
        }
    }
    Component {
        id: dropdownComponent

        EDropdown {
            x: 40
            y: 40
            hideTimeout: 0
            showTimeout: 0
            text: "Actions"
            model: [{text: "Open", command: "open"}, {text: "Blocked", disabled: true},
                {text: "Remove", command: "remove", divided: true}]
        }
    }
    Component {
        id: dialogComponent

        EDialog {
            exitDuration: 0
            text: "Content"
            enterDuration: 0
            destroyOnClose: true
            contentComponent: paneComponent
        }
    }
    Component {
        id: drawerComponent

        EDrawer {
            showHeader: false
            destroyOnClose: true
            contentComponent: paneComponent
        }
    }
    Component {
        id: plainReferenceComponent

        Rectangle {
            y: 40
            x: 240
            height: 40
            width: 120
            color: "#409eff"
        }
    }
    Component {
        id: anchorContentComponent

        EText {
            text: "Custom anchor"
            objectName: "anchorCustomContent"
        }
    }
    Component {
        id: referenceComponent

        EButton {
            x: 40
            y: 40
            text: "Reference"
        }
    }
    Component {
        id: popoverComponent

        EPopover {
            persistent: false
            contentComponent: paneComponent
        }
    }
    Component {
        id: confirmComponent

        EPopconfirm { text: "Continue?" }
    }
    Component {
        id: loadingComponent

        ELoading { text: "Loading" }
    }
    Component {
        id: messageComponent

        EMessage { duration: 0 }
    }
    Component {
        id: messageBoxComponent

        EMessageBox {
            exitDuration: 0
            enterDuration: 0
        }
    }
    Component {
        id: tooltipComponent

        EToolTip {
            text: "Tip"
            trigger: "click"
            persistent: false
            contentComponent: paneComponent
        }
    }
    Component {
        id: dividerComponent

        EDivider {
            width: 300
            lineWidth: 3
            contentComponent: paneComponent
        }
    }
    Component {
        id: watermarkComponent

        EWatermark {
            fontGap: 5
            width: 320
            height: 180
            textAlign: "left"
            textBaseline: "top"
            content: ["EUI", "Watermark"]

            EText { text: "Watermark content" }
        }
    }
    Component {
        id: notificationComponent

        ENotification {
            duration: 0
            animationDuration: 0
        }
    }
}
