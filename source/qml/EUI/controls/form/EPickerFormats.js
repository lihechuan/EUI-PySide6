.pragma library

function padded(value, length) {
    let result = String(value)
    while (result.length < (length || 2)) result = "0" + result
    return result
}

function validDate(value) {
    return value && typeof value.getTime === "function" && !isNaN(value.getTime())
}

function tokens(format) {
    const result = []
    const expression = /\[[^\]]*\]|'[^']*'|YYYY|yyyy|MMMM|dddd|MMM|ddd|SSS|YY|yy|MM|DD|dd|HH|hh|mm|ss|ZZ|AP|ap|WW|ww|M|D|d|H|h|m|s|A|a|Q|Z|X|x|W|w|./g
    let match
    while ((match = expression.exec(format))) {
        const text = match[0]
        result.push({ text: text, literal: text[0] === "[" || text[0] === "'" })
    }
    return result
}

function weekNumber(date) {
    const day = new Date(date.getFullYear(), date.getMonth(), date.getDate())
    day.setDate(day.getDate() + 3 - (day.getDay() + 6) % 7)
    const first = new Date(day.getFullYear(), 0, 4)
    return 1 + Math.round(((day - first) / 86400000 - 3 + (first.getDay() + 6) % 7) / 7)
}

function formatDate(date, pattern, locale) {
    if (!validDate(date)) return ""
    const parts = tokens(pattern)
    function has(expression) {
        return parts.some(function(token) { return !token.literal && expression.test(token.text) })
    }
    const hours = has(/^(H|HH|h|hh|A|a|AP|ap)$/) ? date.getHours() : 0
    const month = has(/^(M|MM|MMM|MMMM|Q)$/) ? date.getMonth() : 0
    const year = has(/^(YYYY|yyyy|YY|yy)$/) ? date.getFullYear() : 0
    const day = has(/^(D|DD|d|dd)$/) ? date.getDate() : 0
    const weekday = has(/^(d|dd|ddd|dddd)$/) ? date.getDay() : 0
    const week = has(/^(W|WW|w|ww)$/) ? weekNumber(date) : 0
    const qt = pattern.indexOf("yyyy") >= 0 || pattern.indexOf("yy") >= 0
    const zone = has(/^(Z|ZZ)$/) ? -date.getTimezoneOffset() : 0
    const offset = (zone < 0 ? "-" : "+") + padded(Math.floor(Math.abs(zone) / 60)) + ":" + padded(Math.abs(zone) % 60)
    const values = {YYYY: year, yyyy: year, YY: padded(year % 100),
        yy: padded(year % 100), M: month + 1, MM: padded(month + 1),
        D: day, DD: padded(day), d: qt ? day : weekday, dd: qt ? padded(day) : undefined,
        H: hours, HH: padded(hours), h: hours % 12 || 12, hh: padded(hours % 12 || 12),
        m: has(/^(m|mm)$/) ? date.getMinutes() : 0, s: has(/^(s|ss)$/) ? date.getSeconds() : 0,
        SSS: has(/^SSS$/) ? padded(date.getMilliseconds(), 3) : "000", A: hours < 12 ? "AM" : "PM", a: hours < 12 ? "am" : "pm",
        AP: hours < 12 ? "AM" : "PM", ap: hours < 12 ? "am" : "pm", Q: Math.floor(month / 3) + 1,
        Z: offset, ZZ: offset.replace(":", ""), X: Math.floor(date.getTime() / 1000), x: date.getTime(),
        W: week, WW: padded(week), w: week, ww: padded(week)}
    values.mm = padded(values.m)
    values.ss = padded(values.s)
    return parts.map(function(token) {
        if (!token.literal) {
            if (token.text === "MMM" || token.text === "MMMM")
                return locale.monthName(month, token.text === "MMM" ? 1 : 0)
            if (token.text === "ddd" || token.text === "dddd" || token.text === "dd" && !qt) {
                const name = locale.dayName((weekday + 6) % 7 + 1, token.text === "dddd" ? 0 : 1)
                return token.text === "dd" ? name.slice(0, 2) : name
            }
        }
        return token.literal ? token.text.slice(1, -1) : values[token.text] !== undefined ? String(values[token.text]) : token.text
    }).join("")
}

function parseDate(input, pattern, locale, baseDate) {
    if (validDate(input)) return new Date(input.getTime())
    if (typeof input === "number") {
        const numberDate = new Date(input)
        return validDate(numberDate) ? numberDate : null
    }
    const text = String(input === undefined || input === null ? "" : input)
    if (!text) return null
    const qt = pattern.indexOf("yyyy") >= 0 || pattern.indexOf("yy") >= 0
    const parts = tokens(pattern)
    const captures = []
    let expression = "^"
    for (let index = 0; index < parts.length; ++index) {
        const token = parts[index]
        const name = token.text
        if (token.literal) expression += token.text.slice(1, -1).replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
        else if (/^(YYYY|yyyy|YY|yy|M|MM|D|DD|H|HH|h|hh|m|mm|s|ss|SSS|Q|W|WW|w|ww|X|x)$/.test(name) || (qt && /^(d|dd)$/.test(name))) {
            captures.push(name)
            expression += name === "YYYY" || name === "yyyy" ? "(\\d{4})"
                : name === "X" || name === "x" ? "(-?\\d+)" : name === "SSS" ? "(\\d{3})"
                : name.length === 2 ? "(\\d{2})" : "(\\d{1,2})"
        } else if (/^(MMM|MMMM|ddd|dddd|A|a|AP|ap|Z|ZZ)$/.test(name)) {
            captures.push(name)
            expression += name === "Z" ? "([+-]\\d{2}:\\d{2}|Z)" : name === "ZZ" ? "([+-]\\d{4}|Z)" : "(.+?)"
        } else expression += name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
    }
    const match = new RegExp(expression + "$", "i").exec(text)
    if (!match) return null
    const base = validDate(baseDate) ? baseDate : new Date(2000, 0, 1)
    let year = base.getFullYear()
    let month = base.getMonth()
    let day = base.getDate()
    let hour = 0
    let minute = 0
    let second = 0
    let milliseconds = 0
    let meridiem = ""
    let zone = null
    let twelveHours = false
    let selectedWeek = null
    for (let index = 0; index < captures.length; ++index) {
        const key = captures[index]
        const raw = match[index + 1]
        const number = Number(raw)
        if (key === "X" || key === "x") {
            const timestamp = new Date(number * (key === "X" ? 1000 : 1))
            return validDate(timestamp) ? timestamp : null
        }
        if (key === "YYYY" || key === "yyyy") year = number
        else if (key === "YY" || key === "yy") year = number + (number > 68 ? 1900 : 2000)
        else if (key === "M" || key === "MM") month = number - 1
        else if (key === "MMM" || key === "MMMM") {
            month = -1
            for (let candidate = 0; candidate < 12; ++candidate)
                if (locale.monthName(candidate, key === "MMM" ? 1 : 0).toLowerCase() === raw.toLowerCase()) month = candidate
        } else if (key === "Q") month = (number - 1) * 3
        else if (key === "W" || key === "WW" || key === "w" || key === "ww") selectedWeek = number
        else if (key === "D" || key === "DD" || (qt && (key === "d" || key === "dd"))) day = number
        else if (key === "H" || key === "HH" || key === "h" || key === "hh") {
            hour = number
            twelveHours = key === "h" || key === "hh"
        } else if (key === "m" || key === "mm") minute = number
        else if (key === "s" || key === "ss") second = number
        else if (key === "SSS") milliseconds = number
        else if (key === "A" || key === "a" || key === "AP" || key === "ap") meridiem = raw.toUpperCase()
        else if (key === "Z" || key === "ZZ") zone = raw
    }
    if (twelveHours && (hour < 1 || hour > 12)) return null
    if (meridiem && meridiem !== "AM" && meridiem !== "PM") return null
    if (twelveHours && meridiem) hour = hour % 12 + (meridiem === "PM" ? 12 : 0)
    if (year < 100 || month < 0 || month > 11 || day < 1 || day > 31 || hour > 23 || minute > 59 || second > 59) return null
    const date = new Date(year, month, day, hour, minute, second, milliseconds)
    if (date.getFullYear() !== year || date.getMonth() !== month || date.getDate() !== day) return null
    if (selectedWeek !== null) {
        if (selectedWeek < 1 || selectedWeek > 53) return null
        const first = new Date(year, 0, 4, hour, minute, second, milliseconds)
        first.setDate(first.getDate() - (first.getDay() + 6) % 7 + (selectedWeek - 1) * 7)
        if (weekNumber(first) !== selectedWeek) return null
        return first
    }
    if (zone && zone !== "Z") {
        const values = /([+-])(\d{2}):?(\d{2})/.exec(zone)
        if (!values || Number(values[2]) > 23 || Number(values[3]) > 59) return null
        const offset = (Number(values[2]) * 60 + Number(values[3])) * (values[1] === "-" ? -1 : 1)
        return new Date(Date.UTC(year, month, day, hour, minute, second, milliseconds) - offset * 60000)
    }
    return zone === "Z" ? new Date(Date.UTC(year, month, day, hour, minute, second, milliseconds)) : date
}

function popupPosition(control, popup, window, placement, fallbacks) {
    function position(name) {
        const side = name.split("-")[0]
        const vertical = side === "top" || side === "bottom"
        const end = name.indexOf("end") >= 0
        const start = name.indexOf("start") >= 0
        return {x: vertical ? end ? control.width - popup.width : start ? 0 : (control.width - popup.width) / 2
                : side === "left" ? -popup.width - 6 : control.width + 6,
            y: vertical ? side === "top" ? -popup.height - 6 : control.height + 6
                : end ? control.height - popup.height : start ? 0 : (control.height - popup.height) / 2}
    }
    const choices = [placement].concat(Array.isArray(fallbacks) ? fallbacks : [])
    const point = window ? control.mapToItem(window.contentItem, 0, 0) : null
    for (let index = 0; index < choices.length; ++index) {
        const candidate = position(choices[index])
        if (!point || point.x + candidate.x >= 8 && point.y + candidate.y >= 8
                && point.x + candidate.x + popup.width <= window.width - 8
                && point.y + candidate.y + popup.height <= window.height - 8) return candidate
    }
    return position(placement)
}

function localeName(configured, fallback) {
    const name = typeof configured === "string" ? configured : configured && configured.name || fallback
    return name === "zh" || name === "zh-CN" ? "zh_CN" : name === "en" ? "en_US" : name
}
