import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls

Control {
    id: control

    property var events: []
    property bool draggable: true
    property bool readOnly: false
    property string view: "month"
    property date date: new Date()
    property int firstDayOfWeek: 1
    property Component eventDelegate: null

    readonly property var visibleDays: days()
    readonly property string errorString: validate()

    signal changed(var events)
    signal slotClicked(date date)
    signal eventClicked(var event)
    signal eventMoved(var event, date previousStart)

    function startOfDay(value) {
        const result = new Date(value)
        result.setHours(0, 0, 0, 0)
        return result
    }

    function eventsFor(day) {
        if (errorString)
            return []
        const start = startOfDay(day)
        const end = new Date(start)
        end.setDate(end.getDate() + 1)
        return events.filter(function(event) {
            return new Date(event.start) < end && new Date(event.end) > start
        }).sort(function(a, b) { return new Date(a.start) - new Date(b.start) })
    }

    function days() {
        const first = startOfDay(date)
        if (!isFinite(first.getTime()))
            return []
        if (view === "month")
            first.setDate(1)
        if (view !== "day")
            first.setDate(first.getDate() - (first.getDay() - firstDayOfWeek + 7) % 7)
        const count = view === "day" ? 1 : view === "week" ? 7 : 42
        const result = []
        for (let index = 0; index < count; ++index) {
            const day = new Date(first)
            day.setDate(first.getDate() + index)
            result.push(day)
        }
        return result
    }

    function navigate(delta) {
        if (!enabled || !isFinite(delta) || Math.floor(delta) !== delta)
            return false
        const next = new Date(date)
        if (view === "month") {
            const day = next.getDate()
            next.setDate(1)
            next.setMonth(next.getMonth() + delta)
            const last = new Date(next.getFullYear(), next.getMonth() + 1, 0).getDate()
            next.setDate(Math.min(day, last))
        } else {
            next.setDate(next.getDate() + delta * (view === "week" ? 7 : 1))
        }
        date = next
        return true
    }

    function resizeEvent(key, end) {
        if (!enabled || readOnly || errorString)
            return false
        const index = events.findIndex(function(event) { return event.key === key })
        const next = new Date(end)
        if (index < 0 || events[index].disabled || !isFinite(next.getTime()) || next <= new Date(events[index].start))
            return false
        const result = events.slice()
        result[index] = Object.assign({}, result[index], {end: next})
        events = result
        changed(events)
        return true
    }

    function dropEvent(event, point) {
        for (let index = 0; index < dayRepeater.count; ++index) {
            const cell = dayRepeater.itemAt(index)
            const local = cell.mapFromItem(control, point.x, point.y)
            if (local.x >= 0 && local.x < cell.width && local.y >= 0 && local.y < cell.height) {
                const start = new Date(cell.day)
                const original = new Date(event.start)
                start.setHours(original.getHours(), original.getMinutes(), original.getSeconds(), original.getMilliseconds())
                return moveEvent(event.key, start)
            }
        }
        return false
    }

    function validate() {
        if (!EDataUtils.isArray(events) || !isFinite(new Date(date).getTime())
            || ["day", "week", "month"].indexOf(view) < 0 || firstDayOfWeek < 0 || firstDayOfWeek > 6)
            return "invalid-calendar-model"
        const keys = []
        for (let index = 0; index < events.length; ++index) {
            const event = events[index]
            if (!event || event.key === undefined || keys.indexOf(event.key) >= 0
                || !isFinite(new Date(event.start).getTime()) || !isFinite(new Date(event.end).getTime())
                || new Date(event.end) <= new Date(event.start))
                return "invalid-event"
            keys.push(event.key)
        }
        return ""
    }

    function moveEvent(key, start) {
        if (!enabled || readOnly || errorString)
            return false
        const index = events.findIndex(function(event) { return event.key === key })
        const next = new Date(start)
        if (index < 0 || events[index].disabled || !isFinite(next.getTime()))
            return false
        const original = events[index]
        const duration = new Date(original.end) - new Date(original.start)
        const replacement = Object.assign({}, original, {start: next, end: new Date(next.getTime() + duration)})
        const result = events.slice()
        result[index] = replacement
        events = result
        eventMoved(replacement, new Date(original.start))
        changed(events)
        return true
    }

    implicitWidth: 840
    implicitHeight: view === "month" ? 580 : 400

    RowLayout {
        id: toolbar

        spacing: 8
        width: control.width

        EButton {
            text: ELocale.texts.Today

            onClicked: control.date = new Date()
        }
        ETextButton {
            width: 32
            iconSize: 18
            iconSource: EIcons.CHEVRON_LEFT
            Accessible.name: ELocale.texts.Previous

            onClicked: control.navigate(-1)
        }
        ETextButton {
            width: 32
            iconSize: 18
            iconSource: EIcons.CHEVRON_RIGHT
            Accessible.name: ELocale.texts.Next

            onClicked: control.navigate(1)
        }
        EText {
            font.bold: true
            font.pixelSize: 16
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: Qt.formatDate(control.date, control.view === "month" ? "yyyy / MM" : "yyyy / MM / dd")
        }
        Row {
            spacing: 2

            Repeater {
                model: ["day", "week", "month"]

                ETextButton {
                    id: viewButton

                    readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                    checkable: true
                    leftPadding: 12
                    rightPadding: 12
                    checked: control.view === modelData
                    styleType: checked ? EStyle.Primary : EStyle.Default
                    text: ELocale.texts[modelData === "day" ? "SchedulerDay" : modelData === "week" ? "SchedulerWeek" : "SchedulerMonth"]
                    background: ERectangle {
                        radius: 4
                        color: viewButton.checked
                            ? Qt.rgba(viewButton.accent.r, viewButton.accent.g, viewButton.accent.b, ETheme.dark ? 0.2 : 0.1)
                            : viewButton.hovered ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark) : "transparent"
                    }

                    onClicked: control.view = modelData
                }
            }
        }
    }
    Row {
        id: weekdays

        width: control.width
        y: toolbar.height + 12
        visible: control.view === "month"

        Repeater {
            model: 7

            EText {
                height: 32
                font.pixelSize: 12
                width: weekdays.width / 7
                objectName: "schedulerWeekday"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                text: Qt.locale(ELocale.language === "zh" ? "zh_CN" : "en_US")
                    .dayName((index + control.firstDayOfWeek + 6) % 7 + 1, Locale.ShortFormat)
            }
        }
    }
    ERectangle {
        radius: 6
        y: calendar.y
        height: calendar.height
        anchors.left: calendar.left
        anchors.right: calendar.right
        color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    Grid {
        id: calendar

        x: 1
        width: Math.max(0, control.width - 2)
        columns: control.view === "day" ? 1 : 7
        height: Math.max(0, control.height - y - 1)
        y: weekdays.y + (weekdays.visible ? weekdays.height : 0)

        Repeater {
            id: dayRepeater

            model: control.visibleDays

            Rectangle {
                id: cell

                readonly property date day: modelData
                readonly property bool currentMonth: day.getMonth() === control.date.getMonth()
                readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                readonly property bool today: control.startOfDay(day).getTime() === control.startOfDay(new Date()).getTime()

                width: Math.max(0, (calendar.width - (calendar.columns - 1) * calendar.spacing) / calendar.columns)
                height: Math.max(0, (calendar.height - (control.view === "month" ? 5 : 0) * calendar.spacing)
                    / (control.view === "month" ? 6 : 1))
                color: currentMonth ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                    : EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)

                Rectangle {
                    height: 1
                    width: parent.width
                    anchors.bottom: parent.bottom
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
                Rectangle {
                    width: 1
                    height: parent.height
                    anchors.right: parent.right
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
                TapHandler {
                    onTapped: control.slotClicked(cell.day)
                }
                ERectangle {
                    x: 8
                    y: 6
                    height: 24
                    radius: 12
                    color: cell.today ? cell.accent : "transparent"
                    width: Math.max(24, dayLabel.implicitWidth + 12)

                    EText {
                        id: dayLabel

                        font.pixelSize: 12
                        font.bold: cell.today
                        anchors.centerIn: parent
                        objectName: "schedulerDayLabel"
                        color: cell.today ? "white" : cell.currentMonth
                            ? EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        text: control.view === "month" ? Qt.formatDate(cell.day, "d")
                            : Qt.locale(ELocale.language === "zh" ? "zh_CN" : "en_US")
                                .dayName((cell.day.getDay() + 6) % 7 + 1, Locale.ShortFormat)
                                + " " + Qt.formatDate(cell.day, "M/d")
                    }
                }
                Flickable {
                    x: 6
                    y: 34
                    clip: true
                    contentWidth: width
                    contentHeight: eventColumn.height
                    ScrollBar.vertical: ScrollHandle {}
                    width: Math.max(0, parent.width - 12)
                    height: Math.max(0, parent.height - y - 3)

                    Column {
                        id: eventColumn

                        spacing: 4
                        width: parent.width

                        Repeater {
                            model: control.eventsFor(cell.day)

                            ETextButton {
                                id: eventCard

                                readonly property var eventData: modelData
                                readonly property color accent: eventData.color || EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                                minHeight: 28
                                leftPadding: 8
                                rightPadding: 6
                                width: eventColumn.width
                                enabled: !eventData.disabled
                                text: (eventData.allDay ? "" : Qt.formatTime(new Date(eventData.start), "hh:mm") + " ") + eventData.title
                                background: ERectangle {
                                    radius: 4
                                    color: Qt.rgba(eventCard.accent.r, eventCard.accent.g, eventCard.accent.b,
                                        eventCard.hovered ? 0.24 : ETheme.dark ? 0.18 : 0.1)

                                    Rectangle {
                                        x: 0
                                        y: 5
                                        width: 3
                                        radius: 1
                                        color: eventCard.accent
                                        height: Math.max(0, parent.height - 10)
                                    }
                                }
                                contentItem: EText {
                                    font.pixelSize: 12
                                    text: eventCard.text
                                    elide: Text.ElideRight
                                    visible: !control.eventDelegate
                                    verticalAlignment: Text.AlignVCenter
                                    color: !eventCard.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                                        : ETheme.dark ? Qt.lighter(eventCard.accent, 1.4) : Qt.darker(eventCard.accent, 1.15)
                                }

                                onClicked: control.eventClicked(eventData)

                                Loader {
                                    readonly property var eventData: eventCard.eventData

                                    anchors.fill: parent
                                    sourceComponent: control.eventDelegate
                                }
                                DragGesture {
                                    anchors.fill: parent
                                    enabled: control.draggable && !control.readOnly

                                    onTapped: control.eventClicked(eventCard.eventData)
                                    onDropped: function(x, y) {
                                        control.dropEvent(eventCard.eventData, mapToItem(control, x, y))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
