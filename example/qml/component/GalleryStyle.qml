pragma Singleton

import EUI 1.0
import QtQuick 2.15

QtObject {
    readonly property int radius: 8
    readonly property int bodySize: 14
    readonly property int smallSize: 12
    readonly property int titleSize: 30
    readonly property int captionSize: 13
    readonly property int headingSize: 16
    readonly property int sectionSize: 20
    readonly property bool dark: ETheme.dark
    readonly property real bodyLineHeight: 1.45
    readonly property color line: dark ? "#3A3A3D" : "#E0E0E4"
    readonly property color teal: dark ? "#5DD8CB" : "#088F85"
    readonly property color text: dark ? "#F3F3F3" : "#202124"
    readonly property color hover: dark ? "#303033" : "#EBEBEF"
    readonly property color muted: dark ? "#AAAAAF" : "#686A70"
    readonly property color accent: dark ? "#7DA5FF" : "#3267E8"
    readonly property color canvas: dark ? "#202020" : "#F7F7F8"
    readonly property color violet: dark ? "#B5A2FF" : "#7B5BE8"
    readonly property color preview: dark ? "#25282F" : "#F4F6FA"
    readonly property color sidebar: dark ? "#202020" : "#F3F3F3"
    readonly property color surface: dark ? "#2B2B2B" : "#FFFFFF"
    readonly property color selection: dark ? "#363639" : "#E2E3E8"
    readonly property color accentSoft: dark ? "#2B3650" : "#E7EEFF"
    readonly property string codeFamily: EDefaultConfig.secondaryFontFamily
    readonly property var componentIcons: ({
        EKnob: EIcons.CIRCLE_NUMBER_1,
        ECompare: EIcons.PICTURE,
        EFloatLabel: EIcons.FONT,
        EIftaLabel: EIcons.FONT,
        ELabel: EIcons.FONT,
        EInputGroup: EIcons.LAYOUT_CELLS,
        EListbox: EIcons.LAYOUT_LIST,
        EOrderList: EIcons.LAYOUT_LIST,
        EOrgChart: EIcons.FOLDER_TREE,
        EMeterGroup: EIcons.CHART_COLUMN,
        EFieldset: EIcons.SQUARE_DASHED_TEXT,
        EInplace: EIcons.PENCIL,
        ETerminal: EIcons.CODE,
        EDock: EIcons.LAYOUT_HEADER,
        EMegaMenu: EIcons.LAYOUT_CELLS,
        ESidebar: EIcons.LAYOUT_SIDE_CONTENT,
        EChip: EIcons.TAG,
        EDeferred: EIcons.CLOCK,
        EAnimateOnScroll: EIcons.PLAY,
        ERipple: EIcons.CIRCLES_CONCENTRIC,
        EFocusTrap: EIcons.HAND_POINT_UP,
        EDialogService: EIcons.LAYOUT_HEADER,
        EDynamicDialog: EIcons.LAYOUT_HEADER,
        EScheduler: EIcons.CALENDAR,
        ETaskBoard: EIcons.LAYOUT_CELLS,
        ETextEditor: EIcons.PENCIL,
        EAnimation: EIcons.PLAY,
        EFilePicker: EIcons.FILE_CODE,
        EFolderPicker: EIcons.FOLDER,
        EToolBar: EIcons.SLIDERS,
        ECodeView: EIcons.CODE,
        ECommandPalette: EIcons.MAGNIFIER,
        EWizard: EIcons.LIST_CHECK,
        TokyoScene: EIcons.BOX,
        EIcon: EIcons.SHAPES_4,
        EText: EIcons.FONT,
        ELink: EIcons.LINK,
        ERow: EIcons.LAYOUT_CELLS,
        ESpace: EIcons.CHEVRONS_EXPAND_HORIZONTAL,
        EFlex: EIcons.LAYOUT_CELLS,
        EFlexItem: EIcons.LAYOUT_CELLS,
        EButton: EIcons.HAND_POINT_UP,
        EFloatButton: EIcons.HAND_POINT_UP,
        EFloatButtonGroup: EIcons.CIRCLES_CONCENTRIC,
        EAppBar: EIcons.LAYOUT_HEADER_SIDE_CONTENT,
        ESplitter: EIcons.LAYOUT_SPLIT_COLUMNS,
        EScrollbar: EIcons.BARS_DESCENDING_ALIGN_LEFT_ARROW_DOWN,
        EContainer: EIcons.LAYOUT_SIDE_CONTENT,
        EApp: EIcons.LAYOUT_SIDE_CONTENT,
        ETypography: EIcons.FONT_CASE,
        ESplitterPanel: EIcons.LAYOUT_SPLIT_SIDE_CONTENT_RIGHT,
        EStaggeredLayout: EIcons.LAYOUT_CELLS_LARGE,
        EConfigProvider: EIcons.GEAR,
        ETag: EIcons.TAG,
        ECard: EIcons.LAYOUT_HEADER,
        EBadge: EIcons.CIRCLE_NUMBER_1,
        ETable: EIcons.LAYOUT_HEADER_CELLS,
        ETree: EIcons.FOLDER_TREE,
        EEmpty: EIcons.BOX,
        EAvatar: EIcons.PERSON,
        EList: EIcons.LAYOUT_LIST,
        EListy: EIcons.LAYOUT_LIST,
        EListItem: EIcons.LAYOUT_LIST,
        ESkeleton: EIcons.SQUARE_DASHED_TEXT,
        EChart: EIcons.CHART_COLUMN,
        EImage: EIcons.PICTURE,
        ETour: EIcons.MAP_PIN,
        EPagination: EIcons.CHEVRONS_RIGHT,
        EResult: EIcons.CIRCLE_CHECK,
        EProgress: EIcons.BARS_ASCENDING_ALIGN_LEFT,
        EQRCode: EIcons.QR_CODE,
        EAvatarGroup: EIcons.PERSONS,
        ECalendar: EIcons.CALENDAR,
        ECarousel: EIcons.RECTANGLES_4,
        ETimeline: EIcons.TIMELINE,
        ECollapse: EIcons.CHEVRONS_COLLAPSE_FROM_LINES,
        ESkeletonItem: EIcons.SQUARE_DASHED,
        EStatistic: EIcons.SQUARE_CHART_COLUMN,
        ECountdown: EIcons.STOPWATCH,
        EMediaPlayer: EIcons.PLAY,
        ESegmented: EIcons.LAYOUT_COLUMNS_3,
        EStatusView: EIcons.RECTANGLE_PULSE,
        EImageViewer: EIcons.MAGNIFIER_PLUS,
        EDescriptions: EIcons.SQUARE_ARTICLE,
        EECharts: EIcons.CHART_MIXED,
        EInfiniteScroll: EIcons.ARROWS_ROTATE_RIGHT,
        EAlert: EIcons.CIRCLE_EXCLAMATION,
        EDrawer: EIcons.LAYOUT_SIDE_CONTENT_RIGHT,
        EDialog: EIcons.SQUARE_ARTICLE,
        ELoading: EIcons.CIRCLE_DASHED,
        EPopover: EIcons.COMMENT,
        EMessage: EIcons.CIRCLE_Info,
        EToolTip: EIcons.CIRCLE_QUESTION,
        EPopconfirm: EIcons.CIRCLE_CHECK,
        ENotification: EIcons.BELL_DOT,
        EMessageBox: EIcons.COMMENT_DOT,
        EDivider: EIcons.MINUS,
        EWatermark: EIcons.DROPLET,
        EShadow: EIcons.LAYERS,
        EAcrylic: EIcons.LAYERS_3_DIAGONAL,
        EClip: EIcons.CROP,
        EBorderBeam: EIcons.SQUARE_DASHED,
        EParallaxView: EIcons.LAYERS_VERTICAL,
        ESpinBox: EIcons.SLIDERS,
        EFormItem: EIcons.FILE_TEXT,
        ERectangle: EIcons.SQUARE,
        ETextArea: EIcons.TEXT_ALIGN_LEFT,
        ETextButton: EIcons.HAND_POINT_UP,
        ERadioButton: EIcons.CIRCLE,
        EThemeSwitch: EIcons.PALETTE,
        ERotatingIcon: EIcons.ARROW_ROTATE_RIGHT,
        ECopyableText: EIcons.COPY,
        ECheckBoxButton: EIcons.SQUARE_CHECK,
        ERadioGroup: EIcons.CIRCLES_CONCENTRIC,
        ECircleProgress: EIcons.CIRCLE_DASHED,
        ECheckBoxGroup: EIcons.LIST_CHECK,
        EAdvancedRectangle: EIcons.VECTOR_SQUARE,
        EForm: EIcons.LIST_CHECK,
        EInput: EIcons.FONT_CURSOR,
        ERadio: EIcons.CIRCLES_CONCENTRIC,
        ESlider: EIcons.SLIDERS,
        ESwitch: EIcons.POWER,
        ERate: EIcons.STAR,
        ECheckBox: EIcons.SQUARE_CHECK,
        ESelect: EIcons.SQUARE_LIST_UL,
        EUpload: EIcons.ARROW_UP_FROM_SQUARE,
        EMention: EIcons.AT,
        ECaptcha: EIcons.SHIELD_CHECK,
        ETransfer: EIcons.ARROW_RIGHT_ARROW_LEFT,
        ECascader: EIcons.BRANCHES_RIGHT,
        EInputTag: EIcons.TAGS,
        EDatePicker: EIcons.CALENDAR,
        EInputOtp: EIcons.SQUARE_HASHTAG,
        ETimePicker: EIcons.CLOCK,
        EAutocomplete: EIcons.MAGIC_WAND,
        ETimeSelect: EIcons.CLOCK_ARROW_ROTATE_LEFT,
        ETreeSelect: EIcons.FOLDER_TREE,
        EColorPicker: EIcons.PALETTE,
        ERangeSlider: EIcons.ARROWS_OPPOSITE_TO_DOTS,
        EShortcutPicker: EIcons.KEYBOARD,
        EDatePickerPanel: EIcons.LAYOUT_CELLS,
        EDateTimePicker: EIcons.TIMESTAMPS,
        EColorPickerPanel: EIcons.BRUSH,
        EMenu: EIcons.BARS,
        ETabs: EIcons.LAYOUT_TABS,
        ESteps: EIcons.LIST_OL,
        EMenuBar: EIcons.LAYOUT_HEADER_CELLS,
        EAffix: EIcons.PIN,
        EDropdown: EIcons.CHEVRON_DOWN,
        EAnchor: EIcons.LINK,
        EBreadcrumb: EIcons.CHEVRONS_RIGHT,
        EBacktop: EIcons.ARROW_UP_TO_LINE,
        EPageHeader: EIcons.LAYOUT_HEADER
    })

    function sourceCode(source) {
        const text = source.replace(/^\r?\n/, "").replace(/\n[ \t]+$/, "\n")
        const indentation = text.match(/^[ \t]+/)
        return indentation ? text.replace(new RegExp("^" + indentation[0], "gm"), "") : text
    }

    function groupIcon(group) {
        const icons = {
            basic: EIcons.CUBES_3,
            config: EIcons.GEAR,
            form: EIcons.SLIDERS,
            data: EIcons.LAYOUT_LIST,
            navigation: EIcons.COMPASS,
            feedback: EIcons.BELL,
            other: EIcons.SHAPES_4,
            visual: EIcons.PALETTE,
            extensions: EIcons.CODE
        }
        return icons[group] || EIcons.CUBE
    }

    function previewScrollAt(root, x, y, dx, dy) {
        const pending = [root]
        while (pending.length > 0) {
            const item = pending.pop()
            if (!item.visible || !item.enabled)
                continue
            const point = item.mapFromItem(root, x, y)
            const inside = point.x >= 0 && point.y >= 0 && point.x < item.width && point.y < item.height
            if (!inside && item.clip)
                continue
            if (inside && (item.contentY !== undefined && dy !== 0 && item.contentHeight > item.height
                || item.contentX !== undefined && dx !== 0 && item.contentWidth > item.width))
                return true
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        return false
    }
}
