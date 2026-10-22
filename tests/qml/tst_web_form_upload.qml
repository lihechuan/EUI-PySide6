import EUI 1.0
import EUI 1.0 as FormControls
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_readonlyMentionAndAutocompleteEnterGuard() {
        const mention = createTemporaryObject(mentionComponent, testCase, {readOnly: true, text: "@Alice "})
        mention.cursorPosition = 6
        verify(!mention.removeWhole())
        compare(mention.text, "@Alice ")
        const autocomplete = createTemporaryObject(autocompleteComponent, testCase,
            {text: "", model: ["Chosen"], highlightFirstItem: true})
        autocomplete.open()
        compare(autocomplete.highlightedIndex, 0)
        autocomplete.readOnly = true
        verify(!autocomplete.handleKeyEnter())
        compare(autocomplete.text, "")
    }

    function test_localProviderTexts() {
        const provider = createTemporaryObject(providerComponent, testCase)
        const upload = findChild(provider, "providerUpload")
        const autocomplete = findChild(provider, "providerAutocomplete")
        compare(findChild(upload, "uploadSelectButton").text, provider.localizedTexts.SelectFiles)
        compare(upload.nameFilters[0], provider.localizedTexts.AllFiles)
        autocomplete.open()
        const loading = findChild(autocomplete.popperRef, "autocompleteLoadingText")
        verify(loading)
        compare(loading.text, provider.localizedTexts.Loading)
        autocomplete.close()
    }

    function test_uploadPublicOperations() {
        const item = createTemporaryObject(uploadComponent, testCase)
        verify(typeof item.handleStart === "function")
        verify(typeof item.handleRemove === "function")
        verify(typeof item.abort === "function")
        verify(item.handleStart(Qt.resolvedUrl("../../assets/eui-mark.svg")))
        compare(item.fileList.length, 1)
        verify(item.fileList[0].uid > 0)
        verify(!item.handleStart(Qt.resolvedUrl("../../assets/eui-mark.svg")))
        verify(!item.upload(NaN))
        verify(!item.removeFile(0.5))
        verify(item.handleRemove(item.fileList[0]))
        compare(item.fileList.length, 0)
    }

    function test_uploadTransformedLocalFile() {
        const item = createTemporaryObject(uploadComponent, testCase)
        item.fileList = [{uid: 1, url: "file:///before.svg", name: "before.svg", status: "ready"}]
        const url = Qt.resolvedUrl("../../assets/eui-mark.svg")
        let request = null
        item.beforeUpload = function() {
            return {url: url}
        }
        item.httpRequest = function(options) {
            request = options
        }
        verify(item.upload(0))
        compare(String(request.file.url), String(url))
        compare(item.fileList[0].uid, 1)
        compare(item.fileList[0].name, "eui-mark.svg")
        request.onSuccess("ok")
        verify(item.clearFiles())
    }

    function test_uploadDirectoryAndDisabledSelection() {
        const item = createTemporaryObject(
            uploadComponent,
            testCase,
            {directory: true, accept: ".svg", limit: 2}
        )
        verify(item.addDirectories([Qt.resolvedUrl("../../assets")]))
        verify(item.fileList.length > 0 && item.fileList.length <= 2)
        item.fileList.forEach(function(file) {
            verify(file.relativePath.length > 0)
            verify(file.relativePath.indexOf("..") < 0)
            verify(/\.svg$/i.test(file.relativePath))
        })
        const count = item.fileList.length
        item.enabled = false
        verify(!item.addDirectories([Qt.resolvedUrl("../../assets")]))
        verify(!item.handleStart(Qt.resolvedUrl("../../assets/eui-mark.svg")))
        compare(item.fileList.length, count)
    }

    function test_uploadDataFailuresAndRemoveWhilePreparing() {
        const item = createTemporaryObject(uploadComponent, testCase)
        item.fileList = [{uid: 1, url: "file:///a.txt", name: "a.txt", status: "ready"}]
        let requests = 0
        item.httpRequest = function() {
            ++requests
        }
        item.data = function() {
            throw new Error("Bad data")
        }
        verify(!item.upload(0))
        compare(item.fileList[0].status, "error")
        verify(item.lastError.indexOf("Bad data") >= 0)
        let resolve = null
        item.data = {token: 1}
        item.beforeUpload = function() {
            return {then: function(allow) {
                resolve = allow
            }}
        }
        verify(item.upload(0))
        verify(item.handleRemove(item.fileList[0]))
        resolve(true)
        compare(item.fileList.length, 0)
        compare(requests, 0)
        verify(!item.uploading)
    }

    function test_autocompleteLoadingAndAsyncRevisions() {
        const item = createTemporaryObject(
            autocompleteComponent,
            testCase,
            {x: 100, y: 180, width: 260, debounce: 0}
        )
        item.loadingDelegate = loadingComponent
        const replies = []
        item.fetchSuggestions = function(query, callback) {
            replies.push(callback)
        }
        item.getData("old")
        item.getData("new")
        replies[0](["Old"])
        verify(item.loading)
        item.open()
        tryVerify(function() {
            return findChild(item.popperRef, "customSuggestionLoading") !== null
        })
        item.hideLoading = true
        tryVerify(function() {
            return findChild(item.popperRef, "customSuggestionLoading") === null
        })
        replies[1](["New", "Newest"])
        compare(item.suggestions[0].label, "New")
        verify(!item.loading)
        verify(!item.choose(0.5))
        verify(item.handleSelect("Newest"))
        compare(item.text, "Newest")
        verify(!item.activated)
    }

    function test_mentionTextareaKeyboardAndSplit() {
        const item = createTemporaryObject(mentionComponent, testCase, {type: "textarea", width: 340, x: 100, y: 40,
            whole: true, props: {label: "name", value: "key"}, options: [{name: "Alice", key: "alice"}]})
        tryVerify(function() {
            return findChild(item, "mentionTextarea") !== null
        })
        const editor = findChild(item, "mentionTextarea")
        editor.forceActiveFocus()
        editor.text = "First line\n@al tail"
        editor.cursorPosition = 14
        compare(item.text, "First line\n@al tail")
        compare(item.cursorPosition, 14)
        compare(item.matches.length, 1)
        item.open()
        tryVerify(function() {
            return item.dropdownVisible
        })
        keyClick(Qt.Key_Return)
        compare(item.text, "First line\n@alice tail")
        compare(editor.text, item.text)
        compare(editor.cursorPosition, 18)
        keyClick(Qt.Key_Backspace)
        compare(item.text, "First line\ntail")
        compare(editor.cursorPosition, 11)
        item.split = ","
        editor.text = "@al,b"
        editor.cursorPosition = 3
        verify(item.choose(0))
        compare(item.text, "@alice,b")
        compare(editor.cursorPosition, 7)
    }

    function test_mentionSlotsAndValues() {
        const item = createTemporaryObject(mentionComponent, testCase, {x: 24, y: 200, width: 260,
            options: [{label: "Alice Smith", value: "alice"}, {label: "Bob", value: "bob", disabled: true}]})
        verify(item.labelDelegate !== undefined)
        item.labelDelegate = optionComponent
        item.headerDelegate = headerComponent
        item.footerDelegate = footerComponent
        item.loadingDelegate = loadingComponent
        item.placement = "top"
        item.offset = 12
        item.text = "Hi @al tail"
        item.cursorPosition = 6
        item.forceActiveFocus()
        item.open()
        tryVerify(function() {
            return item.tooltip.visible
        })
        verify(item.tooltip.y < -12)
        const list = findChild(item.tooltip, "mentionSuggestionList")
        tryCompare(list, "count", 1)
        verify(findChild(list.itemAtIndex(0), "customSuggestionOption"))
        verify(item.choose(0))
        compare(item.text, "Hi @alice tail")
        compare(item.cursorPosition, 10)
        item.whole = true
        verify(item.removeWhole())
        compare(item.text, "Hi tail")
        item.text = "@"
        item.cursorPosition = 1
        item.loading = true
        item.open()
        tryVerify(function() {
            return findChild(item.tooltip, "customSuggestionLoading") !== null
        })
        item.close()
    }

    function test_autocompleteSlotsAndKeyboard() {
        const item = createTemporaryObject(
            autocompleteComponent,
            testCase,
            {x: 100, y: 200, width: 260, model: ["Alpha", "Beta"]}
        )
        verify(item.optionDelegate !== undefined)
        item.optionDelegate = optionComponent
        item.headerDelegate = headerComponent
        item.footerDelegate = footerComponent
        item.placement = "top-end"
        item.popupWidth = 320
        item.fitInputWidth = false
        item.forceActiveFocus()
        item.open()
        tryVerify(function() {
            return item.popperRef.visible
        })
        verify(item.popperRef.y < 0)
        compare(item.popperRef.x, -60)
        verify(findChild(item.popperRef, "customSuggestionHeader"))
        verify(findChild(item.popperRef, "customSuggestionFooter"))
        const list = findChild(item.popperRef, "autocompleteSuggestionList")
        tryCompare(list, "count", 2)
        verify(findChild(list.itemAtIndex(0), "customSuggestionOption"))
        item.highlight(1)
        keyClick(Qt.Key_Down)
        compare(item.highlightedIndex, 0)
        keyClick(Qt.Key_Up)
        compare(item.highlightedIndex, 1)
        keyClick(Qt.Key_Return)
        compare(item.text, "Beta")
        verify(!item.activated)
        item.text = ""
        item.open()
        item.loopNavigation = false
        item.highlight(0)
        keyClick(Qt.Key_Up)
        compare(item.highlightedIndex, -1)
        item.close()
    }

    function test_uploadPictureWallAndSlots() {
        const item = createTemporaryObject(
            uploadComponent,
            testCase,
            {width: 320, listType: "picture-card", action: "https://example.test/upload"}
        )
        item.triggerDelegate = triggerComponent
        item.tipDelegate = tipComponent
        item.defaultDelegate = defaultComponent
        const url = Qt.resolvedUrl("../../assets/eui-mark.svg")
        item.fileList = [{url: url, name: "First.svg", status: "ready"},
            {url: url, name: "Second.svg", status: "success"}, {url: url, name: "Third.svg", status: "ready"}]
        const first = findChild(item, "uploadFileCard_0")
        const second = findChild(item, "uploadFileCard_1")
        const third = findChild(item, "uploadFileCard_2")
        tryCompare(first, "width", 144)
        compare(first.height, 144)
        tryVerify(function() {
            return second.mapToItem(item, 0, 0).x > first.mapToItem(item, 0, 0).x
        })
        tryVerify(function() {
            return third.mapToItem(item, 0, 0).y > second.mapToItem(item, 0, 0).y
        })
        verify(findChild(item, "customUploadTrigger"))
        verify(findChild(item, "customUploadTip"))
        verify(findChild(item, "customUploadDefault"))
        let previewed = null
        item.previewed.connect(function(file) {
            previewed = file
        })
        mouseClick(findChild(first, "uploadPreview_0"), 20, 20)
        compare(previewed.name, "First.svg")
        mouseClick(findChild(first, "uploadDelete_0"))
        compare(item.fileList.length, 2)
        item.fileDelegate = fileComponent
        tryVerify(function() {
            return findChild(item, "customUploadFile_1") !== null
        })
        const custom = findChild(item, "customUploadFile_1")
        compare(custom.file.name, "Third.svg")
        verify(custom.uploadControl === item)
    }

    function test_uploadAsyncDataProgressAndTargetAbort() {
        const item = createTemporaryObject(uploadComponent, testCase)
        item.fileList = [{uid: 1, url: "file:///first.txt", name: "first.txt", status: "ready"},
            {uid: 2, url: "file:///second.txt", name: "second.txt", status: "ready"},
            {uid: 3, url: "file:///third.txt", name: "third.txt", status: "ready"}]
        let resolveData = null
        const requests = []
        let aborted = 0
        item.data = function(file) {
            return {then: function(resolve) {
                resolveData = resolve
            }}
        }
        item.httpRequest = function(request) {
            requests.push(request)
            return {abort: function() {
                ++aborted
            }}
        }
        verify(item.submit())
        verify(item.uploading)
        compare(requests.length, 0)
        resolveData({path: "nested/first.txt"})
        compare(requests.length, 1)
        compare(requests[0].data.path, "nested/first.txt")
        requests[0].onProgress({percent: 37})
        compare(item.fileList[0].percentage, 37)
        verify(item.abort(item.fileList[1]))
        verify(item.uploading)
        item.data = {token: "next"}
        verify(item.abort(item.fileList[0]))
        compare(aborted, 1)
        requests[0].onSuccess("late")
        requests[0].onProgress(100)
        compare(item.fileList[0].status, "ready")
        tryCompare(requests, "length", 2)
        compare(requests[1].file.name, "third.txt")
        requests[1].onSuccess("ok")
        requests[1].onProgress(20)
        compare(item.fileList[2].status, "success")
        compare(item.fileList[2].percentage, 100)
        compare(item.fileList[2].response, "ok")
        verify(item.clearFiles(["success"]))
        compare(item.fileList.length, 2)
        let stale = null
        item.data = {then: function(resolve) {
            stale = resolve
        }}
        verify(item.upload(0))
        item.cancel()
        stale({ignored: true})
        compare(requests.length, 2)
        verify(!item.uploading)
    }

    function test_uploadDialogCreatedOnDemand() {
        const item = createTemporaryObject(uploadComponent, testCase, {enabled: false})
        verify(waitForItemPolished(item.contentItem))
        compare(findChild(item, "uploadFileDialog"), null)
        item.open()
        compare(findChild(item, "uploadFileDialog"), null)
        item.enabled = true
        item.multiple = false
        item.nameFilters = ["Images (*.svg)"]
        item.open()
        const dialog = findChild(item, "uploadFileDialog")
        verify(dialog !== null)
        tryCompare(dialog, "visible", true)
        const qt6Dialog = dialog.selectFolder === undefined
        if (qt6Dialog)
            compare(dialog.fileMode, 0)
        verify(!dialog.selectFolder)
        verify(!dialog.selectMultiple)
        compare(dialog.nameFilters[0], "Images (*.svg)")
        item.enabled = false
        tryCompare(dialog, "visible", false)
        item.directory = true
        item.multiple = true
        item.nameFilters = ["All files (*)"]
        if (qt6Dialog) {
            item.enabled = true
            item.open()
            tryVerify(function() { return findChild(item, "uploadFileDialog") !== dialog })
            const folder = findChild(item, "uploadFileDialog")
            verify(folder !== null && folder !== dialog)
            tryCompare(folder, "visible", true)
            folder.close()
            tryCompare(folder, "visible", false)
            item.directory = false
            item.open()
            tryVerify(function() { return findChild(item, "uploadFileDialog") !== folder })
            const files = findChild(item, "uploadFileDialog")
            verify(files !== null && files !== folder)
            compare(files.fileMode, 1)
            files.close()
            tryCompare(files, "visible", false)
            return
        }
        compare(dialog.selectFolder, true)
        compare(dialog.selectMultiple, false)
        compare(dialog.nameFilters[0], "All files (*)")
        item.directory = false
        compare(dialog.selectMultiple, true)
        item.enabled = true
        item.open()
        compare(findChild(item, "uploadFileDialog"), dialog)
        tryCompare(dialog, "visible", true)
        dialog.close()
        tryCompare(dialog, "visible", false)
    }

    width: 700
    height: 600
    visible: true
    when: windowShown
    name: "WebFormUploadParity"

    Component {
        id: providerComponent

        EConfigProvider {
            locale: ({name: "en", texts: {SelectFiles: "Local pick", AllFiles: "Local all", Loading: "Local wait"}})

            FormControls.EUpload { objectName: "providerUpload" }
            FormControls.EAutocomplete {
                loading: true
                objectName: "providerAutocomplete"
            }
        }
    }
    Component {
        id: uploadComponent

        FormControls.EUpload { width: 360 }
    }
    Component {
        id: autocompleteComponent

        FormControls.EAutocomplete {}
    }
    Component {
        id: mentionComponent

        FormControls.EMention {}
    }
    Component {
        id: triggerComponent

        EButton {
            property var uploadControl

            text: "Choose"
            objectName: "customUploadTrigger"

            onClicked: uploadControl.open()
        }
    }
    Component {
        id: tipComponent

        EText {
            text: "Tip"
            objectName: "customUploadTip"
        }
    }
    Component {
        id: defaultComponent

        EText {
            text: "Extra actions"
            objectName: "customUploadDefault"
        }
    }
    Component {
        id: fileComponent

        Item {
            property var file
            property int fileIndex: -1
            property var uploadControl

            implicitHeight: 40
            objectName: "customUploadFile_" + fileIndex

            EText { text: parent.file ? parent.file.name : "" }
        }
    }
    Component {
        id: optionComponent

        EText {
            property var option
            property int optionIndex: -1

            height: 32
            objectName: "customSuggestionOption"
            text: typeof option === "string" ? option : option ? option.label : ""
        }
    }
    Component {
        id: headerComponent

        EText {
            height: 24
            text: "Header"
            objectName: "customSuggestionHeader"
        }
    }
    Component {
        id: footerComponent

        EText {
            height: 24
            text: "Footer"
            objectName: "customSuggestionFooter"
        }
    }
    Component {
        id: loadingComponent

        EText {
            height: 40
            text: "Loading"
            objectName: "customSuggestionLoading"
        }
    }
}
