var examples = {
    "EBorderBeam": [
        {
            "title": "CoreBorderBeamBasic",
            "description": "CoreBorderBeamBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEBorderBeam {\n    height: 96\n    width: 420\n\n    ERectangle {\n        radius: 12\n        border.width: 1\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)\n        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)\n    }\n    EText {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleAlpha\n    }\n}\n"
        },
        {
            "title": "CoreBorderBeamMultiple",
            "description": "CoreBorderBeamMultipleDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEBorderBeam {\n    count: 3\n    size: 70\n    height: 96\n    width: 420\n\n    ERectangle {\n        radius: 12\n        border.width: 1\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)\n        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)\n    }\n    EText {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleAlpha\n    }\n}\n"
        },
        {
            "title": "CoreBorderBeamGradient",
            "description": "CoreBorderBeamGradientDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEBorderBeam {\n    height: 96\n    width: 420\n    duration: 3\n    color: [{\n        \"color\": \"#3267e8\",\n        \"percent\": 0\n    }, {\n        \"color\": \"#b65cff\",\n        \"percent\": 100\n    }]\n\n    ERectangle {\n        radius: 12\n        border.width: 1\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)\n        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)\n    }\n    EText {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleAlpha\n    }\n}\n"
        },
        {
            "title": "CoreBorderBeamOutset",
            "description": "CoreBorderBeamOutsetDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEBorderBeam {\n    outset: 3\n    height: 96\n    radius: 16\n    width: 420\n    lineWidth: 3\n\n    ERectangle {\n        radius: 12\n        border.width: 1\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)\n        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)\n    }\n    EText {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleAlpha\n    }\n}\n"
        },
        {
            "title": "CoreBorderBeamMotion",
            "description": "CoreBorderBeamMotionDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEBorderBeam {\n    id: beam\n\n    height: 96\n    width: 420\n    running: false\n\n    ERectangle {\n        radius: 12\n        border.width: 1\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)\n        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)\n    }\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleSave\n\n        onClicked: beam.running = !beam.running\n    }\n}\n"
        }
    ],
    "EFloatButton": [
        {
            "title": "CoreFloatButtonBasic",
            "description": "CoreFloatButtonBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 96\n    width: 420\n\n    EFloatButton {\n        iconSource: EIcons.PLUS\n        anchors.centerIn: parent\n        tooltip: ELocale.texts.CoreSampleDetails\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonSquare",
            "description": "CoreFloatButtonSquareDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 96\n    width: 420\n\n    EFloatButton {\n        shape: \"square\"\n        anchors.centerIn: parent\n        iconSource: EIcons.CHECK\n        content: ELocale.texts.CoreSampleSave\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonBadge",
            "description": "CoreFloatButtonBadgeDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 96\n    width: 420\n\n    EFloatButton {\n        badge: ({\n            \"value\": 12\n        })\n        iconSource: EIcons.BELL\n        anchors.centerIn: parent\n        tooltip: ELocale.texts.CoreSampleNotify\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonStatus",
            "description": "CoreFloatButtonStatusDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 96\n    width: 420\n\n    EFloatButton {\n        anchors.centerIn: parent\n        iconSource: EIcons.CHECK\n        styleType: EStyle.Success\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonDisabled",
            "description": "CoreFloatButtonDisabledDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 96\n    width: 420\n\n    EFloatButton {\n        enabled: false\n        iconSource: EIcons.PLUS\n        anchors.centerIn: parent\n    }\n}\n"
        }
    ],
    "EFloatButtonGroup": [
        {
            "title": "CoreFloatButtonGroupBasic",
            "description": "CoreFloatButtonGroupBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    width: 420\n    height: 200\n\n    EFloatButtonGroup {\n        placement: \"right\"\n        x: parent.width - width - 24\n        y: parent.height - height - 8\n\n        EFloatButton {\n            iconSource: EIcons.CHECK\n            tooltip: ELocale.texts.CoreSampleSave\n        }\n        EFloatButton {\n            iconSource: EIcons.BELL\n            badge: ({\n                \"isDot\": true\n            })\n            tooltip: ELocale.texts.CoreSampleNotify\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonGroupClick",
            "description": "CoreFloatButtonGroupClickDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    width: 420\n    height: 200\n\n    EFloatButtonGroup {\n        trigger: \"click\"\n        x: parent.width - width - 24\n        y: parent.height - height - 8\n\n        EFloatButton {\n            iconSource: EIcons.CHECK\n            tooltip: ELocale.texts.CoreSampleSave\n        }\n        EFloatButton {\n            iconSource: EIcons.BELL\n            badge: ({\n                \"isDot\": true\n            })\n            tooltip: ELocale.texts.CoreSampleNotify\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonGroupHover",
            "description": "CoreFloatButtonGroupHoverDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    width: 420\n    height: 200\n\n    EFloatButtonGroup {\n        trigger: \"hover\"\n        x: parent.width - width - 24\n        y: parent.height - height - 8\n\n        EFloatButton {\n            iconSource: EIcons.CHECK\n            tooltip: ELocale.texts.CoreSampleSave\n        }\n        EFloatButton {\n            iconSource: EIcons.BELL\n            badge: ({\n                \"isDot\": true\n            })\n            tooltip: ELocale.texts.CoreSampleNotify\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonGroupDirection",
            "description": "CoreFloatButtonGroupDirectionDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    width: 420\n    height: 200\n\n    EFloatButtonGroup {\n        trigger: \"click\"\n        placement: \"left\"\n        x: parent.width - width - 24\n        y: parent.height - height - 8\n\n        EFloatButton {\n            iconSource: EIcons.CHECK\n            tooltip: ELocale.texts.CoreSampleSave\n        }\n        EFloatButton {\n            iconSource: EIcons.BELL\n            badge: ({\n                \"isDot\": true\n            })\n            tooltip: ELocale.texts.CoreSampleNotify\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFloatButtonGroupControlled",
            "description": "CoreFloatButtonGroupControlledDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    width: 420\n    height: 200\n\n    EFloatButtonGroup {\n        open: true\n        shape: \"square\"\n        trigger: \"click\"\n        x: parent.width - width - 24\n        y: parent.height - height - 8\n\n        EFloatButton {\n            iconSource: EIcons.CHECK\n            tooltip: ELocale.texts.CoreSampleSave\n        }\n        EFloatButton {\n            iconSource: EIcons.BELL\n            badge: ({\n                \"isDot\": true\n            })\n            tooltip: ELocale.texts.CoreSampleNotify\n        }\n    }\n}\n"
        }
    ],
    "EFlex": [
        {
            "title": "CoreFlexBasic",
            "description": "CoreFlexBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 16\n    width: 420\n    height: 200\n    align: \"center\"\n\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 32\n        opacity: 1\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 48\n        opacity: 0.75\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 64\n        opacity: 0.5\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n}\n"
        },
        {
            "title": "CoreFlexJustify",
            "description": "CoreFlexJustifyDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    width: 420\n    height: 200\n    align: \"center\"\n    justify: \"space-between\"\n\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 32\n        opacity: 1\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 48\n        opacity: 0.75\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 64\n        opacity: 0.5\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n}\n"
        },
        {
            "title": "CoreFlexWrap",
            "description": "CoreFlexWrapDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    width: 420\n    wrap: true\n    height: 200\n    gap: [12, 16]\n    align: \"start\"\n\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 32\n        opacity: 1\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 48\n        opacity: 0.75\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 64\n        opacity: 0.5\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 32\n        opacity: 1\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 48\n        opacity: 0.75\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 64\n        opacity: 0.5\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n}\n"
        },
        {
            "title": "CoreFlexVertical",
            "description": "CoreFlexVerticalDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    width: 420\n    height: 200\n    reverse: true\n    align: \"start\"\n    orientation: \"vertical\"\n    justify: \"space-between\"\n\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 32\n        opacity: 1\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 48\n        opacity: 0.75\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n    ERectangle {\n        radius: 6\n        width: 92\n        height: 64\n        opacity: 0.5\n        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n    }\n}\n"
        },
        {
            "title": "CoreFlexElastic",
            "description": "CoreFlexElasticDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 200\n\n    EFlexItem {\n        grow: 1\n        basis: 80\n        minSize: 40\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n        }\n    }\n    EFlexItem {\n        grow: 2\n        basis: 80\n        maxSize: 340\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n        }\n    }\n}\n"
        }
    ],
    "EFlexItem": [
        {
            "title": "CoreFlexItemGrow",
            "description": "CoreFlexItemGrowDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 140\n\n    EFlexItem {\n        grow: 1\n        basis: 80\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"A\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n    EFlexItem {\n        grow: 2\n        basis: 80\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"B\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFlexItemShrink",
            "description": "CoreFlexItemShrinkDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 140\n\n    EFlexItem {\n        shrink: 1\n        basis: 300\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"A\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n    EFlexItem {\n        shrink: 2\n        basis: 300\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"B\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFlexItemBounds",
            "description": "CoreFlexItemBoundsDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 140\n\n    EFlexItem {\n        grow: 1\n        basis: 80\n        minSize: 60\n        maxSize: 140\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"A\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n    EFlexItem {\n        grow: 1\n        basis: 80\n        minSize: 60\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"B\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFlexItemOrder",
            "description": "CoreFlexItemOrderDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 140\n\n    EFlexItem {\n        grow: 1\n        order: 2\n        basis: 80\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"A\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n    EFlexItem {\n        grow: 1\n        order: 1\n        basis: 80\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"B\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n}\n"
        },
        {
            "title": "CoreFlexItemAlign",
            "description": "CoreFlexItemAlignDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEFlex {\n    gap: 12\n    width: 420\n    height: 140\n\n    EFlexItem {\n        grow: 1\n        basis: 80\n        implicitHeight: 40\n        alignSelf: \"center\"\n\n        ERectangle {\n            radius: 6\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"A\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n    EFlexItem {\n        grow: 1\n        basis: 80\n        alignSelf: \"end\"\n        implicitHeight: 60\n\n        ERectangle {\n            radius: 6\n            opacity: 0.65\n            anchors.fill: parent\n            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)\n\n            EText {\n                text: \"B\"\n                color: \"white\"\n                anchors.centerIn: parent\n            }\n        }\n    }\n}\n"
        }
    ],
    "EList": [
        {
            "title": "CoreListBasic",
            "description": "CoreListBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEList {\n    width: 420\n    height: 270\n    bordered: true\n    items: [{\n        \"key\": \"a\",\n        \"title\": ELocale.texts.CoreSampleAlpha,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"b\",\n        \"title\": ELocale.texts.CoreSampleBeta,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"c\",\n        \"title\": ELocale.texts.CoreSampleGamma,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }]\n}\n"
        },
        {
            "title": "CoreListHeader",
            "description": "CoreListHeaderDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEList {\n    width: 420\n    height: 270\n    headerText: ELocale.texts.CoreSampleAlpha\n    footerText: ELocale.texts.CoreSampleDescription\n    items: [{\n        \"key\": \"a\",\n        \"title\": ELocale.texts.CoreSampleAlpha,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"b\",\n        \"title\": ELocale.texts.CoreSampleBeta,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"c\",\n        \"title\": ELocale.texts.CoreSampleGamma,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }]\n}\n"
        },
        {
            "title": "CoreListPagination",
            "description": "CoreListPaginationDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEList {\n    width: 420\n    height: 270\n    pageSize: 2\n    bordered: true\n    pagination: true\n    items: [{\n        \"key\": \"a\",\n        \"title\": ELocale.texts.CoreSampleAlpha,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"b\",\n        \"title\": ELocale.texts.CoreSampleBeta,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"c\",\n        \"title\": ELocale.texts.CoreSampleGamma,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }]\n}\n"
        },
        {
            "title": "CoreListGrid",
            "description": "CoreListGridDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEList {\n    width: 420\n    height: 270\n    itemDelegate: Component {\n        EListItem {\n            split: false\n        }\n    }\n    grid: ({\n        \"xs\": 1,\n        \"sm\": 2,\n        \"md\": 3,\n        \"gutter\": 12,\n        \"itemHeight\": 130\n    })\n    items: [{\n        \"key\": \"a\",\n        \"title\": ELocale.texts.CoreSampleAlpha,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"b\",\n        \"title\": ELocale.texts.CoreSampleBeta,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }, {\n        \"key\": \"c\",\n        \"title\": ELocale.texts.CoreSampleGamma,\n        \"description\": ELocale.texts.CoreSampleDescription\n    }]\n}\n"
        },
        {
            "title": "CoreListEmpty",
            "description": "CoreListEmptyDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEList {\n    items: []\n    width: 420\n    height: 270\n    bordered: true\n}\n"
        }
    ],
    "EListItem": [
        {
            "title": "CoreListItemBasic",
            "description": "CoreListItemBasicDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListItem {\n    width: 420\n    title: ELocale.texts.CoreSampleAlpha\n    description: ELocale.texts.CoreSampleDescription\n}\n"
        },
        {
            "title": "CoreListItemAvatar",
            "description": "CoreListItemAvatarDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListItem {\n    width: 420\n    extra: \"12:30\"\n    avatarText: \"B\"\n    title: ELocale.texts.CoreSampleBeta\n    avatarSource: \"qrc:/example/images/gallery/avatar-03.jpg\"\n}\n"
        },
        {
            "title": "CoreListItemActions",
            "description": "CoreListItemActionsDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListItem {\n    width: 420\n    title: ELocale.texts.CoreSampleAlpha\n    description: ELocale.texts.CoreSampleDescription\n\n    EButton {\n        textButton: true\n        text: ELocale.texts.CoreSampleDetails\n    }\n}\n"
        },
        {
            "title": "CoreListItemData",
            "description": "CoreListItemDataDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListItem {\n    width: 420\n    avatarText: \"G\"\n    itemData: ({\n        \"title\": ELocale.texts.CoreSampleGamma,\n        \"description\": ELocale.texts.CoreSampleDescription\n    })\n    avatarSource: \"qrc:/example/images/gallery/avatar-04.jpg\"\n}\n"
        },
        {
            "title": "CoreListItemPlain",
            "description": "CoreListItemPlainDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListItem {\n    width: 420\n    extra: \"QML\"\n    split: false\n    title: ELocale.texts.CoreSampleAlpha\n}\n"
        }
    ],
    "EListy": [
        {
            "title": "CoreListyVirtual",
            "description": "CoreListyVirtualDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListy {\n    readonly property string itemLabel: ELocale.texts.CoreSampleAlpha\n\n    width: 420\n    height: 270\n    overscan: 80\n    items: Array.from({\n        \"length\": 500\n    }, function(_, index) {\n        return {\n            \"key\": index,\n            \"label\": itemLabel + \" \" + index,\n            \"kind\": index < 250 ? \"A\" : \"B\"\n        }\n    })\n}\n"
        },
        {
            "title": "CoreListyGroups",
            "description": "CoreListyGroupsDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListy {\n    readonly property string itemLabel: ELocale.texts.CoreSampleAlpha\n\n    width: 420\n    height: 270\n    group: ({\n        \"key\": function(item) {\n            return item.kind\n        },\n        \"title\": function(key, entries) {\n            return key + \" · \" + entries.length\n        }\n    })\n    items: Array.from({\n        \"length\": 500\n    }, function(_, index) {\n        return {\n            \"key\": index,\n            \"label\": itemLabel + \" \" + index,\n            \"kind\": index < 250 ? \"A\" : \"B\"\n        }\n    })\n}\n"
        },
        {
            "title": "CoreListySticky",
            "description": "CoreListyStickyDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListy {\n    readonly property string itemLabel: ELocale.texts.CoreSampleAlpha\n\n    width: 420\n    height: 270\n    sticky: true\n    group: ({\n        \"key\": \"kind\"\n    })\n    items: Array.from({\n        \"length\": 500\n    }, function(_, index) {\n        return {\n            \"key\": index,\n            \"label\": itemLabel + \" \" + index,\n            \"kind\": index < 250 ? \"A\" : \"B\"\n        }\n    })\n}\n"
        },
        {
            "title": "CoreListyDelegate",
            "description": "CoreListyDelegateDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListy {\n    readonly property string itemLabel: ELocale.texts.CoreSampleAlpha\n\n    width: 420\n    height: 270\n    itemDelegate: Component {\n        EListItem {\n            property var itemKey: null\n\n            avatarText: \"Q\"\n            extra: String(itemKey)\n        }\n    }\n    items: Array.from({\n        \"length\": 500\n    }, function(_, index) {\n        return {\n            \"key\": index,\n            \"label\": itemLabel + \" \" + index,\n            \"kind\": index < 250 ? \"A\" : \"B\"\n        }\n    })\n}\n"
        },
        {
            "title": "CoreListyLocate",
            "description": "CoreListyLocateDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEListy {\n    id: list\n\n    readonly property string itemLabel: ELocale.texts.CoreSampleAlpha\n\n    width: 420\n    height: 270\n    header: EButton {\n        text: ELocale.texts.CoreSampleLocate\n\n        onClicked: list.scrollTo({\n            \"key\": 200,\n            \"align\": \"top\"\n        })\n    }\n    items: Array.from({\n        \"length\": 500\n    }, function(_, index) {\n        return {\n            \"key\": index,\n            \"label\": itemLabel + \" \" + index,\n            \"kind\": index < 250 ? \"A\" : \"B\"\n        }\n    })\n}\n"
        }
    ],
    "EApp": [
        {
            "title": "CoreAppMessage",
            "description": "CoreAppMessageDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEApp {\n    id: app\n\n    width: 420\n    height: 120\n\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleSave\n\n        onClicked: app.useApp().message.open(ELocale.texts.CoreSampleSaved)\n    }\n}\n"
        },
        {
            "title": "CoreAppNotification",
            "description": "CoreAppNotificationDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEApp {\n    id: app\n\n    width: 420\n    height: 120\n\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleNotify\n\n        onClicked: app.notification.open({\n            \"title\": ELocale.texts.CoreSampleAlpha,\n            \"message\": ELocale.texts.CoreSampleSaved\n        })\n    }\n}\n"
        },
        {
            "title": "CoreAppModal",
            "description": "CoreAppModalDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEApp {\n    id: app\n\n    width: 420\n    height: 120\n\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleDetails\n\n        onClicked: app.modal.alert(ELocale.texts.CoreSampleDescription, ELocale.texts.CoreSampleAlpha)\n    }\n}\n"
        },
        {
            "title": "CoreAppConfig",
            "description": "CoreAppConfigDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEApp {\n    id: app\n\n    width: 420\n    height: 120\n    size: EStyle.Small\n    messageConfig: ({\n        \"duration\": 1200,\n        \"max\": 2\n    })\n\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleSave\n\n        onClicked: app.message.open(ELocale.texts.CoreSampleSaved)\n    }\n}\n"
        },
        {
            "title": "CoreAppDisabled",
            "description": "CoreAppDisabledDescription",
            "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEApp {\n    id: app\n\n    width: 420\n    height: 120\n    disabled: true\n\n    EButton {\n        anchors.centerIn: parent\n        text: ELocale.texts.CoreSampleSave\n    }\n}\n"
        }
    ]
}
