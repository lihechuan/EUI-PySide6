import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ELocale.language = "en"
    }

    function test_playground_data() {
        return [{tag: "zh", language: "zh"}, {tag: "en", language: "en"}]
    }

    function test_playground(data) {
        ELocale.language = data.language
        const entry = exampleCatalog.find("EAnimation")
        compare(entry.source, "AnimationExamples.qml")
        const definition = Qt.createComponent("../../example/qml/component/AnimationExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase,
            {width: 1040, height: 820, selectedComponent: "EAnimation"})
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        compare(page.exampleCount, 5)
        page.contentY = 0
        const selector = findChild(page, "animationEffectSelector")
        const category = findChild(page, "animationCategorySelector")
        const duration = findChild(page, "animationDurationInput")
        const distance = findChild(page, "animationDistanceInput")
        const target = findChild(page, "animationPreviewCard")
        const play = findChild(page, "animationPlayButton")
        const reset = findChild(page, "animationResetButton")
        const invocation = findChild(page, "animationInvocation")
        page.contentY = invocation.mapToItem(page.contentItem, 0, 0).y - 80
        verify(waitForRendering(page))
        const pointer = findChild(invocation, "animationSourcePointer")
        verify(pointer !== null)
        mouseMove(invocation, 12, invocation.height / 2)
        tryCompare(pointer, "containsMouse", true)
        compare(galleryTest.cursorShape(pointer), Qt.ArrowCursor)
        page.contentY = 0
        compare(category.count, 9)
        compare(selector.count, 83)
        verify(findChild(page, "animationEffectCount").text.indexOf("83") >= 0)
        duration.value = 0
        distance.value = 32
        for (let index = 0; index < EAnimation.effects.length; ++index) {
            selector.currentIndex = index
            const effect = EAnimation.effects[index]
            compare(selector.currentText, effect)
            verify(invocation.text.indexOf('"' + effect + '"') >= 0)
            verify(invocation.text.indexOf("duration: 0") >= 0)
            verify(invocation.text.indexOf("distance: 32") >= 0)
            play.clicked()
            compare(target.opacity, effect.indexOf("Out") >= 0 ? 0 : 1)
            reset.clicked()
            compare(target.opacity, 1)
        }
        const counts = [83, 18, 8, 12, 13, 11, 5, 12, 4]
        let filtered = []
        for (let index = 1; index < category.count; ++index) {
            category.currentIndex = index
            compare(selector.count, counts[index])
            compare(selector.currentIndex, 0)
            for (let effectIndex = 0; effectIndex < selector.count; ++effectIndex) {
                selector.currentIndex = effectIndex
                const effect = selector.currentText
                verify(filtered.indexOf(effect) < 0, effect + " belongs to one category")
                filtered.push(effect)
                verify(invocation.text.indexOf('"' + effect + '"') >= 0)
                play.clicked()
                compare(target.opacity, effect.indexOf("Out") >= 0 ? 0 : 1)
                reset.clicked()
            }
        }
        compare(filtered.length, 83)
        category.currentIndex = 0
        compare(selector.count, 83)
        for (let index = 0; index < 5; ++index) {
            const scenario = findChild(page, "showcaseEAnimation" + index)
            verify(scenario !== null && scenario.code.length > 0)
            const sample = Qt.createQmlObject(scenario.code, testCase)
            verify(sample !== null)
            sample.destroy()
        }
        page.width = 600
        verify(waitForItemPolished(page))
        verify(play.width > 0 && invocation.width < 600)
        definition.destroy()
    }

    height: 850
    width: 1100
    visible: true
    when: windowShown
    name: "EUIAnimationGallery"
}
