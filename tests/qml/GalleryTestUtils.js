.pragma library

function sections(root) {
    const result = []
    const pending = [root]
    while (pending.length > 0) {
        const item = pending.pop()
        if (item.loadedCard !== undefined && item.componentName !== undefined
            && item.objectName !== "galleryApiLoader")
            result.push(item)
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            pending.push(children[index])
    }
    return result
}

function loadExamples(testCase, page) {
    while (true) {
        testCase.verify(testCase.waitForItemPolished(page))
        const pending = sections(page).filter(function(section) {
            return section.selected && section.loadedCard === null
        }).sort(function(left, right) {
            return left.mapToItem(page.contentItem, 0, 0).y - right.mapToItem(page.contentItem, 0, 0).y
        })
        if (pending.length === 0)
            break
        const section = pending[0]
        testCase.tryVerify(function() {
            page.contentY = Math.max(0, section.mapToItem(page.contentItem, 0, 0).y - 16)
            return section.loadedCard !== null
        })
    }
    page.contentY = 0
    testCase.verify(testCase.waitForItemPolished(page))
    for (const section of sections(page)) {
        if (section.selected)
            testCase.tryVerify(function() { return section.loadedCard.implicitHeight > 0 })
    }
}
