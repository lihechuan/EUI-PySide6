import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias contentData: fieldContainer.data

    property var rules: []
    property var form: null
    property string prop: ""
    property string error: ""
    property string label: ""
    property int labelWidth: 0
    property int rowSpacing: 6
    property string helpText: ""
    property var validator: null
    property bool required: false
    property bool resettable: true
    property string labelSuffix: ""
    property bool showMessage: true
    property bool formDisabled: false
    property bool validateEvent: true
    property bool inlineMessage: false
    property string labelPosition: "top"
    property bool propagateToField: true
    property bool inheritFormConfig: true
    property bool showSuccessState: false
    property bool validateOnChange: false
    property string validationMessage: ""
    property Component errorComponent: null
    property Component labelComponent: null
    property bool hideRequiredAsterisk: false
    property string requiredAsteriskPosition: "left"
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None
    property string requiredMessage: label.length > 0
        ? EControlConfig.textFor(control, "Value1IsRequired", ELocale.texts).arg(label)
        : EControlConfig.textFor(control, "ThisFieldIsRequired", ELocale.texts)

    readonly property bool validating: internal.validating
    readonly property bool isRequired: required || hasRequiredRule()
    readonly property bool fieldFocused: field ? field.activeFocus : false
    readonly property bool hasValidationError: validationState === EValidationState.Error
    readonly property Item field: fieldContainer.children.length > 0
        ? fieldContainer.children[0] : null
    readonly property bool effectiveValidateEvent: validateEvent && !(field && field.validateEvent === false)
    readonly property string effectiveMessage: validationState !== EValidationState.None
        && validationMessage.length > 0
        ? validationMessage : helpText
    readonly property var fieldValue: {
        if (!field)
            return undefined
        if ("modelValue" in field)
            return field.modelValue
        if ("numberValue" in field)
            return field.numberValue
        if ("value" in field)
            return field.value
        if ("checked" in field)
            return field.checked
        if ("text" in field)
            return field.text
        return undefined
    }

    signal validateFinished(string prop, bool valid, string message)

    function clearValidation() {
        clearValidate()
    }

    function setInitialValue(value) {
        return captureInitialValue(value)
    }

    function validateAsync(trigger, callback) {
        return validate(trigger, callback)
    }

    function clearValidate() {
        if (!internal.cancelValidation())
            return
        validationState = EValidationState.None
        validationMessage = ""
    }

    function focusField() {
        if (field && typeof field.forceActiveFocus === "function") {
            field.forceActiveFocus()
            return true
        }
        return false
    }

    function normalizeRules(value) {
        if (value === undefined || value === null)
            return []
        return EDataUtils.isArray(value) ? value.slice(0) : [value]
    }

    function syncToModel() {
        if (!internal.syncingModel && form && form.model && prop.length > 0)
            return form.setModelValue(prop, snapshotValue(fieldValue))
        return false
    }

    function hasRequiredRule() {
        const list = effectiveRules()
        for (let index = 0; index < list.length; ++index)
            if (list[index] && list[index].required)
                return true
        return false
    }

    function hasRuleForTrigger(trigger) {
        const list = effectiveRules()
        for (let index = 0; index < list.length; ++index)
            if (triggerMatches(list[index], trigger))
                return true
        return false
    }

    function snapshotValue(value) {
        if (EDataUtils.isArray(value))
            return value.slice(0)
        if (value && typeof value === "object") {
            try { return JSON.parse(JSON.stringify(value)) }
            catch (exception) { return value }
        }
        return value
    }

    function isEmpty(value) {
        return value === undefined || value === null
                || (typeof value === "string" && value.trim().length === 0)
                || (EDataUtils.isArray(value) && value.length === 0)
                || (typeof value === "boolean" && !value)
    }

    function ruleMessage(rule, fallback) {
        if (rule && typeof rule.message === "function")
            return String(rule.message(rule, fieldValue))
        if (rule && rule.message !== undefined && String(rule.message).length > 0)
            return String(rule.message)
        return fallback
    }

    function valueProperty() {
        if (!field)
            return ""
        if ("modelValue" in field)
            return "modelValue"
        if ("numberValue" in field)
            return "numberValue"
        if ("value" in field)
            return "value"
        if ("checked" in field)
            return "checked"
        if ("text" in field)
            return "text"
        return ""
    }

    function triggerMatches(rule, trigger) {
        if (!trigger || trigger === "submit")
            return true
        if (!rule || rule.trigger === undefined || rule.trigger === null)
            return true
        const triggers = EDataUtils.isArray(rule.trigger) ? rule.trigger : [rule.trigger]
        return triggers.indexOf(trigger) >= 0
    }

    function scheduleValidation(trigger) {
        if (!internal.cancelValidation())
            return
        const scheduleRevision = internal.validationRevision
        Qt.callLater(function() {
            if (internal && scheduleRevision === internal.validationRevision
                    && effectiveValidateEvent && !internal.resetting) control.validate(trigger)
        })
    }

    function captureInitialValue(value) {
        const propertyName = valueProperty()
        if (!field || propertyName.length === 0)
            return false
        internal.initialValueProperty = propertyName
        internal.initialValue = snapshotValue(arguments.length > 0
                                               ? value : field[propertyName])
        internal.initialValueCaptured = true
        return true
    }

    function resetField() {
        if (!internal.cancelValidation())
            return false
        if (!resettable || !field || !internal.initialValueCaptured
                || internal.initialValueProperty.length === 0) {
            clearValidate()
            return false
        }
        internal.resetting = true
        field[internal.initialValueProperty] = snapshotValue(internal.initialValue)
        internal.resetting = false
        clearValidate()
        return true
    }

    function syncFromModel(force) {
        if (!form || !form.model || prop.length === 0 || !field)
            return false
        if (internal.modelInitialized && !force)
            return false
        const value = form.modelValue(prop)
        const propertyName = valueProperty()
        if (value === undefined || propertyName.length === 0)
            return false
        internal.syncingModel = true
        field[propertyName] = snapshotValue(value)
        internal.syncingModel = false
        internal.modelInitialized = true
        captureInitialValue(value)
        return true
    }

    function effectiveRules() {
        let result = []
        if (form && typeof form.rulesFor === "function")
            result = result.concat(normalizeRules(form.rulesFor(prop)))
        result = result.concat(normalizeRules(rules))
        if (required && !result.some(function(rule) {
            return rule && rule.required
        }))
            result.unshift({ required: true, message: requiredMessage })
        if (typeof validator === "function")
            result.push({ validator: function(rule, value) {
                return control.validator(value, control.field)
            }})
        return result
    }

    function normalizedResult(result, rule) {
        let valid = true
        let state = EValidationState.None
        let message = ""
        if (result instanceof Error) {
            valid = false
            message = result.message
        }
        else if (typeof result === "boolean")
            valid = result
        else if (typeof result === "string") {
            valid = result.length === 0
            message = result
        }
        else if (result && typeof result === "object") {
            valid = result.valid === undefined ? false : Boolean(result.valid)
            if (result.state !== undefined)
                state = result.state
            if (result.message !== undefined)
                message = String(result.message)
        }
        if (!valid && message.length === 0)
            message = ruleMessage(rule, EControlConfig.textFor(control, "ValidationFailed", ELocale.texts))
        return { valid: valid, state: state, message: message }
    }

    function completeValidation(revision, valid, result, callback) {
        if (!internal || revision !== internal.validationRevision)
            return
        internal.pendingCallback = null
        internal.validating = false
        if (valid) {
            validationState = result && result.state !== EValidationState.None
                              ? result.state : (showSuccessState ? EValidationState.Success
                                                                : EValidationState.None)
            validationMessage = result ? result.message : ""
        } else {
            validationState = result && result.state !== EValidationState.None
                              ? result.state : EValidationState.Error
            validationMessage = result && result.message.length > 0
                                ? result.message
                                    : EControlConfig.textFor(control, "ValidationFailed", ELocale.texts)
        }
        validateFinished(prop, valid, validationMessage)
        if (form && typeof form.notifyFieldValidation === "function")
            form.notifyFieldValidation(control, valid, validationMessage)
        if (typeof callback === "function")
            callback(valid, validationMessage, control)
    }

    function validate(trigger, callback) {
        if (typeof trigger === "function") {
            callback = trigger
            trigger = ""
        }
        trigger = trigger || ""
        if (!internal.cancelValidation()) {
            if (typeof callback === "function")
                callback(false, "", control, true)
            return false
        }
        const revision = internal.validationRevision
        internal.pendingCallback = callback
        let value = fieldValue
        const list = effectiveRules().filter(function(rule) {
            return rule && triggerMatches(rule, trigger)
        })
        let completed = false
        let finalValid = true
        let successfulResult = null

        if (error.length > 0) {
            completeValidation(revision, false,
                               { state: EValidationState.Error, message: error }, callback)
            return false
        }
        if (list.length === 0) {
            if (!trigger || trigger === "submit")
                completeValidation(revision, true, null, callback)
            else {
                internal.pendingCallback = null
                internal.validating = false
                if (typeof callback === "function")
                    callback(true, "", control)
            }
            return true
        }
        internal.validating = true

        function finish(valid, result) {
            completed = true
            finalValid = valid
            completeValidation(revision, valid, result, callback)
        }
        function run(index) {
            if (!internal || revision !== internal.validationRevision)
                return
            if (index >= list.length) {
                finish(true, successfulResult)
                return
            }
            const rule = list[index]
            let currentValue = value
            let builtIn
            try {
                if (typeof rule.transform === "function")
                    currentValue = rule.transform(value)
                builtIn = normalizedResult(builtInRuleResult(rule, currentValue), rule)
            } catch (exception) {
                finish(false, normalizedResult(exception, rule))
                return
            }
            if (!builtIn.valid) {
                finish(false, builtIn)
                return
            }
            if (typeof rule.validator !== "function") {
                run(index + 1)
                return
            }

            let callbackCalled = false
            function done(result) {
                if (callbackCalled || !internal || revision !== internal.validationRevision)
                    return
                callbackCalled = true
                const normalized = normalizedResult(result === undefined ? true : result, rule)
                if (normalized.valid) {
                    if (normalized.state !== EValidationState.None
                            || normalized.message.length > 0)
                        successfulResult = normalized
                    run(index + 1)
                }
                else
                    finish(false, normalized)
            }
            try {
                const returned = rule.validator(rule, currentValue, done, field)
                if (returned && typeof returned.then === "function")
                    returned.then(function(result) {
                        done(result === undefined ? true : result)
                    },
                                  function(reason) {
                                      done(reason instanceof Error ? reason : String(reason))
                                  })
                else if (!callbackCalled && returned !== undefined)
                    done(returned)
                else if (!callbackCalled && rule.validator.length < 3)
                    done(true)
            } catch (exception) { done(exception) }
        }
        run(0)
        return completed ? finalValid : undefined
    }

    function builtInRuleResult(rule, value) {
        const requiredValue = Boolean(rule.required)
        if (requiredValue && isEmpty(value))
            return ruleMessage(rule, requiredMessage)
        if (!requiredValue && isEmpty(value))
            return true
        if (rule.whitespace && typeof value === "string" && value.trim().length === 0)
            return ruleMessage(
                rule,
                EControlConfig.textFor(control, "ValueCannotContainOnlyWhitespace", ELocale.texts)
            )

        if (rule.type) {
            const type = String(rule.type).toLowerCase()
            let validType = true
            if (type === "string")
                validType = typeof value === "string"
            else if (type === "number" || type === "float")
                validType = typeof value === "number" && isFinite(value)
            else if (type === "integer")
                validType = typeof value === "number" && isFinite(value)
                        && Math.floor(value) === value
            else if (type === "boolean")
                validType = typeof value === "boolean"
            else if (type === "array")
                validType = EDataUtils.isArray(value)
            else if (type === "object")
                validType = value && typeof value === "object" && !EDataUtils.isArray(value)
            else if (type === "email")
                validType = typeof value === "string" && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
            else if (type === "url")
                validType = typeof value === "string" && /^(https?|ftp):\/\/[^\s]+$/i.test(value)
            if (!validType)
                return ruleMessage(rule, EControlConfig.textFor(control, "InvalidValueType", ELocale.texts))
        }

        const measurable = typeof value === "string" || EDataUtils.isArray(value)
        const amount = measurable ? value.length : value
        if (rule.len !== undefined && amount !== rule.len)
            return ruleMessage(
                rule,
                EControlConfig.textFor(control, "LengthMustBe1", ELocale.texts).arg(rule.len)
            )
        if (rule.min !== undefined && amount < rule.min)
            return ruleMessage(rule, measurable
                ? EControlConfig.textFor(control, "LengthMustBeAtLeast1", ELocale.texts).arg(rule.min)
                                                : EControlConfig.textFor(
                                                    control,
                                                    "ValueMustBeAtLeast1",
                                                    ELocale.texts
                                                ).arg(rule.min))
        if (rule.max !== undefined && amount > rule.max)
            return ruleMessage(rule, measurable
                ? EControlConfig.textFor(control, "LengthMustNotExceed1", ELocale.texts).arg(rule.max)
                                                : EControlConfig.textFor(
                                                    control,
                                                    "ValueMustNotExceed1",
                                                    ELocale.texts
                                                ).arg(rule.max))
        if (rule.pattern !== undefined) {
            try {
                const expression = rule.pattern instanceof RegExp
                                   ? rule.pattern : new RegExp(String(rule.pattern))
                expression.lastIndex = 0
                if (!expression.test(String(value)))
                    return ruleMessage(
                        rule,
                        EControlConfig.textFor(control, "ValueHasAnInvalidFormat", ELocale.texts)
                    )
            } catch (exception) { return ruleMessage(rule, exception.message) }
        }
        const allowed = rule.enum !== undefined ? rule.enum : rule.oneOf
        if (allowed !== undefined && normalizeRules(allowed).indexOf(value) < 0)
            return ruleMessage(rule, EControlConfig.textFor(control, "ValueIsNotAllowed", ELocale.texts))
        return true
    }

    width: implicitWidth
    Accessible.name: label
    height: implicitHeight
    Accessible.description: effectiveMessage
    implicitHeight: contentColumn.implicitHeight
    implicitWidth: Math.max(labelRow.implicitWidth, fieldContainer.implicitWidth,
        messageText.implicitWidth)

    Component.onDestruction: internal.cancelValidation()
    onRulesChanged: {
        if (internal.completed && form && form.validateOnRuleChange)
            scheduleValidation("")
    }
    onErrorChanged: {
        if (error.length > 0) {
            validationState = EValidationState.Error
            validationMessage = error
        }
    }
    Component.onCompleted: {
        internal.completed = true
        internal.previousFieldFocus = fieldFocused
        Qt.callLater(function() {
            if (control && !control.syncFromModel())
                control.captureInitialValue()
        })
    }
    onFieldFocusedChanged: {
        if (internal.completed && internal.previousFieldFocus && !fieldFocused
                && effectiveValidateEvent && hasRuleForTrigger("blur")) scheduleValidation("blur")
        internal.previousFieldFocus = fieldFocused
    }
    onFieldValueChanged: {
        syncToModel()
        if (internal.completed && internal.initialValueCaptured && !internal.resetting
                && effectiveValidateEvent && (validateOnChange || hasRuleForTrigger("change")))
            scheduleValidation("change")
    }
    onFieldChanged: {
        internal.initialValueCaptured = false
        internal.modelInitialized = false
        internal.previousFieldFocus = fieldFocused
        if (internal.completed)
            Qt.callLater(function() {
            if (control && !control.syncFromModel())
                control.captureInitialValue()
        })
    }

    QtObject {
        id: internal

        property var initialValue
        property bool completed: false
        property bool resetting: false
        property bool validating: false
        property bool syncingModel: false
        property var pendingCallback: null
        property int validationRevision: 0
        property bool modelInitialized: false
        property bool previousFieldFocus: false
        property string initialValueProperty: ""
        property bool initialValueCaptured: false

        function cancelValidation() {
            const revision = ++validationRevision
            const callback = pendingCallback
            pendingCallback = null
            validating = false
            if (typeof callback === "function")
                callback(false, "", control, true)
            return revision === validationRevision
        }
    }
    Grid {
        id: contentColumn

        width: control.width
        rowSpacing: control.rowSpacing
        columnSpacing: control.rowSpacing
        columns: control.labelPosition === "top" ? 1 : 2

        Row {
            id: labelRow

            spacing: 2
            visible: control.label.length > 0 || control.isRequired || control.labelComponent !== null
            layoutDirection: control.requiredAsteriskPosition === "right"
                ? Qt.RightToLeft : Qt.LeftToRight
            width: control.labelPosition === "top" || control.labelWidth <= 0
                ? implicitWidth : control.labelWidth
            height: control.labelPosition === "top" ? implicitHeight
                : Math.max(implicitHeight, fieldContainer.height)

            EText {
                visible: control.isRequired && !control.hideRequiredAsterisk
                font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                text: EControlConfig.textFor(control, "RequiredIndicator", ELocale.texts)
                color: EPaletteManager.StatePalette.validationColor(EValidationState.Error)
            }
            ELabel {
                target: control.field
                visible: control.labelComponent === null
                text: control.label + control.labelSuffix
                font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                horizontalAlignment: control.labelPosition === "right"
                    ? Text.AlignRight : Text.AlignLeft
                width: control.labelWidth > 0
                    ? Math.max(0, control.labelWidth - parent.spacing
                        - (control.isRequired ? implicitHeight : 0))
                    : implicitWidth
            }
            Loader {
                readonly property var formItem: control
                readonly property string label: control.label
                readonly property real contentWidth: item ? item.implicitWidth : 0
                readonly property real contentHeight: item ? item.implicitHeight : 0

                width: contentWidth
                height: contentHeight
                active: control.labelComponent !== null
                sourceComponent: control.labelComponent
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            }
        }
        Column {
            id: fieldColumn

            spacing: control.rowSpacing
            width: control.labelPosition === "top" ? contentColumn.width
                : Math.max(0, contentColumn.width - labelRow.width
                    - contentColumn.columnSpacing)

            Grid {
                width: fieldColumn.width
                rowSpacing: control.rowSpacing
                columnSpacing: control.rowSpacing
                columns: control.inlineMessage ? 2 : 1

                Item {
                    id: fieldContainer

                    height: implicitHeight
                    implicitWidth: control.field ? control.field.implicitWidth : 0
                    implicitHeight: control.field ? Math.max(control.field.height,
                        control.field.implicitHeight) : 0
                    width: control.inlineMessage && messageContainer.visible
                        ? Math.max(0, parent.width - messageContainer.implicitWidth
                            - parent.columnSpacing) : parent.width
                }
                Item {
                    id: messageContainer

                    height: implicitHeight
                    width: control.inlineMessage ? implicitWidth : fieldColumn.width
                    visible: control.showMessage && control.effectiveMessage.length > 0
                    implicitWidth: errorLoader.active && errorLoader.item ? errorLoader.item.implicitWidth
                        : messageText.implicitWidth
                    implicitHeight: errorLoader.active && errorLoader.item ? errorLoader.item.implicitHeight
                        : messageText.implicitHeight

                    EText {
                        id: messageText

                        wrapMode: Text.Wrap
                        anchors.fill: parent
                        visible: !errorLoader.active
                        objectName: "formItemMessage"
                        text: control.effectiveMessage
                        font.pixelSize: Math.max(10, EDefaultConfig.controlFontPixelSize(control.size) - 2)
                        color: control.validationState !== EValidationState.None
                            ? EPaletteManager.StatePalette.validationColor(control.validationState)
                            : EPaletteManager.BasePalette.lightGray
                    }
                    Loader {
                        id: errorLoader

                        readonly property var formItem: control
                        readonly property string message: control.effectiveMessage

                        anchors.fill: parent
                        active: control.errorComponent !== null
                        sourceComponent: control.errorComponent
                    }
                }
            }
        }
    }
    Binding {
        property: "size"
        value: control.size
        target: control.field
        restoreMode: Binding.RestoreBindingOrValue
        when: control.propagateToField && control.field && ("size" in control.field)
    }
    Binding {
        target: control.field
        property: "validationState"
        value: control.validationState
        restoreMode: Binding.RestoreBindingOrValue
        when: control.propagateToField && control.field && ("validationState" in control.field)
    }
    Binding {
        target: control.field
        property: "validationMessage"
        value: control.validationMessage
        restoreMode: Binding.RestoreBindingOrValue
        when: control.propagateToField && control.field && ("validationMessage" in control.field)
    }
    Binding {
        value: false
        property: "enabled"
        target: control.field
        restoreMode: Binding.RestoreBindingOrValue
        when: control.field && control.formDisabled
    }
}
