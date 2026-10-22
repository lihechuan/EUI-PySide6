import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_switchChangeAfterDestruction() {
        const control = createTemporaryObject(switchComponent, testCase)
        verify(control !== null)
        control.checked = true
        control.destroy()
        wait(0)
        wait(0)
    }

    function test_scheduledValidationAfterDestruction() {
        const item = createTemporaryObject(formItemComponent, testCase)
        verify(item !== null)
        wait(0)
        item.scheduleValidation("change")
        item.destroy()
        wait(0)
        wait(0)
    }

    function test_validatorCallbackAfterDestruction() {
        let complete = null
        const item = createTemporaryObject(formItemComponent, testCase, {
            rules: [{validator: function(rule, value, done) { complete = done }}]
        })
        verify(item !== null)
        item.validate()
        verify(typeof complete === "function")
        item.destroy()
        wait(0)
        complete(false)
        wait(0)
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "ComponentLifecycle"

    Component {
        id: switchComponent

        ESwitch {}
    }
    Component {
        id: formItemComponent

        EFormItem {
            prop: "name"

            EInput { text: "value" }
        }
    }
}
