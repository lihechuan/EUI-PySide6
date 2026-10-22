import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Button {
    id: control

    property bool bg: false
    property int iconSource
    property bool link: false
    property real progress: -1
    property bool circle: false
    property int duration: 2600
    property int strokeWidth: 3
    property bool loading: false
    property bool leftIcon: false
    property bool autofocus: false
    property int loadingIconSource
    property int paddingSpacing: 6
    property string accessibleName: text
    property string nativeType: "button"
    property Component iconComponent: null
    property Component loadingComponent: null
    property int size: EControlConfig.sizeFor(control)
    property int iconSize: EDefaultConfig.iconSize(control.size)
    property color color: EPaletteManager.BasePalette.transparent
    property int minHeight: EDefaultConfig.controlHeight(control.size)
    property bool plain: EControlConfig.optionFor(control, "button", "plain", false)
    property bool round: EControlConfig.optionFor(control, "button", "round", false)
    property bool dashed: EControlConfig.optionFor(control, "button", "dashed", false)
    property int styleType: EControlConfig.styleFor(control, "button", "type", EStyle.Default)
    property bool textButton: link || EControlConfig.optionFor(control, "button", "text", false)
    property bool autoInsertSpace: EControlConfig.optionFor(control, "button", "autoInsertSpace", false)

    readonly property string displayText: autoInsertSpace && /^[\u4e00-\u9fff]{2}$/.test(text)
        ? text[0] + " " + text[1]
        : text

    function activateForm() {
        if (loading || !enabled || nativeType === "button")
            return
        let ancestor = parent
        while (ancestor) {
            if (typeof ancestor.getField === "function" && typeof ancestor.validate === "function") {
                if (nativeType === "submit" && typeof ancestor.submit === "function")
                    ancestor.submit()
                else if (nativeType === "reset" && typeof ancestor.resetFields === "function")
                    ancestor.resetFields()
                return
            }
            ancestor = ancestor.parent
        }
    }

    font.bold: true
    focusPolicy: Qt.StrongFocus
    Keys.priority: Keys.BeforeItem
    Accessible.role: Accessible.Button
    Accessible.name: control.accessibleName
    implicitHeight: Math.max(0, control.minHeight)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    leftPadding: control.circle ? 0 : EDefaultConfig.horizontalPadding(control.size)
    rightPadding: control.circle ? 0 : EDefaultConfig.horizontalPadding(control.size)
    implicitWidth: control.circle ? control.minHeight : implicitContentWidth + leftPadding + rightPadding
    Accessible.description: control.loading ? EControlConfig.textFor(control, "Loading2", ELocale.texts) : ""
    contentItem: Loader {
        sourceComponent: control.text.length > 0 ? iconTextComponent : loadingOrIconComponent
    }
    background: ERectangle {
        id: buttonSurface

        border.width: control.dashed ? 0 : 1
        implicitHeight: Math.max(0, control.minHeight)
        radius: control.circle ? Math.max(0, control.width / 2)
            : (control.round ? 20 : 4)
        border.color: control.textButton ? color
            : EPaletteManager.StatePalette.computeBorderColor(
                EPaletteManager.createStateObject(this, EStyle.BorderColor)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setPressed(control.pressed)
                    .setEnabled(control.enabled)
                    .setPlain(control.plain)
                    .setColor(control.color)
                    .setComponentStyle(control.styleType)
                    .setBorder(true)
            )
        color: control.textButton
            ? EPaletteManager.StatePalette.adjustPlainTextButtonColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setPressed(control.pressed)
                    .setEnabled(control.enabled)
                    .setColor(EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark))
                    .setIsOpenBackgroundColor(control.bg)
            )
            : EPaletteManager.StatePalette.computeBackgroundColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setPressed(control.pressed)
                    .setEnabled(control.enabled)
                    .setPlain(control.plain)
                    .setColor(control.color)
                    .setComponentStyle(control.styleType)
            )

        Canvas {
            property real cornerRadius: buttonSurface.radius
            property color stroke: buttonSurface.border.color

            anchors.fill: parent
            visible: control.dashed && !control.textButton

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onStrokeChanged: requestPaint()
            onVisibleChanged: requestPaint()
            onCornerRadiusChanged: requestPaint()
            onPaint: {
                const context = getContext("2d")
                context.reset()
                const radius = Math.max(0, Math.min(cornerRadius, width / 2 - 0.5, height / 2 - 0.5))
                context.strokeStyle = stroke
                context.lineWidth = 1
                context.setLineDash([4, 3])
                context.beginPath()
                context.moveTo(0.5 + radius, 0.5)
                context.lineTo(width - radius - 0.5, 0.5)
                context.quadraticCurveTo(width - 0.5, 0.5, width - 0.5, radius + 0.5)
                context.lineTo(width - 0.5, height - radius - 0.5)
                context.quadraticCurveTo(width - 0.5, height - 0.5, width - radius - 0.5, height - 0.5)
                context.lineTo(radius + 0.5, height - 0.5)
                context.quadraticCurveTo(0.5, height - 0.5, 0.5, height - radius - 0.5)
                context.lineTo(0.5, radius + 0.5)
                context.quadraticCurveTo(0.5, 0.5, radius + 0.5, 0.5)
                context.closePath()
                context.stroke()
            }
        }
        ERectangle {
            height: 2
            radius: 1
            color: inside.textColor
            anchors.left: parent.left
            objectName: "buttonProgress"
            anchors.bottom: parent.bottom
            visible: control.progress >= 0 && isFinite(control.progress)
            width: isFinite(control.progress) ? parent.width * Math.max(0, Math.min(1, control.progress)) : 0
        }
    }

    Component.onCompleted: {
        if (autofocus)
            Qt.callLater(forceActiveFocus)
    }
    Keys.onPressed: {
        if (control.loading
            && (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter))
            event.accepted = true
    }
    Keys.onReleased: {
        if (control.loading
            && (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter))
            event.accepted = true
    }

    Connections {
        function onClicked() {
            control.activateForm()
        }

        target: control
    }
    QtObject {
        id: inside

        property color textColor: EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.TextColor)
                .setDark(ETheme.dark)
                .setHovered(control.hovered)
                .setPressed(control.pressed)
                .setEnabled(control.enabled)
                .setPlain(control.plain)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setTextButton(control.textButton)
        )
    }
    Component {
        id: iconTextComponent

        Item {
            implicitWidth: iconTextRow.implicitWidth
            implicitHeight: iconTextRow.implicitHeight

            Row {
                id: iconTextRow

                anchors.centerIn: parent

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    active: (control.loading || control.iconSource || control.iconComponent)
                        && control.leftIcon
                    sourceComponent: control.loading ? control.loadingComponent || loadingComponent
                        : control.iconComponent || iconComponent
                }
                EText {
                    font: control.font
                    color: inside.textColor
                    text: control.displayText
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: (control.loading || control.iconSource) && control.leftIcon
                        ? control.paddingSpacing : 0
                    rightPadding: (control.loading || control.iconSource) && !control.leftIcon
                        ? control.paddingSpacing : 0
                }
                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    active: (control.loading || control.iconSource || control.iconComponent)
                        && !control.leftIcon
                    sourceComponent: control.loading ? control.loadingComponent || loadingComponent
                        : control.iconComponent || iconComponent
                }
            }
        }
    }
    MouseArea {
        z: 100
        anchors.fill: parent
        preventStealing: true
        enabled: control.loading
        cursorShape: Qt.ArrowCursor
        objectName: "loadingBlocker"
        acceptedButtons: Qt.AllButtons
    }
    Component {
        id: loadingOrIconComponent

        Loader {
            sourceComponent: control.loading ? control.loadingComponent || loadingComponent
                : control.iconComponent || iconComponent
        }
    }
    Component {
        id: loadingComponent

        Loader {
            sourceComponent: control.loadingIconSource ? customLoadingComponent : defaultLoadingComponent
        }
    }
    Component {
        id: defaultLoadingComponent

        ELoading {
            material: true
            showBackground: false
            color: inside.textColor
            duration: control.duration
            width: Math.max(0, control.iconSize)
            height: Math.max(0, control.iconSize)
            strokeWidth: Math.max(0, control.strokeWidth)
        }
    }
    Component {
        id: customLoadingComponent

        ERotatingIcon {
            running: true
            color: inside.textColor
            duration: control.duration
            iconSource: control.loadingIconSource
            iconSize: Math.max(0, control.iconSize)
        }
    }
    Component {
        id: iconComponent

        EIcon {
            color: inside.textColor
            iconSource: control.iconSource
            iconSize: Math.max(0, control.iconSize)
        }
    }
}
