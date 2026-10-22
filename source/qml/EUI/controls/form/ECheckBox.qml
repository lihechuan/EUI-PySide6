import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

CheckBox {
    id: control

    property int optRadius: 3
    property var trueValue: true
    property var value: undefined
    property var falseValue: false
    property bool borderVisible: true
    property bool validateEvent: true
    property int styleType: EStyle.Default
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent
    property int optSize: EDefaultConfig.selectionIndicatorSize(control.size)

    spacing: 8
    topPadding: 0
    font.bold: true
    tristate: false
    bottomPadding: 0
    checkState: Qt.Unchecked
    Accessible.name: control.text
    Accessible.checked: control.checked
    Accessible.role: Accessible.CheckBox
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    leftPadding: EDefaultConfig.horizontalPadding(control.size)
    rightPadding: EDefaultConfig.horizontalPadding(control.size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    background: ERectangle {
        id: backgroundRectangle

        anchors.fill: parent
        border.width: control.borderVisible ? 1 : 0
        color: EPaletteManager.BasePalette.transparent
        border.color: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound((control.checked && control.enabled))
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(true)
        )
    }
    contentItem: EText {
        font: control.font
        text: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 10
        color: EPaletteManager.StatePalette.computeTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound((control.checked && control.enabled))
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setTextButton(true)
        )
    }
    indicator: ERectangle {
        border.width: 1
        width: Math.max(0, optSize)
        height: Math.max(0, optSize)
        radius: Math.max(0, optRadius)
        anchors.left: backgroundRectangle.left
        anchors.leftMargin: control.leftPadding
        anchors.verticalCenter: backgroundRectangle.verticalCenter
        border.color: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setHovered((control.checkState > 0 ? true : control.hovered))
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound(control.checkState > 0 ? control.enabled : control.hovered)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(true)
        )
        color: EPaletteManager.StatePalette.resolveEffectiveBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setHovered(control.enabled ? (control.checkState > 0) : false)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound(control.enabled ? (control.checkState > 0) : false)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(control.enabled ? (control.checkState > 0) : true)
        )

        EIcon {
            anchors.fill: parent
            iconSize: Math.max(0, control.optSize)
            opacity: (control.checkState > 0) ? 1 : 0
            iconSource: control.checkState === 2 ? EIcons.CHECK : EIcons.MINUS
            color: control.enabled ? EPaletteManager.BasePalette.white
                : EPaletteManager.StatePalette.computeTextColor(
                    EPaletteManager.createStateObject(this, EStyle.Color)
                        .setDark(ETheme.dark)
                        .setHovered(control.hovered)
                        .setPressed(control.pressed)
                        .setEnabled(control.enabled)
                        .setPlain(true)
                        .setColor(control.color)
                        .setComponentStyle(control.styleType)
                )

            Behavior on opacity {
                NumberAnimation {
                    duration: 200

                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    onValueChanged: {
        if (!typedState.syncing && value !== undefined)
            checked = value === trueValue
    }
    onCheckedChanged: {
        if (!typedState.completed || typedState.syncing)
            return
        typedState.syncing = true
        value = checked ? trueValue : falseValue
        typedState.syncing = false
    }
    Component.onCompleted: {
        typedState.completed = true
        typedState.syncing = true
        if (value === undefined)
            value = checked ? trueValue : falseValue
        else
            checked = value === trueValue
        typedState.syncing = false
    }

    QtObject {
        id: typedState

        property bool syncing: false
        property bool completed: false
    }
}
