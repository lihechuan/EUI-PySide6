import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function sourcesIn(item) {
        let sources = []
        if (item.code !== undefined && item.code.length > 0 && item.objectName !== "galleryCodeExpander")
            sources.push(item.code)
        for (let index = 0; index < item.children.length; ++index)
            sources = sources.concat(sourcesIn(item.children[index]))
        return sources
    }

    function test_copiedExamples_data() {
        return [{tag: "form", page: "WebFormExamples.qml"}, {tag: "dates", page: "WebFormDateExamples.qml"},
            {tag: "basic", page: "WebBasicExamples.qml"}, {tag: "data", page: "WebDataExamples.qml"},
            {tag: "table", page: "WebTableExamples.qml"}, {tag: "navigation", page: "WebNavigationFeedbackExamples.qml"},
            {tag: "upload", page: "WebFormUploadExamples.qml"}]
    }

    function test_copiedExamples(data) {
        const component = Qt.createComponent("../../example/qml/component/" + data.page)
        compare(component.status, Component.Ready, component.errorString())
        const page = createTemporaryObject(component, testCase, {width: 1000, height: 700})
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        const sources = sourcesIn(page)
        verify(sources.length > 0)
        for (let index = 0; index < sources.length; ++index) {
            let example = null
            try {
                example = Qt.createQmlObject(sources[index], testCase, "copied-"
                    + data.tag
                    + "-"
                    + index
                    + ".qml")
            } catch (error) {
                fail(String(error))
            }
            verify(example !== null)
            example.destroy()
        }
    }

    height: 800
    width: 1200
    visible: true
    when: windowShown
    name: "EUIWebGallery"
}
