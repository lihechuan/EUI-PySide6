function actionFor(item) {
    return item && (item.action || (typeof item.trigger === "function" ? item : null))
}

function enabled(item) {
    const action = actionFor(item)
    return !!item && !item.separator && item.enabled !== false && (!action || action.enabled)
}

function invoke(item) {
    if (!enabled(item))
        return false
    const action = actionFor(item)
    if (action)
        action.trigger()
    else {
        if (item.checkable)
            item.checked = !item.checked
        if (typeof item.handler === "function")
            item.handler(item)
    }
    return true
}
