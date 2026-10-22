import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control

    property var values: []
    property int barSize: 12
    property int diameter: 160
    property real maximum: 100
    property bool circular: false
    property bool vertical: false
    property bool labelsOnTop: false

    readonly property real total: items.reduce(function(sum, item) { return sum + Number(item.value) }, 0)
    readonly property var items: EDataUtils.isArray(values) ? values.filter(function(item) {
        return item && typeof item === "object" && isFinite(item.value) && item.value >= 0
    }) : []

    function fractionAt(index) {
        if (!isFinite(maximum) || maximum <= 0 || index < 0 || index >= items.length || Math.floor(index) !== index)
            return 0
        let before = 0
        for (let position = 0; position < index; ++position)
            before += Number(items[position].value)
        return Math.max(0, Math.min(items[index].value, maximum - before)) / maximum
    }

    implicitWidth: circular ? Math.max(240, diameter) : vertical ? 240 : 360
    implicitHeight: circular ? ring.height + legend.implicitHeight + 12
        : vertical ? 180 : barSize + legend.implicitHeight + 12

    onValuesChanged: ring.requestPaint()
    onBarSizeChanged: ring.requestPaint()
    onMaximumChanged: ring.requestPaint()

    EClip {
        id: track

        clip: true
        visible: !control.circular
        radius: control.barSize / 2
        width: control.vertical ? control.barSize : control.width
        height: control.vertical ? control.height : control.barSize
        y: !control.vertical && control.labelsOnTop ? legend.implicitHeight + 12 : 0

        Rectangle {
            anchors.fill: parent
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        Repeater {
            model: control.items

            Rectangle {
                readonly property real fraction: control.fractionAt(index)
                readonly property real preceding: {
                    let value = 0
                    for (let position = 0; position < index; ++position)
                        value += control.fractionAt(position)
                    return value
                }

                x: control.vertical ? 0 : track.width * preceding
                y: control.vertical ? track.height * preceding : 0
                width: control.vertical ? track.width : track.width * fraction
                height: control.vertical ? track.height * fraction : track.height
                color: modelData.color || EPaletteManager.ThemePalette.fetchColorForStyle(
                    [EStyle.Primary, EStyle.Success, EStyle.Warning, EStyle.Info][index % 4])
            }
        }
    }
    Canvas {
        id: ring

        height: width
        visible: control.circular
        objectName: "meterGroupRing"
        x: Math.max(0, (control.width - width) / 2)
        y: control.labelsOnTop ? legend.implicitHeight + 12 : 0
        width: Math.max(0, Math.min(control.width, control.diameter))

        onWidthChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            const context = getContext("2d")
            context.reset()
            if (width <= 0)
                return
            const stroke = Math.max(1, Math.min(width / 2, control.barSize))
            const radius = Math.max(0, (width - stroke - 2) / 2)
            const center = width / 2
            let start = -Math.PI / 2
            context.lineWidth = stroke
            context.strokeStyle = EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            context.beginPath()
            context.arc(center, center, radius, start, start + Math.PI * 2)
            context.stroke()
            for (let index = 0; index < control.items.length; ++index) {
                const angle = control.fractionAt(index) * Math.PI * 2
                if (angle <= 0)
                    continue
                context.strokeStyle = control.items[index].color || EPaletteManager.ThemePalette.fetchColorForStyle(
                    [EStyle.Primary, EStyle.Success, EStyle.Warning, EStyle.Info][index % 4])
                context.beginPath()
                context.arc(center, center, radius, start, start + angle)
                context.stroke()
                start += angle
            }
        }

        Column {
            spacing: 4
            width: ring.width
            anchors.centerIn: ring
            visible: ring.width >= 80

            EText {
                width: ring.width
                font.pixelSize: 26
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                text: Number(control.total.toFixed(2))
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            }
            EText {
                width: ring.width
                text: "/ " + control.maximum
                horizontalAlignment: Text.AlignHCenter
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            }
        }
    }
    Flow {
        id: legend

        spacing: 12
        width: Math.max(0, control.width - x)
        x: control.vertical && !control.circular ? control.barSize + 12 : 0
        y: control.labelsOnTop || control.vertical && !control.circular ? 0
            : control.circular ? ring.height + 12 : control.barSize + 12

        Repeater {
            model: control.items

            Row {
                spacing: 6

                Rectangle {
                    radius: 5
                    width: 10
                    height: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: modelData.color || EPaletteManager.ThemePalette.fetchColorForStyle(
                        [EStyle.Primary, EStyle.Success, EStyle.Warning, EStyle.Info][index % 4])
                }
                EText {
                    text: String(modelData.label || "")
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                }
                EText {
                    font.bold: true
                    text: modelData.value
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
        }
    }
    Connections {
        function onDarkChanged() { ring.requestPaint() }

        target: ETheme
    }
}
