import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.MoreFormComponents
    description: ELocale.texts.CascadingAndTreeSelectionTagsVerificationCodes

    ExampleSection {
        componentName: "ERadioGroup"

        ExampleCard {
            description: ELocale.texts.MapBusinessFieldsToButtonRadiosDisabledOptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ERadioGroup {
                        value: "desktop"
                        buttonStyle: true
                        props: ({value: "id", label: "name"})
                        options: [{id: "desktop", name: ELocale.texts.Desktop}, {id: "web", name: ELocale.texts.Web}]
                    }
                }
`)

            ERadioGroup {
                value: "desktop"
                buttonStyle: true
                width: parent.width
                props: ({value: "id", label: "name"})
                options: [{id: "desktop", name: ELocale.texts.Desktop},
                    {id: "web", name: ELocale.texts.Web}]
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxGroup"

        ExampleCard {
            description: ELocale.texts.FieldMappingsButtonStyleAndSelectionLimitsShare
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ECheckBoxGroup {
                        max: 2
                        min: 1
                        value: [1]
                        buttonStyle: true
                        props: ({value: "id", label: "name", disabled: "locked"})
                        options: [{id: 1, name: ELocale.texts.Desktop}, {id: 2, name: ELocale.texts.Web}, {id: 3, name: ELocale.texts.Mobile, locked: true}]
                    }
                }
`)

            ECheckBoxGroup {
                max: 2
                min: 1
                value: [1]
                buttonStyle: true
                width: parent.width
                props: ({value: "id", label: "name", disabled: "locked"})
                options: [{id: 1, name: ELocale.texts.Desktop},
                    {id: 2, name: ELocale.texts.Web},
                    {id: 3, name: ELocale.texts.Mobile, locked: true}]
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCard {
            description: ELocale.texts.MultiplePrefixesCustomFilteringAndWholeMentionRemoval
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EMention {
                        whole: true
                        prefix: ["@", "#"]
                        options: [{label: "Alice"}, {label: "Bob"}, {label: "Carol"}]
                        onSearched: console.log(pattern, prefix)
                    }
                }`)

            EMention {
                whole: true
                prefix: ["@", "#"]
                objectName: "webFormMention"
                width: Math.min(520, parent.width)
                placeholderText: ELocale.texts.TypeOrToChooseAMember
                options: [{label: "Alice"}, {label: "Bob"}, {label: "Carol"}]
            }
        }
    }
    ExampleSection {
        componentName: "ETransfer"

        ExampleCard {
            description: ELocale.texts.CustomFieldMappingsFilteringAndSelectAllFor
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ETransfer {
                        targetOrder: "push"
                        props: ({key: "id", label: "name", disabled: "locked"})
                        filterMethod: function(query, item) { return item.name.toLowerCase().indexOf(query.toLowerCase()) >= 0 }
                        leftFooter: Component {
                            EText {
                                padding: 8
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.SelectEntriesThenMoveWithTheArrow
                            }
                        }
                        data: [{id: "desktop", name: ELocale.texts.Desktop}, {id: "web", name: ELocale.texts.Web},
                            {id: "mobile", name: ELocale.texts.Mobile, locked: true}, {id: "embedded", name: ELocale.texts.Embedded}]
                    }
                }
`)

            ETransfer {
                targetOrder: "push"
                width: parent.width
                objectName: "webFormTransfer"
                props: ({key: "id", label: "name", disabled: "locked"})
                filterMethod: function(query, item) {
                    return item.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
                }
                leftFooter: Component {
                    EText {
                        padding: 8
                        font.pixelSize: 12
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.SelectEntriesThenMoveWithTheArrow
                    }
                }
                data: [{id: "desktop", name: ELocale.texts.Desktop},
                    {id: "web", name: ELocale.texts.Web},
                    {id: "mobile", name: ELocale.texts.Mobile, locked: true},
                    {id: "embedded", name: ELocale.texts.Embedded}]
            }
        }
    }
    ExampleSection {
        componentName: "EColorPickerPanel"

        ExampleCard {
            description: ELocale.texts.ChoosePresetColorsDirectlyAlphaEditingAndHexadecimal
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EColorPickerPanel {
                        showAlpha: true
                        showButtons: true
                        colorFormat: "hsl"
                        commitOnConfirm: true
                        value: "#409eff"
                        predefine: ["#409eff", "#909399", "#67c23a", "#e6a23c", "#f56c6c"]
                    }
                }`)

            EColorPickerPanel {
                showAlpha: true
                value: "#409eff"
                showButtons: true
                colorFormat: "hsl"
                commitOnConfirm: true
                objectName: "webFormEColorPickerPanel"
                predefine: ["#409eff", "#909399", "#67c23a", "#e6a23c", "#f56c6c"]
            }
        }
    }
    ExampleSection {
        componentName: "EColorPicker"

        ExampleCard {
            description: ELocale.texts.ChoosePresetColorsDirectlyAlphaEditingAndHexadecimal
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EColorPicker {
                        showAlpha: true
                        colorFormat: "rgb"
                        commitOnConfirm: true
                        value: "#409eff"
                        predefine: ["#409eff", "#909399", "#67c23a", "#e6a23c", "#f56c6c"]
                    }
                }`)

            EColorPicker {
                showAlpha: true
                value: "#409eff"
                colorFormat: "rgb"
                commitOnConfirm: true
                objectName: "webFormEColorPicker"
                predefine: ["#409eff", "#909399", "#67c23a", "#e6a23c", "#f56c6c"]
            }
        }
    }
    ExampleSection {
        componentName: "ERangeSlider"

        ExampleCard {
            description: ELocale.texts.DragEitherEndpointToSelectARangeWith
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ERangeSlider {
                        from: 0
                        to: 100
                        stepSize: 10
                        showStops: true
                        first.value: 20
                        second.value: 80
                        marks: ({0: "0", 50: "50", 100: "100"})
                    }
                }`)

            ERangeSlider {
                to: 100
                stepSize: 10
                first.value: 20
                showStops: true
                second.value: 80
                objectName: "webFormRangeSlider"
                width: Math.min(520, parent.width)
                marks: ({0: "0", 50: "50", 100: "100"})
            }
        }
    }
    ExampleSection {
        componentName: "EInputTag"

        ExampleCard {
            description: ELocale.texts.ReturnOrCommasCommitTagsBackspaceInAn
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EInputTag {
                        max: 5
                        delimiter: ","
                        clearable: true
                        draggable: true
                        value: ["Qt", "QML", "Desktop"]
                        prefixComponent: Component {
                            EIcon {
                                iconSize: 16
                                iconSource: EIcons.TAG
                            }
                        }
                    }
                }`)

            EInputTag {
                max: 5
                delimiter: ","
                clearable: true
                maxCollapseTags: 2
                collapseTags: false
                width: parent.width
                objectName: "webFormInputTag"
                value: ["Qt", "QML", "Desktop"]
                prefixComponent: Component {
                    EIcon {
                        iconSize: 16
                        iconSource: EIcons.TAG
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            description: ELocale.texts.ChooseOrDropFilesThenUploadToA
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EUpload {
                        id: webFormUpload
                        action: "https://your-server.example/upload"
                        autoUpload: false
                        drag: true
                        accept: ".txt,.json,.png,.jpg"
                        limit: 3
                        maxFileSize: 5 * 1024 * 1024
                        data: {folder: "documents"}
                        method: "POST"
                        beforeUpload: function(file) { return file.size <= 5 * 1024 * 1024 }
                    }
                    EButton {
                        text: "Upload queue"
                        onClicked: webFormUpload.submit()
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EInput {
                    id: webFormUploadEndpoint

                    clearable: true
                    width: parent.width
                    placeholderText: ELocale.texts.UploadEndpointEGHttpsExampleComUpload
                }
                EUpload {
                    id: webFormUpload

                    limit: 3
                    drag: true
                    width: parent.width
                    objectName: "webFormUpload"
                    maxFileSize: 5 * 1024 * 1024
                    accept: ".txt,.json,.png,.jpg"
                    action: webFormUploadEndpoint.text
                    beforeUpload: function(file) {
                        return file.size <= 5 * 1024 * 1024
                    }
                }
                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.UploadQueue
                        enabled: webFormUpload.action.length > 0
                            && !webFormUpload.uploading
                            && webFormUpload.fileList.length > 0

                        onClicked: webFormUpload.submit()
                    }
                    ETextButton {
                        enabled: webFormUpload.uploading
                        text: ELocale.texts.CancelUpload

                        onClicked: webFormUpload.cancel()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCard {
            description: ELocale.texts.DateTimeRangesPreserveDateBoundsAndReject
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EDateTimePicker {
                        isRange: true
                        minDate: "2026-01-01"
                        maxDate: "2026-12-31"
                        value: ["2026-10-10 09:00:00", "2026-10-11 18:00:00"]
                    }
                }`)

            EDateTimePicker {
                isRange: true
                maxDate: "2026-12-31"
                minDate: "2026-01-01"
                width: Math.min(520, parent.width)
                objectName: "webFormDateTimePicker"
                value: ["2026-10-10 09:00:00", "2026-10-11 18:00:00"]
            }
        }
    }
    ExampleSection {
        componentName: "ECascader"

        ExampleCard {
            description: ELocale.texts.MultipleSelectionsLinkedChecksAndPathFilteringEmitPath
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ECascader {
                        emitPath: true
                        multiple: true
                        filterable: true
                        collapseTags: true
                        maxCollapseTags: 2
                        nodeDelegate: Component {
                            EText {
                                text: parent.node.label
                            }
                        }
                        options: [{label: ELocale.texts.China, value: "cn", children: [
                            {label: ELocale.texts.Zhejiang, value: "zj", children: [{label: ELocale.texts.Hangzhou, value: "hz"}, {label: ELocale.texts.Ningbo, value: "nb"}]},
                            {label: ELocale.texts.Shanghai, value: "sh"}]}]
                    }
                }
`)

            ECascader {
                multiple: true
                filterable: true
                collapseTags: true
                maxCollapseTags: 2
                objectName: "webFormCascader"
                width: Math.min(440, parent.width)
                nodeDelegate: Component {
                    EText {
                        text: parent.node.label
                        color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                    }
                }
                options: [{label: ELocale.texts.China, value: "cn", children: [
                    {label: ELocale.texts.Zhejiang, value: "zj", children: [
                        {label: ELocale.texts.Hangzhou, value: "hz"},
                        {label: ELocale.texts.Ningbo, value: "nb"}]},
                    {label: ELocale.texts.Shanghai, value: "sh"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ETreeSelect"

        ExampleCard {
            description: ELocale.texts.CheckboxesCascadeThroughDescendantsAndShowPartialSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ETreeSelect {
                        multiple: true
                        filterable: true
                        showCheckbox: true
                        value: ["archived"]
                        checkStrictly: false
                        nodeDelegate: Component {
                            EText {
                                text: parent.node.label
                            }
                        }
                        cacheData: [{value: "archived", label: ELocale.texts.ArchivedItem}]
                        data: [{label: ELocale.texts.Engineering2, value: "engineering", children: [
                            {label: ELocale.texts.Desktop, value: "desktop"}, {label: ELocale.texts.Web, value: "web"},
                            {label: ELocale.texts.Mobile, value: "mobile", disabled: true}]}]
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                ETreeSelect {
                    id: webFormTreeSelect

                    multiple: true
                    filterable: true
                    showCheckbox: true
                    value: ["archived"]
                    objectName: "webFormTreeSelect"
                    width: Math.min(360, parent.width)
                    cacheData: [{value: "archived", label: ELocale.texts.ArchivedItem}]
                    nodeDelegate: Component {
                        EText {
                            text: parent.node.label
                            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                        }
                    }
                    data: [{label: ELocale.texts.Engineering2, value
                        : "engineering", children
                        : [
                        {label: ELocale.texts.Desktop, value
                            : "desktop"}, {label
                            : ELocale.texts.Web, value
                            : "web"},
                        {label: ELocale.texts.Mobile, value
                            : "mobile", disabled
                            : true}]}]
                }
                ESwitch {
                    text: ELocale.texts.SelectNodesIndependently

                    onToggled: webFormTreeSelect.checkStrictly = checked
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeSelect"

        ExampleCase {
            title: ELocale.texts.FixedStepsDisplayFormatAndEndTime
            description: ELocale.texts.TypeAnExistingTimeChoiceTheEndTime
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EApplicationWindow {
                    width: 760
                    height: 640
                    visible: true

                    Column {
                        width: parent.width - 48
                        spacing: 16
                        anchors.centerIn: parent

                        ETimeSelect {
                            id: webDatesTimeSelect
                \x20\x20\x20\x20\x20\x20\x20\x20
                            editable: true
                            start: "09:00"
                            end: "18:10"
                            step: "00:30"
                            format: "hh:mm A"
                            includeEndTime: true
                            width: Math.min(260, parent.width)
                            objectName: "webDatesTimeSelect"
                        }
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.SelectedTime + String(webDatesTimeSelect.value || "")
                        }
                    }
                }
            `)

            ETimeSelect {
                id: webDatesTimeSelect

                end: "18:10"
                step: "00:30"
                editable: true
                start: "09:00"
                format: "hh:mm A"
                includeEndTime: true
                objectName: "webDatesTimeSelect"
                width: Math.min(260, parent.width)
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: ELocale.texts.SelectedTime
                    + String(webDatesTimeSelect.value || "")
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCase {
            title: ELocale.texts.DefaultTimesAndDateTimeRanges
            description: ELocale.texts.EditDateAndTimeSeparatelyNewRangesUse
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EApplicationWindow {
                    width: 760
                    height: 640
                    visible: true

                    Column {
                        width: parent.width - 48
                        spacing: 16
                        anchors.centerIn: parent

                        EDateTimePicker {
                            id: webDatesDateTime
                \x20\x20\x20\x20\x20\x20\x20\x20
                            isRange: true
                            readOnly: false
                            format: "DD/MM/YYYY HH:mm"
                            dateFormat: "DD/MM/YYYY"
                            timeFormat: "hh:mm A"
                            width: Math.min(460, parent.width)
                            objectName: "webDatesDateTime"
                            defaultValue: [new Date(2026, 9, 11), new Date(2026, 10, 11)]
                            defaultTime: [new Date(2000, 0, 1, 9, 30), new Date(2000, 0, 1, 18, 45)]
                        }
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.DateAndTime2 + JSON.stringify(webDatesDateTime.value)
                        }
                    }
                }
            `)

            EDateTimePicker {
                id: webDatesDateTime

                isRange: true
                readOnly: false
                timeFormat: "hh:mm A"
                dateFormat: "DD/MM/YYYY"
                format: "DD/MM/YYYY HH:mm"
                objectName: "webDatesDateTime"
                width: Math.min(460, parent.width)
                defaultValue: [new Date(2026, 9, 11), new Date(2026, 10, 11)]
                defaultTime: [new Date(2000, 0, 1, 9, 30), new Date(2000, 0, 1, 18, 45)]
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: ELocale.texts.DateAndTime2
                    + JSON.stringify(webDatesDateTime.value)
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCard {
            title: ELocale.texts.MultilineMentionsValuesAndCustomLabels
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EMention {
                        id: webUploadMention

                        whole: true
                        type: "textarea"
                        prefix: ["@", "#"]
                        width: Math.min(520, parent.width)
                        options: [{label: "Alice Chen", value: "alice"}, {label: "Bob Wang", value: "bob"}, {label: "Carol", value: "carol", disabled: true}]
                        placeholderText: ELocale.texts.TypeOrToMentionAMemberBackspaceRemoves
                        labelDelegate: Component {
                            EText {
                                property var option
                                property int optionIndex: -1

                                text: option ? option.label + "  (@" + option.value + ")" : ""
                            }
                        }
                        headerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.TeamMembers
                            }
                        }
                        footerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.DisplayTheLabelAndInsertTheValue
                            }
                        }
                    }
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ActualText + webUploadMention.text
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EMention {
                    id: webUploadMention

                    whole: true
                    type: "textarea"
                    prefix: ["@", "#"]
                    width: Math.min(520, parent.width)
                    placeholderText: ELocale.texts.TypeOrToMentionAMemberBackspaceRemoves
                    headerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.TeamMembers
                        }
                    }
                    footerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.DisplayTheLabelAndInsertTheValue
                        }
                    }
                    options: [{label: "Alice Chen", value: "alice"}, {label: "Bob Wang", value: "bob"}, {label: "Carol", value: "carol", disabled: true}]
                    labelDelegate: Component {
                        EText {
                            property var option
                            property int optionIndex: -1

                            text: option ? option.label + "  (@" + option.value + ")" : ""
                        }
                    }
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.ActualText + webUploadMention.text
                }
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            title: ELocale.texts.DirectorySelectionAndRequestData
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EUpload {
                        id: webUploadDirectory

                        directory: true
                        width: Math.min(520, parent.width)
                        data: function(file) { return {relativePath: file.relativePath} }
                        httpRequest: function(request) {
                            Qt.callLater(function() { request.onSuccess("Received: " + request.data.relativePath) })
                        }
                        triggerDelegate: Component {
                            EButton {
                                property var uploadControl

                                iconSource: EIcons.FOLDER
                                text: ELocale.texts.ChooseAFolder

                                onClicked: uploadControl.open()
                            }
                        }
                        tipDelegate: Component {
                            EText {
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.ReadableFilesAreCollectedRecursivelyWithRelativePathSymbolic
                            }
                        }
                    }
                    EButton {
                        text: ELocale.texts.SubmitDirectoryFiles
                        enabled: !webUploadDirectory.uploading

                        onClicked: webUploadDirectory.submit()
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EUpload {
                    id: webUploadDirectory

                    directory: true
                    width: Math.min(520, parent.width)
                    data: function(file) {
                        return {relativePath: file.relativePath}
                    }
                    httpRequest: function(request) {
                        Qt.callLater(function() {
                            request.onSuccess("Received: " + request.data.relativePath)
                        })
                    }
                    tipDelegate: Component {
                        EText {
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ReadableFilesAreCollectedRecursivelyWithRelativePathSymbolic
                        }
                    }
                    triggerDelegate: Component {
                        EButton {
                            property var uploadControl

                            iconSource: EIcons.FOLDER
                            text: ELocale.texts.ChooseAFolder

                            onClicked: uploadControl.open()
                        }
                    }
                }
                EButton {
                    enabled: !webUploadDirectory.uploading
                    text: ELocale.texts.SubmitDirectoryFiles

                    onClicked: webUploadDirectory.submit()
                }
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            title: ELocale.texts.PhotoWallSlotsAndManualQueue
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EUpload {
                        id: webUploadWall

                        width: Math.min(520, parent.width)
                        listType: "picture-card"
                        limit: 6
                        accept: "image/*"
                        fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                            {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                            {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
                        httpRequest: function(request) {
                            let cancelled = false
                            Qt.callLater(function() {
                                if (!cancelled) {
                                    request.onProgress(100)
                                    request.onSuccess("Demo upload completed")
                                }
                            })
                            return {abort: function() { cancelled = true }}
                        }
                        tipDelegate: Component {
                            EText {
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.PreviewRemoveAndRetryFilesThisDemoSimulates
                            }
                        }
                        defaultDelegate: Component {
                            Row {
                                spacing: 8

                                EButton {
                                    text: ELocale.texts.UploadAll
                                    enabled: !webUploadWall.uploading

                                    onClicked: webUploadWall.submit()
                                }
                                EButton {
                                    text: ELocale.texts.Cancel

                                    onClicked: webUploadWall.abort()
                                }
                                EButton {
                                    text: ELocale.texts.ClearCompleted

                                    onClicked: webUploadWall.clearFiles(["success"])
                                }
                            }
                        }

                        onPreviewed: webUploadStatus.text = ELocale.texts.Preview + file.name
                    }
                    EText {
                        id: webUploadStatus

                        text: ELocale.texts.ClickAThumbnailToInspectTheFile
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EUpload {
                    id: webUploadWall

                    limit: 6
                    accept: "image/*"
                    listType: "picture-card"
                    width: Math.min(520, parent.width)
                    fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
                    tipDelegate: Component {
                        EText {
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.PreviewRemoveAndRetryFilesThisDemoSimulates
                        }
                    }
                    httpRequest: function(request) {
                        let cancelled = false
                        Qt.callLater(function() {
                            if (!cancelled) {
                                request.onProgress(100)
                                request.onSuccess("Demo upload completed")
                            }
                        })
                        return {abort: function() {
                            cancelled = true
                        }}
                    }
                    defaultDelegate: Component {
                        Row {
                            spacing: 8

                            EButton {
                                text: ELocale.texts.UploadAll
                                enabled: !webUploadWall.uploading

                                onClicked: webUploadWall.submit()
                            }
                            EButton {
                                text: ELocale.texts.Cancel

                                onClicked: webUploadWall.abort()
                            }
                            EButton {
                                text: ELocale.texts.ClearCompleted

                                onClicked: webUploadWall.clearFiles(["success"])
                            }
                        }
                    }

                    onPreviewed: webUploadStatus.text = ELocale.texts.Preview
                        + file.name
                }
                EText {
                    id: webUploadStatus

                    text: ELocale.texts.ClickAThumbnailToInspectTheFile
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECascader"

        ExampleCard {
            introduction: ELocale.texts.SelectEachLevelInTurnChoosingA

            ExampleCase {
                code: exampleData.samples.ECascaderExample
                title: ELocale.texts.CascadingCitySelection

                ECascader {
                    options: exampleData.models.Regions
                    value: exampleData.models.InitialRegion
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETreeSelect"

        ExampleCard {
            introduction: ELocale.texts.TreeOptionsAppearAsIndentedLevelsWith

            ExampleCase {
                title: ELocale.texts.TreeNodeSelection
                code: exampleData.samples.ETreeSelectExample

                ETreeSelect {
                    clearable: true
                    leavesOnly: true
                    data: exampleData.models.Regions
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeSelect"

        ExampleCard {
            introduction: ELocale.texts.GenerateTimeSlotsFromAStartTime

            ExampleCase {
                title: ELocale.texts.ThirtyMinuteTimeSlots
                code: exampleData.samples.ETimeSelectExample

                ETimeSelect {
                    step: 30
                    end: ELocale.texts.Value1800
                    start: ELocale.texts.Value0900
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInputTag"

        ExampleCard {
            introduction: ELocale.texts.EnterTextAndPressEnterToAdd

            ExampleCase {
                title: ELocale.texts.TagInput
                code: exampleData.samples.EInputTagExample

                EInputTag {
                    max: 5
                    width: Math.min(parent.width, 520)
                    value: exampleData.models.InitialTags
                    placeholderText: ELocale.texts.PressEnterToAdd
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInputOtp"

        ExampleCard {
            introduction: ELocale.texts.EnterDigitsOrPasteAVerificationCode

            ExampleCase {
                code: exampleData.samples.EInputOtpExample
                title: ELocale.texts.SixDigitVerificationCode

                EInputOtp { }
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCard {
            introduction: ELocale.texts.TypeAndANameThenSelectThe

            ExampleCase {
                title: ELocale.texts.MentionAMember
                code: exampleData.samples.EMentionExample

                EMention {
                    width: 360
                    options: exampleData.models.Members
                    placeholderText: ELocale.texts.TypeAliceOrBob
                }
            }
        }
    }
    ExampleSection {
        componentName: "EColorPicker"

        ExampleCard {
            introduction: ELocale.texts.AdjustHueSaturationBrightnessAndOptionalOpacity

            ExampleCase {
                title: ELocale.texts.ColorSelection
                code: exampleData.samples.EColorPickerExample

                EColorPicker {
                    showAlpha: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "EColorPickerPanel"

        ExampleCard {
            introduction: ELocale.texts.AStandaloneColorPanelWithDirectHexadecimal

            ExampleCase {
                title: ELocale.texts.StandaloneColorPanel
                code: exampleData.samples.EColorPickerPanelExample

                EColorPickerPanel {
                    showAlpha: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCard {
            introduction: ELocale.texts.ChooseADateHoursMinutesAndSeconds

            ExampleCase {
                title: ELocale.texts.DateAndTime
                code: exampleData.samples.EDateTimePickerExample

                EDateTimePicker {
                    value: ELocale.texts.Value20261010093000
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxGroup"

        ExampleCard {
            introduction: ELocale.texts.ArrayBasedOptionsSupportMinimumAndMaximum

            ExampleCase {
                title: ELocale.texts.SelectUpToTwo
                code: exampleData.samples.ECheckBoxGroupExample

                ECheckBoxGroup {
                    max: 2
                    width: parent.width
                    options: exampleData.models.Languages
                    value: exampleData.models.InitialCheckedTags
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioGroup"

        ExampleCard {
            introduction: ELocale.texts.AnArrayBasedRadioGroupWhoseValue

            ExampleCase {
                title: ELocale.texts.SingleSelection
                code: exampleData.samples.ERadioGroupExample

                ERadioGroup {
                    width: parent.width
                    value: ELocale.texts.Qml
                    options: exampleData.models.Languages
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETransfer"

        ExampleCard {
            introduction: ELocale.texts.SearchAndCheckItemsThenUseThe

            ExampleCase {
                title: ELocale.texts.TransferSelection
                code: exampleData.samples.ETransferExample

                ETransfer {
                    width: Math.min(parent.width, 620)
                    data: exampleData.models.TransferItems
                    value: exampleData.models.InitialTransferredKeys
                }
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            introduction: ELocale.texts.NativeFileSelectionWithAFileList

            ExampleCase {
                code: exampleData.samples.EUploadExample
                title: ELocale.texts.SelectAndUploadFiles
                description: ELocale.texts.SetTheServerUrlBeforeUploadingMissing

                EInput {
                    id: uploadUrl

                    width: Math.min(parent.width, 520)
                    placeholderText: ELocale.texts.HttpOrHttpsUploadUrl
                }
                EUpload {
                    limit: 5
                    action: uploadUrl.text
                    width: Math.min(parent.width, 520)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERangeSlider"

        ExampleCard {
            code: exampleData.samples.RangeSlider
            description: exampleData.ui.RangeIntroduction

            ERangeSlider {
                id: rangeSlider

                from: 0
                to: 100
                stepSize: 5
                first.value: 20
                second.value: 70
                width: Math.min(420, parent.width)
            }
            EText {
                font.pixelSize: 14
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                text: exampleData.ui.RangeValue.arg(rangeSlider.first.value).arg(rangeSlider.second.value)
            }
        }
    }
    ExampleSection {
        componentName: "EShortcutPicker"

        ExampleCard {
            code: exampleData.samples.ShortcutPicker
            description: exampleData.ui.ShortcutIntroduction

            EShortcutPicker {
                width: Math.min(360, parent.width)
                sequence: exampleData.ui.ShortcutDefault
            }
        }
    }
    ExampleSection {
        componentName: "ECaptcha"

        ExampleCard {
            code: exampleData.samples.Captcha
            description: exampleData.ui.CaptchaIntroduction

            ECaptcha {
                id: captcha

                length: 5
            }
            Flow {
                spacing: 12
                width: parent.width

                EInput {
                    id: captchaInput

                    width: 220
                    placeholderText: exampleData.ui.CaptchaPlaceholder
                }
                EButton {
                    text: exampleData.ui.Verify

                    onClicked: captchaStatus.text = captcha.verify(captchaInput.text)
                        ? exampleData.ui.CaptchaValid
                        : exampleData.ui.CaptchaInvalid
                }
                EText {
                    id: captchaStatus

                    font.pixelSize: 14
                    text: exampleData.ui.Waiting
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
        }
    }
    ExtendedFormShowcase { }
    PrimeShowcase { names: ["ETransfer"] }
}
