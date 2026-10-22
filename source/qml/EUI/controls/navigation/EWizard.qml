import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property bool lazy: true
    property int currentIndex: 0
    property bool allowJump: false
    property var beforeLeave: null
    property bool showCancel: true
    property string nextText: EControlConfig.textFor(control, "WizardNext", ELocale.texts)
    property string finishText: EControlConfig.textFor(control, "WizardFinish", ELocale.texts)
    property string previousText: EControlConfig.textFor(control, "WizardPrevious", ELocale.texts)

    readonly property bool busy: internal.busy
    readonly property bool complete: internal.complete
    readonly property bool hasNext: adjacent(currentIndex, 1) >= 0
    readonly property bool hasPrevious: adjacent(currentIndex, -1) >= 0
    readonly property var currentPage: {
        internal.pagesRevision
        const page = pageRepeater.itemAt(currentIndex)
        return page ? page.item : null
    }
    readonly property var pages: EDataUtils.isArray(model) ? model.map(function(page) {
        return page && typeof page === "object" ? page : {disabled: true}
    }) : []

    signal canceled()
    signal completed()
    signal stepChanged(int index)
    signal navigationRejected(int index, string reason)

    function previous() {
        return navigate(adjacent(currentIndex, -1))
    }

    function finish() {
        return !hasNext && currentIndex >= 0 ? navigate(pages.length) : false
    }

    function next() {
        const index = adjacent(currentIndex, 1)
        return index >= 0 ? navigate(index) : finish()
    }

    function reset() {
        ++internal.revision
        internal.busy = false
        internal.complete = false
        currentIndex = adjacent(-1, 1)
    }

    function adjacent(index, direction) {
        for (let next = index + direction; next >= 0 && next < pages.length; next += direction) {
            if (pages[next] && !pages[next].disabled)
                return next
        }
        return -1
    }

    function commit(index, revision, result) {
        if (!internal || revision !== internal.revision || !enabled)
            return false
        internal.busy = false
        if (result === false) {
            navigationRejected(index, "validation")
            return false
        }
        if (index === pages.length) {
            internal.complete = true
            completed()
        } else {
            currentIndex = index
        }
        return true
    }

    function navigate(index) {
        if (!enabled || busy || complete || currentIndex < 0 || Math.floor(index) !== index || index < 0
            || index > pages.length || index === pages.length && hasNext || index < pages.length && (!pages[index] || pages[index].disabled))
            return false
        if (index === currentIndex)
            return true
        const revision = ++internal.revision
        try {
            const result = typeof beforeLeave === "function" ? beforeLeave(currentIndex, index) : true
            if (result && typeof result.then === "function") {
                internal.busy = true
                result.then(function(valid) {
                    if (control)
                        control.commit(index, revision, valid)
                }, function(error) {
                    if (internal && revision === internal.revision) {
                        internal.busy = false
                        navigationRejected(index, String(error))
                    }
                })
                return true
            }
            return commit(index, revision, result)
        } catch (error) {
            internal.busy = false
            navigationRejected(index, String(error))
            return false
        }
    }

    padding: 16
    implicitWidth: 560
    implicitHeight: steps.implicitHeight + pagesArea.implicitHeight + navigation.implicitHeight + 32
        + topPadding + bottomPadding
    contentItem: Column {
        spacing: 16

        ESteps {
            id: steps

            width: parent.width
            objectName: "wizardSteps"
            clickable: control.allowJump && !control.busy && !control.complete
            active: control.complete ? control.pages.length : control.currentIndex
            model: control.pages.map(function(page) {
                return {title: page.title || "", description: page.description || "", disabled: !!page.disabled}
            })

            onStepClicked: function(index) {
                control.navigate(index)
                active = Qt.binding(function() { return control.complete ? control.pages.length : control.currentIndex })
            }
        }
        Item {
            id: pagesArea

            width: parent.width
            height: Math.max(0, control.availableHeight - steps.height - navigation.height - 32)
            implicitHeight: control.currentPage ? Math.max(160, control.currentPage.implicitHeight) : 160

            Repeater {
                id: pageRepeater

                model: control.pages

                onItemAdded: ++internal.pagesRevision
                onItemRemoved: ++internal.pagesRevision

                Loader {
                    property bool visited: false

                    anchors.fill: parent
                    visible: index === control.currentIndex
                    active: !control.lazy || visible || visited
                    sourceComponent: modelData.component && typeof modelData.component.createObject === "function"
                        ? modelData.component : null

                    onLoaded: visited = true
                }
            }
        }
        Row {
            id: navigation

            spacing: 8
            width: parent.width

            EButton {
                enabled: !control.busy
                visible: control.showCancel
                text: EControlConfig.textFor(control, "Cancel2", ELocale.texts)

                onClicked: control.canceled()
            }
            Item {
                height: 1
                width: Math.max(0, navigation.width - previousButton.width - nextButton.width
                    - (control.showCancel ? navigation.children[0].width : 0)
                    - navigation.spacing * (control.showCancel ? 3 : 2))
            }
            EButton {
                id: previousButton

                text: control.previousText
                objectName: "wizardPrevious"
                enabled: control.hasPrevious && !control.busy && !control.complete

                onClicked: control.previous()
            }
            EButton {
                id: nextButton

                loading: control.busy
                objectName: "wizardNext"
                styleType: EStyle.Primary
                text: control.hasNext ? control.nextText : control.finishText
                enabled: control.currentIndex >= 0 && !control.busy && !control.complete

                onClicked: control.next()
            }
        }
    }

    onModelChanged: reset()
    onEnabledChanged: if (!enabled) {
        ++internal.revision
        internal.busy = false
    }
    onCurrentIndexChanged: {
        ++internal.revision
        internal.busy = false
        if (!isFinite(currentIndex) || Math.floor(currentIndex) !== currentIndex
            || currentIndex >= pages.length || currentIndex < -1 || currentIndex >= 0 && pages[currentIndex].disabled)
            currentIndex = adjacent(-1, 1)
        else
            stepChanged(currentIndex)
    }

    QtObject {
        id: internal

        property int revision: 0
        property bool busy: false
        property bool complete: false
        property int pagesRevision: 0
    }
}
