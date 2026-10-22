import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "ERate"

        ExampleCase {
            objectName: "showcaseERate0"
            title: ELocale.texts.HalfStarsAndScore
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERate {
                    value: 3.5
                    allowHalf: true
                    showScore: true
                    scoreTemplate: "{value} / 5"
                }
            `)

            ERate {
                value: 3.5
                allowHalf: true
                showScore: true
                scoreTemplate: "{value} / 5"
            }
        }
    }
    ExampleSection {
        componentName: "ERate"

        ExampleCase {
            objectName: "showcaseERate1"
            title: ELocale.texts.ReadOnlyRating
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERate {
                    value: 4
                    readOnly: true
                    showText: true
                    texts: [ELocale.texts.Poor, ELocale.texts.Fair, ELocale.texts.Satisfied, ELocale.texts.Great, ELocale.texts.Excellent2]
                }
            `)

            ERate {
                value: 4
                readOnly: true
                showText: true
                texts: [ELocale.texts.Poor, ELocale.texts.Fair, ELocale.texts.Satisfied, ELocale.texts.Great, ELocale.texts.Excellent2]
            }
        }
    }
    ExampleSection {
        componentName: "ERate"

        ExampleCase {
            objectName: "showcaseERate2"
            title: ELocale.texts.DisabledSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERate {
                        value: 3
                        enabled: false
                        size: EStyle.Small
                    }
                    ERate {
                        value: 3
                        enabled: false
                        size: EStyle.Medium
                    }
                    ERate {
                        value: 3
                        enabled: false
                        size: EStyle.Large
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERate {
                    value: 3
                    enabled: false
                    size: EStyle.Small
                }
                ERate {
                    value: 3
                    enabled: false
                    size: EStyle.Medium
                }
                ERate {
                    value: 3
                    enabled: false
                    size: EStyle.Large
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESelect"

        ExampleCase {
            objectName: "showcaseESelect0"
            title: ELocale.texts.MultipleSelectionLimit
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESelect {
                    multiple: true
                    clearable: true
                    multipleLimit: 2
                    textRole: "label"
                    valueRole: "value"
                    width: Math.min(480, parent.width)
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ESelect {
                multiple: true
                clearable: true
                multipleLimit: 2
                textRole: "label"
                valueRole: "value"
                width: Math.min(480, parent.width)
                model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ESelect"

        ExampleCase {
            objectName: "showcaseESelect1"
            title: ELocale.texts.FilterAndCreate
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESelect {
                    clearable: true
                    filterable: true
                    allowCreate: true
                    model: ["QML", "Qt", "C++"]
                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.FilterOrCreateAProject
                }
            `)

            ESelect {
                clearable: true
                filterable: true
                allowCreate: true
                model: ["QML", "Qt", "C++"]
                width: Math.min(480, parent.width)
                placeholderText: ELocale.texts.FilterOrCreateAProject
            }
        }
    }
    ExampleSection {
        componentName: "ESelect"

        ExampleCase {
            objectName: "showcaseESelect2"
            title: ELocale.texts.EmptyAndLoading
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESelect {
                        model: []
                        width: Math.min(480, parent.width)
                        noDataText: ELocale.texts.NoProjectsCreatedYet
                    }
                    ESelect {
                        loading: true
                        width: Math.min(480, parent.width)
                        loadingText: ELocale.texts.Searching
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESelect {
                    model: []
                    width: Math.min(480, parent.width)
                    noDataText: ELocale.texts.NoProjectsCreatedYet
                }
                ESelect {
                    loading: true
                    width: Math.min(480, parent.width)
                    loadingText: ELocale.texts.Searching
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePicker"

        ExampleCase {
            title: ELocale.texts.MonthAndYear
            objectName: "showcaseEDatePicker0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDatePicker {
                        type: "month"
                        width: Math.min(480, parent.width)
                    }
                    EDatePicker {
                        type: "year"
                        width: Math.min(480, parent.width)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDatePicker {
                    type: "month"
                    width: Math.min(480, parent.width)
                }
                EDatePicker {
                    type: "year"
                    width: Math.min(480, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePicker"

        ExampleCase {
            objectName: "showcaseEDatePicker1"
            title: ELocale.texts.DateConstraints
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDatePicker {
                    type: "date"
                    minDate: new Date(2026, 0, 1)
                    maxDate: new Date(2026, 11, 31)
                    width: Math.min(480, parent.width)
                    disabledDate: function(date) { return date.getDay() === 0 || date.getDay() === 6 }
                }
            `)

            EDatePicker {
                type: "date"
                minDate: new Date(2026, 0, 1)
                maxDate: new Date(2026, 11, 31)
                width: Math.min(480, parent.width)
                disabledDate: function(date) { return date.getDay() === 0 || date.getDay() === 6 }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePicker"

        ExampleCase {
            objectName: "showcaseEDatePicker2"
            title: ELocale.texts.WeekNumbersAndConfirmation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDatePicker {
                    showFooter: true
                    showConfirm: true
                    showWeekNumber: true
                    width: Math.min(480, parent.width)
                }
            `)

            EDatePicker {
                showFooter: true
                showConfirm: true
                showWeekNumber: true
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ETimePicker"

        ExampleCase {
            title: ELocale.texts.TimeRanges
            objectName: "showcaseETimePicker0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimePicker {
                    isRange: true
                    width: Math.min(480, parent.width)
                    endPlaceholder: ELocale.texts.EndTime
                    startPlaceholder: ELocale.texts.StartTime
                }
            `)

            ETimePicker {
                isRange: true
                width: Math.min(480, parent.width)
                endPlaceholder: ELocale.texts.EndTime
                startPlaceholder: ELocale.texts.StartTime
            }
        }
    }
    ExampleSection {
        componentName: "ETimePicker"

        ExampleCase {
            objectName: "showcaseETimePicker1"
            title: ELocale.texts.DisabledTimes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimePicker {
                    width: Math.min(480, parent.width)
                    disabledHours: function() { return [0, 1, 2, 3, 4, 5, 23] }
                    disabledMinutes: function(hour) { return hour === 6 ? [0, 15, 30] : [] }
                }
            `)

            ETimePicker {
                width: Math.min(480, parent.width)
                disabledHours: function() { return [0, 1, 2, 3, 4, 5, 23] }
                disabledMinutes: function(hour) { return hour === 6 ? [0, 15, 30] : [] }
            }
        }
    }
    ExampleSection {
        componentName: "ETimePicker"

        ExampleCase {
            objectName: "showcaseETimePicker2"
            title: ELocale.texts.ArrowControlsAndFormats
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimePicker {
                    format: "HH:mm"
                    arrowControl: true
                    showSeconds: false
                    width: Math.min(480, parent.width)
                }
            `)

            ETimePicker {
                format: "HH:mm"
                arrowControl: true
                showSeconds: false
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCase {
            objectName: "showcaseEAutocomplete0"
            title: ELocale.texts.FocusSuggestions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAutocomplete {
                    triggerOnFocus: true
                    highlightFirstItem: true
                    width: Math.min(480, parent.width)
                    model: ["QML", "Qt Quick", "Qt Widgets", "C++"]
                }
            `)

            EAutocomplete {
                triggerOnFocus: true
                highlightFirstItem: true
                width: Math.min(480, parent.width)
                model: ["QML", "Qt Quick", "Qt Widgets", "C++"]
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCase {
            objectName: "showcaseEAutocomplete1"
            title: ELocale.texts.ObjectSuggestions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAutocomplete {
                    valueKey: "id"
                    textRole: "name"
                    selectWhenUnmatched: true
                    width: Math.min(480, parent.width)
                    model: [{name: "Alpha", id: "a"}, {name: "Beta", id: "b"}]
                }
            `)

            EAutocomplete {
                valueKey: "id"
                textRole: "name"
                selectWhenUnmatched: true
                width: Math.min(480, parent.width)
                model: [{name: "Alpha", id: "a"}, {name: "Beta", id: "b"}]
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCase {
            objectName: "showcaseEAutocomplete2"
            title: ELocale.texts.DebounceAndPopupSizing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAutocomplete {
                    debounce: 300
                    popupWidth: 300
                    popupMaxHeight: 120
                    fitInputWidth: false
                    width: Math.min(480, parent.width)
                    model: [ELocale.texts.Design, "Develop", "Deploy"]
                }
            `)

            EAutocomplete {
                debounce: 300
                popupWidth: 300
                popupMaxHeight: 120
                fitInputWidth: false
                width: Math.min(480, parent.width)
                model: [ELocale.texts.Design, "Develop", "Deploy"]
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCase {
            title: ELocale.texts.MonthAndYear
            objectName: "showcaseEDatePickerPanel0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDatePickerPanel {
                        type: "month"
                        width: Math.min(480, parent.width)
                    }
                    EDatePickerPanel {
                        type: "year"
                        width: Math.min(480, parent.width)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDatePickerPanel {
                    type: "month"
                    width: Math.min(480, parent.width)
                }
                EDatePickerPanel {
                    type: "year"
                    width: Math.min(480, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCase {
            title: ELocale.texts.DateConstraints
            objectName: "showcaseEDatePickerPanel1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDatePickerPanel {
                    type: "date"
                    minDate: new Date(2026, 0, 1)
                    maxDate: new Date(2026, 11, 31)
                    width: Math.min(480, parent.width)
                    disabledDate: function(date) { return date.getDay() === 0 || date.getDay() === 6 }
                }
            `)

            EDatePickerPanel {
                type: "date"
                minDate: new Date(2026, 0, 1)
                maxDate: new Date(2026, 11, 31)
                width: Math.min(480, parent.width)
                disabledDate: function(date) { return date.getDay() === 0 || date.getDay() === 6 }
            }
        }
    }
    ExampleSection {
        componentName: "EDatePickerPanel"

        ExampleCase {
            objectName: "showcaseEDatePickerPanel2"
            title: ELocale.texts.WeekNumbersAndConfirmation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDatePickerPanel {
                    showFooter: true
                    showConfirm: true
                    showWeekNumber: true
                    width: Math.min(480, parent.width)
                }
            `)

            EDatePickerPanel {
                showFooter: true
                showConfirm: true
                showWeekNumber: true
                width: Math.min(480, parent.width)
            }
        }
    }
}
