function valueFor(control, key, fallback) {
    let ancestor = control ? control.parent : null
    while (ancestor) {
        if (ancestor.euiConfigProvider === true && ancestor[key] !== undefined && (ancestor[key] !== null || key === "valueOnClear"))
            return ancestor[key]
        ancestor = ancestor.parent
    }
    const providers = control ? EDataUtils.configProviders(control) : []
    for (let index = 0; index < providers.length; ++index) {
        const provider = providers[index]
        if (provider && provider[key] !== undefined && (provider[key] !== null || key === "valueOnClear"))
            return provider[key]
    }
    return fallback
}

function optionFor(control, group, key, fallback) {
    let ancestor = control ? control.parent : null
    while (ancestor) {
        if (ancestor.euiConfigProvider === true && ancestor[group] && ancestor[group][key] !== undefined)
            return ancestor[group][key]
        ancestor = ancestor.parent
    }
    const providers = control ? EDataUtils.configProviders(control) : []
    for (let index = 0; index < providers.length; ++index) {
        const options = providers[index] ? providers[index][group] : null
        if (options && options[key] !== undefined)
            return options[key]
    }
    return fallback
}

function textFor(control, key, globalTexts) {
    let ancestor = control ? control.parent : null
    while (ancestor) {
        if (ancestor.euiConfigProvider === true && ancestor.localizedTexts)
            return ancestor.localizedTexts[key] === undefined ? key : ancestor.localizedTexts[key]
        ancestor = ancestor.parent
    }
    const providers = control ? EDataUtils.configProviders(control) : []
    for (let index = 0; index < providers.length; ++index) {
        const provider = providers[index]
        if (provider && provider.localizedTexts)
            return provider.localizedTexts[key] === undefined ? key : provider.localizedTexts[key]
    }
    return globalTexts && globalTexts[key] !== undefined ? globalTexts[key] : key
}

function sizeFor(control) {
    return valueFor(control, "size", 1)
}

function styleFor(control, group, key, fallback) {
    const value = optionFor(control, group, key, fallback)
    const names = ["primary", "success", "warning", "danger", "info", "default"]
    const styles = [1, 2, 4, 5, 3, 0]
    const position = names.indexOf(value)
    return position >= 0 ? styles[position] : value
}
