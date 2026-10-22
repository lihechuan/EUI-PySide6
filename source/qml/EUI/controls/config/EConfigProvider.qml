import EUI 1.0
import "EControlConfig.js" as EControlConfig
import QtQuick 2.15

Item {
    id: control

    property var card: ({})
    property var link: ({})
    property var table: ({})
    property var button: ({})
    property var dialog: ({})
    property var locale: null
    property var message: ({})
    property bool disabled: false
    property var valueOnClear: undefined
    property int size: EControlConfig.sizeFor(control)
    property int zIndex: EControlConfig.valueFor(control, "zIndex", 0)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property bool euiConfigProvider: true
    readonly property var effectiveLocale: locale
        || EControlConfig.valueFor(control, "effectiveLocale", ELocale.language)
    readonly property string language: typeof effectiveLocale === "string" ? effectiveLocale
        : effectiveLocale && effectiveLocale.name ? effectiveLocale.name : ELocale.language
    readonly property var localizedTexts: Object.assign({}, ELocale.textsForLanguage(language),
        effectiveLocale && typeof effectiveLocale === "object" ? effectiveLocale.texts || {} : {})

    enabled: !disabled
}
