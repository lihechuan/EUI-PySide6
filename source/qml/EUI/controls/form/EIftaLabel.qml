import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

EFloatLabel {
    id: control

    fixed: true

    onTargetChanged: lifecycle.hasPadding = target !== null && "topPadding" in target
    Component.onCompleted: lifecycle.hasPadding = target !== null && "topPadding" in target
    Component.onDestruction: {
        let ancestor = target
        while (ancestor) {
            if (ancestor === control) {
                lifecycle.destroying = true
                break
            }
            ancestor = ancestor.parent
        }
        if (!lifecycle.destroying) {
            heightBinding.when = false
            paddingBinding.when = false
        }
    }

    QtObject {
        id: lifecycle

        property bool destroying: false
        property bool hasPadding: false
    }
    Binding {
        id: heightBinding

        property: "height"
        value: control.height
        target: control.target
        when: control.fixed && control.target !== null
        restoreMode: lifecycle.destroying ? Binding.RestoreNone : Binding.RestoreBindingOrValue
    }
    Binding {
        id: paddingBinding

        value: 18
        property: "topPadding"
        target: control.target
        when: control.fixed && lifecycle.hasPadding
        restoreMode: lifecycle.destroying ? Binding.RestoreNone : Binding.RestoreBindingOrValue
    }
}
