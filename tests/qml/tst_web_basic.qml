import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function test_textWebOptions() {
        const text = createTemporaryObject(textComponent, testCase)
        verify(text !== null)
        compare(text.elide, Text.ElideRight)
        text.truncated = false
        text.lineClamp = 2
        compare(text.maximumLineCount, 2)
        compare(text.wrapMode, Text.Wrap)
        text.type = "danger"
        compare(text.color, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger))
    }

    function test_spaceWrapAndPairGaps() {
        const space = createTemporaryObject(spaceComponent, testCase)
        verify(space !== null)
        wait(0)
        compare(space.children[0].children[1].x, 70)
        compare(space.children[0].children[2].y, 50)
        space.wrap = false
        wait(0)
        compare(space.children[0].children[2].x, 140)
        compare(space.children[0].children[2].y, 0)
        space.direction = "vertical"
        space.height = 200
        wait(0)
        compare(space.children[0].children[1].y, 50)
    }

    function test_rapidSplitterCollapseEvents() {
        const splitter = createTemporaryObject(splitComponent, testCase)
        verify(waitForItemPolished(splitter))
        splitter.itemAt(1).collapsible = true
        let events = []
        splitter.collapsed.connect(function(index, side, sizes) {
            events.push({index: index, side: side})
        })
        verify(splitter.collapsePanel(0, true, "start"))
        verify(splitter.collapsePanel(1, true, "end"))
        tryCompare(events, "length", 2)
        compare(events[0], {index: 0, side: "start"})
        compare(events[1], {index: 1, side: "end"})
    }

    function test_manualScrollAndEndEvent() {
        const scrollbar = createTemporaryObject(scrollComponent, testCase)
        verify(scrollbar !== null)
        tryVerify(function() {
            return scrollbar.contentHeight > 100
        })
        verify(scrollbar.scrollTarget !== null)
        scrollbar.setScrollTop(100)
        compare(scrollbar.scrollTop, 100)
        scrollbar.scrollTo({top: 10000})
        compare(scrollbar.scrollTop, scrollbar.scrollTarget.contentHeight - scrollbar.scrollTarget.height)
        verify(scrollbar.bottomReached)
        scrollbar.setScrollTop(NaN)
        verify(scrollbar.bottomReached)
        scrollbar.scrollTo({top: 0})
        compare(scrollbar.scrollTop, 0)
        verify(scrollbar.topReached)
    }

    function test_gridResponsiveOffsetsAlignment() {
        const row = createTemporaryObject(gridComponent, testCase)
        verify(row !== null)
        wait(0)
        compare(row.children[0].width, 194)
        compare(row.children[1].x, 206)
        row.children[0].offset = 6
        wait(0)
        compare(row.children[0].x, 103)
        verify(row.children[1].y >= 52)
        row.children[0].offset = 0
        row.children[0].xs = 24
        row.children[0].md = {span: 8, push: 2}
        row.viewportWidth = 1024
        wait(0)
        compare(row.children[0].effectiveSpan, 8)
        compare(row.children[0].effectivePush, 2)
        row.viewportWidth = 600
        wait(0)
        compare(row.children[0].effectiveSpan, 24)
        row.children[0].xs = 6
        row.children[1].span = 6
        row.justify = "space-between"
        row.align = "bottom"
        wait(0)
        compare(row.children[1].x + row.children[1].width, row.width)
        compare(row.children[1].y, 20)
    }

    function test_textareaAutosizeLimitAndSlots() {
        const area = createTemporaryObject(areaComponent, testCase)
        verify(area !== null)
        area.text = "one\ntwo\nthree\nfour\nfive"
        verify(area.height <= area.lineHeight * 3 + area.topPadding + area.bottomPadding + 1)
        verify(area.height >= area.lineHeight * 2)
        area.maximumLength = 4
        area.text = "abcdef"
        compare(area.text, "abcd")
        area.text = "a😀b"
        compare(area.wordCount, 3)
        area.maximumLength = 2
        area.text = "a😀b"
        compare(area.text, "a")
        area.autosize = false
        area.height = 200
        area.text = "short"
        compare(area.height, 200)
        const button = createTemporaryObject(iconButtonComponent, testCase)
        verify(button !== null)
        verify(findChild(button, "customButtonIcon"))
        button.loading = true
        tryVerify(function() {
            return findChild(button, "customButtonLoading") !== null
        })
        verify(button.dashed)
        compare(button.background.border.width, 0)
    }

    function test_splitterEndCollapseAndFinalEventSizes() {
        const splitter = createTemporaryObject(splitComponent, testCase)
        verify(waitForItemPolished(splitter))
        splitter.itemAt(0).collapsible = false
        splitter.itemAt(1).collapsible = true
        const end = findChild(splitter, "splitterCollapseEnd")
        verify(end !== null && end.visible)
        let finalSizes = []
        let collapsedSizes = []
        splitter.resizeEnd.connect(function(index, sizes) {
            finalSizes = sizes.slice()
        })
        splitter.collapsed.connect(function(index, side, sizes) {
            collapsedSizes = sizes.slice()
        })
        const old = splitter.itemAt(0).width
        mousePress(splitter, old + 3, 10)
        mouseMove(splitter, old + 33, 10)
        mouseRelease(splitter, old + 33, 10)
        tryCompare(splitter.itemAt(0), "width", old + 30)
        tryVerify(function() {
            return finalSizes.length === 2
        })
        compare(finalSizes[0], splitter.itemAt(0).width)
        mouseClick(end)
        tryCompare(splitter.itemAt(1), "width", 0)
        tryVerify(function() {
            return collapsedSizes.length === 2
        })
        compare(collapsedSizes[1], 0)
    }

    function test_avatarSourcesAndCountdownTokens() {
        const avatar = createTemporaryObject(avatarComponent, testCase)
        verify(avatar !== null)
        compare(String(avatar.effectiveSource), "qrc:/qt/qml/EUI/font/icons/GITHUB_LIGHT.svg")
        avatar.srcset = "invalid -1x"
        compare(String(avatar.effectiveSource), String(avatar.source))
        const statistic = createTemporaryObject(statisticComponent, testCase)
        statistic.value = Date.now() + 90061000
        statistic.format = "HH:mm:ss [remaining]"
        verify(statistic.displayValue.indexOf("25:01:") === 0)
        verify(statistic.displayValue.indexOf("remaining") > 0)
        statistic.format = "D [days] H [hours] m [minutes] s"
        verify(statistic.displayValue.indexOf("1 days 1 hours 1 minutes ") === 0)
        statistic.format = "mm"
        compare(statistic.displayValue, "1501")
        const progress = createTemporaryObject(progressComponent, testCase)
        compare(findChild(progress, "progressTrack").radius, 0)
        progress.strokeLinecap = "round"
        verify(findChild(progress, "progressTrack").radius > 0)
    }

    function test_splitterPanelAndLazyResize() {
        const splitter = createTemporaryObject(splitComponent, testCase)
        verify(splitter !== null)
        verify(waitForItemPolished(splitter))
        compare(splitter.count, 2)
        const first = splitter.itemAt(0)
        const second = splitter.itemAt(1)
        compare(first.width, 180)
        verify(second.width >= 100)
        splitter.initialSizes = splitter.panelSizes()
        verify(splitter.resizePanels(0, 40))
        wait(0)
        tryCompare(first, "width", 220)
        verify(splitter.collapsePanel(0, true))
        wait(0)
        tryCompare(first, "width", 0)
        verify(splitter.collapsePanel(0, false))
        wait(0)
        tryCompare(first, "width", 220)
        splitter.initialSizes = []
        splitter.lazy = false
        const width = first.width
        mouseDrag(splitter, first.width + 3, 10, 20, 0)
        tryCompare(first, "width", width + 20)
        splitter.lazy = true
        const lazyWidth = first.width
        mousePress(splitter, first.width + 3, 10)
        mouseMove(splitter, first.width + 33, 10)
        compare(first.width, lazyWidth)
        mouseRelease(splitter, first.width + 33, 10)
        tryCompare(first, "width", lazyWidth + 30)
        first.resizable = false
        verify(!splitter.resizePanels(0, 20))
    }

    function test_nestedProviderAndOverrides() {
        const provider = createTemporaryObject(providerComponent, testCase)
        verify(provider !== null)
        const button = findChild(provider, "providerButton")
        compare(button.plain, true)
        compare(button.round, true)
        compare(button.styleType, EStyle.Danger)
        compare(button.displayText, "保 存")
        provider.button = {plain: false, round: false, type: "success", autoInsertSpace: false}
        compare(button.plain, false)
        compare(button.round, false)
        compare(button.styleType, EStyle.Success)
        compare(button.displayText, "保存")
        const dialog = findChild(provider, "providerDialog")
        compare(dialog.draggable, true)
        compare(dialog.cancelText, "Cancel")
        const drawer = findChild(provider, "providerDrawer")
        compare(drawer.z, 27)
        const nested = findChild(provider, "nestedProvider")
        compare(nested.localizedTexts.NoData, "No data")
        provider.locale = {name: "zh", texts: {NoData: "自定义空状态"}}
        compare(nested.localizedTexts.NoData, "自定义空状态")
        compare(dialog.cancelText, "取消")
        nested.locale = "en"
        compare(nested.localizedTexts.NoData, "No data")
        const link = findChild(provider, "providerLink")
        compare(link.font.underline, true)
        provider.link = {underline: "never"}
        compare(link.font.underline, false)
    }

    width: 900
    height: 700
    visible: true
    when: windowShown
    name: "EUIWebBasic"

    Component {
        id: gridComponent

        ERow {
            gutter: 12
            width: 400

            ECol {
                span: 12
                height: 40
            }
            ECol {
                span: 12
                height: 20
            }
        }
    }
    Component {
        id: spaceComponent

        ESpace {
            width: 150
            size: [10, 20]

            Item {
                width: 60
                height: 30
            }
            Item {
                width: 60
                height: 30
            }
            Item {
                width: 60
                height: 30
            }
        }
    }
    Component {
        id: textComponent

        EText {
            width: 100
            truncated: true
            text: "A long text that is truncated"
        }
    }
    Component {
        id: providerComponent

        EConfigProvider {
            zIndex: 27
            locale: "en"
            dialog: ({draggable: true})
            link: ({underline: "always"})
            button: ({plain: true, round: true, type: "danger", autoInsertSpace: true})

            EDialog {
                objectName: "providerDialog"
            }
            EDrawer {
                objectName: "providerDrawer"
            }
            EConfigProvider {
                objectName: "nestedProvider"

                EButton {
                    text: "保存"
                    objectName: "providerButton"
                }
                ELink {
                    text: "Link"
                    objectName: "providerLink"
                }
            }
        }
    }
    Component {
        id: scrollComponent

        EScrollbar {
            width: 100
            height: 100

            Column {
                width: 100

                Repeater {
                    model: 20

                    Item {
                        height: 20
                        width: 100
                    }
                }
            }
        }
    }
    Component {
        id: splitComponent

        ESplitter {
            lazy: true
            width: 500
            height: 100

            ESplitterPanel {
                min: 100
                size: 180
                collapsible: true
            }
            ESplitterPanel {
                min: 100
                SplitView.fillWidth: true
            }
        }
    }
    Component {
        id: areaComponent

        ETextArea {
            width: 240
            showWordLimit: true
            autosize: ({minRows: 2, maxRows: 3})
        }
    }
    Component {
        id: iconButtonComponent

        EButton {
            dashed: true
            leftIcon: true
            text: "Action"
            iconComponent: Component {
                EText {
                    text: "✓"
                    objectName: "customButtonIcon"
                }
            }
            loadingComponent: Component {
                EText {
                    text: "…"
                    objectName: "customButtonLoading"
                }
            }
        }
    }
    Component {
        id: avatarComponent

        EAvatar {
            source: "qrc:/qt/qml/EUI/font/icons/GITHUB_DARK.svg"
            srcset: "qrc:/qt/qml/EUI/font/icons/GITHUB_DARK.svg 0.001x, qrc:/qt/qml/EUI/font/icons/GITHUB_LIGHT.svg 1000x"
        }
    }
    Component {
        id: statisticComponent

        EStatistic {
            countdown: true
        }
    }
    Component {
        id: progressComponent

        EProgress {
            value: 0.5
            width: 200
            strokeLinecap: "butt"
        }
    }
}
