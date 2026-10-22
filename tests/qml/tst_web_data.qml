import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function initTestCase() {
        ELocale.language = "zh"
    }

    function make(component, properties) {
        const item = createTemporaryObject(component, testCase, properties || ({}))
        verify(item !== null)
        return item
    }

    function test_imageLazyExplicitLoad() {
        const image = make(imageComponent, { lazy: true, visible: false })
        compare(image.status, Image.Null)
        image.loadNow()
        tryCompare(image, "status", Image.Ready)
    }

    function test_treePointerDragReordersNodes() {
        const tree = make(treeComponent, { draggable: true })
        const row = findChild(tree, "treeRow_a")
        verify(row)
        mouseDrag(row, 90, row.height / 2, 0, 45, Qt.LeftButton)
        tryCompare(tree.model[0].children[0], "id", "b")
        compare(tree.model[0].children[1].id, "a")
    }

    function test_segmentedValidateEvent() {
        const field = make(segmentedFormComponent)
        const segment = findChild(field, "segmentedFormControl")
        field.setInitialValue("valid")
        field.clearValidate()
        segment.validateEvent = false
        verify(segment.select(1))
        wait(0)
        compare(field.validationState, EValidationState.None)
        segment.validateEvent = true
        verify(segment.select(0))
        wait(0)
        verify(segment.select(1))
        tryCompare(field, "validationState", EValidationState.Error)
        field.clearValidate()
    }

    function test_skeletonThrottleCountAndContentHeight() {
        const skeleton = make(skeletonComponent, { loading: false, count: 2, rows: 1 })
        compare(skeleton.implicitHeight, 44)
        skeleton.throttle = { leading: 50, trailing: 50 }
        skeleton.loading = true
        verify(!skeleton.displayedLoading)
        tryCompare(skeleton, "displayedLoading", true)
        verify(skeleton.implicitHeight >= 100)
        skeleton.loading = false
        verify(skeleton.displayedLoading)
        tryCompare(skeleton, "displayedLoading", false)
        compare(skeleton.implicitHeight, 44)
    }

    function test_statisticFormatterAndCountdownFinish() {
        const statistic = make(statisticComponent)
        statistic.formatter = function(value) {
            return "#" + value
        }
        statistic.value = 42
        compare(statistic.displayValue, "#42")
        statistic.formatter = null
        statistic.countdown = true
        statistic.format = "DD HH:mm:ss"
        statistic.value = Date.now() + 86400000 + 3661000
        verify(statistic.displayValue.indexOf("01 01:01:") === 0)
        const spy = make(finishedSpy, { target: statistic })
        statistic.value = Date.now() + 150
        tryCompare(spy, "count", 1)
        compare(statistic.remaining, 0)
        wait(300)
        compare(spy.count, 1)
    }

    function test_descriptionsSpansVerticalAndCustomContent() {
        const descriptions = make(descriptionsComponent)
        verify(waitForItemPolished(descriptions.contentItem))
        const first = findChild(descriptions, "descriptionCell_0")
        const second = findChild(descriptions, "descriptionCell_1")
        verify(first.width > second.width * 1.5)
        verify(first.height > second.height)
        descriptions.direction = "vertical"
        verify(waitForItemPolished(descriptions.contentItem))
        verify(descriptions.height > 0)
        descriptions.valueDelegate = customTextComponent
        tryVerify(function() {
            return findChild(descriptions, "customDescription") !== null
        })
    }

    function test_tourStepButtonProperties() {
        const tour = make(tourComponent, { type: "primary", steps: [
            { title: "First", nextButtonProps: { text: "Continue", disabled: true } },
            { title: "Second", prevButtonProps: { text: "Back" } }] })
        verify(tour.start())
        tryCompare(tour, "opened", true)
        compare(tour.effectiveType, "primary")
        const next = findChild(tour, "tourNext")
        compare(next.text, "Continue")
        verify(!next.enabled)
        verify(tour.goTo(1))
        const previous = findChild(tour, "tourPrevious")
        compare(previous.text, "Back")
        verify(waitForRendering(previous))
        mouseClick(previous, previous.width / 2, previous.height / 2)
        compare(tour.currentStep, 0)
        tour.close()
    }

    function test_tourPlacementMaskAndFunctionTarget() {
        const target = make(tagComponent, { x: 450, y: 360 })
        const tour = make(tourComponent, { steps: [{ target: function() {
            return target
        }, title: "Target" }] })
        verify(tour.start())
        tryCompare(tour, "opened", true)
        compare(tour.target, target)
        tour.placement = "top-start"
        tryVerify(function() {
            return tour.cardPosition.y < tour.highlight.y
        })
        tour.gap = { offset: 12, radius: 8 }
        compare(tour.gapOffset, 12)
        tour.targetAreaClickable = true
        verify(!tour.modal)
        tour.mask = false
        verify(!tour.effectiveMask)
        tour.showClose = false
        tour.closeOnPressEscape = false
        keyClick(Qt.Key_Escape)
        verify(tour.visible)
        tour.close()
    }

    function test_carouselNamedVerticalCardAndHoverPause() {
        const carousel = make(carouselComponent)
        verify(carousel.setActiveItem("second"))
        compare(carousel.currentIndex, 1)
        carousel.direction = "vertical"
        const view = findChild(carousel, "carouselSlides")
        compare(view.orientation, Qt.Vertical)
        carousel.direction = "horizontal"
        carousel.type = "card"
        verify(view.width < carousel.width)
        carousel.arrow = "never"
        carousel.indicatorPosition = "none"
        const timer = findChild(carousel, "carouselAutoTimer")
        carousel.autoplay = true
        verify(timer.running)
        mouseMove(carousel, 20, 20)
        tryCompare(timer, "running", false)
        carousel.pauseOnHover = false
        tryCompare(timer, "running", true)
        carousel.enabled = false
        verify(!carousel.setActiveItem("first"))
    }

    function test_segmentedValueFieldsDirectionAndKeyboard() {
        const segmented = make(segmentedComponent)
        segmented.props = { label: "name", value: "key", disabled: "locked" }
        segmented.model = [{ key: "one", name: "One" }, { key: "locked", name: "Locked", locked: true },
            { key: "three", name: "Three" }]
        verify(segmented.selectValue("one"))
        compare(segmented.currentValue, "one")
        segmented.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(segmented.value, "three")
        verify(!segmented.selectValue("locked"))
        segmented.direction = "vertical"
        segmented.block = true
        verify(waitForItemPolished(segmented.contentItem))
        verify(segmented.height > EDefaultConfig.controlHeight(segmented.size) * 2)
        segmented.value = "one"
        compare(segmented.currentIndex, 0)
    }

    function test_collapseGuardAndAsyncResolution() {
        const collapse = make(collapseComponent)
        collapse.beforeCollapse = function() {
            return false
        }
        verify(!collapse.toggle("a"))
        compare(collapse.activeNames, [])
        let accept = null
        let reject = null
        collapse.beforeCollapse = function() {
            return {then: function(resolve, fail) {
                accept = resolve
                reject = fail
            }}
        }
        verify(collapse.toggle("a"))
        verify(!collapse.toggle("a"))
        compare(collapse.activeNames, [])
        reject("cancel")
        compare(collapse.pendingNames, [])
        verify(collapse.toggle("a"))
        accept()
        compare(collapse.activeNames, ["a"])
        collapse.accordion = true
        collapse.setActiveNames(["a", "b"])
        compare(collapse.activeNames, ["a"])
        collapse.beforeCollapse = null
        verify(collapse.toggle("b"))
        compare(collapse.activeNames, ["b"])
    }

    function test_imagePreviewNavigationZoomRotationAndClose() {
        const image = make(imageComponent)
        tryCompare(image, "status", Image.Ready)
        verify(image.openPreview())
        tryCompare(image, "previewVisible", true)
        const next = findChild(image, "imagePreviewNext")
        verify(next)
        mouseClick(next, next.width / 2, next.height / 2)
        compare(image.previewIndex, 1)
        verify(image.zoomPreview(100))
        compare(image.previewScale, image.maxScale)
        verify(image.zoomPreview(0.001))
        compare(image.previewScale, image.minScale)
        verify(image.rotatePreview(90))
        compare(image.previewRotation, 90)
        image.infinite = false
        verify(!image.setActiveItem(99))
        image.resetPreview()
        compare(image.previewScale, 1)
        compare(image.previewRotation, 0)
        keyClick(Qt.Key_Escape)
        tryCompare(image, "previewVisible", false)
        image.enabled = false
        verify(!image.openPreview())
    }

    function test_paginationSizeJumpAndEvents() {
        const pagination = make(paginationComponent)
        verify(pagination.setPage(20))
        verify(pagination.setPageSize(100))
        compare(pagination.pageCount, 3)
        compare(pagination.currentPage, 3)
        verify(!pagination.setPageSize(0))
        verify(!pagination.setPageSize(1.5))
        verify(!pagination.setPageSize(NaN))
        const sizes = findChild(pagination, "paginationSizes")
        const jumper = findChild(pagination, "paginationJumper")
        verify(sizes && jumper)
        sizes.activated(0)
        compare(pagination.pageSize, 10)
        pagination.setPage(1)
        mouseClick(jumper.up.indicator, jumper.up.indicator.width / 2, jumper.up.indicator.height / 2)
        compare(pagination.currentPage, 2)
        pagination.explicitPageCount = 1
        pagination.hideOnSinglePage = true
        verify(!pagination.visible)
        pagination.enabled = false
        verify(!pagination.setPageSize(20))
    }

    function test_calendarSelectionRangeAndTimelineReverse() {
        const calendar = make(calendarComponent)
        verify(calendar.selectDate("2026-10-10"))
        compare(calendar.value, "2026-10-10")
        verify(calendar.selectDate("next-month"))
        compare(calendar.month, 10)
        const weekStart = Qt.locale("zh_CN").firstDayOfWeek
        calendar.range = [new Date(2026, 9, 4 + weekStart), new Date(2026, 9, 31 + weekStart)]
        compare(calendar.validatedRange.length, 2)
        verify(!calendar.selectDate(new Date(2026, 10, 1 + weekStart)))
        verify(calendar.selectDate("2026-10-12"))
        calendar.range = ["invalid", "2026-11-01"]
        compare(calendar.validatedRange.length, 0)
        const timeline = make(timelineComponent)
        timeline.reverse = true
        compare(timeline.displayEvents[0].content, "Second")
        timeline.mode = "alternate"
        verify(waitForItemPolished(timeline.contentItem))
        verify(timeline.height > 0)
    }

    function test_treeCheckingStrictAndDisabled() {
        const tree = make(treeComponent)
        const check = findChild(tree, "treeCheck_root")
        verify(check)
        mouseClick(check, check.width / 2, check.height / 2)
        compare(tree.getCheckedKeys(), ["root", "a", "b"])
        verify(tree.setChecked("a", false))
        compare(tree.getCheckedKeys(), ["b"])
        compare(tree.getHalfCheckedKeys(), ["root"])
        compare(tree.getHalfCheckedNodes()[0].label, "Root")
        verify(!tree.setChecked("disabled", true))
        verify(!tree.setChecked("disabled-child", true))
        tree.checkStrictly = true
        verify(tree.setCheckedKeys(["root"]))
        compare(tree.getCheckedKeys(), ["root"])
        compare(tree.getHalfCheckedKeys(), [])
        compare(tree.getCheckedKeys(true), [])
        tree.checkStrictly = false
        verify(tree.setCheckedNodes([tree.findNode("a")]))
        compare(tree.getCheckedKeys(), ["a"])
        compare(tree.getHalfCheckedKeys(), ["root"])
        tree.checkedKeys = ["root"]
        compare(tree.getCheckedKeys(), ["root", "a", "b"])
    }

    function test_treeFilterFieldsAndCurrentAncestors() {
        const tree = make(treeComponent)
        const nodes = tree.allNodes
        tree.filter("Ban")
        compare(tree.visibleNodes.map(function(entry) {
            return entry.key
        }), ["root", "b"])
        verify(tree.allNodes === nodes)
        tree.filterNodeMethod = function(value, node) {
            return node.id === value
        }
        tree.filter("a")
        compare(tree.visibleNodes.map(function(entry) {
            return entry.key
        }), ["root", "a"])
        tree.filter("")
        tree.expandedKeys = []
        verify(tree.setCurrentKey("b"))
        compare(tree.currentNode.label, "Banana")
        verify(tree.isExpanded("root"))
        verify(tree.setCurrentKey(null))
        compare(tree.currentKey, "")
        tree.props = { label: "name", children: "items", disabled: "locked" }
        tree.nodeKey = "key"
        tree.model = [{ key: "folder", name: "Folder", items: [{ key: "file", name: "File" }] }]
        verify(tree.setExpanded("folder", true))
        compare(tree.visibleNodes[1].label, "File")
        verify(tree.select("file"))
        compare(tree.currentKey, "file")
    }

    function test_treeLazyFailureRetryAndStaleReply() {
        const tree = make(treeComponent, { lazy: true, model: [{ id: "remote" }] })
        let resolve = null
        let reject = null
        tree.load = function(node, accept, fail) {
            resolve = accept
            reject = fail
        }
        verify(tree.setExpanded("remote", true))
        verify(tree.isLoading("remote"))
        reject("offline")
        verify(!tree.isLoading("remote"))
        verify(tree.loadNode("remote"))
        resolve([{ id: "remote-child", label: "Child", isLeaf: true }])
        compare(tree.visibleNodes.map(function(entry) {
            return entry.key
        }), ["remote", "remote-child"])
        verify(!tree.loadNode("remote"))
        verify(tree.append({ id: "remote-added", isLeaf: true }, "remote"))
        compare(tree.findNode("remote-added").id, "remote-added")
        tree.model = [{ id: "new" }]
        verify(tree.loadNode("new"))
        const stale = resolve
        tree.model = [{ id: "replacement", isLeaf: true }]
        stale([{ id: "should-not-appear" }])
        compare(tree.allNodes.length, 1)
        compare(tree.allNodes[0].key, "replacement")
    }

    function test_treeMutationsAndDropGuards() {
        const tree = make(treeComponent, { draggable: true })
        const originalBranch = tree.model[1]
        verify(tree.insertBefore({ id: "first" }, "a"))
        verify(tree.insertAfter({ id: "last" }, "b"))
        verify(tree.append({ id: "nested" }, "a"))
        verify(!tree.canDrop("root", "nested", "inner"))
        verify(!tree.canDrop("a", "a", "before"))
        verify(!tree.canDrop("a", "disabled", "inner"))
        tree.allowDrop = function(source, target, position) {
            return position !== "inner"
        }
        verify(!tree.moveNode("a", "b", "inner"))
        verify(tree.moveNode("a", "b", "after"))
        compare(tree.model[0].children.map(function(node) {
            return node.id
        }), ["first", "b", "a", "last"])
        verify(tree.model[1] === originalBranch)
        verify(tree.remove("nested"))
        verify(tree.updateKeyChildren("root", [{ id: "replacement" }]))
        compare(tree.model[0].children[0].id, "replacement")
        verify(!tree.remove("missing"))
        tree.enabled = false
        verify(!tree.append({ id: "blocked" }, "root"))
    }

    function test_tagCheckedBadgeOffsetAndContentSlots() {
        const tag = make(tagComponent)
        mouseClick(tag, tag.width / 2, tag.height / 2)
        verify(tag.checked)
        tag.enabled = false
        mouseClick(tag, tag.width / 2, tag.height / 2)
        verify(tag.checked)
        const badge = make(badgeComponent, { offset: Qt.point(10, 5), color: "#123456" })
        const indicator = findChild(badge, "badgeIndicator")
        compare(indicator.x, badge.width - indicator.width / 2 + 10)
        compare(indicator.y, -indicator.height / 2 + 5)
        compare(indicator.color, Qt.rgba(0x12 / 255, 0x34 / 255, 0x56 / 255, 1))
        const card = make(
            cardComponent,
            { headerDelegate: customTextComponent, footerDelegate: customTextComponent }
        )
        tryVerify(function() {
            return findChild(card, "customDescription") !== null
        })
        const empty = make(emptyComponent, { descriptionDelegate: customTextComponent })
        verify(findChild(empty, "customDescription"))
        const result = make(resultComponent, { titleDelegate: customTextComponent })
        verify(findChild(result, "customDescription"))
    }

    function test_progressPercentageStatusColorAndFormatter() {
        const progress = make(progressComponent)
        progress.value = 0.25
        compare(progress.normalizedValue, 0.25)
        progress.percentage = 70
        compare(progress.normalizedValue, 0.7)
        progress.color = [{ color: "#ff0000", percentage: 30 }, { color: "#00ff00", percentage: 100 }]
        compare(progress.effectiveColor, Qt.rgba(0, 1, 0, 1))
        progress.format = function(value) {
            return value + " done"
        }
        compare(progress.displayText, "70 done")
        progress.percentage = Infinity
        compare(progress.normalizedValue, 0)
        progress.color = EPaletteManager.BasePalette.transparent
        progress.status = "success"
        compare(progress.effectiveStyle, EStyle.Success)
        progress.indeterminate = true
        progress.striped = true
        progress.stripedFlow = true
        const fill = findChild(progress, "progressFill")
        tryVerify(function() {
            return fill.width > 0 && fill.x > 0
        })
        const circle = make(circleComponent, { percentage: 120, strokeLinecap: "butt", dashboard: true })
        compare(circle.normalizedValue, 1)
        circle.percentage = NaN
        compare(circle.normalizedValue, 0)
    }

    function test_remainingLayoutsAndStandaloneTypes() {
        const pagination = make(paginationComponent, { width: 900, layout: "total, ->, prev, pager, next" })
        const left = findChild(pagination, "paginationLeft")
        const right = findChild(pagination, "paginationRight")
        verify(waitForItemPolished(right))
        fuzzyCompare(right.x + right.width, pagination.availableWidth, 0.5)
        verify(right.x > left.width)
        const descriptions = make(descriptionsComponent, { columns: 2,
            model: [{ label: "A", value: "One", width: 180 }, { label: "B", value: "Two" },
                { label: "C", value: "Three", width: 220 }, { label: "D", value: "Four" }] })
        verify(waitForItemPolished(descriptions.contentItem))
        const a = findChild(descriptions, "descriptionCell_0")
        const c = findChild(descriptions, "descriptionCell_2")
        fuzzyCompare(a.width, 220, 0.5)
        fuzzyCompare(c.width, a.width, 0.5)
        const skeletonItem = make(skeletonItemComponent, { variant: "image", animated: true })
        compare(skeletonItem.height, 100)
        tryVerify(function() {
            return skeletonItem.opacity < 1
        })
        const countdown = make(countdownComponent, { value: Date.now() + 150 })
        const spy = make(countdownSpy, { target: countdown })
        tryCompare(spy, "count", 1)
        const viewer = make(viewerComponent)
        tryCompare(viewer, "previewVisible", true)
        viewer.closePreview()
        const group = make(avatarGroupComponent)
        tryCompare(group, "count", 4)
        compare(group.collapsedCount, 2)
        compare(group.avatars[0].size, 36)
        verify(!group.avatars[2].visible)
        const more = findChild(group, "avatarGroupCollapsed")
        mouseClick(more, more.width / 2, more.height / 2)
        tryVerify(function() {
            return findChild(group, "avatarGroupPopup").visible
        })
        findChild(group, "avatarGroupPopup").close()
        group.maxCollapseAvatars = 4
        tryCompare(group, "collapsedCount", 0)
        tryVerify(function() {
            return group.avatars[3].visible
        })
    }

    function test_tourScrollOptions() {
        const fixture = make(tourScrollFixture)
        const scroller = findChild(fixture, "tourScrollFlickable")
        const tour = findChild(fixture, "tourScrollOptions")
        tour.scrollIntoViewOptions = {block: "start", inline: "end"}
        verify(tour.start())
        tryCompare(scroller, "contentY", 700)
        compare(scroller.contentX, 460)
        const target = findChild(fixture, "tourScrollTarget")
        const actual = target.mapToItem(tour.parent, 0, 0)
        compare(tour.highlight.x, actual.x - tour.gapOffset)
        compare(tour.highlight.y, actual.y - tour.gapOffset)
        tour.scrollIntoViewOptions = {block: "end", inline: "center"}
        tour.revealTarget()
        compare(scroller.contentY, 600)
        compare(scroller.contentX, 530)
        scroller.contentX = 0
        scroller.contentY = 0
        tour.steps = [{target: findChild(fixture, "tourScrollTarget"), scrollIntoViewOptions: false}]
        tour.revealTarget()
        compare(scroller.contentX, 0)
        compare(scroller.contentY, 0)
        tour.steps = [{target: findChild(fixture, "tourScrollTarget"), scrollIntoViewOptions: {block: "center", inline: "start", behavior: "smooth"}}]
        tour.revealTarget()
        verify(scroller.contentY < 650)
        tryCompare(scroller, "contentY", 650)
        compare(scroller.contentX, 600)
        const finalPosition = target.mapToItem(tour.parent, 0, 0)
        compare(tour.highlight.y, finalPosition.y - tour.gapOffset)
        scroller.contentX = 550
        scroller.contentY = 660
        const movedPosition = target.mapToItem(tour.parent, 0, 0)
        compare(tour.highlight.x, movedPosition.x - tour.gapOffset)
        tour.steps = [{target: target, scrollIntoViewOptions: {block: "nearest", inline: "nearest"}}]
        tour.revealTarget()
        compare(scroller.contentX, 550)
        compare(scroller.contentY, 660)
        tour.steps = [{target: target, scrollIntoViewOptions: {block: "start", inline: "start", behavior: "smooth"}}]
        tour.revealTarget()
        const stoppedAt = scroller.contentY
        tour.close()
        wait(220)
        compare(scroller.contentY, stoppedAt)
    }

    height: 760
    width: 1000
    visible: true
    when: windowShown
    name: "EUIWebData"

    Component {
        id: treeComponent

        ETree {
            width: 300
            height: 260
            showCheckbox: true
            expandedKeys: ["root"]
            model: [{ id: "root", label: "Root", children: [{ id: "a", label: "Apple" }, { id: "b", label: "Banana" }] },
                { id: "disabled", disabled: true, children: [{ id: "disabled-child" }] }]
        }
    }
    Component {
        id: imageComponent

        EImage {
            width: 120
            height: 120
            preview: true
            previewSrcList: [source, source]
            source: Qt.resolvedUrl("../../assets/eui-mark.svg")
        }
    }
    Component {
        id: paginationComponent

        EPagination {
            total: 256
            pageSizes: [10, 20, 100]
            layout: "total, sizes, prev, pager, next, jumper"
        }
    }
    Component {
        id: carouselComponent

        ECarousel {
            width: 420
            height: 200
            autoplay: false
            interval: 10000
            delegate: Rectangle {
                color: "#dceaf8"
            }
            model: [{ name: "first" }, { name: "second" }, { name: "third" }]
        }
    }
    Component {
        id: descriptionsComponent

        EDescriptions {
            columns: 3
            width: 600
            model: [{ label: "Wide", value: "Value", span: 2, rowspan: 2 },
                { label: "A", value: "One" }, { label: "B", value: "Two" }]
        }
    }
    Component {
        id: customTextComponent

        EText {
            text: "Custom"
            objectName: "customDescription"
        }
    }
    Component {
        id: collapseComponent

        ECollapse {
            model: [{ name: "a", title: "A", content: "First" }, { name: "b", title: "B", content: "Second" }]
        }
    }
    Component {
        id: segmentedComponent

        ESegmented {
            width: 260
        }
    }
    Component {
        id: skeletonComponent

        ESkeleton {
            width: 300

            EText {
                height: 44
                text: "Loaded"
            }
        }
    }
    Component {
        id: statisticComponent

        EStatistic { }
    }
    Component {
        id: finishedSpy

        SignalSpy {
            signalName: "finished"
        }
    }
    Component {
        id: progressComponent

        EProgress {
            height: 20
            width: 200
            duration: 200
        }
    }
    Component {
        id: circleComponent

        ECircleProgress { }
    }
    Component {
        id: calendarComponent

        ECalendar { }
    }
    Component {
        id: timelineComponent

        ETimeline {
            model: [{ content: "First" }, { content: "Second" }]
        }
    }
    Component {
        id: tagComponent

        ETag {
            text: "Check"
            checkable: true
        }
    }
    Component {
        id: badgeComponent

        EBadge {
            value: 5

            EButton {
                text: "Badge"
            }
        }
    }
    Component {
        id: cardComponent

        ECard {
            EText { text: "Body" }
        }
    }
    Component {
        id: emptyComponent

        EEmpty { }
    }
    Component {
        id: resultComponent

        EResult { }
    }
    Component {
        id: tourComponent

        ETour { }
    }
    Component {
        id: avatarGroupComponent

        EAvatarGroup {
            size: 36
            collapseAvatars: true
            maxCollapseAvatars: 2
            collapseAvatarsTooltip: true

            EAvatar { text: "A" }
            EAvatar { text: "B" }
            EAvatar { text: "C" }
            EAvatar { text: "D" }
        }
    }
    Component {
        id: skeletonItemComponent

        ESkeletonItem { }
    }
    Component {
        id: countdownComponent

        ECountdown { }
    }
    Component {
        id: countdownSpy

        SignalSpy {
            signalName: "finish"
        }
    }
    Component {
        id: viewerComponent

        EImageViewer {
            urlList: [Qt.resolvedUrl("../../assets/eui-mark.svg")]
        }
    }
    Component {
        id: tourScrollFixture

        Item {
            width: 500
            height: 450

            Flickable {
                x: 20
                y: 20
                clip: true
                width: 180
                height: 140
                contentWidth: 1000
                contentHeight: 1000
                objectName: "tourScrollFlickable"

                Rectangle {
                    id: scrollTarget

                    x: 600
                    y: 700
                    width: 40
                    height: 40
                    color: "red"
                    objectName: "tourScrollTarget"
                }
            }
            ETour {
                mask: false
                objectName: "tourScrollOptions"
                steps: [{target: scrollTarget}]
            }
        }
    }
    Component {
        id: segmentedFormComponent

        EFormItem {
            width: 300
            prop: "choice"
            rules: [{required: true, trigger: "change", message: "Required"}]

            ESegmented {
                value: "valid"
                model: ["valid", ""]
                objectName: "segmentedFormControl"
            }
        }
    }
}
