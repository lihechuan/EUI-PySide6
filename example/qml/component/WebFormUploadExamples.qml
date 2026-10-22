import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.UploadsAndInputSuggestions
    description: ELocale.texts.WorkingPhotoWallsDirectoryUploadsCustomSuggestionsAnd

    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            title: ELocale.texts.PhotoWallSlotsAndManualQueue
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EUpload {
                        id: webUploadWall

                        width: Math.min(520, parent.width)
                        listType: "picture-card"
                        limit: 6
                        accept: "image/*"
                        fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                            {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                            {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
                        httpRequest: function(request) {
                            let cancelled = false
                            Qt.callLater(function() {
                                if (!cancelled) {
                                    request.onProgress(100)
                                    request.onSuccess("Demo upload completed")
                                }
                            })
                            return {abort: function() { cancelled = true }}
                        }
                        tipDelegate: Component {
                            EText {
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.PreviewRemoveAndRetryFilesThisDemoSimulates
                            }
                        }
                        defaultDelegate: Component {
                            Row {
                                spacing: 8

                                EButton {
                                    text: ELocale.texts.UploadAll
                                    enabled: !webUploadWall.uploading

                                    onClicked: webUploadWall.submit()
                                }
                                EButton {
                                    text: ELocale.texts.Cancel

                                    onClicked: webUploadWall.abort()
                                }
                                EButton {
                                    text: ELocale.texts.ClearCompleted

                                    onClicked: webUploadWall.clearFiles(["success"])
                                }
                            }
                        }

                        onPreviewed: webUploadStatus.text = ELocale.texts.Preview + file.name
                    }
                    EText {
                        id: webUploadStatus

                        text: ELocale.texts.ClickAThumbnailToInspectTheFile
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EUpload {
                    id: webUploadWall

                    limit: 6
                    accept: "image/*"
                    listType: "picture-card"
                    width: Math.min(520, parent.width)
                    fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
                    tipDelegate: Component {
                        EText {
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.PreviewRemoveAndRetryFilesThisDemoSimulates
                        }
                    }
                    httpRequest: function(request) {
                        let cancelled = false
                        Qt.callLater(function() {
                            if (!cancelled) {
                                request.onProgress(100)
                                request.onSuccess("Demo upload completed")
                            }
                        })
                        return {abort: function() {
                            cancelled = true
                        }}
                    }
                    defaultDelegate: Component {
                        Row {
                            spacing: 8

                            EButton {
                                text: ELocale.texts.UploadAll
                                enabled: !webUploadWall.uploading

                                onClicked: webUploadWall.submit()
                            }
                            EButton {
                                text: ELocale.texts.Cancel

                                onClicked: webUploadWall.abort()
                            }
                            EButton {
                                text: ELocale.texts.ClearCompleted

                                onClicked: webUploadWall.clearFiles(["success"])
                            }
                        }
                    }

                    onPreviewed: webUploadStatus.text = ELocale.texts.Preview
                        + file.name
                }
                EText {
                    id: webUploadStatus

                    text: ELocale.texts.ClickAThumbnailToInspectTheFile
                }
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCard {
            title: ELocale.texts.DirectorySelectionAndRequestData
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EUpload {
                        id: webUploadDirectory

                        directory: true
                        width: Math.min(520, parent.width)
                        data: function(file) { return {relativePath: file.relativePath} }
                        httpRequest: function(request) {
                            Qt.callLater(function() { request.onSuccess("Received: " + request.data.relativePath) })
                        }
                        triggerDelegate: Component {
                            EButton {
                                property var uploadControl

                                iconSource: EIcons.FOLDER
                                text: ELocale.texts.ChooseAFolder

                                onClicked: uploadControl.open()
                            }
                        }
                        tipDelegate: Component {
                            EText {
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.ReadableFilesAreCollectedRecursivelyWithRelativePathSymbolic
                            }
                        }
                    }
                    EButton {
                        text: ELocale.texts.SubmitDirectoryFiles
                        enabled: !webUploadDirectory.uploading

                        onClicked: webUploadDirectory.submit()
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EUpload {
                    id: webUploadDirectory

                    directory: true
                    width: Math.min(520, parent.width)
                    data: function(file) {
                        return {relativePath: file.relativePath}
                    }
                    httpRequest: function(request) {
                        Qt.callLater(function() {
                            request.onSuccess("Received: " + request.data.relativePath)
                        })
                    }
                    tipDelegate: Component {
                        EText {
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.ReadableFilesAreCollectedRecursivelyWithRelativePathSymbolic
                        }
                    }
                    triggerDelegate: Component {
                        EButton {
                            property var uploadControl

                            iconSource: EIcons.FOLDER
                            text: ELocale.texts.ChooseAFolder

                            onClicked: uploadControl.open()
                        }
                    }
                }
                EButton {
                    enabled: !webUploadDirectory.uploading
                    text: ELocale.texts.SubmitDirectoryFiles

                    onClicked: webUploadDirectory.submit()
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAutocomplete"

        ExampleCard {
            title: ELocale.texts.CustomSuggestionsLoadingAndKeyboardNavigation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EAutocomplete {
                        id: webUploadAutocomplete

                        width: Math.min(420, parent.width)
                        debounce: 120
                        showArrow: true
                        highlightFirstItem: true
                        textRole: "name"
                        placeholderText: ELocale.texts.SearchCitiesAndSelectWithArrowKeys
                        fetchSuggestions: function(query, callback) {
                            const cities = [{name: "Shanghai", country: "China"}, {name: "Singapore", country: "Singapore"}, {name: "Seattle", country: "USA"}]
                            Qt.callLater(function() { callback(cities.filter(function(city) { return city.name.toLowerCase().indexOf(query.toLowerCase()) >= 0 })) })
                        }
                        optionDelegate: Component {
                            EText {
                                property var option
                                property int optionIndex: -1

                                text: option ? option.name + " · " + option.country : ""
                            }
                        }
                        headerDelegate: Component {
                            EText {
                                text: ELocale.texts.CitySuggestions
                                leftPadding: 20
                            }
                        }
                        footerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.CyclesThroughSuggestionsEnterSelects
                            }
                        }
                        loadingDelegate: Component {
                            EText {
                                horizontalAlignment: Text.AlignHCenter
                                text: ELocale.texts.SearchingCities
                            }
                        }
                    }
                    EText {
                        text: ELocale.texts.CurrentText + webUploadAutocomplete.text
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EAutocomplete {
                    id: webUploadAutocomplete

                    debounce: 120
                    showArrow: true
                    textRole: "name"
                    highlightFirstItem: true
                    width: Math.min(420, parent.width)
                    placeholderText: ELocale.texts.SearchCitiesAndSelectWithArrowKeys
                    headerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.CitySuggestions
                        }
                    }
                    footerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.CyclesThroughSuggestionsEnterSelects
                        }
                    }
                    loadingDelegate: Component {
                        EText {
                            text: ELocale.texts.SearchingCities
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    optionDelegate: Component {
                        EText {
                            property var option
                            property int optionIndex: -1

                            text: option ? option.name + " · " + option.country : ""
                        }
                    }
                    fetchSuggestions: function(query, callback) {
                        const cities = [{name: "Shanghai", country: "China"}, {name: "Singapore", country: "Singapore"}, {name: "Seattle", country: "USA"}]
                        Qt.callLater(function() {
                            callback(cities.filter(function(city) {
                                return city.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
                            }))
                        })
                    }
                }
                EText {
                    text: ELocale.texts.CurrentText
                        + webUploadAutocomplete.text
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCard {
            title: ELocale.texts.MultilineMentionsValuesAndCustomLabels
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EMention {
                        id: webUploadMention

                        whole: true
                        type: "textarea"
                        prefix: ["@", "#"]
                        width: Math.min(520, parent.width)
                        options: [{label: "Alice Chen", value: "alice"}, {label: "Bob Wang", value: "bob"}, {label: "Carol", value: "carol", disabled: true}]
                        placeholderText: ELocale.texts.TypeOrToMentionAMemberBackspaceRemoves
                        labelDelegate: Component {
                            EText {
                                property var option
                                property int optionIndex: -1

                                text: option ? option.label + "  (@" + option.value + ")" : ""
                            }
                        }
                        headerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.TeamMembers
                            }
                        }
                        footerDelegate: Component {
                            EText {
                                leftPadding: 20
                                text: ELocale.texts.DisplayTheLabelAndInsertTheValue
                            }
                        }
                    }
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ActualText + webUploadMention.text
                    }
                }`)

            Column {
                spacing: 12
                width: parent.width

                EMention {
                    id: webUploadMention

                    whole: true
                    type: "textarea"
                    prefix: ["@", "#"]
                    width: Math.min(520, parent.width)
                    placeholderText: ELocale.texts.TypeOrToMentionAMemberBackspaceRemoves
                    headerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.TeamMembers
                        }
                    }
                    footerDelegate: Component {
                        EText {
                            leftPadding: 20
                            text: ELocale.texts.DisplayTheLabelAndInsertTheValue
                        }
                    }
                    options: [{label: "Alice Chen", value: "alice"}, {label: "Bob Wang", value: "bob"}, {label: "Carol", value: "carol", disabled: true}]
                    labelDelegate: Component {
                        EText {
                            property var option
                            property int optionIndex: -1

                            text: option ? option.label + "  (@" + option.value + ")" : ""
                        }
                    }
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.ActualText + webUploadMention.text
                }
            }
        }
    }
}
