import EUI 1.0
import QtQuick 2.15

ExamplePage {
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
}
