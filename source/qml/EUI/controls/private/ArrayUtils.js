.pragma library

function isArray(value) {
    return Array.isArray(value) || Object.prototype.toString.call(value) === "[object V4Sequence]"
}
