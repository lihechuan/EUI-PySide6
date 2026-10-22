# Additional components and interaction extensions

[简体中文](primevue-completion.md) | English

These controls and features were introduced in the original EUI 1.3.0 and use its Qt/QML interface. Import them with `import EUI 1.0`, then search for a component in the Gallery to try examples and expand or copy their source. The addition introduced 26 public types with at least five demonstrations each, and 15 demonstrations extending existing controls. Property types, defaults, and bindings appear in the Gallery's English and Chinese API tables.

## Component entry points

| Category | Public types | Capabilities |
| --- | --- | --- |
| Field labels | `ELabel`, `EFloatLabel`, `EIftaLabel` | Field association, click to focus, floating and inset labels |
| Inputs and selection | `EInputGroup`, `EKnob`, `EListbox` | Combined inputs, rotary input, single/multiple selection and filtering |
| Data operations | `EOrderList`, `EOrgChart`, `EMeterGroup` | Drag/button ordering, organization trees, segmented meters and legends |
| Containers and editing | `EFieldset`, `EDeferred`, `EInplace` | Titled borders and collapse, viewport loading, display/edit switching |
| Navigation | `EDock`, `EMegaMenu`, `ESidebar` | Hover magnification, multi-column menus, collapsible/responsive navigation |
| Images and tags | `ECompare`, `EChip` | Image/content comparison, icon/avatar chips |
| Effects and focus | `EAnimateOnScroll`, `ERipple`, `EFocusTrap` | Viewport animations, click ripples, Tab/Shift+Tab focus cycling |
| Dialogs and commands | `EDynamicDialog`, `EDialogService`, `ETerminal` | Dynamic content, parameters/results, dialog management, command history and asynchronous responses |
| Work components | `EScheduler`, `ETaskBoard`, `ETextEditor` | Event scheduling, task columns, rich text and undo/redo |

## Comparison and numeric controls

`ECompare.value` is the front layer's visible percentage (0–100). `vertical` selects a horizontal separator; `hover` follows the pointer. `beforeSource` and `afterSource` accept image URLs. `beforeComponent` and `afterComponent` accept arbitrary QML content; `handleComponent` customizes the handle. `setValue(value)` clamps the range and `moved(value)` reports user changes. Arrow keys adjust the value; Home/End reach the bounds.

```qml
ECompare {
    width: 600
    height: 320
    beforeSource: "before.png"
    afterSource: "after.png"
}
```

`EKnob` uses `from`, `to`, `stepSize`, and `value`, with dragging, wheel, arrows, and Home/End. `readOnly` preserves display while preventing interaction. `EMeterGroup.values` accepts `{label, value, color}` objects. `maximum` defines the total; values cannot overflow the meter, and negative or non-finite values are excluded.

`EMeterGroup.circular: true` selects ring segments and takes precedence over `vertical`. `diameter` sets ring diameter and `barSize` its thickness. The ring shrinks when space is limited. `labelsOnTop` also applies to rings; the center displays the valid sum and total. The Gallery includes ring examples with custom totals and labels on top.

Horizontal and vertical bars clip rounded corners at their outer silhouette while keeping inner segments continuous. The thin rounded-bar example has five unequal segments; the two ring examples remain, for eight meter examples in total.

```qml
EMeterGroup {
    width: 360
    diameter: 180
    barSize: 16
    circular: true
    values: [{label: "Used", value: 40, color: "#409eff"},
        {label: "Cache", value: 25, color: "#67c23a"},
        {label: "Free", value: 35, color: "#909399"}]
}
```

Custom example accents consistently use Primary `#409eff`, Success `#67c23a`, Warning `#e6a23c`, Danger `#f56c6c`, and Info `#909399`, including data, layout, comparison, animation, and scheduler demonstrations.

## Forms and ordering

`ELabel.target` associates a field and focuses it on click; checkable targets also toggle. `EFormItem` labels likewise associate their fields. `EFloatLabel` and `EIftaLabel` use their default child or an explicit `target`. Give the field `width: parent.width` inside the wrapper.

`EInputGroup` arranges default content with `RowLayout`, combining `EInput`, `ESelect`, buttons, and other controls. Default `spacing: 8` avoids overlapping borders and focus states. Use `Layout.fillWidth: true` for expanding fields and `Layout.preferredWidth` for fixed sizes. Layout-managed `width` is not a sizing constraint. Set `spacing: 16` or bind a changing value. The Gallery's custom spacing example adjusts 0–48px and redistributes the two inputs' widths.

Combine `EInput.showPasswordStrength: true` and `showPassword: true` for focused strength/rule feedback. `passwordRules` accepts `{label, minLength}` or `{label, pattern}` objects. `passwordRequirements` returns `{label, passed}` and `passwordStrength` the passing proportion. These are UI feedback rules; business validation uses the application's own rules.

`EListbox.model` accepts primitive or object arrays. Objects default to `label`, `value`, and `disabled`, configurable with `labelKey` and `valueKey`. Without a value field, the object itself is the value. Single selection uses `value`; multiple selection uses `multiple: true` and `values`. `filterable` shows search and `filterText` is writable externally. Arrows navigate and Space/Enter selects. Custom `itemDelegate` reads `parent.optionData` and `parent.selected`.

`EOrderList` adds dragging and up/down/top/bottom operations to list selection. `moveItem(from, to)` moves one item; `moveSelected("up" | "down" | "top" | "bottom")` moves the selection. New array assignments update the model and `changed(model)` reports results. Disabled items cannot move directly; top/bottom return `false` when disabled items would be crossed.

`ETransfer.reorderable` enables ordering inside each column and `draggable` enables dragging between columns. Both default to false. In `reorder(right, from, to)`, `right` selects the column. Target ordering updates `value`; source ordering updates `data`. `reordered(right)` reports internal reordering.

## Organization trees and content lifetime

`EOrgChart.model` accepts a root or root array with `{key, label, children, disabled}`. Missing keys use hierarchy paths; explicit keys must be unique. `collapsedKeys` and `selectedKeys` hold state. `selectionMode` supports `none`, `single`, `multiple`, and `checkbox`; checkbox selection cascades through descendants. `toggle(key)` and `select(key)` update state. `errorString` reports duplicate keys, cycles, and invalid models.

`EDeferred` accepts a default Component and creates it only after entering the visible viewport. `once: false` unloads on exit; the default true preserves it. `margin` preloads and `viewport` selects a viewport, respecting clipping ancestors. Read `item` and `status`, handle `loaded()`, and call `reset()` to reset activation.

`EAnimateOnScroll` uses the same viewport detection and `EAnimation`. Configure `enterEffect`, `leaveEffect`, `duration`, `distance`, and `once`. `ERipple` wraps content or attaches to `target`; `pulse(x, y)` triggers it programmatically. `EFocusTrap.active` enables focus containment; only visible, enabled, Tab-focusable controls join the cycle.

`EFieldset.title` sits in its border. `collapsible` enables collapse, `collapsed` is its state, and `toggle()` changes it. `EInplace` accepts an editor Component as default content and a `displayComponent` for display. `open()` and `close()` switch states; `item` accesses the current editor.

## Dialogs and context menus

```qml
EApp {
    id: app

    EButton {
        text: "Edit"
        onClicked: app.dialog.open(editorComponent, {name: "EUI"}, {
            title: "Edit account",
            onClose: function(result, accepted) {
                if (accepted)
                    console.log(result.name)
            }
        })
    }
    Component {
        id: editorComponent

        Column {
            property var dialogRef
            property string name

            EInput { id: field; text: parent.name }
            EButton {
                text: "Save"
                onClicked: parent.dialogRef.resolve({name: field.text})
            }
        }
    }
}
```

An independent `EDialogService` also works. `open(component, properties, options)` returns a dialog; `dialogs` lists dialogs and `closeAll()` cancels them. Options include `title`, `width`, and `onClose`. Reuse an `EDynamicDialog` with `openComponent(component, properties)`. Access content through `instance`, return results with `resolve(value)`, and handle `finished(result, accepted)`. The service destroys instances after their exit animation.

`EDropdown.openAt(x, y, reference)` opens at coordinates local to `reference`, defaulting to the existing reference or control. `trigger: "contextmenu"` uses the pointer position. Qt Popup handles window-boundary avoidance.

## Navigation, images, and commands

`EDock.model` uses `{label, iconSource, command, disabled}`. `placement` accepts top/bottom/left/right and `magnification` sets hover scaling. `EMegaMenu` uses top-level `children` for column groups and each group's `children` for actions. `open(index)` and `close()` control display; `command(command, item)` reports actions.

Dock implicit sizes reserve margins for magnification, including the first/last buttons and vertical layouts. Preserve these sizes in external layouts to avoid clipping enlarged content.

`ESidebar` uses `EMenu` models and `EDrawer`. `collapsed` selects icon-only navigation; `mode: "offcanvas"` uses a drawer and `overlay: true` forces overlay mode. `responsive` and `breakpoint` switch to a drawer on narrow windows. `variant` supports sidebar/floating/inset. `headerComponent`, `footerComponent`, and default content extend navigation; `selected(index, item)` reports selection. Put overlay opening controls outside the Sidebar.

`ETag` and `EChip` support `iconSource`, `avatarSource`, and `closable`. `EImage` and `EImageViewer` show thumbnails with `showThumbnails`; toolbar actions flip horizontally/vertically and download. `flipPreview(vertical)` toggles flipping. `downloadPreview(destination)` saves the original image to a local file URL or opens a save picker if omitted. `allowDownload` controls the action. Read `downloadBusy` and handle `downloaded(destination)` / `downloadFailed(message)`. Local, qrc, data, and HTTP(S) sources work. Saving preserves original file data without preview scaling, rotation, or flipping.

`ETerminal` provides help/echo/clear, command history, and Up/Down navigation. `commandHandler(command)` returns a value or Promise; errors appear as error output. External methods are `execute()`, `write()`, and `clear()`. Commands use application-provided handlers without an operating-system shell connection.

## Work components

`EScheduler.events` uses `{key, title, start, end, allDay, color, disabled}`. `date` is the current date, `view` supports day/week/month, and `firstDayOfWeek` accepts 0–6. `eventClicked(event)` and `slotClicked(date)` report clicks. Dragging to another day preserves time and duration. `moveEvent(key, start)` and `resizeEvent(key, end)` update events; `changed(events)` reports the new array. `eventDelegate` reads `parent.eventData`; `readOnly` disables changes. Day/week views organize event lists by date, without hourly time grids, recurring events, or a resource scheduling engine.

`ETaskBoard.columns` uses `{key, title, limit, disabled}` and `tasks` uses `{key, title, status, disabled}`. Cards move between columns and reorder inside a column. `moveTask(key, status, position)` performs the same action. Returning false from `beforeMove(task, status, position)` cancels; column `limit` restricts incoming tasks. `filterable` searches titles and `cardDelegate` reads `parent.taskData`. Handle `changed(tasks)` and `taskMoved(task, from, to, index)`; the application persists business data.

During dragging a card preview follows the pointer, its original location fades while reserving space, and accepting columns highlight. Releasing outside the board or rejecting a move restores the original state. The preview reuses the rendered card, including custom `cardDelegate` content.

`ETextEditor.text` is Qt RichText HTML; `plainText` returns text and `editor` exposes the TextEdit. Its toolbar provides bold, italic, underline, strikeout, paragraph alignment, lists, clear formatting, and undo/redo. `applyFormat(operation, value)` also supports color/size/family/link; links allow HTTP(S) and mailto. With no selection, character formatting applies to the current word; otherwise it applies to the selection. `undo()` and `redo()` use Qt document history. HTML capabilities follow Qt rich text support.

These controls use EUI's Qt/QML interface; see each component's documentation for its properties, signals, and methods.
