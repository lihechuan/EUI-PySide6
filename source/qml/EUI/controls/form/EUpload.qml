import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Dialogs
import QtQuick.Controls

Control {
    id: control

    property int limit: 0
    property var data: ({})
    property bool drag: false
    property var fileList: []
    property string accept: ""
    property string action: ""
    property var headers: ({})
    property int maxFileSize: 0
    property bool multiple: true
    property string lastError: ""
    property bool directory: false
    property var httpRequest: null
    property string method: "POST"
    property bool autoUpload: false
    property var beforeRemove: null
    property var beforeUpload: null
    property string listType: "text"
    property bool showFileList: true
    property string fieldName: "file"
    property int pictureCardSize: 144
    property Component tipDelegate: null
    property bool withCredentials: false
    property Component fileDelegate: null
    property alias name: control.fieldName
    property Component defaultDelegate: null
    property Component triggerDelegate: null
    property var nameFilters: [EControlConfig.textFor(control, "AllFiles", ELocale.texts)]

    readonly property bool uploading: uploader.busy || internal.customBusy || internal.preparing
    readonly property string effectiveLanguage: {
        const locale = EControlConfig.valueFor(control, "locale", ELocale.language)
        return typeof locale === "string" ? locale
            : locale && locale.name ? String(locale.name)
            : ELocale.language
    }

    signal removed(var file)
    signal previewed(var file)
    signal selected(var files)
    signal rejected(string message)
    signal changed(var file, var files)
    signal failed(var file, string message)
    signal exceeded(var files, var fileList)
    signal progress(var file, real percentage)
    signal succeeded(var file, string response)

    function handleStart(file) {
        return addFiles([file])
    }

    function handleRemove(file) {
        const index = typeof file === "number" ? file : fileIndex(file)
        return removeFile(index)
    }

    function open() {
        if (!enabled)
            return
        if (!internal.fileDialog)
            internal.fileDialog = (control.directory ? folderDialogComponent : fileDialogComponent).createObject(control)
        if (internal.fileDialog)
            internal.fileDialog.open()
    }

    function clearFiles(statuses) {
        if (uploading)
            return false
        fileList = EDataUtils.isArray(statuses) ? fileList.filter(function(file) {
            return statuses.indexOf(file.status) < 0
        }) : []
        return true
    }

    function submit() {
        if (!enabled || uploading)
            return false
        internal.queue = fileList.filter(function(file) {
            return file.status === "ready" || file.status === "error"
        })
            .map(function(file) {
                return file.url
            })
        return uploadNext()
    }

    function fileIndex(file) {
        const url = file && typeof file === "object" ? file.url : file
        return fileList.findIndex(function(item) {
            return file && typeof file === "object" && file.uid !== undefined ? item.uid === file.uid
                : url !== undefined && String(item.url) === String(url)
        })
    }

    function uploadNext() {
        if (uploading || internal.queue.length === 0)
            return false
        const url = internal.queue[0]
        internal.queue = internal.queue.slice(1)
        const index = fileList.findIndex(function(file) {
            return String(file.url) === String(url)
        })
        if (index < 0)
            return uploadNext()
        return upload(index)
    }

    function updateProgress(file, percentage) {
        const amount = Number(percentage && typeof percentage === "object" ? percentage.percent : percentage)
        if (!isFinite(amount))
            return
        const percent = Math.max(0, Math.min(100, amount))
        updateFile(file.url || file, "uploading", "", {percentage: percent})
        progress(file, percent)
    }

    function addDirectories(urls) {
        if (!enabled || !urls || typeof urls.length !== "number")
            return false
        const files = []
        for (let index = 0; index < urls.length; ++index) {
            const entries = uploader.directoryFiles(urls[index])
            for (let entry = 0; entry < entries.length; ++entry)
                files.push(entries[entry])
        }
        return addFiles(files)
    }

    function abort(file) {
        if (file === undefined) {
            cancel()
            return true
        }
        const index = fileIndex(file)
        if (index < 0)
            return false
        const url = String(fileList[index].url)
        const pending = internal.queue.filter(function(item) {
            return String(item) !== url
        })
        if (internal.activeUrl === url) {
            cancel()
            internal.queue = pending
            Qt.callLater(uploadNext)
        } else internal.queue = pending
        return true
    }

    function updateFile(url, status, error, extra) {
        const items = fileList.slice(0)
        for (let index = 0; index < items.length; ++index) {
            if (String(items[index].url) !== String(url))
                continue
            items[index] = Object.assign({}, items[index], extra
                || {}, { status: status, error: error || "" })
        }
        fileList = items
        const file = fileList.find(function(item) {
            return String(item.url) === String(url)
        })
        if (file)
            changed(file, fileList)
    }

    function cancel() {
        internal.queue = []
        ++internal.revision
        internal.preparing = false
        if (internal.request && typeof internal.request.abort === "function") {
            try { internal.request.abort() } catch (error) { lastError = String(error) }
        }
        internal.request = null
        internal.activeUrl = ""
        internal.customBusy = false
        fileList.forEach(function(file) {
            if (file.status === "uploading")
                control.updateFile(file.url, "ready", "")
        })
        uploader.cancel()
    }

    function finishUpload(file, success, response, error) {
        internal.customBusy = false
        internal.request = null
        internal.activeUrl = ""
        updateFile(file.url || file, success ? "success" : "error", error,
            {response: response, percentage: success ? 100 : 0})
        lastError = error || ""
        if (success)
            succeeded(file.url || file, String(response || ""))
        else
            failed(file.url || file, String(error || ""))
        if (internal.queue.length > 0)
            Qt.callLater(uploadNext)
        else if (autoUpload)
            Qt.callLater(function() {
            const next = control.fileList.findIndex(function(item) {
                return item.status === "ready"
            })
            if (next >= 0)
                control.upload(next)
        })
    }

    function acceptsFile(name, mimeType) {
        if (!accept.trim())
            return true
        const lower = String(name).toLowerCase()
        return accept.split(",").some(function(type) {
            const token = type.trim().toLowerCase()
            if (token.charAt(0) === ".")
                return lower.slice(-token.length) === token
            if (mimeType && (token === mimeType || (token.slice(-2) === "/*"
                    && mimeType.indexOf(token.slice(0, -1)) === 0))) return true
            const image = /\.(png|jpg|jpeg|gif|webp|bmp|svg)$/.test(lower)
            if (token === "image/*")
                return image
            if (token === "text/*")
                return /\.(txt|csv|json|xml|md|html|css|js)$/.test(lower)
            return token.indexOf("/") >= 0
                && lower.slice(-(token.split("/")[1].length + 1)) === "." + token.split("/")[1]
        })
    }

    function removeFile(index) {
        if (!enabled || !Number.isInteger(index) || index < 0 || index >= fileList.length)
            return false
        const file = fileList[index]
        function remove(allowed) {
            if (allowed === false)
                return false
            const position = control.fileIndex(file)
            if (position < 0)
                return false
            const items = control.fileList.slice(0)
            items.splice(position, 1)
            if (internal.activeUrl === String(file.url))
                control.abort(file)
            control.fileList = items
            control.removed(file)
            return true
        }
        try {
            const result = typeof beforeRemove === "function" ? beforeRemove(file, fileList) : true
            if (result && typeof result.then === "function") {
                result.then(remove, function(error) {
                    control.lastError = String(error)
                })
                return true
            }
            return remove(result)
        } catch (error) { lastError = String(error) }
        return false
    }

    function startUpload(file) {
        const revision = internal.revision
        function send(fields) {
            if (revision !== internal.revision)
                return false
            internal.preparing = false
            if (!fields || typeof fields !== "object" || EDataUtils.isArray(fields)) {
                control.finishUpload(file, false, "", effectiveLanguage.indexOf("zh") === 0 ? "上传数据必须是对象"
                    : "Upload data must be an object")
                return false
            }
            return control.startRequest(file, fields)
        }
        try {
            const fields = typeof data === "function" ? data(file) : data
            if (fields && typeof fields.then === "function") {
                internal.preparing = true
                fields.then(send, function(error) {
                    if (revision !== internal.revision)
                        return
                    internal.preparing = false
                    control.finishUpload(file, false, "", String(error))
                })
                return true
            }
            return send(fields)
        } catch (error) {
            finishUpload(file, false, "", String(error))
            return false
        }
    }

    function startRequest(file, fields) {
        if (typeof httpRequest !== "function") {
            internal.nativeRevision = internal.revision
            return uploader.submit(file.url, action, fieldName, headers, fields, method, withCredentials)
        }
        const revision = internal.revision
        internal.customBusy = true
        updateFile(file.url, "uploading", "")
        let finished = false
        function finish(success, response, error) {
            if (finished || revision !== internal.revision)
                return
            finished = true
            control.finishUpload(file, success, response, error)
        }
        try {
            const result = httpRequest({ file: file, action: action, filename: fieldName, headers: headers, data: fields, method: method, withCredentials: withCredentials,
                onSuccess: function(response) {
                    finish(true, response, "")
                },
                onError: function(error) {
                    finish(false, "", String(error))
                },
                onProgress: function(percentage) {
                    if (!finished && revision === internal.revision)
                        control.updateProgress(file, percentage)
                } })
            if (result && typeof result.then === "function")
                result.then(function(response) {
                    finish(true, response, "")
                }, function(error) {
                    finish(false, "", String(error))
                })
            else if (!finished)
                internal.request = result || null
            return true
        } catch (error) {
            finish(false, "", String(error))
            return false
        }
    }

    function addFiles(urls) {
        if (!enabled || !urls || typeof urls.length !== "number")
            return false
        const items = fileList.slice(0)
        const added = []
        for (let index = 0; index < urls.length; ++index) {
            if (limit > 0 && items.length >= limit) {
                exceeded(urls, fileList)
                rejected(EControlConfig.textFor(control, "TheNumberOfFilesExceedsTheLimit", ELocale.texts))
                break
            }
            const entry = urls[index]
            const url = String(entry && typeof entry === "object" && entry.url !== undefined ? entry.url
                : entry)
            const info = uploader.fileInfo(url)
            if (!info.readable
                || !acceptsFile(info.name, info.mimeType)
                || (maxFileSize > 0 && info.size > maxFileSize)) {
                rejected(EControlConfig.textFor(control, "TheFileIsUnreadableOrExceedsThe", ELocale.texts))
                continue
            }
            if (items.some(function(file) {
                return String(file.url) === url
            }))
                continue
            const file = { url: url, name: info.name, size: info.size, status: "ready", error: "", percentage: 0,
                uid: ++internal.nextUid, relativePath: entry && typeof entry === "object"
                    ? String(entry.relativePath || "")
                    : "" }
            items.push(file)
            added.push(file)
            if (!multiple)
                break
        }
        fileList = items
        if (added.length) {
            selected(added)
            added.forEach(function(file) {
                control.changed(file, control.fileList)
            })
        }
        if (autoUpload && !uploading && added.length)
            upload(fileList.length - added.length)
        return added.length > 0
    }

    function upload(index) {
        if (!enabled || uploading || !Number.isInteger(index) || index < 0 || index >= fileList.length)
            return false
        const file = fileList[index]
        const revision = ++internal.revision
        internal.activeUrl = String(file.url)
        function start(allowed) {
            if (revision !== internal.revision)
                return false
            internal.preparing = false
            if (allowed === false) {
                internal.activeUrl = ""
                Qt.callLater(control.uploadNext)
                return false
            }
            let uploadFile = file
            if (allowed && typeof allowed === "object" && allowed.url !== undefined) {
                const url = String(allowed.url)
                const info = uploader.fileInfo(url)
                if (!info.readable
                    || !control.acceptsFile(info.name, info.mimeType)
                    || (control.maxFileSize > 0 && info.size > control.maxFileSize)) {
                    control.finishUpload(
                        file,
                        false,
                        "",
                        EControlConfig.textFor(control, "TheFileIsUnreadableOrExceedsThe", ELocale.texts)
                    )
                    return false
                }
                uploadFile = Object.assign({}, file, {url: url, name: info.name, size: info.size})
                const position = control.fileIndex(file)
                if (position < 0)
                    return false
                const items = control.fileList.slice(0)
                items[position] = uploadFile
                control.fileList = items
                internal.activeUrl = url
            }
            return control.startUpload(uploadFile)
        }
        try {
            const result = typeof beforeUpload === "function" ? beforeUpload(file) : true
            if (result && typeof result.then === "function") {
                internal.preparing = true
                result.then(start, function(error) {
                    if (revision !== internal.revision)
                        return
                    internal.preparing = false
                    internal.activeUrl = ""
                    control.lastError = String(error)
                    Qt.callLater(control.uploadNext)
                })
                return true
            }
            return start(result)
        } catch (error) {
            internal.activeUrl = ""
            lastError = String(error)
            Qt.callLater(uploadNext)
            return false
        }
    }

    implicitWidth: 360
    implicitHeight: uploadColumn.implicitHeight
    contentItem: Column {
        id: uploadColumn

        spacing: 8

        Loader {
            width: parent.width
            height: active ? implicitHeight : 0
            active: control.listType !== "picture-card"
            sourceComponent: control.triggerDelegate || defaultTrigger

            onLoaded: if ("uploadControl" in item)
                item.uploadControl = control
        }
        Loader {
            width: parent.width
            height: active ? implicitHeight : 0
            active: control.defaultDelegate !== null
            sourceComponent: control.defaultDelegate

            onLoaded: if ("uploadControl" in item)
                item.uploadControl = control
        }
        Flow {
            id: fileFlow

            spacing: 8
            width: parent.width
            objectName: "uploadFileFlow"

            Repeater {
                model: control.showFileList ? control.fileList : []
                delegate: Loader {
                    id: fileLoader

                    readonly property var file: modelData
                    readonly property int fileIndex: index

                    height: implicitHeight
                    width: control.listType === "picture-card" ? control.pictureCardSize : fileFlow.width
                    sourceComponent: control.fileDelegate
                        || (control.listType === "picture-card" ? pictureCard : fileRow)

                    onLoaded: {
                        if ("file" in item)
                            item.file = Qt.binding(function() {
                                return fileLoader.file
                            })
                        if ("fileIndex" in item)
                            item.fileIndex = Qt.binding(function() {
                                return fileLoader.fileIndex
                            })
                        if ("uploadControl" in item)
                            item.uploadControl = control
                    }
                }
            }
            Loader {
                width: active ? control.pictureCardSize : 0
                height: active ? control.pictureCardSize : 0
                sourceComponent: control.triggerDelegate || pictureTrigger
                active: control.listType === "picture-card"
                    && (control.limit <= 0 || control.fileList.length < control.limit)

                onLoaded: if ("uploadControl" in item)
                    item.uploadControl = control
            }
        }
        Loader {
            width: parent.width
            height: implicitHeight
            sourceComponent: control.tipDelegate || defaultTip
        }
        EText {
            width: parent.width
            text: control.lastError
            wrapMode: Text.WordWrap
            visible: text.length > 0
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
        }
        EProgress {
            height: 4
            width: parent.width
            visible: control.uploading
            value: control.fileList.reduce(function(value, file) {
                return file.status === "uploading" ? Number(file.percentage || 0) / 100 : value
            }, 0)
        }
    }

    onRejected: function(message) {
        lastError = message
    }
    onFileListChanged: if (!EDataUtils.isArray(fileList))
        fileList = []
    onDirectoryChanged: if (internal.fileDialog) {
        internal.fileDialog.close()
        internal.fileDialog.destroy()
        internal.fileDialog = null
    }
    onEnabledChanged: if (!enabled && internal.fileDialog)
        internal.fileDialog.close()

    QtObject {
        id: internal

        property var queue: []
        property int revision: 0
        property var request: null
        property string activeUrl: ""
        property var fileDialog: null
        property bool preparing: false
        property bool customBusy: false
        property int nativeRevision: -1
        property double nextUid: Date.now()
    }
    DropArea {
        anchors.fill: parent
        enabled: control.enabled && control.drag

        onEntered: drag.accepted = drag.hasUrls
        onDropped: {
            if (drop.hasUrls
                && (control.directory ? control.addDirectories(drop.urls) : control.addFiles(drop.urls)))
                drop.acceptProposedAction()
        }
    }
    FileUploader {
        id: uploader

        language: control.effectiveLanguage

        onStarted: {
            control.lastError = ""
            control.updateFile(file, "uploading", "")
        }
        onFinished: if (internal.nativeRevision === internal.revision)
            control.finishUpload(file, success, response, error)
        onBusyChanged: if (!busy && internal.activeUrl === "" && internal.queue.length > 0)
            Qt.callLater(control.uploadNext)
        onProgressChanged: {
            const file = control.fileList.find(function(item) {
                return item.status === "uploading"
            })
            if (file && internal.nativeRevision === internal.revision)
                control.updateProgress(file, progress * 100)
        }
    }
    Component {
        id: fileDialogComponent

        FileDialog {
            objectName: "uploadFileDialog"
            nameFilters: control.nameFilters
            fileMode: control.multiple ? FileDialog.OpenFiles : FileDialog.OpenFile
            title: EControlConfig.textFor(control, "SelectFiles", ELocale.texts)

            onAccepted: control.addFiles(selectedFiles)
        }
    }
    Component {
        id: folderDialogComponent

        FolderDialog {
            objectName: "uploadFileDialog"
            title: EControlConfig.textFor(control, "SelectFiles", ELocale.texts)

            onAccepted: control.addDirectories([selectedFolder])
        }
    }
    Component {
        id: defaultTrigger

        EButton {
            styleType: EStyle.Primary
            objectName: "uploadSelectButton"
            text: EControlConfig.textFor(control, "SelectFiles", ELocale.texts)

            onClicked: control.open()
        }
    }
    Component {
        id: defaultTip

        EText {
            wrapMode: Text.WordWrap
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            visible: control.action.length === 0 && typeof control.httpRequest !== "function"
            text: visible ? EControlConfig.textFor(control, "SelectFilesAndSetTheActionUpload", ELocale.texts)
                : ""
        }
    }
    Component {
        id: pictureTrigger

        EButton {
            iconSource: EIcons.PLUS
            objectName: "uploadPictureTrigger"

            onClicked: control.open()
        }
    }
    Component {
        id: fileRow

        Row {
            property var file
            property int fileIndex: -1

            spacing: 8
            objectName: "uploadFileRow_" + fileIndex
            height: Math.max(40, childrenRect.height)

            Image {
                width: 40
                height: 40
                fillMode: Image.PreserveAspectFit
                visible: control.listType === "picture"
                source: visible && parent.file ? parent.file.url : ""

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: control.previewed(parent.parent.file)
                }
            }
            EText {
                elide: Text.ElideMiddle
                verticalAlignment: Text.AlignVCenter
                text: parent.file ? parent.file.name : ""
                height: EDefaultConfig.controlHeight(EStyle.Medium)
                width: Math.max(0, parent.width - uploadAction.width - removeAction.width - 16
                    - (control.listType === "picture" ? 48 : 0))
            }
            EButton {
                id: uploadAction

                textButton: true
                loading: parent.file && parent.file.status === "uploading"
                enabled: !control.uploading && parent.file && parent.file.status !== "success"
                text: parent.file && parent.file.status === "success"
                    ? EControlConfig.textFor(control, "Uploaded", ELocale.texts)
                    : (parent.file && parent.file.status === "error"
                        ? EControlConfig.textFor(control, "Retry", ELocale.texts)
                        : EControlConfig.textFor(control, "Upload2", ELocale.texts))

                onClicked: control.upload(parent.fileIndex)
            }
            EButton {
                id: removeAction

                textButton: true
                text: EControlConfig.textFor(control, "Delete", ELocale.texts)

                onClicked: control.removeFile(parent.fileIndex)
            }
        }
    }
    Component {
        id: pictureCard

        ERectangle {
            id: card

            property var file
            property int fileIndex: -1

            radius: 6
            border.width: 1
            implicitHeight: control.pictureCardSize
            objectName: "uploadFileCard_" + fileIndex
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

            Image {
                x: 8
                y: 8
                fillMode: Image.PreserveAspectFit
                width: Math.max(0, parent.width - 16)
                source: card.file ? card.file.url : ""
                height: Math.max(0, parent.height - 56)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    objectName: "uploadPreview_" + card.fileIndex

                    onClicked: control.previewed(card.file)
                }
            }
            EText {
                x: 8
                height: 18
                y: parent.height - 46
                elide: Text.ElideMiddle
                width: parent.width - 16
                text: card.file ? card.file.name : ""
                horizontalAlignment: Text.AlignHCenter
            }
            Row {
                spacing: 4
                y: parent.height - height - 4
                anchors.horizontalCenter: parent.horizontalCenter

                EButton {
                    textButton: true
                    size: EStyle.Small
                    loading: card.file && card.file.status === "uploading"
                    enabled: !control.uploading && card.file && card.file.status !== "success"
                    text: card.file && card.file.status === "success"
                        ? EControlConfig.textFor(control, "Uploaded", ELocale.texts)
                        : EControlConfig.textFor(control, "Upload2", ELocale.texts)

                    onClicked: control.upload(card.fileIndex)
                }
                EButton {
                    textButton: true
                    size: EStyle.Small
                    objectName: "uploadDelete_" + card.fileIndex
                    text: EControlConfig.textFor(control, "Delete", ELocale.texts)

                    onClicked: control.removeFile(card.fileIndex)
                }
            }
            EProgress {
                x: 4
                height: 3
                width: parent.width - 8
                y: parent.height - height
                visible: card.file && card.file.status === "uploading"
                value: card.file ? Number(card.file.percentage || 0) / 100 : 0
            }
        }
    }
}
