import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15

EButton {
    id: control

    property Item target: null
    property real visibilityHeight: 200

    function scrollToTop() {
        if (!enabled || !target || target.contentY === undefined)
            return false
        scrollAnimation.to = target.originY || 0
        scrollAnimation.restart()
        return true
    }

    width: 40
    height: 40
    circle: true
    iconSize: 16
    duration: 250
    styleType: EStyle.Primary
    iconSource: EIcons.CHEVRON_UP
    accessibleName: EControlConfig.textFor(control, "BackToTop", ELocale.texts)
    visible: target && target.contentY !== undefined
        && target.contentY - (target.originY || 0) >= Math.max(0, visibilityHeight)

    onClicked: scrollToTop()

    NumberAnimation {
        id: scrollAnimation

        property: "contentY"
        target: control.target
        easing.type: Easing.OutCubic
        duration: Math.max(0, control.duration)
    }
}
