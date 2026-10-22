import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.FormComponents
    description: ELocale.texts.SelectionInputDateAndUploadInteractions

    ExampleSection {
        componentName: "ESelect"

        ExampleCard {
            description: ELocale.texts.MultipleSelectionsOptionGroupsAndFilteringRemoteQueries
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESelect {
                        multiple: true
                        clearable: true
                        filterable: true
                        multipleLimit: 3
                        allowCreate: true
                        textRole: "label"
                        collapseTags: true
                        valueRole: "value"
                        popupFooter: Component {
                            EText {
                                padding: 8
                                text: ELocale.texts.ChooseUpToThreeItems
                            }
                        }
                        tagDelegate: Component {
                            ETag {
                                closable: true
                                size: EStyle.Small
                                text: parent.label
                                styleType: EStyle.Success

                                onClosed: parent.remove()
                            }
                        }
                        model: [{label: "Desktop", options: [{label: "Qt", value: "qt"}, {label: "QML", value: "qml"}]},
                            {label: "Web", options: [{label: "Vue", value: "vue"}, {label: "TypeScript", value: "ts"}]}]
                    }
                    ESelect {
                        remote: true
                        filterable: true
                        textRole: "label"
                        valueRole: "value"
                        remoteMethod: function(query) {
                            return Promise.resolve([{label: "Qt", value: "qt"}, {label: "QML", value: "qml"}, {label: "Vue", value: "vue"}]
                                .filter(function(item) { return item.label.toLowerCase().indexOf(query.toLowerCase()) >= 0 }))
                        }
                    }
                }
`)

            Flow {
                spacing: 16
                width: parent.width

                ESelect {
                    multiple: true
                    clearable: true
                    filterable: true
                    multipleLimit: 3
                    allowCreate: true
                    textRole: "label"
                    collapseTags: true
                    valueRole: "value"
                    objectName: "webFormSelect"
                    width: Math.min(320, parent.width)
                    popupFooter: Component {
                        EText {
                            padding: 8
                            font.pixelSize: 12
                            text: ELocale.texts.ChooseUpToThreeItems
                        }
                    }
                    tagDelegate: Component {
                        ETag {
                            closable: true
                            size: EStyle.Small
                            text: parent.label
                            styleType: EStyle.Success

                            onClosed: parent.remove()
                        }
                    }
                    model: [{label: ELocale.texts.Desktop, options
                        : [{label: "Qt", value: "qt"}, {label: "QML", value: "qml"}]},
                        {label: ELocale.texts.Web, options
                            : [{label: "Vue", value: "vue"}, {label: "TypeScript", value: "ts"}]}]
                }
                ESelect {
                    remote: true
                    debounce: 250
                    filterable: true
                    textRole: "label"
                    valueRole: "value"
                    width: Math.min(280, parent.width)
                    placeholderText: ELocale.texts.QueryALocalAsyncSource
                    remoteMethod: function(query) {
                        return Promise.resolve([{label: "Qt", value: "qt"}, {label: "QML", value: "qml"}, {label: "Vue", value: "vue"}]
                            .filter(function(item) {
                                return item.label.toLowerCase().indexOf(query.toLowerCase()) >= 0
                            }))
                    }
                }
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
        componentName: "EDatePicker"

        ExampleCard {
            description: ELocale.texts.DateWeekMonthYearMultipleAndRangeSelections
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EDatePicker {
                        type: "daterange"
                        minDate: "2026-01-01"
                        maxDate: "2026-12-31"
                        disabledDate: function(date) { return date.getDay() === 0 }
                    }
                    EDatePicker { type: "months" }
                    EDatePicker { type: "week" }
                }`)

            Column {
                spacing: 16
                width: parent.width

                ESelect {
                    id: webFormDateType

                    currentIndex: 0
                    width: Math.min(240, parent.width)
                    model: ["date", "week", "month", "year", "dates", "months", "years", "daterange", "monthrange", "yearrange", "quarter", "quarters", "quarterrange"]
                }
                EDatePicker {
                    objectName: "webFormDatePicker"
                    type: webFormDateType.currentText
                    width: Math.min(480, parent.width)
                    shortcuts: [{text: ELocale.texts.Today, value: function() {
                        const date = new Date()
                        if (webFormDateType.currentText === "week")
                            date.setDate(date.getDate() - (date.getDay() + 6) % 7)
                        const format = webFormDateType.currentText.indexOf("year") === 0 ? "yyyy"
                            : webFormDateType.currentText.indexOf("month") === 0 ? "yyyy-MM" : "yyyy-MM-dd"
                        const today = webFormDateType.currentText.indexOf("quarter") === 0
                            ? String(date.getFullYear()) + "-Q" + (Math.floor(date.getMonth() / 3) + 1)
                                : Qt.formatDate(date, format)
                        return webFormDateType.currentText.indexOf("range") >= 0 ? [today, today]
                            : ["dates", "months", "years", "quarters"].indexOf(webFormDateType.currentText) >= 0
                                ? [today]
                                : today
                    }}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCard {
            description: ELocale.texts.ClickTwoDatesToCompleteARangeClicking
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EDatePickerPanel {
                        type: "daterange"
                        disabledDate: function(date) { return date.getDay() === 0 }
                    }
                }`)

            EDatePickerPanel {
                type: "daterange"
                objectName: "webFormDatePanel"
                width: Math.min(360, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ETimePicker"

        ExampleCard {
            description: ELocale.texts.RangesValidateTheirOrderHoursMinutesAndSeconds
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ETimePicker {
                        isRange: true
                        minTime: "08:00:00"
                        maxTime: "20:00:00"
                        value: ["09:00:00", "18:00:00"]
                        disabledHours: function() { return [12, 13] }
                        disabledMinutes: function(hour) { return hour === 9 ? [15, 45] : [] }
                    }
                }`)

            ETimePicker {
                isRange: true
                maxTime: "20:00:00"
                minTime: "08:00:00"
                objectName: "webFormTimePicker"
                value: ["09:00:00", "18:00:00"]
                width: Math.min(440, parent.width)
                disabledHours: function() {
                    return [12, 13]
                }
                disabledMinutes: function(hour) {
                    return hour === 9 ? [15, 45] : []
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
        componentName: "EAutocomplete"

        ExampleCard {
            description: ELocale.texts.SuggestionSourcesAcceptCallbacksArraysOrPromisesDebouncing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EAutocomplete {
                        debounce: 250
                        highlightFirstItem: true
                        fetchSuggestions: function(query, done) {
                            done(["Qt", "QML", "Qt Quick", "Qt Creator"].filter(function(text) {
                                return text.toLowerCase().indexOf(query.toLowerCase()) >= 0
                            }))
                        }
                    }
                }`)

            EAutocomplete {
                debounce: 250
                highlightFirstItem: true
                objectName: "webFormAutocomplete"
                width: Math.min(400, parent.width)
                placeholderText: ELocale.texts.TypeQtQMLOrQuick
                fetchSuggestions: function(query, done) {
                    done(["Qt", "QML", "Qt Quick", "Qt Creator"].filter(function(text) {
                        return text.toLowerCase().indexOf(query.toLowerCase()) >= 0
                    }))
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCard {
            description: ELocale.texts.ParsingAndFormattingRunOnEditingCompletionWord
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EInput {
                        text: "$128"
                        clearable: true
                        prependComponent: Component {
                            EText {
                                padding: 8
                                text: "USD"
                            }
                        }
                        parser: function(value) { return value.replace(/\\$/g, "") }
                        formatter: function(value) { return value ? "$" + value : "" }
                        appendComponent: Component {
                            EText {
                                padding: 8
                                text: ELocale.texts.Month2
                            }
                        }
                    }
                    EInput {
                        clearable: true
                        maximumLength: 40
                        showWordLimit: true
                        suffixComponent: Component {
                            EText {
                                text: "QML"
                                font.pixelSize: 12
                            }
                        }
                        prefixComponent: Component {
                            EIcon {
                                iconSize: 14
                                iconSource: EIcons.MAGNIFIER
                            }
                        }
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    text: "$128"
                    clearable: true
                    width: Math.min(360, parent.width)
                    objectName: "webFormFormattedInput"
                    parser: function(value) {
                        return value.replace(/\$/g, "")
                    }
                    prependComponent: Component {
                        EText {
                            padding: 8
                            text: "USD"
                        }
                    }
                    formatter: function(value) {
                        return value ? "$" + value : ""
                    }
                    appendComponent: Component {
                        EText {
                            padding: 8
                            text: ELocale.texts.Month2
                        }
                    }
                }
                EInput {
                    clearable: true
                    maximumLength: 40
                    showWordLimit: true
                    width: Math.min(440, parent.width)
                    placeholderText: ELocale.texts.UpTo40Characters
                    suffixComponent: Component {
                        EText {
                            text: "QML"
                            font.pixelSize: 12
                        }
                    }
                    prefixComponent: Component {
                        EIcon {
                            iconSize: 14
                            iconSource: EIcons.MAGNIFIER
                        }
                    }
                }
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
        componentName: "ESpinBox"

        ExampleCard {
            description: ELocale.texts.DecimalValuesUseNumberValueIntegerValueSteppingAnd
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESpinBox {
                        from: -10
                        to: 20
                        value: 7
                        editable: true
                    }
                    ESpinBox {
                        precision: 2
                        editable: true
                        prefix: "$"
                        stepStrictly: true
                        controlsPosition: "right"
                        numberFrom: -1.5
                        numberTo: 20.5
                        numberStep: 0.25
                        numberValue: 1.25
                        onNumberModified: console.log(numberValue)
                    }
                }`)

            Flow {
                spacing: 16
                width: parent.width

                ESpinBox {
                    to: 20
                    value: 7
                    from: -10
                    editable: true
                    objectName: "webFormInteger"
                }
                ESpinBox {
                    prefix: "$"
                    precision: 2
                    editable: true
                    numberTo: 20.5
                    numberFrom: -1.5
                    numberStep: 0.25
                    numberValue: 1.25
                    stepStrictly: true
                    controlsPosition: "right"
                    objectName: "webFormDecimal"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCard {
            description: ELocale.texts.RealStepStopsMarksAndFormattedTooltipsNative
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESlider {
                        from: 0
                        to: 100
                        value: 50
                        stepSize: 25
                        showStops: true
                        showInput: true
                        marks: ({0: "0%", 25: "25%", 50: "50%", 75: "75%", 100: "100%"})
                        formatTooltip: function(value) { return value + "%" }
                    }
                }`)

            ESlider {
                to: 100
                value: 50
                stepSize: 25
                showInput: true
                showStops: true
                objectName: "webFormSlider"
                width: Math.min(520, parent.width)
                formatTooltip: function(value) {
                    return value + "%"
                }
                marks: ({0: "0%", 25: "25%", 50: "50%", 75: "75%", 100: "100%"})
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
        componentName: "ESwitch"

        ExampleCard {
            description: ELocale.texts.SynchronousOrAsynchronousGuardsRunBeforeAChange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESwitch {
                        value: "off"
                        activeValue: "on"
                        inactiveValue: "off"
                        activeColor: "#67c23a"
                        activeIcon: EIcons.CHECK
                        inactiveColor: "#909399"
                        inactiveIcon: EIcons.XMARK
                        activeText: ELocale.texts.Enabled2
                        inactiveText: ELocale.texts.Disabled3
                        beforeChange: function() { return Promise.resolve(true) }
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                ECheckBox {
                    id: webFormAllowSwitch

                    checked: true
                    borderVisible: false
                    text: ELocale.texts.AllowChanges
                }
                ESwitch {
                    value: "off"
                    activeValue: "on"
                    inactiveValue: "off"
                    activeColor: "#67c23a"
                    activeIcon: EIcons.CHECK
                    inactiveColor: "#909399"
                    inactiveIcon: EIcons.XMARK
                    objectName: "webFormSwitch"
                    activeText: ELocale.texts.Enabled2
                    inactiveText: ELocale.texts.Disabled3
                    beforeChange: function() {
                        return Promise.resolve(webFormAllowSwitch.checked)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERate"

        ExampleCard {
            description: ELocale.texts.CustomizeLevelTextIconsAndColorsWhileRetaining
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ERate {
                        value: 3
                        showText: true
                        allowHalf: true
                        texts: [ELocale.texts.Poor, ELocale.texts.Fair, ELocale.texts.Good, ELocale.texts.Great, ELocale.texts.Excellent]
                        colors: ["#909399", "#E6A23C", "#E6A23C", "#e6a23c", "#e6a23c"]
                    }
                    ERate {
                        value: 4.5
                        readOnly: true
                        showScore: true
                        scoreTemplate: "{value}/5"
                    }
                }`)

            Flow {
                spacing: 24
                width: parent.width

                ERate {
                    value: 3
                    showText: true
                    allowHalf: true
                    objectName: "webFormRate"
                    colors: ["#909399", "#E6A23C", "#E6A23C", "#e6a23c", "#e6a23c"]
                    texts: [ELocale.texts.Poor, ELocale.texts.Fair, ELocale.texts.Good,
                        ELocale.texts.Great, ELocale.texts.Excellent]
                }
                ERate {
                    value: 4.5
                    readOnly: true
                    showScore: true
                    scoreTemplate: "{value}/5"
                }
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
        componentName: "ECheckBox"

        ExampleCard {
            description: ELocale.texts.MapBooleanChecksToStringsNumbersOrObjects
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ECheckBox {
                        value: "no"
                        falseValue: "no"
                        trueValue: "yes"
                        text: ELocale.texts.ReceiveNotifications
                    }
                }
`)

            ECheckBox {
                value: "no"
                falseValue: "no"
                trueValue: "yes"
                borderVisible: false
                text: ELocale.texts.ReceiveNotifications
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
        componentName: "EForm"

        ExampleCard {
            description: ELocale.texts.DecimalAndTypedValuesParticipateInModelValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EForm {
                        id: form

                        width: parent.width
                        model: ({amount: 1.25})

                        onSubmitted: console.log(valid, model.amount)

                        EFormItem {
                            prop: "amount"
                            required: true
                            width: parent.width
                            label: ELocale.texts.Amount
                            rules: [{type: "number", min: 0.25, max: 10}]
                            labelComponent: Component {
                                EText {
                                    font.bold: true
                                    text: parent.label
                                }
                            }
                            errorComponent: Component {
                                EText {
                                    text: parent.message
                                    color: EPaletteManager.StatePalette.validationColor(EValidationState.Error)
                                }
                            }

                            ESpinBox {
                                numberTo: 10
                                precision: 2
                                editable: true
                                numberStep: 0.25
                                numberValue: 1.25
                            }
                        }
                    }
                    EButton {
                        text: ELocale.texts.ValidateSubmission

                        onClicked: form.submit()
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                EForm {
                    id: webFormModel

                    width: parent.width
                    model: ({amount: 1.25})
                    objectName: "webFormModel"

                    onSubmitted: webFormSubmitStatus.text = valid
                        ? ELocale.texts.ValidatedSubmittedSignalEmitted
                        : ELocale.texts.CheckTheField

                    EFormItem {
                        prop: "amount"
                        required: true
                        width: parent.width
                        label: ELocale.texts.Amount
                        rules: [{type: "number", min: 0.25, max: 10}]
                        labelComponent: Component {
                            EText {
                                font.bold: true
                                text: parent.label
                            }
                        }
                        errorComponent: Component {
                            EText {
                                text: parent.message
                                color: EPaletteManager.StatePalette.validationColor(EValidationState.Error)
                            }
                        }

                        ESpinBox {
                            numberTo: 10
                            precision: 2
                            editable: true
                            numberStep: 0.25
                            numberValue: 1.25
                        }
                    }
                }
                EButton {
                    text: ELocale.texts.ValidateSubmission

                    onClicked: webFormModel.submit()
                }
                EText {
                    id: webFormSubmitStatus

                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
