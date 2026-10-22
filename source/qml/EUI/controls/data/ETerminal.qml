import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property string prompt: "$"
    property string welcome: ""
    property int historyLimit: 200
    property var commandHandler: null

    readonly property bool busy: state.busy
    readonly property alias input: commandInput
    readonly property var entries: state.entries

    signal submitted(string command)
    signal completed(string command, string output, bool error)

    function clear() {
        state.entries = []
        state.history = []
        state.cursor = 0
        state.generation++
        state.busy = false
    }

    function write(text, error) {
        const entries = state.entries.slice()
        entries.push({command: "", output: String(text), error: error === true})
        state.entries = entries.slice(-Math.max(1, historyLimit))
        Qt.callLater(function() { if (control) output.positionViewAtEnd() })
    }

    function historyAt(delta) {
        if (!enabled || !state.history.length || !isFinite(delta) || Math.floor(delta) !== delta)
            return false
        state.cursor = Math.max(0, Math.min(state.history.length, state.cursor + delta))
        commandInput.text = state.cursor === state.history.length ? "" : state.history[state.cursor]
        commandInput.cursorPosition = commandInput.text.length
        return true
    }

    function execute(command) {
        if (!enabled || state.busy || typeof command !== "string" || !command.trim())
            return false
        command = command.trim()
        if (command === "clear") {
            clear()
            return true
        }
        const history = state.history.slice()
        history.push(command)
        state.history = history.slice(-Math.max(1, historyLimit))
        state.cursor = state.history.length
        const entries = state.entries.slice()
        const record = {command: command, output: "", error: false}
        entries.push(record)
        state.entries = entries.slice(-Math.max(1, historyLimit))
        const generation = ++state.generation
        state.busy = true
        submitted(command)
        function finish(value, error) {
            if (!control || generation !== state.generation)
                return
            record.output = value === undefined || value === null ? "" : String(value)
            record.error = error === true
            state.entries = state.entries.slice()
            state.busy = false
            control.completed(command, record.output, record.error)
            Qt.callLater(function() { if (control) output.positionViewAtEnd() })
        }
        try {
            const result = typeof commandHandler === "function" ? commandHandler(command)
                : command === "help" ? "help, clear, echo <text>"
                : command.indexOf("echo ") === 0 ? command.slice(5) : "Unknown command: " + command
            if (result && typeof result.then === "function")
                result.then(function(value) { finish(value, false) }, function(error) { finish(error, true) })
            else
                finish(result, false)
        } catch (error) {
            finish(error, true)
        }
        commandInput.text = ""
        return true
    }

    padding: 16
    implicitWidth: 480
    implicitHeight: 280
    background: ERectangle {
        radius: 6
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    EText {
        id: welcomeText

        x: control.padding
        y: control.padding
        text: control.welcome
        visible: text.length > 0
        wrapMode: Text.WrapAnywhere
        width: control.availableWidth
        font.family: EDefaultConfig.secondaryFontFamily
        color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
    }
    ListView {
        id: output

        clip: true
        spacing: 8
        x: control.padding
        model: control.entries
        width: control.availableWidth
        ScrollBar.vertical: ScrollHandle {}
        height: Math.max(0, commandRow.y - y - 8)
        y: control.padding + (welcomeText.visible ? welcomeText.height + 8 : 0)
        delegate: Column {
            spacing: 2
            width: output.width

            EText {
                width: parent.width
                textFormat: Text.PlainText
                wrapMode: Text.WrapAnywhere
                visible: modelData.command.length > 0
                text: control.prompt + " " + modelData.command
                font.family: EDefaultConfig.secondaryFontFamily
            }
            EText {
                width: parent.width
                text: modelData.output
                textFormat: Text.PlainText
                wrapMode: Text.WrapAnywhere
                font.family: EDefaultConfig.secondaryFontFamily
                color: modelData.error ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
                    : EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            }
        }
    }
    Rectangle {
        height: 1
        x: control.padding
        y: commandRow.y - 8
        width: control.availableWidth
        color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    Row {
        id: commandRow

        spacing: 8
        x: control.padding
        width: control.availableWidth
        y: control.height - height - control.padding

        EText {
            font.bold: true
            text: control.prompt
            anchors.verticalCenter: parent.verticalCenter
            font.family: EDefaultConfig.secondaryFontFamily
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        }
        EInput {
            id: commandInput

            leftPadding: 0
            rightPadding: 0
            enabled: !control.busy
            Accessible.name: "Command"
            width: Math.max(0, parent.width - x)
            background: ERectangle { color: "transparent" }
            font.family: EDefaultConfig.secondaryFontFamily

            onAccepted: control.execute(text)
            Keys.onUpPressed: control.historyAt(-1)
            Keys.onDownPressed: control.historyAt(1)
        }
    }
    QtObject {
        id: state

        property int cursor: 0
        property var entries: []
        property var history: []
        property bool busy: false
        property int generation: 0
    }
}
