import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var tasks: []
    property var beforeMove: null
    property bool draggable: true
    property bool readOnly: false
    property real columnWidth: 260
    property bool filterable: false
    property string keyField: "key"
    property string titleField: "title"
    property Component cardDelegate: null
    property string statusField: "status"
    property alias filterText: search.text
    property var columns: [{key: "todo", title: ELocale.texts.TaskTodo},
        {key: "doing", title: ELocale.texts.TaskDoing}, {key: "done", title: ELocale.texts.TaskDone}]

    readonly property string errorString: validate()

    signal changed(var tasks)
    signal taskClicked(var task)
    signal taskMoved(var task, var from, var to, int index)

    function tasksFor(key) {
        return !errorString ? tasks.filter(function(task) {
            return task[control.statusField] === key && String(task[control.titleField] || "")
                .toLowerCase().indexOf(search.text.toLowerCase()) >= 0
        }) : []
    }

    function validate() {
        if (!EDataUtils.isArray(tasks) || !EDataUtils.isArray(columns))
            return "invalid-model"
        const keys = []
        const statuses = []
        for (let index = 0; index < columns.length; ++index) {
            const column = columns[index]
            if (!column || column.key === undefined || statuses.indexOf(column.key) >= 0)
                return "invalid-column-key"
            statuses.push(column.key)
        }
        for (let index = 0; index < tasks.length; ++index) {
            const task = tasks[index]
            if (!task || task[keyField] === undefined || keys.indexOf(task[keyField]) >= 0
                || statuses.indexOf(task[statusField]) < 0)
                return "invalid-task-key-or-status"
            keys.push(task[keyField])
        }
        return ""
    }

    function dropTask(key, point) {
        for (let index = 0; index < columnRepeater.count; ++index) {
            const column = columnRepeater.itemAt(index)
            const local = column.mapFromItem(control, point.x, point.y)
            if (local.x >= 0 && local.x < column.width && local.y >= 0 && local.y < column.height) {
                let position = column.entries.length
                for (let cardIndex = 0; cardIndex < column.cards.count; ++cardIndex) {
                    const card = column.cards.itemAt(cardIndex)
                    const cardPoint = card.mapFromItem(control, point.x, point.y)
                    if (cardPoint.y < card.height / 2) {
                        position = cardIndex
                        break
                    }
                }
                return moveTask(key, column.entry.key, Math.min(position,
                    column.entries.filter(function(item) { return item[control.keyField] !== key }).length))
            }
        }
        return false
    }

    function moveTask(key, status, position) {
        if (!enabled || readOnly || errorString)
            return false
        const index = tasks.findIndex(function(task) { return task[control.keyField] === key })
        const column = columns.filter(function(item) { return item.key === status })[0]
        if (index < 0 || !column || column.disabled || tasks[index].disabled)
            return false
        const task = tasks[index]
        const previous = task[statusField]
        const destination = tasks.filter(function(item) {
            return item[control.statusField] === status && item[control.keyField] !== key
        })
        const nextPosition = position === undefined ? destination.length : position
        if (!isFinite(nextPosition) || Math.floor(nextPosition) !== nextPosition
            || nextPosition < 0 || nextPosition > destination.length)
            return false
        if (column.limit > 0 && previous !== status && destination.length >= column.limit)
            return false
        try {
            if (typeof beforeMove === "function" && beforeMove(task, status, nextPosition) === false)
                return false
        } catch (error) {
            return false
        }
        const replacement = Object.assign({}, task)
        replacement[statusField] = status
        const result = tasks.filter(function(item) { return item[control.keyField] !== key })
        const insertBefore = destination[nextPosition]
        const insertAt = insertBefore ? result.indexOf(insertBefore) : result.length
        result.splice(insertAt, 0, replacement)
        tasks = result
        taskMoved(replacement, previous, status, nextPosition)
        changed(tasks)
        return true
    }

    implicitHeight: 380
    implicitWidth: Math.min(900, (EDataUtils.isArray(columns) ? columns.length : 0) * (columnWidth + 12))

    onEnabledChanged: if (!enabled) dragState.card = null
    onReadOnlyChanged: if (readOnly) dragState.card = null
    onDraggableChanged: if (!draggable) dragState.card = null

    QtObject {
        id: dragState

        property Item card: null
        property point offset: Qt.point(0, 0)
        property point position: Qt.point(0, 0)
    }
    EInput {
        id: search

        clearable: true
        width: control.width
        visible: control.filterable
        prefixIcon: EIcons.MAGNIFIER
        placeholderText: ELocale.texts.Search2
    }
    Flickable {
        id: view

        clip: true
        width: control.width
        contentHeight: height
        contentWidth: row.width
        ScrollBar.horizontal: ScrollHandle {}
        height: Math.max(0, control.height - y)
        y: control.filterable ? search.height + 12 : 0

        Row {
            id: row

            spacing: 12
            height: view.height

            Repeater {
                id: columnRepeater

                model: control.columns

                ERectangle {
                    id: column

                    property var entry: modelData

                    readonly property alias cards: cards
                    readonly property var entries: control.tasksFor(entry.key)
                    readonly property bool dropHovered: dragState.card !== null && !entry.disabled
                        && (!(entry.limit > 0) || entries.length < entry.limit
                            || dragState.card.taskData[control.statusField] === entry.key)
                        && contains(mapFromItem(control, dragState.position.x, dragState.position.y))

                    radius: 8
                    border.width: 1
                    height: row.height
                    width: control.columnWidth
                    objectName: "taskBoardColumn"
                    color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                    border.color: dropHovered ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                        : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                    Rectangle {
                        x: 16
                        y: 24
                        width: 6
                        height: 6
                        radius: 3
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(
                            [EStyle.Info, EStyle.Primary, EStyle.Success][index % 3])
                    }
                    EText {
                        x: 30
                        y: 16
                        height: 24
                        font.bold: true
                        elide: Text.ElideRight
                        text: column.entry.title
                        verticalAlignment: Text.AlignVCenter
                        width: Math.max(0, countBadge.x - x - 8)
                    }
                    ERectangle {
                        id: countBadge

                        y: 16
                        height: 24
                        radius: 12
                        x: parent.width - width - 12
                        width: Math.max(24, countText.implicitWidth + 12)
                        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

                        EText {
                            id: countText

                            font.pixelSize: 12
                            anchors.centerIn: parent
                            text: column.entries.length
                            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                        }
                    }
                    Flickable {
                        x: 12
                        y: 52
                        clip: true
                        contentWidth: width
                        width: parent.width - 24
                        contentHeight: stack.height
                        ScrollBar.vertical: ScrollHandle {}
                        height: Math.max(0, parent.height - y - 12)

                        Column {
                            id: stack

                            spacing: 8
                            width: parent.width

                            Repeater {
                                id: cards

                                model: column.entries

                                ETextButton {
                                    id: card

                                    readonly property var taskData: modelData

                                    minHeight: 72
                                    leftPadding: 14
                                    rightPadding: 14
                                    width: stack.width
                                    Accessible.name: text
                                    enabled: !taskData.disabled
                                    opacity: dragState.card === card ? 0.35 : 1
                                    text: String(taskData[control.titleField] || "")
                                    contentItem: EText {
                                        text: card.text
                                        font.pixelSize: 14
                                        wrapMode: Text.Wrap
                                        visible: !control.cardDelegate
                                        verticalAlignment: Text.AlignVCenter
                                        color: card.enabled ? EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                                            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                                    }
                                    background: ERectangle {
                                        radius: 6
                                        border.width: 1
                                        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                                        border.color: card.hovered || card.visualFocus
                                            ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                                            : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                                    }

                                    onClicked: control.taskClicked(taskData)

                                    Loader {
                                        readonly property var taskData: card.taskData

                                        anchors.margins: 12
                                        anchors.fill: parent
                                        sourceComponent: control.cardDelegate
                                    }
                                    DragGesture {
                                        id: drag

                                        anchors.fill: parent
                                        enabled: control.draggable && !control.readOnly
                                        cursorShape: dragState.card === card ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                                        onCanceled: dragState.card = null
                                        onTapped: control.taskClicked(card.taskData)
                                        onPositionChanged: function(mouse) {
                                            if (dragging)
                                                dragState.position = mapToItem(control, mouse.x, mouse.y)
                                        }
                                        onDropped: function(x, y) {
                                            dragState.card = null
                                            control.dropTask(card.taskData[control.keyField], mapToItem(control, x, y))
                                        }
                                        onDraggingChanged: {
                                            if (dragging) {
                                                dragState.offset = origin
                                                dragState.position = mapToItem(control, mouseX, mouseY)
                                                dragState.card = card
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ShaderEffectSource {
        z: 10
        live: true
        sourceItem: dragState.card
        visible: dragState.card !== null
        objectName: "taskBoardDragPreview"
        width: sourceItem ? sourceItem.width : 0
        height: sourceItem ? sourceItem.height : 0
        x: dragState.position.x - dragState.offset.x
        y: dragState.position.y - dragState.offset.y
    }
}
