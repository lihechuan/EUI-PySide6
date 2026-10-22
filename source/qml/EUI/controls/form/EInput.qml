import EUI 1.0
import EUI.Private 1.0
import "../indicator" as IndicatorControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

TextField {
    id: control

    property int prefixIcon
    property int suffixIcon
    property var parser: null
    property var formatter: null
    property bool clearable: false
    property bool showPassword: false
    property bool validateEvent: true
    property bool showWordLimit: false
    property bool passwordVisible: false
    property string validationMessage: ""
    property int styleType: EStyle.Primary
    property Component appendComponent: null
    property Component prefixComponent: null
    property Component suffixComponent: null
    property Component prependComponent: null
    property bool showPasswordStrength: false
    property int clearIcon: EIcons.CIRCLE_XMARK
    property string accessibleName: placeholderText
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None
    property color textColor: EPaletteManager.StatePalette.defaultTextColor(
        EPaletteManager.createStateObject(this, EStyle.TextColor)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
    )
    property var passwordRules: [
        {label: ELocale.texts.PasswordLength, minLength: 8},
        {label: ELocale.texts.PasswordUppercase, pattern: /[A-Z]/},
        {label: ELocale.texts.PasswordLowercase, pattern: /[a-z]/},
        {label: ELocale.texts.PasswordNumber, pattern: /[0-9]/},
        {label: ELocale.texts.PasswordSymbol, pattern: /[^A-Za-z0-9]/}
    ]

    readonly property int wordCount: text.length
    readonly property bool hasValidationError: validationState === EValidationState.Error
    readonly property real passwordStrength: passwordRequirements.length
        ? passwordRequirements.filter(function(rule) { return rule.passed }).length / passwordRequirements.length : 0
    readonly property var passwordRequirements: EDataUtils.isArray(passwordRules) ? passwordRules.map(function(rule) {
        let passed = false
        try {
            if (rule && rule.minLength !== undefined)
                passed = text.length >= Number(rule.minLength)
            else if (rule && rule.pattern) {
                const expression = new RegExp(rule.pattern)
                passed = expression.test(text)
            }
        } catch (error) {
            passed = false
        }
        return {label: rule && rule.label ? String(rule.label) : "", passed: passed}
    }) : []

    signal cleared()
    signal formatFailed(string message)

    function formatInput(value) {
        try {
            const parsed = typeof parser === "function" ? parser(String(value)) : String(value)
            return typeof formatter === "function" ? String(formatter(parsed)) : String(parsed)
        } catch (error) {
            formatFailed(String(error))
            return String(value)
        }
    }

    topPadding: 0
    bottomPadding: 0
    hoverEnabled: true
    selectByMouse: true
    renderType: Text.QtRendering
    Accessible.name: control.accessibleName
    Accessible.role: Accessible.EditableText
    verticalAlignment: TextInput.AlignVCenter
    selectionColor: EPaletteManager.BasePalette.blue
    Accessible.description: control.validationMessage
    selectedTextColor: EPaletteManager.BasePalette.white
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    echoMode: control.showPassword && !control.passwordVisible
        ? TextInput.Password : TextInput.Normal
    placeholderTextColor: enabled ? EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
    background: FieldSurface {
        hovered: control.hovered
        focused: control.activeFocus
        styleType: control.styleType
        validationState: control.validationState
    }
    leftPadding: EDefaultConfig.horizontalPadding(control.size)
        + prependSlot.width + (prefixLoader.active ? prefixLoader.width + 6 : 0)
        + (prefixIconItem.visible ? prefixIconItem.width + 6 : 0)
    color: EPaletteManager.StatePalette.computeEffectiveTextColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
            .setPlain(true)
            .setColor(textColor)
    )
    rightPadding: EDefaultConfig.horizontalPadding(control.size)
        + appendSlot.width + (suffixLoader.active ? suffixLoader.width + 6 : 0)
        + (suffixIconItem.visible ? suffixIconItem.width + 6 : 0)
        + (wordLimit.visible ? wordLimit.implicitWidth + 6 : 0)

    onEditingFinished: if (typeof formatter === "function" || typeof parser === "function")
        text = formatInput(text)

    Popup {
        x: 0
        padding: 12
        focus: false
        y: control.height + 6
        closePolicy: Popup.NoAutoClose
        objectName: "passwordStrengthPopup"
        width: Math.max(240, control.width)
        visible: control.enabled && control.showPassword && control.showPasswordStrength && control.activeFocus
        background: ERectangle {
            radius: 4
            border.width: 1
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        contentItem: Column {
            spacing: 8

            ERectangle {
                height: 6
                radius: 3
                width: parent.width
                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                ERectangle {
                    radius: 3
                    height: parent.height
                    width: parent.width * control.passwordStrength
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(
                        control.passwordStrength >= 1 ? EStyle.Success : EStyle.Warning)
                }
            }
            Repeater {
                model: control.passwordRequirements

                EText {
                    text: (modelData.passed ? "✓  " : "○  ") + modelData.label
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(
                        modelData.passed ? EStyle.Success : EStyle.Warning)
                }
            }
        }
    }
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
    EAdvancedRectangle {
        borderWidth: 1
        height: control.height
        width: prependSlot.width
        visible: prependLoader.active
        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
        borderColor: control.background ? control.background.border.color : "transparent"
        radius: control.background ? [control.background.radius, 0, 0, control.background.radius] : 0
    }
    EAdvancedRectangle {
        borderWidth: 1
        height: control.height
        width: appendSlot.width
        anchors.right: control.right
        visible: appendLoader.active
        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
        borderColor: control.background ? control.background.border.color : "transparent"
        radius: control.background ? [0, control.background.radius, control.background.radius, 0] : 0
    }
    Item {
        id: prependSlot

        height: control.height
        anchors.left: control.left
        width: prependLoader.active ? prependLoader.width + 16 : 0

        Loader {
            id: prependLoader

            readonly property var input: control

            anchors.centerIn: parent
            objectName: "inputPrepend"
            active: control.prependComponent !== null
            sourceComponent: control.prependComponent
        }
    }
    Item {
        id: appendSlot

        height: control.height
        anchors.right: control.right
        width: appendLoader.active ? appendLoader.width + 16 : 0

        Loader {
            id: appendLoader

            readonly property var input: control

            anchors.centerIn: parent
            objectName: "inputAppend"
            active: control.appendComponent !== null
            sourceComponent: control.appendComponent
        }
    }
    Loader {
        id: prefixLoader

        readonly property var input: control
        readonly property real contentWidth: active && item ? item.implicitWidth : 0
        readonly property real contentHeight: active && item ? item.implicitHeight : 0

        width: contentWidth
        height: contentHeight
        objectName: "inputPrefix"
        y: (control.height - height) / 2
        active: control.prefixComponent !== null
        sourceComponent: control.prefixComponent
        x: prependSlot.width + EDefaultConfig.horizontalPadding(control.size)
    }
    Loader {
        id: suffixLoader

        readonly property var input: control
        readonly property real contentWidth: active && item ? item.implicitWidth : 0
        readonly property real contentHeight: active && item ? item.implicitHeight : 0

        width: contentWidth
        height: contentHeight
        objectName: "inputSuffix"
        y: (control.height - height) / 2
        active: control.suffixComponent !== null
        sourceComponent: control.suffixComponent
        x: control.width - appendSlot.width - EDefaultConfig.horizontalPadding(control.size) - width
    }
    EText {
        id: wordLimit

        font.pixelSize: 11
        anchors.right: control.right
        anchors.verticalCenter: control.verticalCenter
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        visible: control.showWordLimit && control.length > 0 && !control.activeFocus
        text: control.wordCount + (control.maximumLength < 32767 ? "/" + control.maximumLength : "")
        anchors.rightMargin: EDefaultConfig.horizontalPadding(control.size) + appendSlot.width
            + (suffixLoader.active ? suffixLoader.width + 6 : 0)
            + (suffixIconItem.visible ? suffixIconItem.width + 6 : 0)
    }
    EIcon {
        id: prefixIconItem

        height: width
        iconSize: width
        color: control.textColor
        anchors.left: control.left
        iconSource: control.prefixIcon
        visible: control.prefixIcon > 0
        width: EDefaultConfig.iconSize(control.size)
        anchors.verticalCenter: control.verticalCenter
        anchors.leftMargin: EDefaultConfig.horizontalPadding(control.size) + prependSlot.width
            + (prefixLoader.active ? prefixLoader.width + 6 : 0)
    }
    EIcon {
        id: suffixIconItem

        readonly property bool actionable: canClear || control.showPassword
        readonly property bool canClear: control.clearable && control.text.length > 0

        height: width
        iconSize: width
        color: control.textColor
        anchors.right: control.right
        width: EDefaultConfig.iconSize(control.size)
        visible: actionable || control.suffixIcon > 0
        anchors.verticalCenter: control.verticalCenter
        anchors.rightMargin: EDefaultConfig.horizontalPadding(control.size) + appendSlot.width
            + (suffixLoader.active ? suffixLoader.width + 6 : 0)
        iconSource: control.showPassword
            ? (control.passwordVisible ? EIcons.EYE : EIcons.EYE_SLASH)
            : (canClear ? control.clearIcon : control.suffixIcon)

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: suffixIconItem.actionable

            onClicked: {
                if (control.showPassword) {
                    control.passwordVisible = !control.passwordVisible
                } else if (suffixIconItem.canClear) {
                    control.clear()
                    control.cleared()
                    control.forceActiveFocus()
                }
            }
        }
    }
}
