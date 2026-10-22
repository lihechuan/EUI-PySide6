import QtQuick 2.15

Item {
    id: control

    property int pull: 0
    property int push: 0
    property var lg: null
    property var md: null
    property var sm: null
    property int span: 24
    property var xl: null
    property var xs: null
    property int offset: 0

    readonly property var responsive: responsiveProps()
    readonly property int effectivePull: Math.max(0, Math.min(24, responsive.pull === undefined ? pull
        : Number(responsive.pull) || 0))
    readonly property int effectivePush: Math.max(0, Math.min(24, responsive.push === undefined ? push
        : Number(responsive.push) || 0))
    readonly property int effectiveSpan: Math.max(0, Math.min(24, responsive.span === undefined ? span
        : Number(responsive.span) || 0))
    readonly property int effectiveOffset: Math.max(0, Math.min(24, responsive.offset === undefined ? offset
        : Number(responsive.offset) || 0))
    readonly property real gutter: parent && "horizontalGutter" in parent ? parent.horizontalGutter
        : parent ? Math.max(0, Number(parent.gutter) || 0)
        : 0

    function responsiveProps() {
        const width = parent && "viewportWidth" in parent ? parent.viewportWidth : parent ? parent.width : 0
        const rules = [xs, sm, md, lg, xl]
        const thresholds = [0, 768, 992, 1200, 1920]
        let result = ({})
        for (let index = 0; index < rules.length; ++index) {
            const rule = rules[index]
            if (width >= thresholds[index] && rule !== null && rule !== undefined)
                result = Object.assign({}, result, typeof rule === "number" ? { span: rule } : rule)
        }
        return result
    }

    implicitHeight: childrenRect.height
    width: parent ? Math.max(0, (parent.width + gutter) * effectiveSpan / 24 - gutter) : implicitWidth
}
