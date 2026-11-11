import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_terminalInvalidOutput_data() {
        return ["sync-return", "sync-throw", "async-resolve", "async-reject"].map(function(mode) {
            return {tag: mode, mode: mode}
        })
    }

    function test_stepsBinding() {
        const steps = createTemporaryObject(stepsComponent, testCase)
        steps.selectedStep = 1
        compare(steps.active, 1)
        steps.selectedStep = 2
        compare(steps.active, 2)
    }

    function test_infiniteScrollBoundary() {
        const list = createTemporaryObject(infiniteComponent, testCase)
        verify(waitForItemPolished(list))
        list.forceLayout()
        list.contentY = list.contentHeight - list.height - list.distance
        tryCompare(list, "loading", true)
    }

    function test_anchorTargetCleared() {
        const fixture = createTemporaryObject(anchorComponent, testCase)
        verify(fixture.anchor.scrollTo(1))
        compare(fixture.anchor.currentIndex, 1)
        fixture.anchor.target = null
        compare(fixture.anchor.currentIndex, -1)
        verify(!fixture.anchor.scrollTo(0))
    }

    function test_dynamicDialogCompletion_data() {
        const rows = []
        for (const duration of [0, 30]) {
            for (const action of ["resolve", "accept", "done", "reject", "close"]) {
                rows.push({tag: action + "-" + duration, action: action, duration: duration,
                    accepted: ["resolve", "accept", "done"].indexOf(action) >= 0})
            }
        }
        return rows
    }

    function test_infiniteScrollAppendPosition() {
        const list = createTemporaryObject(infiniteComponent, testCase)
        verify(waitForItemPolished(list))
        list.forceLayout()
        list.contentY = 120
        list.loading = true
        const rows = list.model.slice()
        rows.push("New first", "New second")
        list.model = rows
        list.forceLayout()
        wait(30)
        compare(list.contentY - list.originY, 120)
    }

    function test_imageErrorDelegate() {
        const image = createTemporaryObject(imageComponent, testCase)
        image.source = Qt.resolvedUrl("missing-regression-image.png")
        tryCompare(image, "status", 3)
        tryVerify(function() { return findChild(image, "errorContent") !== null })
        image.source = ""
        tryCompare(image, "status", 0)
        tryVerify(function() { return findChild(image, "errorContent") === null })
    }

    function test_collapseContentRemoved() {
        const collapse = createTemporaryObject(collapseComponent, testCase)
        const empty = createTemporaryObject(collapseComponent, testCase, {contentDelegate: null})
        verify(waitForItemPolished(collapse))
        verify(waitForItemPolished(empty))
        const height = collapse.implicitHeight
        collapse.contentDelegate = null
        tryCompare(collapse, "implicitHeight", empty.implicitHeight)
        collapse.contentDelegate = headerComponent
        tryCompare(collapse, "implicitHeight", height)
    }

    function test_timelineContentRemoved() {
        const timeline = createTemporaryObject(timelineComponent, testCase)
        const empty = createTemporaryObject(timelineComponent, testCase, {contentDelegate: null})
        verify(waitForItemPolished(timeline))
        verify(waitForItemPolished(empty))
        const height = timeline.implicitHeight
        timeline.contentDelegate = null
        tryCompare(timeline, "implicitHeight", empty.implicitHeight)
        timeline.contentDelegate = headerComponent
        tryCompare(timeline, "implicitHeight", height)
    }

    function test_wizardStepsFollowPage() {
        const wizard = createTemporaryObject(wizardComponent, testCase)
        const steps = findChild(wizard, "wizardSteps")
        compare(steps.active, 0)
        verify(wizard.next())
        compare(wizard.currentIndex, 2)
        compare(steps.active, 2)
        verify(wizard.previous())
        compare(steps.active, 0)
        wizard.currentIndex = 2
        compare(steps.active, 2)
        verify(wizard.finish())
        compare(steps.active, 3)
        wizard.reset()
        compare(steps.active, 0)
        wizard.model = [{title: "New first"}, {title: "New last"}]
        verify(wizard.next())
        compare(steps.active, 1)
    }

    function test_terminalCompletionOnce() {
        const terminal = createTemporaryObject(terminalComponent, testCase)
        const spy = createTemporaryObject(spyComponent, testCase, {target: terminal, signalName: "completed"})
        let resolve = null
        let reject = null
        terminal.commandHandler = function(command) {
            return {then: function(success, failure) {
                resolve = success
                reject = failure
            }}
        }
        verify(terminal.execute("pending"))
        compare(terminal.busy, true)
        resolve("First")
        reject("Second")
        compare(spy.count, 1)
        compare(terminal.entries[0].output, "First")
        compare(terminal.entries[0].error, false)
    }

    function test_commandPaletteBatchedResize() {
        for (const dark of [false, true]) {
            ETheme.setDark(dark)
            const fixture = createTemporaryObject(paletteComponent, testCase)
            const palette = fixture.palette
            palette.open()
            tryCompare(palette, "opened", true)
            palette.query = "folder workspace"
            palette.query = "nothing found"
            fixture.width = 360
            fixture.height = 280
            tryCompare(palette, "width", 328)
            wait(100)
            const list = findChild(palette.contentItem, "commandList")
            compare(list.count, 0)
            compare(list.height, 0)
            verify(palette.height < 100)
            compare(palette.y, (280 - palette.height) / 3)
            palette.close()
        }
    }

    function test_cardSlotsRemoved() {
        const card = createTemporaryObject(cardComponent, testCase)
        const empty = createTemporaryObject(cardComponent, testCase, {headerDelegate: null, footerDelegate: null})
        verify(waitForItemPolished(card))
        verify(waitForItemPolished(empty))
        const originalHeight = card.implicitHeight
        verify(originalHeight > empty.implicitHeight)
        card.headerDelegate = null
        card.footerDelegate = null
        tryCompare(card, "implicitHeight", empty.implicitHeight)
        card.headerDelegate = headerComponent
        card.footerDelegate = footerComponent
        tryCompare(card, "implicitHeight", originalHeight)
    }

    function test_dynamicDialogCompletion(data) {
        const dialog = createTemporaryObject(dialogComponent, testCase, {exitDuration: data.duration})
        const spy = createTemporaryObject(spyComponent, testCase, {target: dialog})
        verify(dialog.openComponent(pageComponent, {}))
        tryCompare(dialog, "opened", true)
        dialog.resultData = "Done"
        if (data.action === "resolve")
            dialog.resolve("Done")
        else if (data.action === "done")
            dialog.done(1)
        else
            dialog[data.action]()
        tryCompare(spy, "count", 1)
        compare(spy.signalArguments[0][0], "Done")
        compare(spy.signalArguments[0][1], data.accepted)
        dialog.reject()
        wait(data.duration + 20)
        compare(spy.count, 1)
    }

    function test_statisticSlotsRemoved() {
        const statistic = createTemporaryObject(statisticComponent, testCase)
        const empty = createTemporaryObject(statisticComponent, testCase,
            {titleDelegate: null, prefixDelegate: null, suffixDelegate: null})
        verify(waitForItemPolished(statistic))
        verify(waitForItemPolished(empty))
        const width = statistic.implicitWidth
        const height = statistic.implicitHeight
        statistic.titleDelegate = null
        statistic.prefixDelegate = null
        statistic.suffixDelegate = null
        tryCompare(statistic, "implicitWidth", empty.implicitWidth)
        tryCompare(statistic, "implicitHeight", empty.implicitHeight)
        statistic.titleDelegate = headerComponent
        statistic.prefixDelegate = footerComponent
        statistic.suffixDelegate = footerComponent
        tryCompare(statistic, "implicitWidth", width)
        tryCompare(statistic, "implicitHeight", height)
    }

    function test_dynamicDialogReopenBeforeFallback() {
        const dialog = createTemporaryObject(dialogComponent, testCase, {exitDuration: 0})
        const spy = createTemporaryObject(spyComponent, testCase, {target: dialog})
        const callbacks = []
        dialog.callback = function(value, accepted) { callbacks.push("old:" + value + ":" + accepted) }
        verify(dialog.openComponent(pageComponent, {}))
        tryCompare(dialog, "opened", true)
        dialog.resultData = "First"
        dialog.close()
        verify(dialog.openComponent(pageComponent, {}))
        dialog.callback = function(value, accepted) { callbacks.push("new:" + value + ":" + accepted) }
        tryCompare(dialog, "opened", true)
        dialog.resolve("Second")
        tryCompare(spy, "count", 2)
        const results = spy.signalArguments.map(function(args) { return args[0] + ":" + args[1] }).sort()
        compare(results.join(","), "First:false,Second:true")
        compare(callbacks.sort().join(","), "new:Second:true,old:First:false")
    }

    function test_terminalInvalidOutput(data) {
        const terminal = createTemporaryObject(terminalComponent, testCase)
        const spy = createTemporaryObject(spyComponent, testCase, {target: terminal, signalName: "completed"})
        const invalid = {toString: function() { throw new Error("output-conversion-failed") }}
        let resolve = null
        let reject = null
        terminal.commandHandler = function(command) {
            if (data.mode === "sync-return")
                return invalid
            if (data.mode === "sync-throw")
                throw invalid
            return {then: function(success, failure) {
                resolve = success
                reject = failure
            }}
        }
        verify(terminal.execute("invalid"))
        if (resolve) {
            compare(terminal.busy, true)
            if (data.mode === "async-resolve")
                resolve(invalid)
            else
                reject(invalid)
        }
        compare(terminal.busy, false)
        compare(spy.count, 1)
        compare(terminal.entries.length, 1)
        compare(terminal.entries[0].error, true)
        compare(spy.signalArguments[0][2], true)
        const firstOutput = terminal.entries[0].output
        if (resolve) {
            resolve("late success")
            reject("late failure")
            compare(spy.count, 1)
            compare(terminal.entries[0].output, firstOutput)
            compare(terminal.entries[0].error, true)
        }
        terminal.commandHandler = function(command) { return "recovered" }
        verify(terminal.execute("next"))
        compare(terminal.busy, false)
        compare(spy.count, 2)
        compare(terminal.entries[1].output, "recovered")
        compare(terminal.entries[1].error, false)
    }

    function test_dynamicDialogComponentSwitch() {
        const fixture = createTemporaryObject(dialogSwitchComponent, testCase)
        const dialog = fixture.dialog
        const spy = createTemporaryObject(spyComponent, testCase, {target: dialog, signalName: "loadFailed"})
        verify(dialog.openComponent(fixture.firstPage, {firstName: "First"}))
        tryCompare(dialog, "opened", true)
        compare(dialog.instance.firstName, "First")
        compare(fixture.firstCreated, 1)
        compare(fixture.secondCreated, 0)
        verify(dialog.close())
        tryCompare(dialog, "visible", false)
        verify(dialog.openComponent(fixture.secondPage, {secondName: "Second"}))
        tryCompare(dialog, "opened", true)
        compare(dialog.instance.secondName, "Second")
        compare(fixture.firstCreated, 1)
        compare(fixture.secondCreated, 1)
        compare(spy.count, 0)
        verify(dialog.close())
        tryCompare(dialog, "visible", false)
        verify(dialog.openComponent(fixture.secondPage, {secondName: "Updated"}))
        tryCompare(dialog, "opened", true)
        compare(dialog.instance.secondName, "Updated")
        compare(fixture.firstCreated, 1)
        compare(fixture.secondCreated, 2)
        compare(spy.count, 0)
        dialog.parameters = {secondName: "Direct"}
        compare(dialog.instance.secondName, "Direct")
        compare(fixture.secondCreated, 3)
        dialog.component = null
        compare(dialog.instance, null)
        dialog.component = fixture.secondPage
        compare(dialog.instance.secondName, "Direct")
        compare(fixture.secondCreated, 4)
        compare(fixture.firstCreated, 1)
        compare(spy.count, 0)
        dialog.close()
    }

    width: 700
    height: 520
    visible: true
    when: windowShown
    name: "RestorationRegressions"

    Component {
        id: terminalComponent

        ETerminal {
        }
    }
    Component {
        id: infiniteComponent

        EInfiniteScroll {
            width: 240
            height: 100
            delegate: Item {
                width: 240
                height: 30
            }
            model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        }
    }
    Component {
        id: spyComponent

        SignalSpy {
            signalName: "finished"
        }
    }
    Component {
        id: pageComponent

        Item {
            implicitHeight: 40
        }
    }
    Component {
        id: headerComponent

        Item {
            width: 80
            height: 30
        }
    }
    Component {
        id: footerComponent

        Item {
            width: 20
            height: 22
        }
    }
    Component {
        id: cardComponent

        ECard {
            footerDelegate: footerComponent
            headerDelegate: headerComponent

            Item {
                width: 10
                height: 10
            }
        }
    }
    Component {
        id: timelineComponent

        ETimeline {
            contentDelegate: headerComponent
            model: [{content: "Body", timestamp: "Now"}]
        }
    }
    Component {
        id: collapseComponent

        ECollapse {
            activeNames: ["a"]
            contentDelegate: headerComponent
            model: [{name: "a", title: "First", content: "Body"}]
        }
    }
    Component {
        id: statisticComponent

        EStatistic {
            value: 12
            titleDelegate: headerComponent
            prefixDelegate: footerComponent
            suffixDelegate: footerComponent
        }
    }
    Component {
        id: paletteComponent

        Item {
            id: owner

            property alias palette: palette

            width: 800
            height: 600

            ECommandPalette {
                id: palette

                shortcut: ""
                parent: owner
                model: [{text: "Open project", description: "Choose workspace"},
                    {text: "Disabled", enabled: false}, {text: "Open folder", description: "Folder workspace"}]
            }
        }
    }
    Component {
        id: stepsComponent

        ESteps {
            property int selectedStep: 0

            active: selectedStep
            model: ["First", "Second", "Third"]
        }
    }
    Component {
        id: wizardComponent

        EWizard {
            model: [{title: "First"}, {title: "Disabled", disabled: true}, {title: "Last"}]
        }
    }
    Component {
        id: dialogComponent

        EDynamicDialog {
            enterDuration: 0
            destroyOnClose: false
        }
    }
    Component {
        id: dialogSwitchComponent

        Item {
            id: owner

            property int firstCreated: 0
            property alias dialog: dialog
            property int secondCreated: 0
            property alias firstPage: firstPage
            property alias secondPage: secondPage

            EDynamicDialog {
                id: dialog

                exitDuration: 0
                enterDuration: 0
                destroyOnClose: false
            }
            Component {
                id: firstPage

                Item {
                    property string firstName: ""

                    implicitHeight: 40

                    Component.onCompleted: ++owner.firstCreated
                }
            }
            Component {
                id: secondPage

                Item {
                    property string secondName: ""

                    implicitHeight: 40

                    Component.onCompleted: ++owner.secondCreated
                }
            }
        }
    }
    Component {
        id: imageComponent

        EImage {
            errorDelegate: Component {
                Rectangle {
                    color: "#6080c0"
                    objectName: "errorContent"
                }
            }
        }
    }
    Component {
        id: anchorComponent

        Item {
            property alias anchor: anchor

            Flickable {
                id: target

                width: 240
                height: 100
                contentHeight: 600

                Item {
                    id: first

                    y: 0
                }
                Item {
                    id: last

                    y: 200
                }
            }
            EAnchor {
                id: anchor

                target: target
                model: [{text: "First", target: first}, {text: "Last", target: last}]
            }
        }
    }
}
