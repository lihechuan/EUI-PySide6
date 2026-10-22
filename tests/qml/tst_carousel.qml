import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_navigationAndModelChanges() {
        const carousel = createTemporaryObject(carouselComponent, testCase)
        verify(carousel !== null)
        const slides = findChild(carousel, "carouselSlides")
        verify(slides !== null)
        verify(waitForItemPolished(carousel))
        for (let index = 0; index < slides.count; ++index) {
            tryCompare(slides.itemAt(index), "width", slides.width)
            tryCompare(slides.itemAt(index), "height", slides.height)
        }
        verify(carousel.setCurrentIndex(1))
        compare(carousel.currentIndex, 1)
        tryCompare(slides.contentItem, "currentIndex", 1)
        wait(300)
        mouseDrag(slides, 300, 80, -240, 0, Qt.LeftButton, Qt.NoModifier, 50)
        tryCompare(carousel, "currentIndex", 2)
        tryCompare(slides.contentItem, "currentIndex", 2)
        carousel.width = 520
        carousel.height = 210
        tryCompare(slides.itemAt(2), "width", 520)
        tryCompare(slides.itemAt(2), "height", 210)
        carousel.direction = "vertical"
        tryCompare(slides, "orientation", Qt.Vertical)
        tryCompare(slides.itemAt(2), "height", 210)
        carousel.model = ["A", "B"]
        tryCompare(carousel, "count", 2)
        tryVerify(function() {
            return carousel.currentIndex >= 0 && carousel.currentIndex < 2
        })
        tryCompare(slides.contentItem, "currentIndex", carousel.currentIndex)
        carousel.autoplay = true
        carousel.pauseOnHover = false
        const previous = carousel.currentIndex
        tryVerify(function() { return carousel.currentIndex !== previous })
        carousel.visible = false
        carousel.destroy()
        wait(20)
    }

    width: 600
    height: 400
    visible: true
    when: windowShown
    name: "CarouselInteraction"

    Component {
        id: carouselComponent

        ECarousel {
            width: 400
            height: 180
            interval: 100
            autoplay: false
            model: ["A", "B", "C", "D"]
            delegate: Rectangle {
                color: "red"
            }
        }
    }
}
