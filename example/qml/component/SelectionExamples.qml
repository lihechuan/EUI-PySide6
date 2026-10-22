import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.SelectionAndDates
    description: ELocale.texts.DropdownsInputSuggestionsRatingsAndDateAnd

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
        componentName: "ETimePicker"

        ExampleCase {
            title: ELocale.texts.DisabledTimeChoicesAndRangeRoles
            description: ELocale.texts.DisabledChoicesAreVisibleConfirmAcceptsOnlyA
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

                        ETimePicker {
                            id: webDatesTime
                \x20\x20\x20\x20\x20\x20\x20\x20
                            isRange: true
                            readOnly: false
                            arrowControl: false
                            format: "hh:mm A"
                            minTime: "08:00:00"
                            maxTime: "20:00:00"
                            width: Math.min(380, parent.width)
                            value: ["09:00:00", "18:00:00"]
                            objectName: "webDatesTime"
                            disabledHours: function(role) { return role === "end" ? [12, 13] : [] }
                            disabledMinutes: function(hour) { return hour === 9 ? [15, 45] : [] }
                        }
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.TimeRange + JSON.stringify(webDatesTime.value)
                        }
                    }
                }
            `)

            ETimePicker {
                id: webDatesTime

                isRange: true
                readOnly: false
                format: "hh:mm A"
                arrowControl: false
                maxTime: "20:00:00"
                minTime: "08:00:00"
                objectName: "webDatesTime"
                value: ["09:00:00", "18:00:00"]
                width: Math.min(380, parent.width)
                disabledMinutes: function(hour) {
                    return hour === 9 ? [15, 45] : []
                }
                disabledHours: function(role) {
                    return role === "end" ? [12, 13] : []
                }
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: ELocale.texts.TimeRange
                    + JSON.stringify(webDatesTime.value)
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCase {
            description: ELocale.texts.UseArrowsToMoveAndEnterToSelect
            title: ELocale.texts.KeyboardNavigationRangePreviewAndCustomCells
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

                        EDatePickerPanel {
                            id: webDatesPanel
                \x20\x20\x20\x20\x20\x20\x20\x20
                            year: 2026
                            month: 9
                            type: "daterange"
                            showWeekNumber: true
                            width: Math.min(330, parent.width)
                            cellComponent: webDatesCell
                            objectName: "webDatesPanel"
                            disabledDate: function(date) { return date.getDay() === 0 || date.getDay() === 6 }
                        }
                        Component {
                            id: webDatesCell
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EText {
                                text: parent.cellData.text
                                font.bold: parent.cellData.isSelected
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        ETextButton {
                            text: ELocale.texts.ClearRange
                \x20\x20\x20\x20\x20\x20\x20\x20
                            onClicked: webDatesPanel.value = []
                        }
                    }
                }
            `)

            EDatePickerPanel {
                id: webDatesPanel

                month: 9
                year: 2026
                type: "daterange"
                showWeekNumber: true
                cellComponent: webDatesCell
                objectName: "webDatesPanel"
                width: Math.min(330, parent.width)
                disabledDate: function(date) {
                    return date.getDay() === 0 || date.getDay() === 6
                }
            }
            Component {
                id: webDatesCell

                EText {
                    text: parent.cellData.text
                    verticalAlignment: Text.AlignVCenter
                    font.bold: parent.cellData.isSelected
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            ETextButton {
                text: ELocale.texts.ClearRange

                onClicked: webDatesPanel.value = []
            }
        }
    }
    ExampleSection {
        componentName: "EDatePicker"

        ExampleCase {
            title: ELocale.texts.FormattedInputAndTwoPanelRanges
            description: ELocale.texts.EditTheDisplayFormatSelectARangeAcross
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

                        EDatePicker {
                            id: webDatesRange
                \x20\x20\x20\x20\x20\x20\x20\x20
                            readOnly: false
                            type: "daterange"
                            width: Math.min(380, parent.width)
                            format: "DD/MM/YYYY"
                            valueFormat: "YYYY-MM-DD"
                            objectName: "webDatesRange"
                            defaultValue: new Date(2026, 9, 11)
                            value: ["2026-10-11", "2026-10-20"]
                            disabledDate: function(date) { return date.getDay() === 0 }
                        }
                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.BoundValue + JSON.stringify(webDatesRange.value)
                        }
                    }
                }
            `)

            EDatePicker {
                id: webDatesRange

                readOnly: false
                type: "daterange"
                format: "DD/MM/YYYY"
                valueFormat: "YYYY-MM-DD"
                objectName: "webDatesRange"
                width: Math.min(380, parent.width)
                defaultValue: new Date(2026, 9, 11)
                value: ["2026-10-11", "2026-10-20"]
                disabledDate: function(date) {
                    return date.getDay() === 0
                }
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: ELocale.texts.BoundValue
                    + JSON.stringify(webDatesRange.value)
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCard {
            title: ELocale.texts.CustomSuggestionsLoadingAndKeyboardNavigation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EAutocomplete {
                        id: webUploadAutocomplete

                        width: Math.min(420, parent.width)
                        debounce: 120
                        showArrow: true
                        highlightFirstItem: true
                        textRole: "name"
                        placeholderText: ELocale.texts.SearchCitiesAndSelectWithArrowKeys
                        fetchSuggestions: function(query, callback) {
                            const cities = [{name: "Shanghai", country: "China"}, {name: "Singapore", country: "Singapore"}, {name: "Seattle", country: "USA"}]
                            Qt.callLater(function() { callback(cities.filter(function(city) { return city.name.toLowerCase().indexOf(query.toLowerCase()) >= 0 })) })
                        }
                        optionDelegate: Component {
                            EText {
                                property var option
                                property int optionIndex: -1

                                text: option ? option.name + " · " + option.country : ""
                            }
                        }
                        headerDelegate: Component {
                            EText {
                                text: ELocale.texts.CitySuggestions
                                leftPadding: 20
                            }
                        }
                        footerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.CyclesThroughSuggestionsEnterSelects
                            }
                        }
                        loadingDelegate: Component {
                            EText {
                                horizontalAlignment: Text.AlignHCenter
                                text: ELocale.texts.SearchingCities
                            }
                        }
                    }
                    EText {
                        text: ELocale.texts.CurrentText + webUploadAutocomplete.text
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EAutocomplete {
                    id: webUploadAutocomplete

                    debounce: 120
                    showArrow: true
                    textRole: "name"
                    highlightFirstItem: true
                    width: Math.min(420, parent.width)
                    placeholderText: ELocale.texts.SearchCitiesAndSelectWithArrowKeys
                    headerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.CitySuggestions
                        }
                    }
                    footerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.CyclesThroughSuggestionsEnterSelects
                        }
                    }
                    loadingDelegate: Component {
                        EText {
                            text: ELocale.texts.SearchingCities
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    optionDelegate: Component {
                        EText {
                            property var option
                            property int optionIndex: -1

                            text: option ? option.name + " · " + option.country : ""
                        }
                    }
                    fetchSuggestions: function(query, callback) {
                        const cities = [{name: "Shanghai", country: "China"}, {name: "Singapore", country: "Singapore"}, {name: "Seattle", country: "USA"}]
                        Qt.callLater(function() {
                            callback(cities.filter(function(city) {
                                return city.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
                            }))
                        })
                    }
                }
                EText {
                    text: ELocale.texts.CurrentText
                        + webUploadAutocomplete.text
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESelect"

        ExampleCard {
            introduction: ELocale.texts.ChooseAValueFromTheOptionsWith

            ExampleCase {
                title: ELocale.texts.SelectionAndClearing
                code: exampleData.samples.SelectionExamplesSample0

                Flow {
                    spacing: 16
                    width: parent.width

                    ESelect {
                        clearable: true
                        model: exampleData.models.Cities
                        placeholderText: ELocale.texts.SelectACity
                    }
                    ESelect {
                        enabled: false
                        currentIndex: 1
                        model: exampleData.models.Cities
                    }
                }
            }
            ExampleCase {
                title: exampleData.ui.LargeData
                code: exampleData.samples.SelectLargeData

                ESelect {
                    clearable: true
                    model: exampleData.models.ManyOptions
                    placeholderText: ELocale.texts.SelectAnOption
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCard {
            introduction: ELocale.texts.TypeToFilterSuggestionsUseTheArrow

            ExampleCase {
                title: ELocale.texts.InputSuggestions
                code: exampleData.samples.SelectionExamplesSample1

                EAutocomplete {
                    width: 280
                    clearable: true
                    model: exampleData.models.Technologies
                    placeholderText: ELocale.texts.TypeQtOrQml
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERate"

        ExampleCard {
            introduction: ELocale.texts.StarRatingsSupportHalfStarsClearingAnd

            ExampleCase {
                title: ELocale.texts.HalfStarRating
                code: exampleData.samples.SelectionExamplesSample2

                ERate {
                    value: 3.5
                    allowHalf: true
                    clearable: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePicker"

        ExampleCard {
            introduction: ELocale.texts.SelectASingleDateWithinTheAllowed

            ExampleCase {
                title: ELocale.texts.DateSelection
                code: exampleData.samples.SelectionExamplesSample3

                EDatePicker {
                    value: ELocale.texts.Value20261010
                    maxDate: ELocale.texts.Value20261231
                    minDate: ELocale.texts.Value20260101
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCard {
            introduction: ELocale.texts.AStandaloneCalendarPanelForFormsAnd

            ExampleCase {
                title: ELocale.texts.StandalonePanel
                code: exampleData.samples.EDatePickerPanelExample

                EDatePickerPanel {
                    value: ELocale.texts.Value20261010
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimePicker"

        ExampleCard {
            introduction: ELocale.texts.AdjustHoursMinutesAndSecondsThenConfirm

            ExampleCase {
                title: ELocale.texts.TimeSelection
                code: exampleData.samples.SelectionExamplesSample4

                ETimePicker {
                    value: ELocale.texts.Value093000
                }
            }
        }
    }
    SelectionShowcase { }
}
