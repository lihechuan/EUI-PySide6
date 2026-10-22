import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias contentData: formGrid.data

    property var model: null
    property var rules: ({})
    property int spacing: 18
    property int labelWidth: 0
    property bool inline: false
    property bool disabled: false
    property string labelSuffix: ""
    property bool showMessage: true
    property bool inlineMessage: false
    property int columnSpacing: spacing
    property bool focusFirstError: true
    property string labelPosition: "top"
    property bool validateOnChange: false
    property bool validateOnRuleChange: true
    property bool hideRequiredAsterisk: false
    property string requiredAsteriskPosition: "left"
    property int size: EControlConfig.sizeFor(control)

    readonly property var fields: formItems()
    readonly property bool valid: internal.valid
    readonly property bool validating: internal.validating
    readonly property var firstInvalidItem: internal.firstInvalidItem

    signal submitted(bool valid, var model)
    signal validationFinished(bool valid, var firstInvalidItem)
    signal fieldValidated(string prop, bool valid, string message)

    function clearValidation(props) {
        clearValidate(props)
    }

    function rulesFor(prop) {
        return valueAtPath(rules, prop)
    }

    function modelValue(prop) {
        return valueAtPath(model, prop)
    }

    function validateAsync(callback) {
        return validate(callback)
    }

    function setModelValue(prop, value) {
        return setValueAtPath(model, prop, value)
    }

    function validate(callback) {
        return runValidation(formItems(), "submit", callback, true)
    }

    function submit() {
        return validate(function(valid) {
            control.submitted(valid, control.model)
        })
    }

    function getField(prop) {
        const matches = selectedItems(prop)
        return matches.length > 0 ? matches[0] : null
    }

    function notifyFieldValidation(item, itemValid, message) {
        fieldValidated(item ? item.prop : "", itemValid, message)
    }

    function validateField(props, callback, trigger) {
        return runValidation(selectedItems(props), trigger || "submit", callback, false)
    }

    function normalizeProps(props) {
        if (props === undefined || props === null || props === "")
            return []
        return EDataUtils.isArray(props) ? props : [props]
    }

    function propMatches(item, requested) {
        if (!item)
            return false
        if (requested === item || requested === item.field)
            return true
        return String(item.prop) === String(requested)
    }

    function captureInitialValues(props) {
        const items = selectedItems(props)
        for (let index = 0; index < items.length; ++index)
            if (typeof items[index].captureInitialValue === "function")
                items[index].captureInitialValue()
    }

    function formItems() {
        const result = []
        for (let index = 0; index < formGrid.children.length; ++index) {
            const child = formGrid.children[index]
            if (child && typeof child.validate === "function"
                    && typeof child.clearValidate === "function") result.push(child)
        }
        return result
    }

    function selectedItems(props) {
        const all = formItems()
        const requested = normalizeProps(props)
        if (requested.length === 0)
            return all
        return all.filter(function(item) {
            for (let index = 0; index < requested.length; ++index)
                if (propMatches(item, requested[index]))
                    return true
            return false
        })
    }

    function setInitialValues(valuesOrProps) {
        if (valuesOrProps && typeof valuesOrProps === "object"
                && !EDataUtils.isArray(valuesOrProps)) {
            const items = formItems()
            for (let index = 0; index < items.length; ++index) {
                const value = valueAtPath(valuesOrProps, items[index].prop)
                if (value !== undefined)
                    items[index].setInitialValue(value)
            }
        } else captureInitialValues(valuesOrProps)
    }

    function resetFields(props) {
        if (!internal.cancelValidation())
            return
        ++internal.validationRevision
        const items = selectedItems(props)
        for (let index = 0; index < items.length; ++index)
            items[index].resetField()
        internal.validating = false
        if (normalizeProps(props).length === 0) {
            internal.valid = true
            internal.firstInvalidItem = null
        } else if (internal.firstInvalidItem
                   && items.indexOf(internal.firstInvalidItem) >= 0) {
            internal.firstInvalidItem = null
        }
    }

    function clearValidate(props) {
        if (!internal.cancelValidation())
            return
        ++internal.validationRevision
        const items = selectedItems(props)
        for (let index = 0; index < items.length; ++index)
            items[index].clearValidate()
        internal.validating = false
        if (normalizeProps(props).length === 0) {
            internal.valid = true
            internal.firstInvalidItem = null
        } else if (internal.firstInvalidItem
                   && items.indexOf(internal.firstInvalidItem) >= 0) {
            internal.firstInvalidItem = null
        }
    }

    function valueAtPath(object, path) {
        if (!object || path === undefined || path === null || path === "")
            return undefined
        if (object[path] !== undefined)
            return object[path]
        const segments = EDataUtils.isArray(path) ? path : String(path).split(".")
        if (segments.length === 0)
            return undefined
        let value = object
        for (let index = 0; index < segments.length; ++index) {
            if (value === undefined || value === null)
                return undefined
            value = value[segments[index]]
        }
        return value
    }

    function scrollToField(prop) {
        const item = getField(prop)
        if (!item)
            return false
        let ancestor = item.parent
        while (ancestor) {
            if (ancestor.contentItem && "contentY" in ancestor && "contentHeight" in ancestor) {
                const position = item.mapToItem(ancestor.contentItem, 0, 0)
                const bottom = position.y + item.height
                const target = position.y < ancestor.contentY ? position.y
                    : bottom > ancestor.contentY + ancestor.height ? bottom - ancestor.height
                        : ancestor.contentY
                ancestor.contentY = Math.max(
                    0,
                    Math.min(Math.max(0, ancestor.contentHeight - ancestor.height), target)
                )
            }
            ancestor = ancestor.parent
        }
        return item.focusField()
    }

    function setValueAtPath(object, path, value) {
        if (!object || path === undefined || path === null || path === "")
            return false
        if (object[path] !== undefined) {
            object[path] = value
            return true
        }
        const segments = EDataUtils.isArray(path) ? path : String(path).split(".")
        if (segments.length === 0)
            return false
        let target = object
        for (let index = 0; index < segments.length - 1; ++index) {
            const key = segments[index]
            if (target[key] === undefined || target[key] === null)
                target[key] = /^\d+$/.test(segments[index + 1]) ? [] : ({})
            target = target[key]
            if (typeof target !== "object" && typeof target !== "function")
                return false
        }
        target[segments[segments.length - 1]] = value
        return true
    }

    function syncItems(forceModel) {
        const items = formItems()
        internal.itemCount = Math.max(1, items.length)
        for (let index = 0; index < items.length; ++index) {
            const item = items[index]
            item.form = control
            if (item.inheritFormConfig === undefined || item.inheritFormConfig) {
                item.size = size
                item.showMessage = showMessage
                item.inlineMessage = inlineMessage
                item.validateOnChange = validateOnChange
                item.formDisabled = disabled
                item.hideRequiredAsterisk = hideRequiredAsterisk
                item.requiredAsteriskPosition = requiredAsteriskPosition
                item.labelSuffix = labelSuffix
                item.labelPosition = labelPosition
                item.labelWidth = labelWidth
            }
            if (typeof item.syncFromModel === "function")
                item.syncFromModel(Boolean(forceModel))
        }
    }

    function runValidation(items, trigger, callback, updateFormState) {
        if (!internal.cancelValidation()) {
            if (typeof callback === "function")
                callback(false, {}, null)
            return false
        }
        const revision = ++internal.validationRevision
        let remaining = items.length
        let allValid = true
        let firstInvalid = null
        let launching = true
        let completed = false
        let allSynchronous = true
        const errors = ({})
        const observedItems = []

        internal.validating = items.length > 0

        function finishIfReady() {
            if (completed || launching || remaining > 0 || !internal
                    || revision !== internal.validationRevision)
                return
            completed = true
            internal.pendingValidationCancel = null
            internal.validating = false
            for (let index = 0; index < observedItems.length; ++index) {
                if (observedItems[index] && observedItems[index].fieldValueChanged)
                    observedItems[index].fieldValueChanged.disconnect(cancel)
            }
            if (updateFormState) {
                internal.valid = allValid
                internal.firstInvalidItem = firstInvalid
                if (firstInvalid && focusFirstError)
                    firstInvalid.focusField()
                validationFinished(allValid, firstInvalid)
            }
            if (typeof callback === "function")
                callback(allValid, errors, firstInvalid)
        }

        function cancel() {
            allValid = false
            remaining = 0
            launching = false
            firstInvalid = null
            finishIfReady()
        }
        internal.pendingValidationCancel = cancel
        for (let index = 0; index < items.length; ++index) {
            if (items[index].fieldValueChanged) {
                items[index].fieldValueChanged.connect(cancel)
                observedItems.push(items[index])
            }
        }

        if (items.length === 0) {
            launching = false
            finishIfReady()
            return true
        }

        for (let index = 0; index < items.length; ++index) {
            const item = items[index]
            let itemCompleted = false
            const returned = item.validate(trigger, function(itemValid, message, field, cancelled) {
                if (itemCompleted || completed || !internal || revision !== internal.validationRevision)
                    return
                if (cancelled) {
                    cancel()
                    return
                }
                itemCompleted = true
                if (!itemValid) {
                    allValid = false
                    if (!firstInvalid)
                        firstInvalid = item
                    const key = item.prop.length > 0 ? item.prop : String(index)
                    errors[key] = { message: message, field: item }
                }
                --remaining
                finishIfReady()
            })
            if (returned === undefined)
                allSynchronous = false
            if (completed)
                break
        }
        launching = false
        finishIfReady()
        return completed && allSynchronous ? allValid : undefined
    }

    width: implicitWidth
    height: implicitHeight
    implicitWidth: formGrid.implicitWidth
    implicitHeight: formGrid.implicitHeight

    onSizeChanged: syncItems()
    onDisabledChanged: syncItems()
    onModelChanged: syncItems(true)
    onLabelWidthChanged: syncItems()
    onLabelSuffixChanged: syncItems()
    onShowMessageChanged: syncItems()
    Component.onCompleted: syncItems()
    onInlineMessageChanged: syncItems()
    onLabelPositionChanged: syncItems()
    onValidateOnChangeChanged: syncItems()
    onHideRequiredAsteriskChanged: syncItems()
    onRequiredAsteriskPositionChanged: syncItems()
    onRulesChanged: {
        if (validateOnRuleChange)
            Qt.callLater(validate)
    }

    QtObject {
        id: internal

        property int itemCount: 1
        property bool valid: true
        property bool validating: false
        property int validationRevision: 0
        property var firstInvalidItem: null
        property var pendingValidationCancel: null

        function cancelValidation() {
            const revision = validationRevision
            if (typeof pendingValidationCancel === "function")
                pendingValidationCancel()
            return revision === validationRevision
        }
    }
    Grid {
        id: formGrid

        width: control.width
        rowSpacing: control.spacing
        columnSpacing: control.columnSpacing
        columns: control.inline ? internal.itemCount : 1

        onChildrenChanged: {
            if (internal && internal.validating)
                internal.cancelValidation()
            Qt.callLater(control.syncItems)
        }
    }
}
