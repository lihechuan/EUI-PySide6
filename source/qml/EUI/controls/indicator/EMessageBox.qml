import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

EDialog {
    id: control

    property int iconSource: 0
    property var callback: null
    property string inputValue: ""
    property bool showInput: false
    property var inputPattern: null
    property bool roundButton: false
    property string inputType: "text"
    property var inputValidator: null
    property string inputPlaceholder: ""
    property string inputErrorMessage: ""
    property int buttonSize: EStyle.Medium
    property int styleType: EStyle.Default
    property int cancelButtonLoadingIcon: 0
    property bool cancelButtonLoading: false
    property int confirmButtonLoadingIcon: 0
    property bool confirmButtonLoading: false
    property int cancelStyleType: EStyle.Default
    property bool dangerouslyUseHTMLString: false
    property bool distinguishCancelAndClose: false

    readonly property alias loadedMessageContent: messageContentLoader.item

    signal canceled()
    signal confirmed(string value)
    signal completed(string action, string value)

    function reject() {
        return dispatch("cancel")
    }

    function requestClose() {
        return dispatch("close")
    }

    function accept() {
        return validateInput() && dispatch("confirm")
    }

    function alert(message, heading) {
        showCancelButton = false
        showInput = false
        text = message === undefined ? "" : String(message)
        title = heading === undefined ? EControlConfig.textFor(control, "Confirm3", ELocale.texts)
            : String(heading)
        closeOnEscape = false
        closeOnClickOutside = false
        inputErrorMessage = ""
        open()
    }

    function confirm(message, heading) {
        showCancelButton = true
        closeOnEscape = true
        closeOnClickOutside = true
        showInput = false
        inputValue = ""
        text = message === undefined ? "" : String(message)
        title = heading === undefined ? EControlConfig.textFor(control, "Confirm3", ELocale.texts)
            : String(heading)
        inputErrorMessage = ""
        open()
    }

    function prompt(message, heading, initialValue) {
        showCancelButton = true
        closeOnEscape = true
        closeOnClickOutside = true
        showInput = true
        text = message === undefined ? "" : String(message)
        title = heading === undefined ? EControlConfig.textFor(control, "Input", ELocale.texts)
            : String(heading)
        inputValue = initialValue === undefined ? "" : String(initialValue)
        promptInput.text = inputValue
        inputErrorMessage = ""
        open()
        if (autofocus)
            Qt.callLater(function() {
                control.inputType === "textarea" ? promptArea.forceActiveFocus()
                    : promptInput.forceActiveFocus()
            })
    }

    function validateInput() {
        if (!showInput)
            return true
        let result = true
        try {
            if (inputPattern && typeof inputPattern.test === "function") {
                inputPattern.lastIndex = 0
                result = inputPattern.test(inputValue)
            }
            if (result === true && typeof inputValidator === "function")
                result = inputValidator(inputValue)
        } catch (error) {
            result = error.message || EControlConfig.textFor(control, "InvalidInput", ELocale.texts)
        }
        inputErrorMessage = result === true || result === undefined ? ""
            : typeof result === "string" ? result
                : EControlConfig.textFor(control, "InvalidInput", ELocale.texts)
        return inputErrorMessage.length === 0
    }

    function dispatch(action) {
        if (!visible || operation.pending || action === "confirm" && confirmButtonLoading
            || action === "cancel" && cancelButtonLoading)
            return false
        operation.pending = true
        const generation = operation.generation
        let finished = false
        const done = function(cancel) {
            if (finished || operation.generation !== generation)
                return
            finished = true
            operation.pending = false
            if (cancel === true)
                return
            operation.action = action
            control.done(action === "confirm" ? Dialog.Accepted : Dialog.Rejected)
        }
        if (typeof beforeClose !== "function") {
            done()
            return true
        }
        let result
        try {
            result = beforeClose(action, control, done)
        } catch (error) {
            operation.pending = false
            closeRejected()
            return false
        }
        if (result === false) {
            operation.pending = false
            finished = true
            closeRejected()
            return false
        }
        if (result && typeof result.then === "function") {
            result.then(function(allowed) {
                if (finished || generation !== operation.generation)
                    return
                if (allowed === false) {
                    operation.pending = false
                    finished = true
                    control.closeRejected()
                } else {
                    done()
                }
            }, function() {
                if (finished || generation !== operation.generation)
                    return
                operation.pending = false
                finished = true
                control.closeRejected()
            })
        } else if (result === true) {
            done()
        }
        return true
    }

    beforeClose: function(action, instance, done) {
        done()
    }
    cancelText: EControlConfig.textFor(control, "Cancel", ELocale.texts)
    confirmText: EControlConfig.textFor(control, "Confirm", ELocale.texts)
    footer: Item {
        implicitHeight: visible ? 64 : 0
        visible: control.showFooter && (control.showCancelButton || control.showConfirmButton)

        Row {
            spacing: 12
            anchors.rightMargin: 20
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            EButton {
                size: control.buttonSize
                text: control.cancelText
                round: control.roundButton
                visible: control.showCancelButton
                styleType: control.cancelStyleType
                loading: control.cancelButtonLoading
                objectName: "messageBoxCancelButton"
                loadingIconSource: control.cancelButtonLoadingIcon

                onClicked: control.reject()
            }
            EButton {
                size: control.buttonSize
                text: control.confirmText
                round: control.roundButton
                visible: control.showConfirmButton
                styleType: control.confirmStyleType
                loading: control.confirmButtonLoading
                objectName: "messageBoxConfirmButton"
                loadingIconSource: control.confirmButtonLoadingIcon

                onClicked: {
                    if (control.validateInput())
                        control.accept()
                }
            }
        }
    }
    contentItem: Column {
        spacing: 12

        Keys.onEscapePressed: {
            if (control.closeOnEscape)
                control.requestClose()
        }

        Loader {
            id: messageContentLoader

            width: parent.width
            sourceComponent: control.contentComponent
            active: control.visible || !control.destroyOnClose
        }
        EIcon {
            iconSize: 28
            visible: control.iconSource > 0 || control.styleType !== EStyle.Default
            color: EPaletteManager.ThemePalette.fetchColorForStyle(control.styleType)
            iconSource: control.iconSource > 0 ? control.iconSource
                : control.styleType === EStyle.Success ? EIcons.CIRCLE_CHECK_FILL
                : control.styleType === EStyle.Danger ? EIcons.CIRCLE_XMARK_FILL
                : control.styleType === EStyle.Warning ? EIcons.TRIANGLE_EXCLAMATION_FILL
                    : EIcons.CIRCLE_Info_FILL
        }
        EText {
            text: control.text
            width: parent.width
            wrapMode: Text.WordWrap
            color: control.textColor
            textFormat: control.dangerouslyUseHTMLString ? Text.RichText : Text.PlainText
        }
        EInput {
            id: promptInput

            width: parent.width
            text: control.inputValue
            placeholderText: control.inputPlaceholder
            validationMessage: control.inputErrorMessage
            visible: control.showInput && control.inputType !== "textarea"
            echoMode: control.inputType === "password" ? TextInput.Password : TextInput.Normal
            validationState: control.inputErrorMessage.length > 0 ? EValidationState.Error
                : EValidationState.None
            inputMethodHints: control.inputType === "number" ? Qt.ImhFormattedNumbersOnly
                : control.inputType === "email" ? Qt.ImhEmailCharactersOnly
                : control.inputType === "tel" ? Qt.ImhDialableCharactersOnly
                : control.inputType === "url" ? Qt.ImhUrlCharactersOnly : Qt.ImhNone

            onTextChanged: control.inputValue = text
            onAccepted: {
                if (control.validateInput())
                    control.accept()
            }
        }
        ETextArea {
            id: promptArea

            height: 96
            width: parent.width
            text: control.inputValue
            placeholderText: control.inputPlaceholder
            visible: control.showInput && control.inputType === "textarea"

            onTextChanged: control.inputValue = text
        }
        EText {
            width: parent.width
            wrapMode: Text.WordWrap
            visible: text.length > 0
            text: control.inputErrorMessage
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
        }
    }

    onRejected: canceled()
    onAccepted: confirmed(inputValue)
    onAboutToShow: {
        ++operation.generation
        operation.action = "close"
        operation.pending = false
    }
    onInputValueChanged: {
        if (promptInput.text !== inputValue)
            promptInput.text = inputValue
        if (promptArea.text !== inputValue)
            promptArea.text = inputValue
    }
    onClosed: {
        ++operation.generation
        const action = operation.action === "close" && !distinguishCancelAndClose ? "cancel"
            : operation.action
        completed(action, inputValue)
        if (typeof callback === "function")
            callback(inputValue, action)
    }

    QtObject {
        id: operation

        property int generation: 0
        property bool pending: false
        property string action: "close"
    }
}
