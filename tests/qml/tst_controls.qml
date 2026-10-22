import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property int clickCount: 0
    property int messageClosedCount: 0
    property int messageOpenedCount: 0
    property int asyncValidationCount: 0
    property bool asyncValidationValid: false
    property bool reopenMessageOnClose: false
    property var advancedModel: ({
        username: "model-name",
        profile: {
            email: "model@example.com"
        }
    })

    function test_passwordVisibility() {
        input.showPassword = true
        input.passwordVisible = false
        compare(input.echoMode, TextInput.Password)
        input.passwordVisible = true
        compare(input.echoMode, TextInput.Normal)
    }

    function test_plainButtonFocusDoesNotKeepHoverBackground() {
        button.plain = true
        button.color = "#626aef"
        wait(0)

        const normalColor = button.background.color
        button.forceActiveFocus()
        wait(0)
        compare(button.background.color, normalColor)
    }

    function test_customSolidColorUsesWhiteText() {
        const state = EPaletteManager.createStateObject(testCase, EStyle.TextColor)
            .setDark(false)
            .setEnabled(true)
            .setColor("#f5e663")
            .setComponentStyle(EStyle.Default)

        compare(EPaletteManager.StatePalette.computeEffectiveTextColor(state), "#ffffff")
    }

    function test_controlSizeTokens() {
        compare(EDefaultConfig.controlHeight(EStyle.Small), 24)
        compare(EDefaultConfig.controlHeight(EStyle.Medium), 32)
        compare(EDefaultConfig.controlHeight(EStyle.Large), 40)
        button.size = EStyle.Small
        compare(button.implicitHeight, 24)
        input.size = EStyle.Large
        compare(input.implicitHeight, 40)
    }

    function test_buttonProgressBounds() {
        const progress = findChild(button, "buttonProgress")
        verify(progress)
        button.progress = -1
        compare(progress.visible, false)
        button.progress = 0.5
        compare(progress.width, button.background.width / 2)
        button.progress = 2
        compare(progress.width, button.background.width)
        button.progress = NaN
        compare(progress.visible, false)
        button.progress = -1
    }

    function test_messageReopensAfterClear() {
        animatedMessage.open("First", "before-clear", 0)
        reopenMessageOnClose = true
        compare(animatedMessage.clear(), 1)
        tryCompare(testCase, "messageClosedCount", 1, 400)
        compare(animatedMessage.count, 1)
        compare(animatedMessage.clearing, false)
        verify(animatedMessage.close("after-clear"))
        tryCompare(animatedMessage, "count", 0, 400)
        compare(messageClosedCount, 2)
    }

    function test_loadingBlocksPointerActivation() {
        verify(button.enabled)
        verify(button.width > 0)
        verify(button.height > 0)
        button.loading = true
        wait(1)
        compare(findChild(button, "loadingBlocker").enabled, true)
        mouseClick(testCase, button.x + button.width / 2, button.y + button.height / 2, Qt.LeftButton)
        compare(clickCount, 0)
        button.loading = false
        wait(1)
        compare(findChild(button, "loadingBlocker").enabled, false)
    }

    function test_messageExitAnimation() {
        const key = animatedMessage.open("Animated message", "animation-test", 0)
        tryCompare(testCase, "messageOpenedCount", 1)
        compare(animatedMessage.count, 1)
        wait(350)
        verify(animatedMessage.close(key))
        verify(!animatedMessage.close(key))
        compare(messageClosedCount, 0)
        wait(100)
        compare(messageClosedCount, 0)
        tryCompare(testCase, "messageClosedCount", 1, 400)
        compare(animatedMessage.count, 0)
        wait(50)
        compare(messageClosedCount, 1)
    }

    function test_inputDisabledAndFocusPalette() {
        input.validationState = EValidationState.None
        verify(input.hoverEnabled)
        input.enabled = false
        compare(input.background.color, EPaletteManager.ThemePalette.surfaceDisabled(ETheme.dark))
        compare(input.background.border.color, EPaletteManager.ThemePalette.borderDisabled(ETheme.dark))
        input.enabled = true
        input.forceActiveFocus()
        compare(
            input.background.border.color,
            EPaletteManager.ThemePalette.fetchColorForStyle(input.styleType)
        )
    }

    function test_stateColorCalculationIsPure() {
        const state = EPaletteManager.createStateObject(testCase, EStyle.BackgroundColor)
            .setDark(false)
            .setActiveFocus(true)
            .setHovered(false)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Primary)

        EPaletteManager.StatePalette.computeBackgroundColor(state)

        compare(state.hovered, false)
        compare(state.color, EPaletteManager.BasePalette.transparent)
        compare(state.componentStyle, EStyle.Primary)
    }

    function test_watermarkKeepsDenseTilesBounded() {
        watermark.width = 240
        watermark.height = 180
        watermark.content = "EUI"
        const renderer = findChild(watermark, "watermarkRenderer")
        compare(renderer.width, 240)
        compare(renderer.height, 180)
        compare(renderer.text, "EUI")
        watermark.tileWidth = 1
        watermark.tileHeight = 1
        watermark.gap = Qt.point(0, 0)
        compare(renderer.tileSize, Qt.size(1, 1))
        compare(renderer.gap, Qt.point(0, 0))
        compare(watermark.children.length, 2)
        compare(renderer.children.length, 0)
        watermark.width = 120
        watermark.height = 80
        watermark.visible = false
    }

    function test_menuBehavior() {
        compare(menu.visibleItems.length, 3)
        verify(menu.open("workspace"))
        compare(menu.openedIndexes, ["workspace"])
        compare(menu.visibleItems.length, 5)
        verify(menu.select("projects"))
        compare(menu.currentIndex, "projects")
        compare(menuSelectedSpy.count, 1)
        verify(menu.open("files"))
        compare(menu.openedIndexes, ["files"])
        verify(menu.open("archive"))
        compare(menu.openedIndexes, ["files", "archive"])
        verify(menu.close("files"))
        compare(menu.openedIndexes, [])
        menu.direction = EOrientation.Horizontal
        compare(menu.horizontal, true)
        compare(menu.visibleItems.length, 3)
    }

    function test_dividerBehavior() {
        divider.direction = EOrientation.Horizontal
        divider.contentPosition = EPlacement.Left
        divider.contentSpacing = 20
        divider.lineWidth = 1
        divider.text = "A divider label that is wider than the available space"
        wait(0)
        compare(divider.horizontal, true)
        compare(divider.effectiveContentPosition, EPlacement.Left)
        compare(divider.availableContentWidth, 80)
        compare(findChild(divider, "dividerLabel").width, 80)
        divider.contentPosition = EPlacement.Top
        compare(divider.effectiveContentPosition, EPlacement.Center)
        divider.direction = EOrientation.Vertical
        compare(divider.horizontal, false)
        divider.lineWidth = -1
        compare(divider.effectiveLineWidth, 0)
    }

    function test_validationStates() {
        compare(EPaletteManager.StatePalette.validationColor(EValidationState.Success), "#67c23a")
        compare(EPaletteManager.StatePalette.validationColor(EValidationState.Warning), "#e6a23c")
        compare(EPaletteManager.StatePalette.validationColor(EValidationState.Error), "#f56c6c")
        input.validationState = EValidationState.Error
        input.validationMessage = "Required field"
        compare(input.hasValidationError, true)
        compare(input.Accessible.description, "Required field")
        compare(input.background.border.color, "#f56c6c")
        textArea.validationState = EValidationState.Success
        compare(textArea.hasValidationError, false)
        compare(textArea.background.border.color, "#67c23a")
        spinBox.validationState = EValidationState.Warning
        compare(spinBox.background.border.color, "#e6a23c")
    }

    function test_watermarkBehavior() {
        watermark.content = null
        wait(0)
        compare(watermark.hasContent, false)
        compare(watermark.rowCount, 0)
        compare(watermark.columnCount, 0)
        compare(findChild(watermark, "watermarkRenderer").text, "")
        watermark.content = ["EUI", "Internal"]
        wait(0)
        compare(watermark.resolvedContent, "EUI\nInternal")
        verify(watermark.rowCount > 0)
        verify(watermark.columnCount > 0)
        compare(findChild(watermark, "watermarkRenderer").text, "EUI\nInternal")
        compare(watermark.children.length, 2)
        watermark.content = null
        watermark.tileWidth = 0
        watermark.tileHeight = -1
        watermark.gap = Qt.point(-10, -20)
        compare(watermark.effectiveTileWidth, 1)
        compare(watermark.effectiveTileHeight, 1)
        compare(watermark.effectiveGapX, 0)
        compare(watermark.effectiveGapY, 0)
        compare(watermark.stepX, 1)
        compare(watermark.stepY, 1)
        compare(watermark.clip, true)
    }

    function test_formControlSizes() {
        checkBox.size = EStyle.Small
        compare(checkBox.implicitHeight, 24)
        compare(checkBox.optSize, 12)
        radio.size = EStyle.Large
        compare(radio.implicitHeight, 40)
        compare(radio.optSize, 16)
        toggle.size = EStyle.Small
        compare(toggle.implicitWidth, 32)
        compare(toggle.implicitHeight, 16)
        toggle.size = EStyle.Large
        compare(toggle.implicitWidth, 48)
        compare(toggle.implicitHeight, 24)
        spinBox.size = EStyle.Large
        compare(spinBox.implicitHeight, 40)
        compare(spinBox.indicatorWidth, 40)
        textArea.size = EStyle.Small
        verify(textArea.implicitHeight >= 24)
        slider.size = EStyle.Small
        compare(slider.trackSize, 4)
        compare(slider.handleSize, 12)
        slider.size = EStyle.Large
        compare(slider.trackSize, 8)
        compare(slider.handleSize, 20)
        checkBoxButton.size = EStyle.Large
        compare(checkBoxButton.implicitHeight, 40)
        radioButton.size = EStyle.Small
        compare(radioButton.implicitHeight, 24)
    }

    function test_formItemPropagation() {
        formItem.size = EStyle.Large
        formItem.validationState = EValidationState.Error
        formItem.validationMessage = "Invalid email"
        wait(0)
        compare(formItem.field, formInput)
        compare(formInput.size, EStyle.Large)
        compare(formInput.validationState, EValidationState.Error)
        compare(formInput.validationMessage, "Invalid email")
        compare(formItem.hasValidationError, true)
        compare(formItem.effectiveMessage, "Invalid email")
        compare(findChild(formItem, "formItemMessage").text, "Invalid email")
        verify(formItem.implicitHeight > formInput.implicitHeight)
        formItem.validationState = EValidationState.None
        formItem.validationMessage = ""
        formItem.helpText = "We never share your email"
        wait(0)
        compare(formItem.effectiveMessage, "We never share your email")
        compare(findChild(formItem, "formItemMessage").color, EPaletteManager.BasePalette.lightGray)
        formItem.showMessage = false
        compare(findChild(formItem, "formItemMessage").visible, false)
        compare(formInput.validationState, EValidationState.None)
    }

    function test_formResetAndValidateOnChange() {
        compare(resetTextInput.text, "Initial title")
        compare(resetCheckBox.checked, true)
        compare(resetTextItem.validateOnChange, true)
        compare(resetCheckItem.validateOnChange, true)
        resetTextInput.text = ""
        tryCompare(resetTextItem, "validationState", EValidationState.Error)
        compare(resetTextItem.validationMessage, "Title is required")
        resetTextInput.text = "Edited title"
        tryCompare(resetTextItem, "validationState", EValidationState.None)
        resetCheckBox.checked = false
        tryCompare(resetCheckItem, "validationState", EValidationState.Error)
        resetForm.resetFields()
        compare(resetTextInput.text, "Initial title")
        compare(resetCheckBox.checked, true)
        compare(resetTextItem.validationState, EValidationState.None)
        compare(resetCheckItem.validationState, EValidationState.None)
        compare(resetForm.valid, true)
        compare(resetForm.firstInvalidItem, null)
        resetTextInput.text = "New baseline"
        resetForm.captureInitialValues()
        resetTextInput.text = "Temporary"
        resetForm.resetFields()
        compare(resetTextInput.text, "New baseline")
        resetTextItem.resettable = false
        resetTextInput.text = "Keep me"
        compare(resetTextItem.resetField(), false)
        compare(resetTextInput.text, "Keep me")
        resetTextItem.resettable = true
    }

    function test_formValidation() {
        validationForm.size = EStyle.Large
        validationForm.showMessage = false
        wait(0)
        compare(validationForm.formItems().length, 2)
        compare(requiredFormItem.size, EStyle.Large)
        compare(customFormItem.showMessage, false)
        compare(validationForm.validate(), false)
        compare(validationForm.valid, false)
        compare(validationForm.firstInvalidItem, requiredFormItem)
        compare(requiredFormItem.validationState, EValidationState.Error)
        compare(requiredFormItem.validationMessage, "Name is required")
        compare(customFormItem.validationState, EValidationState.Error)
        compare(customFormItem.validationMessage, "Code is too short")
        compare(validationFinishedSpy.count, 1)
        validationForm.focusFirstError = true
        validationForm.validate()
        tryCompare(requiredFormInput, "activeFocus", true)
        validationForm.focusFirstError = false
        requiredFormInput.text = "Codex"
        customFormInput.text = "EUI"
        compare(validationForm.validate(), true)
        compare(validationForm.valid, true)
        compare(validationForm.firstInvalidItem, null)
        compare(requiredFormItem.validationState, EValidationState.None)
        compare(customFormItem.validationState, EValidationState.Success)
        compare(customFormItem.validationMessage, "Code accepted")
        compare(validationFinishedSpy.count, 3)
        validationForm.clearValidation()
        compare(customFormItem.validationState, EValidationState.None)
        compare(customFormItem.validationMessage, "")
    }

    function test_generatedColorScale() {
        const hoverState = EPaletteManager.createStateObject(testCase, EStyle.BackgroundColor)
            .setDark(false)
            .setHovered(true)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Primary)
        compare(EPaletteManager.StatePalette.computeBackgroundColor(hoverState), "#79bbff")

        const pressedState = EPaletteManager.createStateObject(testCase, EStyle.BackgroundColor)
            .setDark(false)
            .setPressed(true)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Primary)
        compare(EPaletteManager.StatePalette.computeBackgroundColor(pressedState), "#3782d0")

        const plainState = EPaletteManager.createStateObject(testCase, EStyle.BackgroundColor)
            .setDark(false)
            .setPlain(true)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Primary)
        compare(EPaletteManager.StatePalette.computeBackgroundColor(plainState), "#ecf5ff")

        const semanticTextState = EPaletteManager.createStateObject(testCase, EStyle.TextColor)
            .setDark(false)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Warning)
        compare(EPaletteManager.StatePalette.computeEffectiveTextColor(semanticTextState), "#ffffff")

        const hoveredPlainTextState = EPaletteManager.createStateObject(testCase, EStyle.TextColor)
            .setDark(false)
            .setPlain(true)
            .setHovered(true)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Success)
        compare(EPaletteManager.StatePalette.computeEffectiveTextColor(hoveredPlainTextState), "#ffffff")

        const pressedPlainTextState = EPaletteManager.createStateObject(testCase, EStyle.TextColor)
            .setDark(false)
            .setPlain(true)
            .setPressed(true)
            .setEnabled(true)
            .setColor(EPaletteManager.BasePalette.transparent)
            .setComponentStyle(EStyle.Success)
        compare(EPaletteManager.StatePalette.computeEffectiveTextColor(pressedPlainTextState), "#ffffff")
    }

    function init() {
        clickCount = 0
        asyncValidationCount = 0
        asyncValidationValid = false
        button.loading = false
        button.plain = false
        button.color = EPaletteManager.BasePalette.transparent
        button.size = EStyle.Medium
        input.size = EStyle.Medium
        input.showPassword = false
        input.passwordVisible = false
        checkBox.size = EStyle.Medium
        radio.size = EStyle.Medium
        toggle.size = EStyle.Medium
        spinBox.size = EStyle.Medium
        textArea.size = EStyle.Medium
        slider.size = EStyle.Medium
        checkBoxButton.size = EStyle.Medium
        radioButton.size = EStyle.Medium
        input.validationState = EValidationState.None
        input.validationMessage = ""
        textArea.validationState = EValidationState.None
        spinBox.validationState = EValidationState.None
        formItem.size = EStyle.Medium
        formItem.validationState = EValidationState.None
        formItem.validationMessage = ""
        formItem.helpText = ""
        formItem.propagateToField = true
        formItem.showMessage = true
        validationForm.size = EStyle.Medium
        validationForm.showMessage = true
        validationForm.focusFirstError = false
        resetForm.validateOnChange = true
        resetTextItem.resettable = true
        requiredFormItem.inheritFormConfig = true
        customFormItem.inheritFormConfig = true
        validationForm.clearValidation()
        resetTextInput.text = "Initial title"
        resetCheckBox.checked = true
        resetForm.captureInitialValues()
        resetForm.clearValidation()
        advancedForm.disabled = false
        advancedForm.clearValidate()
        menu.direction = EOrientation.Vertical
        menu.currentIndex = "home"
        menu.openedIndexes = []
        menuSelectedSpy.clear()
        usernameInput.text = "initial"
        emailInput.text = "valid@example.com"
        ageInput.value = 20
        roleInput.text = "admin"
        remoteInput.text = "available"
        promiseInput.text = "resolved"
        advancedForm.captureInitialValues()
        requiredFormInput.text = ""
        customFormInput.text = ""
        validationFinishedSpy.clear()
        messageOpenedCount = 0
        messageClosedCount = 0
        reopenMessageOnClose = false
        divider.text = ""
        divider.lineWidth = 1
        divider.contentSpacing = 20
        divider.direction = EOrientation.Horizontal
        divider.contentPosition = EPlacement.Center
        watermark.content = null
        watermark.gap = Qt.point(100, 100)
        watermark.tileWidth = 180
        watermark.tileHeight = 100
    }

    function test_advancedFormRulesAndFieldApis() {
        compare(advancedForm.fields.length, 6)
        compare(advancedForm.getField("profile.email"), emailItem)
        compare(advancedForm.getField(emailInput), emailItem)
        compare(advancedForm.getField("missing"), null)
        advancedModel.username = "from-model"
        compare(usernameItem.syncFromModel(true), true)
        compare(usernameInput.text, "from-model")
        usernameInput.text = "from-field"
        compare(advancedModel.username, "from-field")
        emailInput.text = "nested@example.com"
        compare(advancedModel.profile.email, "nested@example.com")
        usernameInput.text = ""
        compare(usernameItem.validate("change"), true)
        compare(usernameItem.validationState, EValidationState.None)
        compare(advancedForm.validateField("username"), false)
        compare(usernameItem.validationMessage, "Username required")
        usernameInput.text = "ab"
        compare(usernameItem.validate("blur"), false)
        compare(usernameItem.validationMessage, "Username length")
        usernameInput.text = "Codex"
        compare(usernameItem.validate("blur"), true)
        emailInput.text = "invalid"
        tryCompare(emailItem, "validationState", EValidationState.Error)
        compare(emailItem.validationMessage, "Invalid email")
        emailInput.text = "user@example.com"
        tryCompare(emailItem, "validationState", EValidationState.None)
        ageInput.value = 17
        compare(advancedForm.validateField("age"), false)
        compare(ageItem.validationMessage, "Invalid age")
        ageInput.value = 21
        roleInput.text = "owner"
        compare(advancedForm.validateField("role"), false)
        compare(roleItem.validationMessage, "Invalid role")
        roleInput.text = "editor"
        compare(advancedForm.validateField("role"), true)
        remoteInput.text = "taken"
        compare(advancedForm.validateField("remote", function(valid) {
            asyncValidationValid = valid
            ++asyncValidationCount
        }), undefined)
        tryCompare(testCase, "asyncValidationCount", 1)
        compare(asyncValidationValid, false)
        compare(remoteItem.validationMessage, "Name unavailable")
        remoteInput.text = "available"
        advancedForm.validateField("remote", function(valid) {
            asyncValidationValid = valid
            ++asyncValidationCount
        })
        tryCompare(testCase, "asyncValidationCount", 2)
        compare(asyncValidationValid, true)
        promiseInput.text = "rejected"
        compare(advancedForm.validateField("promise", function(valid) {
            asyncValidationValid = valid
            ++asyncValidationCount
        }), undefined)
        tryCompare(testCase, "asyncValidationCount", 3)
        compare(asyncValidationValid, false)
        compare(promiseItem.validationMessage, "Promise rejected")
        promiseInput.text = "resolved"
        advancedForm.validate(function(valid, errors, firstInvalid) {
            asyncValidationValid = valid
            ++asyncValidationCount
            compare(Object.keys(errors).length, 0)
            compare(firstInvalid, null)
        })
        tryCompare(testCase, "asyncValidationCount", 4)
        compare(asyncValidationValid, true)
        remoteInput.text = "taken"
        remoteItem.validate("change")
        remoteInput.text = "available"
        remoteItem.validate("change")
        tryCompare(remoteItem, "validating", false)
        compare(remoteItem.validationState, EValidationState.None)
        roleItem.error = "Server error"
        compare(roleItem.validationState, EValidationState.Error)
        compare(roleItem.validationMessage, "Server error")
        roleItem.error = ""
        roleItem.clearValidate()
        advancedForm.labelPosition = "left"
        advancedForm.labelWidth = 80
        advancedForm.inlineMessage = true
        advancedForm.hideRequiredAsterisk = true
        advancedForm.labelSuffix = ":"
        compare(usernameItem.labelPosition, "left")
        compare(usernameItem.labelWidth, 80)
        compare(usernameItem.inlineMessage, true)
        compare(usernameItem.hideRequiredAsterisk, true)
        compare(usernameItem.labelSuffix, ":")
        advancedForm.disabled = true
        tryCompare(usernameInput, "enabled", false)
        advancedForm.disabled = false
        tryCompare(usernameInput, "enabled", true)
        usernameInput.text = "baseline"
        advancedForm.setInitialValues({
            username: "server"
        })
        usernameInput.text = "temporary"
        advancedForm.resetFields("username")
        compare(usernameInput.text, "server")
        emailItem.validationState = EValidationState.Error
        roleItem.validationState = EValidationState.Error
        advancedForm.clearValidate(["profile.email", roleItem])
        compare(emailItem.validationState, EValidationState.None)
        compare(roleItem.validationState, EValidationState.None)
        compare(advancedForm.scrollToField("username"), true)
    }

    width: 360
    height: 160
    when: windowShown
    name: "EUIControls"

    EButton {
        id: button

        x: 10
        y: 10
        loading: false
        text: "Submit"

        onClicked: testCase.clickCount++
    }
    EInput {
        id: input

        x: 10
        y: 70
        width: 240
        text: "secret"
        clearable: true
        prefixIcon: EIcons.LOCK
    }
    ECheckBox {
        id: checkBox

        visible: false
    }
    ERadio {
        id: radio

        visible: false
    }
    ESwitch {
        id: toggle

        visible: false
    }
    ESpinBox {
        id: spinBox

        visible: false
    }
    ETextArea {
        id: textArea

        visible: false
        adaptiveHeight: false
    }
    ESlider {
        id: slider

        visible: false
    }
    ECheckBoxButton {
        id: checkBoxButton

        text: "Choice"
        visible: false
    }
    ERadioButton {
        id: radioButton

        text: "Choice"
        visible: false
    }
    EDivider {
        id: divider

        width: 120
        visible: false
    }
    EWatermark {
        id: watermark

        height: 80
        width: 120
        visible: false
    }
    EMenu {
        id: menu

        width: 240
        visible: false
        currentIndex: "home"
        model: [{
            index: "home",
            text: "Home"
        }, {
            index: "workspace",
            text: "Workspace",
            children: [{
                index: "projects",
                text: "Projects"
            }, {
                index: "reports",
                text: "Reports"
            }]
        }, {
            index: "files",
            text: "Files",
            children: [{
                index: "archive",
                text: "Archive",
                children: [{
                    index: "year-2026",
                    text: "2026"
                }]
            }]
        }]
    }
    EMessage {
        id: animatedMessage

        duration: 0

        onOpened: ++testCase.messageOpenedCount
        onClosed: {
            ++testCase.messageClosedCount
            if (testCase.reopenMessageOnClose) {
                testCase.reopenMessageOnClose = false
                open("Second", "after-clear", 0)
            }
        }
    }
    EFormItem {
        id: formItem

        width: 240
        label: "Email"
        required: true
        x: testCase.width + 20

        EInput {
            id: formInput

            width: parent.width
        }
    }
    EForm {
        id: validationForm

        width: 240
        focusFirstError: false
        x: testCase.width + 300

        EFormItem {
            id: requiredFormItem

            label: "Name"
            required: true
            width: parent.width

            EInput {
                id: requiredFormInput

                width: parent.width
            }
        }
        EFormItem {
            id: customFormItem

            label: "Code"
            width: parent.width
            showSuccessState: true
            validator: function(value) {
                if (value.length < 3)
                    return "Code is too short"

                return {
                    valid: true,
                    message: "Code accepted"
                }
            }

            EInput {
                id: customFormInput

                width: parent.width
            }
        }
    }
    EForm {
        id: resetForm

        width: 240
        validateOnChange: true
        x: testCase.width + 560

        EFormItem {
            id: resetTextItem

            label: "Title"
            required: true
            width: parent.width

            EInput {
                id: resetTextInput

                width: parent.width
                text: "Initial title"
            }
        }
        EFormItem {
            id: resetCheckItem

            required: true
            label: "Agreement"
            width: parent.width

            ECheckBox {
                id: resetCheckBox

                checked: true
            }
        }
    }
    EForm {
        id: advancedForm

        width: 240
        focusFirstError: false
        x: testCase.width + 820
        model: testCase.advancedModel
        rules: ({
            username: [{
                required: true,
                message: "Username required",
                trigger: "blur"
            }, {
                min: 3,
                max: 5,
                message: "Username length",
                trigger: "blur"
            }],
            "profile.email": {
                type: "email",
                message: "Invalid email",
                trigger: "change"
            },
            age: {
                type: "integer",
                min: 18,
                max: 120,
                message: "Invalid age"
            },
            role: {
                enum: ["admin", "editor"],
                message: "Invalid role"
            },
            remote: {
                trigger: "change",
                validator: function(rule, value, callback) {
                    Qt.callLater(function() {
                        callback(value === "available" ? true : "Name unavailable")
                    })
                }
            },
            promise: {
                validator: function(rule, value) {
                    return new Promise(function(resolve, reject) {
                        Qt.callLater(function() {
                            if (value === "resolved")
                                resolve(true)
                            else
                                reject(new Error("Promise rejected"))
                        })
                    })
                }
            }
        })

        EFormItem {
            id: usernameItem

            prop: "username"
            label: "Username"
            width: parent.width

            EInput {
                id: usernameInput

                text: "initial"
                width: parent.width
            }
        }
        EFormItem {
            id: emailItem

            width: parent.width
            prop: "profile.email"

            EInput {
                id: emailInput

                width: parent.width
            }
        }
        EFormItem {
            id: ageItem

            prop: "age"
            width: parent.width

            ESpinBox {
                id: ageInput

                from: 0
                to: 150
                value: 20
            }
        }
        EFormItem {
            id: roleItem

            prop: "role"
            width: parent.width
            rules: ({
                pattern: "^[a-z]+$",
                message: "Role format"
            })

            EInput {
                id: roleInput

                text: "admin"
                width: parent.width
            }
        }
        EFormItem {
            id: remoteItem

            prop: "remote"
            width: parent.width

            EInput {
                id: remoteInput

                text: "available"
                width: parent.width
            }
        }
        EFormItem {
            id: promiseItem

            prop: "promise"
            width: parent.width

            EInput {
                id: promiseInput

                text: "resolved"
                width: parent.width
            }
        }
    }
    SignalSpy {
        id: validationFinishedSpy

        target: validationForm
        signalName: "validationFinished"
    }
    SignalSpy {
        id: menuSelectedSpy

        target: menu
        signalName: "itemSelected"
    }
}
