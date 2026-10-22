import EUI 1.0
import "../indicator" as IndicatorControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

TextArea {
    id: control

    property int rows: 1
    property string resize: "none"
    property var autosize: undefined
    property bool validateEvent: true
    property bool adaptiveHeight: true
    property bool showWordLimit: false
    property string validationMessage: ""
    property int maximumLength: 2147483647
    property int styleType: EStyle.Default
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None
    property color textColor: EPaletteManager.StatePalette.defaultTextColor(
        EPaletteManager.createStateObject(this, EStyle.TextColor)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
    )

    readonly property real lineHeight: Math.max(1, lineMetrics.height)
    readonly property bool hasValidationError: validationState === EValidationState.Error
    readonly property int wordCount: text.replace(/[\uD800-\uDBFF][\uDC00-\uDFFF]/g, "x").length
    readonly property int minimumRows: Math.max(1, typeof autosize === "object" && autosize
        ? Number(autosize.minRows) || rows
        : rows)
    readonly property real maximumRows: typeof autosize === "object" && autosize && isFinite(autosize.maxRows)
        ? Math.max(minimumRows, Number(autosize.maxRows)) : Infinity
    readonly property real automaticHeight: Math.max(EDefaultConfig.controlHeight(size),
        Math.min(maximumRows * lineHeight, Math.max(minimumRows * lineHeight, contentHeight))
            + topPadding
            + bottomPadding)

    function updateAdaptiveHeight() {
        if (!adaptiveHeight || autosize === false)
            return

        height = automaticHeight
    }

    function enforceLength() {
        const limit = Math.max(0, maximumLength)
        if (text.length > limit) {
            let end = limit
            if (end > 0 && /[\uD800-\uDBFF]/.test(text[end - 1]))
                --end
            text = text.slice(0, end)
        }
    }

    focus: false
    enabled: true
    selectByMouse: true
    wrapMode: Text.WrapAnywhere
    renderType: Text.QtRendering
    implicitHeight: automaticHeight
    Accessible.name: placeholderText
    Accessible.role: Accessible.EditableText
    selectionColor: EPaletteManager.BasePalette.blue
    Accessible.description: control.validationMessage
    bottomPadding: topPadding + (showWordLimit ? 22 : 0)
    selectedTextColor: EPaletteManager.BasePalette.white
    leftPadding: EDefaultConfig.horizontalPadding(control.size)
    placeholderTextColor: EPaletteManager.BasePalette.lightGray
    rightPadding: EDefaultConfig.horizontalPadding(control.size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    topPadding: size === EStyle.Small ? 4 : (size === EStyle.Large ? 10 : 7)
    color: EPaletteManager.StatePalette.computeEffectiveTextColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
            .setPlain(true)
            .setColor(textColor)
    )
    background: ERectangle {
        border.width: 1
        color: EPaletteManager.StatePalette.resolveRectBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
        )
        border.color: control.validationState !== EValidationState.None
            ? EPaletteManager.StatePalette.validationColor(control.validationState)
            : EPaletteManager.StatePalette.resolveRectBorderColor(
                EPaletteManager.createStateObject(this, EStyle.BorderColor)
                    .setActiveFocus(control.activeFocus)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setComponentStyle(control.styleType)
            )
    }

    onTextChanged: enforceLength()
    onRowsChanged: updateAdaptiveHeight()
    onSizeChanged: updateAdaptiveHeight()
    onMaximumLengthChanged: enforceLength()
    onAutosizeChanged: updateAdaptiveHeight()
    Component.onCompleted: updateAdaptiveHeight()
    onContentHeightChanged: updateAdaptiveHeight()
    onAdaptiveHeightChanged: updateAdaptiveHeight()
    onAutomaticHeightChanged: updateAdaptiveHeight()

    IndicatorControls.EToolTip {
        delay: 300
        triggerKeys: []
        trigger: "manual"
        reference: control
        text: control.validationMessage
        objectName: "inputValidationTooltip"
        visible: control.enabled && control.validationState !== EValidationState.None
            && control.validationState !== EValidationState.Success
            && control.validationMessage.length > 0
            && (control.hovered || control.activeFocus)
    }
    TextMetrics {
        id: lineMetrics

        text: "Ag"
        font: control.font
    }
    EText {
        font.pixelSize: 11
        anchors.bottomMargin: 6
        anchors.rightMargin: 12
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: control.showWordLimit
        objectName: "textareaWordCount"
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        text: String(control.wordCount)
            + (control.maximumLength < 2147483647 ? "/" + control.maximumLength : "")
    }
    MouseArea {
        property real startX: 0
        property real startY: 0
        property real startWidth: 0
        property real startHeight: 0

        width: 14
        height: 14
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: control.resize !== "none"
        enabled: control.enabled && !control.readOnly
        cursorShape: control.resize === "vertical" ? Qt.SizeVerCursor
            : control.resize === "horizontal" ? Qt.SizeHorCursor
            : Qt.SizeFDiagCursor

        onPressed: {
            const point = mapToItem(null, mouse.x, mouse.y)
            startX = point.x
            startY = point.y
            startWidth = control.width
            startHeight = control.height
            control.adaptiveHeight = false
        }
        onPositionChanged: {
            if (!pressed)
                return
            const point = mapToItem(null, mouse.x, mouse.y)
            if (control.resize === "horizontal" || control.resize === "both")
                control.width = Math.max(80, startWidth + point.x - startX)
            if (control.resize === "vertical" || control.resize === "both")
                control.height = Math.max(EDefaultConfig.controlHeight(control.size), startHeight
                    + point.y - startY)
        }

        EIcon {
            iconSize: 10
            rotation: -45
            anchors.centerIn: parent
            iconSource: EIcons.CHEVRON_DOWN
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
    }
}
