(function () {
    "use strict"

    let chart = null
    let theme = null
    let bridge = null
    let configuration = ""
    let pendingResize = false
    const container = document.getElementById("chart")

    function report(event, parameters) {
        if (!bridge) return
        bridge.report(event, JSON.stringify(parameters || {}, function (key, value) {
            return key === "event" ? undefined : value
        }))
    }

    function resize() {
        if (pendingResize) return
        pendingResize = true
        requestAnimationFrame(function () {
            pendingResize = false
            if (chart) chart.resize()
        })
    }

    function replaceTheme(value, previous, next) {
        if (value === previous) return next
        if (Array.isArray(previous))
            return JSON.stringify(value) === JSON.stringify(previous) ? next : value
        if (!previous || !next || typeof previous !== "object" || typeof value !== "object" || !value)
            return value
        if (Array.isArray(value)) {
            value.forEach(function (item) { replaceTheme(item, previous, next) })
        } else {
            Object.keys(previous).forEach(function (key) {
                if (Object.prototype.hasOwnProperty.call(value, key)
                    && Object.prototype.hasOwnProperty.call(next, key))
                    value[key] = replaceTheme(value[key], previous[key], next[key])
            })
        }
        return value
    }

    function updatePalette(option, previous, next) {
        if (!option || !previous) return
        Object.keys(previous).forEach(function (key) {
            if (!/^(category|value|log|time)Axis$/.test(key))
                option[key] = replaceTheme(option[key], previous[key], next[key])
        })
        for (const key of ["xAxis", "yAxis"]) {
            const axes = option[key] || []
            axes.forEach(function (axis) {
                if (!axis) return
                const type = (axis.type || "value") + "Axis"
                replaceTheme(axis, previous[type], next[type])
            })
        }
    }

    function render(packet) {
        try {
            const next = JSON.parse(packet)
            const key = JSON.stringify([next.renderer, next.locale])
            const paletteChanged = JSON.stringify(theme) !== JSON.stringify(next.theme)
            if (!chart || key !== configuration) {
                const previous = chart ? chart.getOption() : null
                if (paletteChanged) updatePalette(previous, theme, next.theme)
                if (chart) chart.dispose()
                chart = null
                chart = echarts.init(container, next.theme, {
                    renderer: next.renderer,
                    locale: next.locale
                })
                configuration = key
                for (const event of ["click", "datazoom", "legendselectchanged", "finished"]) {
                    chart.on(event, function (parameters) { report(event, parameters) })
                }
                if (previous) chart.setOption(previous, {notMerge: true, silent: true})
                else chart.clear()
            } else if (paletteChanged) {
                const previous = chart.getOption()
                updatePalette(previous, theme, next.theme)
                chart.setTheme(next.theme, {silent: true})
                if (previous) chart.setOption(previous, {notMerge: true, silent: true})
            }
            theme = next.theme
            if (next.applyOption) {
                if (Object.keys(next.option).length) chart.setOption(next.option, next.settings)
                else chart.clear()
            }
            bridge.report("ready", "{}")
        } catch (error) {
            if (chart) chart.dispose()
            chart = null
            theme = null
            configuration = ""
            bridge.report("error", String(error.message || error))
        }
    }

    new QWebChannel(qt.webChannelTransport, function (channel) {
        bridge = channel.objects.chartBridge
        bridge.renderRequested.connect(render)
        bridge.commandRequested.connect(function (name, payload) {
            if (!chart) return
            try {
                const parameters = JSON.parse(payload)
                if (name === "clear") chart.clear()
                else if (name === "resize") resize()
                else if (name === "appendData") chart.appendData(parameters)
                else if (name === "dispatchAction") chart.dispatchAction(parameters)
            } catch (error) {
                bridge.report("error", String(error.message || error))
            }
        })
        bridge.attach()
    })

    const observer = new ResizeObserver(resize)
    observer.observe(container)
    window.addEventListener("pagehide", function () {
        observer.disconnect()
        if (chart) chart.dispose()
        chart = null
    })
}())
