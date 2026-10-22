.pragma library

var definitions = {
    "EKnob": {
        "name": "EKnob",
        "cases": [
            {
                "name": "EKnob",
                "title": "PrimeKnobCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEKnob {\n    value: 65\n}\n"
            },
            {
                "name": "EKnob",
                "title": "PrimeKnobCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEKnob {\n    to: 20\n    from: -20\n    value: 10\n    stepSize: 5\n}\n"
            },
            {
                "name": "EKnob",
                "title": "PrimeKnobCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEKnob {\n    value: 40\n    suffix: \"%\"\n}\n"
            },
            {
                "name": "EKnob",
                "title": "PrimeKnobCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEKnob {\n    value: 75\n    strokeWidth: 16\n    color: \"#67c23a\"\n}\n"
            },
            {
                "name": "EKnob",
                "title": "PrimeKnobCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEKnob {\n    value: 80\n    readOnly: true\n}\n"
            }
        ]
    },
    "ECompare": {
        "name": "ECompare",
        "cases": [
            {
                "name": "ECompare",
                "title": "PrimeCompareCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nECompare {\n    value: 50\n    height: 220\n    width: Math.min(540, parent.width)\n    beforeSource: \"qrc:/example/images/gallery/neon-red.jpg\"\n    afterSource: \"qrc:/example/images/gallery/neon-purple.jpg\"\n}\n"
            },
            {
                "name": "ECompare",
                "title": "PrimeCompareCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nECompare {\n    height: 220\n    hover: true\n    width: Math.min(540, parent.width)\n    beforeSource: \"qrc:/example/images/gallery/neon-red.jpg\"\n    afterSource: \"qrc:/example/images/gallery/neon-purple.jpg\"\n}\n"
            },
            {
                "name": "ECompare",
                "title": "PrimeCompareCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nECompare {\n    height: 220\n    vertical: true\n    width: Math.min(540, parent.width)\n    beforeSource: \"qrc:/example/images/gallery/neon-red.jpg\"\n    afterSource: \"qrc:/example/images/gallery/neon-purple.jpg\"\n}\n"
            },
            {
                "name": "ECompare",
                "title": "PrimeCompareCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nECompare {\n    height: 220\n    width: Math.min(540, parent.width)\n    beforeSource: \"qrc:/example/images/gallery/neon-red.jpg\"\n    afterSource: \"qrc:/example/images/gallery/neon-purple.jpg\"\n    handleComponent: EText {\n        text: \"◆\"\n        verticalAlignment: Text.AlignVCenter\n        horizontalAlignment: Text.AlignHCenter\n    }\n}\n"
            },
            {
                "name": "ECompare",
                "title": "PrimeCompareCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nECompare {\n    value: 0\n    height: 220\n    width: Math.min(540, parent.width)\n    Accessible.description: \"Arrow keys, Home, End\"\n    beforeSource: \"qrc:/example/images/gallery/neon-red.jpg\"\n    afterSource: \"qrc:/example/images/gallery/neon-purple.jpg\"\n}\n"
            }
        ]
    },
    "EFloatLabel": {
        "name": "EFloatLabel",
        "cases": [
            {
                "name": "EFloatLabel",
                "title": "PrimeFloatLabelCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFloatLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EFloatLabel",
                "title": "PrimeFloatLabelCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFloatLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        text: \"EUI\"\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EFloatLabel",
                "title": "PrimeFloatLabelCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFloatLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        text: \"EUI2026!\"\n        showPassword: true\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EFloatLabel",
                "title": "PrimeFloatLabelCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFloatLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        enabled: false\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EFloatLabel",
                "title": "PrimeFloatLabelCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFloatLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        clearable: true\n        text: \"Clear me\"\n        width: parent.width\n    }\n}\n"
            }
        ]
    },
    "EIftaLabel": {
        "name": "EIftaLabel",
        "cases": [
            {
                "name": "EIftaLabel",
                "title": "PrimeIftaLabelCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEIftaLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EIftaLabel",
                "title": "PrimeIftaLabelCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEIftaLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        text: \"EUI\"\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EIftaLabel",
                "title": "PrimeIftaLabelCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEIftaLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        text: \"EUI2026!\"\n        showPassword: true\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EIftaLabel",
                "title": "PrimeIftaLabelCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEIftaLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        enabled: false\n        width: parent.width\n    }\n}\n"
            },
            {
                "name": "EIftaLabel",
                "title": "PrimeIftaLabelCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEIftaLabel {\n    width: 300\n    text: ELocale.texts.Name2\n\n    EInput {\n        clearable: true\n        text: \"Clear me\"\n        width: parent.width\n    }\n}\n"
            }
        ]
    },
    "ELabel": {
        "name": "ELabel",
        "cases": [
            {
                "name": "ELabel",
                "title": "PrimeLabelCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    spacing: 12\n\n    ELabel {\n        target: field\n        text: ELocale.texts.DemoAccount\n    }\n    EInput {\n        id: field\n\n        width: 300\n    }\n}\n"
            },
            {
                "name": "ELabel",
                "title": "PrimeLabelCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    spacing: 12\n\n    ELabel {\n        target: field\n        text: ELocale.texts.DemoAccount\n    }\n    EInput {\n        id: field\n\n        width: 300\n        text: \"EUI\"\n    }\n}\n"
            },
            {
                "name": "ELabel",
                "title": "PrimeLabelCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    spacing: 12\n\n    ELabel {\n        target: field\n        text: ELocale.texts.DemoAccount\n    }\n    EInput {\n        id: field\n\n        width: 300\n        showPassword: true\n    }\n}\n"
            },
            {
                "name": "ELabel",
                "title": "PrimeLabelCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    spacing: 12\n\n    ELabel {\n        target: field\n        text: ELocale.texts.DemoAccount\n    }\n    EInput {\n        id: field\n\n        width: 300\n        enabled: false\n    }\n}\n"
            },
            {
                "name": "ELabel",
                "title": "PrimeLabelCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    spacing: 12\n\n    ELabel {\n        target: field\n        text: ELocale.texts.DemoAccount\n    }\n    EInput {\n        id: field\n\n        width: 300\n        clearable: true\n        text: ELocale.texts.DemoAccount\n    }\n}\n"
            }
        ]
    },
    "EInputGroup": {
        "name": "EInputGroup",
        "cases": [
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInputGroup {\n    width: Math.min(480, parent.width)\n\n    EInput {\n        Layout.fillWidth: true\n        placeholderText: ELocale.texts.Search\n    }\n    EButton {\n        text: ELocale.texts.Search\n    }\n}\n"
            },
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInputGroup {\n    width: Math.min(480, parent.width)\n\n    ESelect {\n        currentIndex: 0\n        Layout.minimumWidth: 120\n        Layout.preferredWidth: 120\n        model: [\"https://\", \"http://\"]\n    }\n    EInput {\n        text: \"example.com\"\n        Layout.fillWidth: true\n    }\n}\n"
            },
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInputGroup {\n    width: Math.min(480, parent.width)\n\n    EButton {\n        enabled: false\n        iconSource: EIcons.MAGNIFIER\n    }\n    EInput {\n        Layout.fillWidth: true\n    }\n}\n"
            },
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInputGroup {\n    width: Math.min(480, parent.width)\n\n    EInput {\n        Layout.fillWidth: true\n        placeholderText: \"First\"\n    }\n    EInput {\n        Layout.fillWidth: true\n        placeholderText: ELocale.texts.DemoLast\n    }\n}\n"
            },
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInputGroup {\n    width: Math.min(480, parent.width)\n\n    EInput {\n        text: \"100\"\n        Layout.fillWidth: true\n    }\n    EButton {\n        text: \"USD\"\n        enabled: false\n    }\n}\n"
            },
            {
                "name": "EInputGroup",
                "title": "PrimeInputGroupCase6",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\n\nColumn {\n    spacing: 16\n    width: Math.min(480, parent.width)\n\n    Row {\n        spacing: 12\n\n        EText {\n            text: ELocale.texts.PrimeInputGroupSpacing\n            anchors.verticalCenter: parent.verticalCenter\n        }\n        ESpinBox {\n            id: gap\n\n            to: 48\n            from: 0\n            value: 16\n            stepSize: 4\n            editable: true\n            objectName: \"inputGroupSpacingControl\"\n        }\n        EText {\n            text: \"px\"\n            anchors.verticalCenter: parent.verticalCenter\n        }\n    }\n    EInputGroup {\n        spacing: gap.value\n        width: parent.width\n        objectName: \"customSpacingInputGroup\"\n\n        EInput {\n            Layout.fillWidth: true\n            placeholderText: \"First\"\n        }\n        EInput {\n            Layout.fillWidth: true\n            placeholderText: ELocale.texts.DemoLast\n        }\n    }\n}\n"
            }
        ]
    },
    "EListbox": {
        "name": "EListbox",
        "cases": [
            {
                "name": "EListbox",
                "title": "PrimeListboxCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEListbox {\n    value: 1\n    width: 320\n    height: 200\n    model: [{\n        \"label\": ELocale.texts.Design,\n        \"value\": 1\n    }, {\n        \"label\": ELocale.texts.DemoDevelop,\n        \"value\": 2\n    }, {\n        \"label\": ELocale.texts.Review,\n        \"value\": 3,\n        \"disabled\": true\n    }, {\n        \"label\": ELocale.texts.DemoRelease,\n        \"value\": 4\n    }]\n}\n"
            },
            {
                "name": "EListbox",
                "title": "PrimeListboxCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEListbox {\n    width: 320\n    height: 200\n    multiple: true\n    values: [1, 2]\n    model: [{\n        \"label\": ELocale.texts.Design,\n        \"value\": 1\n    }, {\n        \"label\": ELocale.texts.DemoDevelop,\n        \"value\": 2\n    }, {\n        \"label\": ELocale.texts.Review,\n        \"value\": 3,\n        \"disabled\": true\n    }, {\n        \"label\": ELocale.texts.DemoRelease,\n        \"value\": 4\n    }]\n}\n"
            },
            {
                "name": "EListbox",
                "title": "PrimeListboxCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEListbox {\n    width: 320\n    height: 200\n    filterable: true\n    model: [{\n        \"label\": ELocale.texts.Design,\n        \"value\": 1\n    }, {\n        \"label\": ELocale.texts.DemoDevelop,\n        \"value\": 2\n    }, {\n        \"label\": ELocale.texts.Review,\n        \"value\": 3,\n        \"disabled\": true\n    }, {\n        \"label\": ELocale.texts.DemoRelease,\n        \"value\": 4\n    }]\n}\n"
            },
            {
                "name": "EListbox",
                "title": "PrimeListboxCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEListbox {\n    value: 2\n    width: 320\n    height: 200\n    Accessible.description: \"Up, Down, Space, Enter\"\n    model: [{\n        \"label\": ELocale.texts.Design,\n        \"value\": 1\n    }, {\n        \"label\": ELocale.texts.DemoDevelop,\n        \"value\": 2\n    }, {\n        \"label\": ELocale.texts.Review,\n        \"value\": 3,\n        \"disabled\": true\n    }, {\n        \"label\": ELocale.texts.DemoRelease,\n        \"value\": 4\n    }]\n}\n"
            },
            {
                "name": "EListbox",
                "title": "PrimeListboxCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEListbox {\n    width: 320\n    height: 200\n    itemDelegate: EText {\n        text: \"★ \" + parent.optionData.label\n        verticalAlignment: Text.AlignVCenter\n    }\n    model: [{\n        \"label\": ELocale.texts.Design,\n        \"value\": 1\n    }, {\n        \"label\": ELocale.texts.DemoDevelop,\n        \"value\": 2\n    }, {\n        \"label\": ELocale.texts.Review,\n        \"value\": 3,\n        \"disabled\": true\n    }, {\n        \"label\": ELocale.texts.DemoRelease,\n        \"value\": 4\n    }]\n}\n"
            }
        ]
    },
    "EOrderList": {
        "name": "EOrderList",
        "cases": [
            {
                "name": "EOrderList",
                "title": "PrimeOrderListCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrderList {\n    height: 220\n    values: [ELocale.texts.DemoDevelop]\n    width: Math.min(460, parent.width)\n    model: [ELocale.texts.Design, ELocale.texts.DemoDevelop, ELocale.texts.Review, ELocale.texts.DemoRelease]\n}\n"
            },
            {
                "name": "EOrderList",
                "title": "PrimeOrderListCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrderList {\n    height: 220\n    values: [ELocale.texts.DemoDevelop, ELocale.texts.Review]\n    width: Math.min(460, parent.width)\n    model: [ELocale.texts.Design, ELocale.texts.DemoDevelop, ELocale.texts.Review, ELocale.texts.DemoRelease]\n}\n"
            },
            {
                "name": "EOrderList",
                "title": "PrimeOrderListCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrderList {\n    height: 220\n    filterable: true\n    width: Math.min(460, parent.width)\n    model: [ELocale.texts.Design, ELocale.texts.DemoDevelop, ELocale.texts.Review, ELocale.texts.DemoRelease]\n}\n"
            },
            {
                "name": "EOrderList",
                "title": "PrimeOrderListCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrderList {\n    height: 220\n    values: [ELocale.texts.Design, ELocale.texts.DemoRelease]\n    width: Math.min(460, parent.width)\n    model: [ELocale.texts.Design, ELocale.texts.DemoDevelop, ELocale.texts.Review, ELocale.texts.DemoRelease]\n}\n"
            },
            {
                "name": "EOrderList",
                "title": "PrimeOrderListCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrderList {\n    height: 220\n    enabled: false\n    values: [ELocale.texts.Design]\n    width: Math.min(460, parent.width)\n    model: [ELocale.texts.Design, ELocale.texts.DemoDevelop, ELocale.texts.Review, ELocale.texts.DemoRelease]\n}\n"
            }
        ]
    },
    "EOrgChart": {
        "name": "EOrgChart",
        "cases": [
            {
                "name": "EOrgChart",
                "title": "PrimeOrgChartCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrgChart {\n    height: 270\n    width: Math.min(700, parent.width)\n    model: [{\n        \"key\": \"team\",\n        \"label\": ELocale.texts.DemoTeam,\n        \"children\": [{\n            \"key\": \"design\",\n            \"label\": ELocale.texts.Design\n        }, {\n            \"key\": \"dev\",\n            \"label\": ELocale.texts.DemoDevelopment,\n            \"children\": [{\n                \"key\": \"qa\",\n                \"label\": ELocale.texts.DemoQualityAssurance\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EOrgChart",
                "title": "PrimeOrgChartCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrgChart {\n    height: 270\n    collapsedKeys: [\"dev\"]\n    width: Math.min(700, parent.width)\n    model: [{\n        \"key\": \"team\",\n        \"label\": ELocale.texts.DemoTeam,\n        \"children\": [{\n            \"key\": \"design\",\n            \"label\": ELocale.texts.Design\n        }, {\n            \"key\": \"dev\",\n            \"label\": ELocale.texts.DemoDevelopment,\n            \"children\": [{\n                \"key\": \"qa\",\n                \"label\": ELocale.texts.DemoQualityAssurance\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EOrgChart",
                "title": "PrimeOrgChartCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrgChart {\n    height: 270\n    selectionMode: \"multiple\"\n    selectedKeys: [\"design\", \"qa\"]\n    width: Math.min(700, parent.width)\n    model: [{\n        \"key\": \"team\",\n        \"label\": ELocale.texts.DemoTeam,\n        \"children\": [{\n            \"key\": \"design\",\n            \"label\": ELocale.texts.Design\n        }, {\n            \"key\": \"dev\",\n            \"label\": ELocale.texts.DemoDevelopment,\n            \"children\": [{\n                \"key\": \"qa\",\n                \"label\": ELocale.texts.DemoQualityAssurance\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EOrgChart",
                "title": "PrimeOrgChartCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrgChart {\n    height: 270\n    selectionMode: \"checkbox\"\n    width: Math.min(700, parent.width)\n    model: [{\n        \"key\": \"team\",\n        \"label\": ELocale.texts.DemoTeam,\n        \"children\": [{\n            \"key\": \"design\",\n            \"label\": ELocale.texts.Design\n        }, {\n            \"key\": \"dev\",\n            \"label\": ELocale.texts.DemoDevelopment,\n            \"children\": [{\n                \"key\": \"qa\",\n                \"label\": ELocale.texts.DemoQualityAssurance\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EOrgChart",
                "title": "PrimeOrgChartCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEOrgChart {\n    height: 270\n    width: Math.min(700, parent.width)\n    nodeDelegate: EText {\n        anchors.centerIn: parent\n        text: \"★ \" + parent.node.label\n    }\n    model: [{\n        \"key\": \"team\",\n        \"label\": ELocale.texts.DemoTeam,\n        \"children\": [{\n            \"key\": \"design\",\n            \"label\": ELocale.texts.Design\n        }, {\n            \"key\": \"dev\",\n            \"label\": ELocale.texts.DemoDevelopment,\n            \"children\": [{\n                \"key\": \"qa\",\n                \"label\": ELocale.texts.DemoQualityAssurance\n            }]\n        }]\n    }]\n}\n"
            }
        ]
    },
    "EMeterGroup": {
        "name": "EMeterGroup",
        "cases": [
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    labelsOnTop: true\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    height: 180\n    vertical: true\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    maximum: 200\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    barSize: 24\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase6",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    barSize: 16\n    diameter: 180\n    circular: true\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase7",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMeterGroup {\n    width: 360\n    maximum: 160\n    diameter: 140\n    circular: true\n    labelsOnTop: true\n    values: [{\n        \"label\": ELocale.texts.DemoUsed,\n        \"value\": 40,\n        \"color\": \"#409eff\"\n    }, {\n        \"label\": ELocale.texts.DemoCache,\n        \"value\": 25,\n        \"color\": \"#67c23a\"\n    }, {\n        \"label\": ELocale.texts.DemoFree,\n        \"value\": 35,\n        \"color\": \"#909399\"\n    }]\n}\n"
            },
            {
                "name": "EMeterGroup",
                "title": "PrimeMeterGroupCase8",
                "code": "import EUI 1.0\nimport QtQuick 2.15\n\nEMeterGroup {\n    width: 360\n    barSize: 10\n    values: [{label: \"Completed\", value: 75, color: \"#67c23a\"},\n        {label: \"Failed\", value: 15, color: \"#f56c6c\"},\n        {label: \"Pending\", value: 3, color: \"#e6a23c\"},\n        {label: \"Running\", value: 3, color: \"#409eff\"},\n        {label: \"Other\", value: 4, color: \"#909399\"}]\n}\n"
            }
        ]
    },
    "EFieldset": {
        "name": "EFieldset",
        "cases": [
            {
                "name": "EFieldset",
                "title": "PrimeFieldsetCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFieldset {\n    width: 360\n    title: ELocale.texts.DemoAccount\n\n    Column {\n        spacing: 12\n        width: parent.width\n\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Name2\n        }\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Email\n        }\n    }\n}\n"
            },
            {
                "name": "EFieldset",
                "title": "PrimeFieldsetCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFieldset {\n    width: 360\n    title: ELocale.texts.DemoAccount\n    collapsible: true\n\n    Column {\n        spacing: 12\n        width: parent.width\n\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Name2\n        }\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Email\n        }\n    }\n}\n"
            },
            {
                "name": "EFieldset",
                "title": "PrimeFieldsetCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFieldset {\n    width: 360\n    collapsed: true\n    title: ELocale.texts.DemoAccount\n    collapsible: true\n\n    Column {\n        spacing: 12\n        width: parent.width\n\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Name2\n        }\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Email\n        }\n    }\n}\n"
            },
            {
                "name": "EFieldset",
                "title": "PrimeFieldsetCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFieldset {\n    width: 360\n    padding: 10\n    topPadding: 28\n    title: ELocale.texts.DemoAccount\n\n    Column {\n        spacing: 12\n        width: parent.width\n\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Name2\n        }\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Email\n        }\n    }\n}\n"
            },
            {
                "name": "EFieldset",
                "title": "PrimeFieldsetCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFieldset {\n    width: 360\n    enabled: false\n    title: ELocale.texts.DemoAccount\n\n    Column {\n        spacing: 12\n        width: parent.width\n\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Name2\n        }\n        EInput {\n            width: parent.width\n            placeholderText: ELocale.texts.Email\n        }\n    }\n}\n"
            }
        ]
    },
    "EInplace": {
        "name": "EInplace",
        "cases": [
            {
                "name": "EInplace",
                "title": "PrimeInplaceCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInplace {\n    width: 320\n    text: ELocale.texts.PrimeInplaceCase1\n\n    EInput {\n        text: ELocale.texts.DemoEditableValue\n    }\n}\n"
            },
            {
                "name": "EInplace",
                "title": "PrimeInplaceCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInplace {\n    width: 320\n    closable: true\n    text: ELocale.texts.PrimeInplaceCase1\n\n    EInput {\n        text: ELocale.texts.DemoEditableValue\n    }\n}\n"
            },
            {
                "name": "EInplace",
                "title": "PrimeInplaceCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInplace {\n    width: 320\n    active: true\n    text: ELocale.texts.PrimeInplaceCase1\n\n    EInput {\n        text: ELocale.texts.DemoEditableValue\n    }\n}\n"
            },
            {
                "name": "EInplace",
                "title": "PrimeInplaceCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInplace {\n    id: inplace\n\n    width: 320\n    text: ELocale.texts.PrimeInplaceCase1\n    displayComponent: ETag {\n        text: \"Edit account\"\n        iconSource: EIcons.PENCIL\n\n        onClicked: inplace.open()\n    }\n\n    EInput {\n        text: ELocale.texts.DemoEditableValue\n    }\n}\n"
            },
            {
                "name": "EInplace",
                "title": "PrimeInplaceCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInplace {\n    width: 320\n    enabled: false\n    text: ELocale.texts.PrimeInplaceCase1\n\n    EInput {\n        text: ELocale.texts.DemoEditableValue\n    }\n}\n"
            }
        ]
    },
    "ETerminal": {
        "name": "ETerminal",
        "cases": [
            {
                "name": "ETerminal",
                "title": "PrimeTerminalCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETerminal {\n    height: 240\n    width: Math.min(600, parent.width)\n    welcome: ELocale.texts.DemoTerminalWelcome\n}\n"
            },
            {
                "name": "ETerminal",
                "title": "PrimeTerminalCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETerminal {\n    height: 240\n    welcome: \"Try status\"\n    width: Math.min(600, parent.width)\n    commandHandler: function(command) {\n        return command === \"status\" ? \"Ready\" : \"Unknown: \" + command\n    }\n}\n"
            },
            {
                "name": "ETerminal",
                "title": "PrimeTerminalCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETerminal {\n    height: 240\n    welcome: \"Try any command\"\n    width: Math.min(600, parent.width)\n    commandHandler: function(command) {\n        return Promise.resolve(\"Done: \" + command)\n    }\n}\n"
            },
            {
                "name": "ETerminal",
                "title": "PrimeTerminalCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETerminal {\n    height: 240\n    width: Math.min(600, parent.width)\n    commandHandler: function(command) {\n        return Promise.reject(\"Failed: \" + command)\n    }\n}\n"
            },
            {
                "name": "ETerminal",
                "title": "PrimeTerminalCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETerminal {\n    height: 240\n    prompt: \"eui >\"\n    historyLimit: 20\n    width: Math.min(600, parent.width)\n}\n"
            }
        ]
    },
    "EDock": {
        "name": "EDock",
        "cases": [
            {
                "name": "EDock",
                "title": "PrimeDockCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDock {\n    model: [{\n        \"label\": \"Home\",\n        \"iconSource\": EIcons.HOUSE,\n        \"command\": \"home\"\n    }, {\n        \"label\": \"Files\",\n        \"iconSource\": EIcons.FOLDER,\n        \"command\": \"files\"\n    }, {\n        \"label\": \"Search\",\n        \"iconSource\": EIcons.MAGNIFIER,\n        \"command\": \"search\"\n    }]\n}\n"
            },
            {
                "name": "EDock",
                "title": "PrimeDockCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDock {\n    placement: \"left\"\n    model: [{\n        \"label\": \"Home\",\n        \"iconSource\": EIcons.HOUSE,\n        \"command\": \"home\"\n    }, {\n        \"label\": \"Files\",\n        \"iconSource\": EIcons.FOLDER,\n        \"command\": \"files\"\n    }, {\n        \"label\": \"Search\",\n        \"iconSource\": EIcons.MAGNIFIER,\n        \"command\": \"search\"\n    }]\n}\n"
            },
            {
                "name": "EDock",
                "title": "PrimeDockCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDock {\n    iconSize: 32\n    itemSize: 60\n    model: [{\n        \"label\": \"Home\",\n        \"iconSource\": EIcons.HOUSE,\n        \"command\": \"home\"\n    }, {\n        \"label\": \"Files\",\n        \"iconSource\": EIcons.FOLDER,\n        \"command\": \"files\"\n    }, {\n        \"label\": \"Search\",\n        \"iconSource\": EIcons.MAGNIFIER,\n        \"command\": \"search\"\n    }]\n}\n"
            },
            {
                "name": "EDock",
                "title": "PrimeDockCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDock {\n    magnification: 1\n    model: [{\n        \"label\": \"Home\",\n        \"iconSource\": EIcons.HOUSE,\n        \"command\": \"home\"\n    }, {\n        \"label\": \"Files\",\n        \"iconSource\": EIcons.FOLDER,\n        \"command\": \"files\"\n    }, {\n        \"label\": \"Search\",\n        \"iconSource\": EIcons.MAGNIFIER,\n        \"command\": \"search\"\n    }]\n}\n"
            },
            {
                "name": "EDock",
                "title": "PrimeDockCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDock {\n    model: [{\n        \"label\": \"Home\",\n        \"iconSource\": EIcons.HOUSE,\n        \"command\": \"home\"\n    }, {\n        \"label\": \"Files\",\n        \"iconSource\": EIcons.FOLDER,\n        \"command\": \"files\"\n    }, {\n        \"label\": \"Search\",\n        \"iconSource\": EIcons.MAGNIFIER,\n        \"command\": \"search\"\n    }]\n\n    onCommand: function(command, item) { sampleFeedback.open(String(command)) }\n\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Success\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            }
        ]
    },
    "EMegaMenu": {
        "name": "EMegaMenu",
        "cases": [
            {
                "name": "EMegaMenu",
                "title": "PrimeMegaMenuCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMegaMenu {\n    width: 520\n    model: [{\n        \"label\": ELocale.texts.DemoWorkspace,\n        \"children\": [{\n            \"label\": ELocale.texts.Design,\n            \"children\": [{\n                \"label\": \"Assets\",\n                \"command\": \"assets\"\n            }, {\n                \"label\": \"Themes\",\n                \"command\": \"themes\"\n            }]\n        }, {\n            \"label\": ELocale.texts.DemoDevelop,\n            \"children\": [{\n                \"label\": \"Code\",\n                \"command\": \"code\"\n            }, {\n                \"label\": \"Build\",\n                \"command\": \"build\"\n            }]\n        }]\n    }, {\n        \"label\": ELocale.texts.DemoHelp,\n        \"children\": [{\n            \"label\": \"Learn\",\n            \"children\": [{\n                \"label\": \"Docs\",\n                \"command\": \"docs\"\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EMegaMenu",
                "title": "PrimeMegaMenuCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMegaMenu {\n    width: 180\n    vertical: true\n    model: [{\n        \"label\": ELocale.texts.DemoWorkspace,\n        \"children\": [{\n            \"label\": ELocale.texts.Design,\n            \"children\": [{\n                \"label\": \"Assets\",\n                \"command\": \"assets\"\n            }, {\n                \"label\": \"Themes\",\n                \"command\": \"themes\"\n            }]\n        }, {\n            \"label\": ELocale.texts.DemoDevelop,\n            \"children\": [{\n                \"label\": \"Code\",\n                \"command\": \"code\"\n            }, {\n                \"label\": \"Build\",\n                \"command\": \"build\"\n            }]\n        }]\n    }, {\n        \"label\": ELocale.texts.DemoHelp,\n        \"children\": [{\n            \"label\": \"Learn\",\n            \"children\": [{\n                \"label\": \"Docs\",\n                \"command\": \"docs\"\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EMegaMenu",
                "title": "PrimeMegaMenuCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMegaMenu {\n    width: 520\n    columnWidth: 240\n    model: [{\n        \"label\": ELocale.texts.DemoWorkspace,\n        \"children\": [{\n            \"label\": ELocale.texts.Design,\n            \"children\": [{\n                \"label\": \"Assets\",\n                \"command\": \"assets\"\n            }, {\n                \"label\": \"Themes\",\n                \"command\": \"themes\"\n            }]\n        }, {\n            \"label\": ELocale.texts.DemoDevelop,\n            \"children\": [{\n                \"label\": \"Code\",\n                \"command\": \"code\"\n            }, {\n                \"label\": \"Build\",\n                \"command\": \"build\"\n            }]\n        }]\n    }, {\n        \"label\": ELocale.texts.DemoHelp,\n        \"children\": [{\n            \"label\": \"Learn\",\n            \"children\": [{\n                \"label\": \"Docs\",\n                \"command\": \"docs\"\n            }]\n        }]\n    }]\n}\n"
            },
            {
                "name": "EMegaMenu",
                "title": "PrimeMegaMenuCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMegaMenu {\n    width: 520\n    model: [{\n        \"label\": ELocale.texts.DemoWorkspace,\n        \"children\": [{\n            \"label\": ELocale.texts.Design,\n            \"children\": [{\n                \"label\": \"Assets\",\n                \"command\": \"assets\"\n            }, {\n                \"label\": \"Themes\",\n                \"command\": \"themes\"\n            }]\n        }, {\n            \"label\": ELocale.texts.DemoDevelop,\n            \"children\": [{\n                \"label\": \"Code\",\n                \"command\": \"code\"\n            }, {\n                \"label\": \"Build\",\n                \"command\": \"build\"\n            }]\n        }]\n    }, {\n        \"label\": ELocale.texts.DemoHelp,\n        \"children\": [{\n            \"label\": \"Learn\",\n            \"children\": [{\n                \"label\": \"Docs\",\n                \"command\": \"docs\"\n            }]\n        }]\n    }]\n\n    onCommand: function(command, item) { sampleFeedback.open(String(command)) }\n\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Success\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EMegaMenu",
                "title": "PrimeMegaMenuCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEMegaMenu {\n    width: 520\n    enabled: false\n    model: [{\n        \"label\": ELocale.texts.DemoWorkspace,\n        \"children\": [{\n            \"label\": ELocale.texts.Design,\n            \"children\": [{\n                \"label\": \"Assets\",\n                \"command\": \"assets\"\n            }, {\n                \"label\": \"Themes\",\n                \"command\": \"themes\"\n            }]\n        }, {\n            \"label\": ELocale.texts.DemoDevelop,\n            \"children\": [{\n                \"label\": \"Code\",\n                \"command\": \"code\"\n            }, {\n                \"label\": \"Build\",\n                \"command\": \"build\"\n            }]\n        }]\n    }, {\n        \"label\": ELocale.texts.DemoHelp,\n        \"children\": [{\n            \"label\": \"Learn\",\n            \"children\": [{\n                \"label\": \"Docs\",\n                \"command\": \"docs\"\n            }]\n        }]\n    }]\n}\n"
            }
        ]
    },
    "ESidebar": {
        "name": "ESidebar",
        "cases": [
            {
                "name": "ESidebar",
                "title": "PrimeSidebarCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nESidebar {\n    height: 300\n    responsive: false\n    title: ELocale.texts.DemoWorkspace\n    model: [{\n        \"index\": \"home\",\n        \"text\": ELocale.texts.DemoHome,\n        \"iconSource\": EIcons.HOUSE\n    }, {\n        \"index\": \"files\",\n        \"text\": ELocale.texts.DemoFiles,\n        \"iconSource\": EIcons.FOLDER\n    }, {\n        \"index\": \"settings\",\n        \"text\": ELocale.texts.DemoSettings,\n        \"iconSource\": EIcons.GEAR\n    }]\n}\n"
            },
            {
                "name": "ESidebar",
                "title": "PrimeSidebarCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nESidebar {\n    height: 300\n    collapsed: true\n    responsive: false\n    title: ELocale.texts.DemoWorkspace\n    model: [{\n        \"index\": \"home\",\n        \"text\": ELocale.texts.DemoHome,\n        \"iconSource\": EIcons.HOUSE\n    }, {\n        \"index\": \"files\",\n        \"text\": ELocale.texts.DemoFiles,\n        \"iconSource\": EIcons.FOLDER\n    }, {\n        \"index\": \"settings\",\n        \"text\": ELocale.texts.DemoSettings,\n        \"iconSource\": EIcons.GEAR\n    }]\n}\n"
            },
            {
                "name": "ESidebar",
                "title": "PrimeSidebarCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nESidebar {\n    height: 300\n    collapsed: true\n    openOnHover: true\n    responsive: false\n    title: ELocale.texts.DemoWorkspace\n    model: [{\n        \"index\": \"home\",\n        \"text\": ELocale.texts.DemoHome,\n        \"iconSource\": EIcons.HOUSE\n    }, {\n        \"index\": \"files\",\n        \"text\": ELocale.texts.DemoFiles,\n        \"iconSource\": EIcons.FOLDER\n    }, {\n        \"index\": \"settings\",\n        \"text\": ELocale.texts.DemoSettings,\n        \"iconSource\": EIcons.GEAR\n    }]\n}\n"
            },
            {
                "name": "ESidebar",
                "title": "PrimeSidebarCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nESidebar {\n    height: 300\n    responsive: false\n    title: ELocale.texts.DemoWorkspace\n    variant: \"floating\"\n    model: [{\n        \"index\": \"home\",\n        \"text\": ELocale.texts.DemoHome,\n        \"iconSource\": EIcons.HOUSE\n    }, {\n        \"index\": \"files\",\n        \"text\": ELocale.texts.DemoFiles,\n        \"iconSource\": EIcons.FOLDER\n    }, {\n        \"index\": \"settings\",\n        \"text\": ELocale.texts.DemoSettings,\n        \"iconSource\": EIcons.GEAR\n    }]\n}\n"
            },
            {
                "name": "ESidebar",
                "title": "PrimeSidebarCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\n\nItem {\n    height: 60\n    width: 420\n\n    EButton {\n        text: \"Open navigation\"\n\n        onClicked: navigation.open = true\n    }\n    ESidebar {\n        id: navigation\n\n        open: false\n        mode: \"offcanvas\"\n        responsive: false\n        title: ELocale.texts.DemoWorkspace\n        model: [{index: \"home\", text: ELocale.texts.DemoHome, iconSource: EIcons.HOUSE}, {index: \"files\", text: ELocale.texts.DemoFiles, iconSource: EIcons.FOLDER}, {index: \"settings\", text: ELocale.texts.DemoSettings, iconSource: EIcons.GEAR}]\n    }\n}\n"
            }
        ]
    },
    "EChip": {
        "name": "EChip",
        "cases": [
            {
                "name": "EChip",
                "title": "PrimeChipCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nRow {\n    spacing: 12\n\n    EChip {\n        text: \"EUI\"\n    }\n}\n"
            },
            {
                "name": "EChip",
                "title": "PrimeChipCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nRow {\n    spacing: 12\n\n    EChip {\n        text: \"EUI\"\n        iconSource: EIcons.HOUSE\n    }\n}\n"
            },
            {
                "name": "EChip",
                "title": "PrimeChipCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nRow {\n    spacing: 12\n\n    EChip {\n        text: \"EUI\"\n        avatarSource: \"qrc:/example/images/gallery/avatar-01.jpg\"\n    }\n}\n"
            },
            {
                "name": "EChip",
                "title": "PrimeChipCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nRow {\n    spacing: 12\n\n    EChip {\n        text: \"EUI\"\n        closable: true\n\n        onClosed: visible = false\n    }\n}\n"
            },
            {
                "name": "EChip",
                "title": "PrimeChipCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nRow {\n    spacing: 12\n\n    EChip {\n        text: \"EUI\"\n        size: EStyle.Large\n        styleType: EStyle.Success\n    }\n}\n"
            }
        ]
    },
    "EDeferred": {
        "name": "EDeferred",
        "cases": [
            {
                "name": "EDeferred",
                "title": "PrimeDeferredCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoScrollDown\n            anchors.centerIn: parent\n        }\n    }\n    EDeferred {\n        y: 240\n        width: 300\n        height: 100\n\n        EText {\n            padding: 20\n            text: ELocale.texts.DemoLoadedInViewport\n        }\n    }\n}\n"
            },
            {
                "name": "EDeferred",
                "title": "PrimeDeferredCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoScrollDown\n            anchors.centerIn: parent\n        }\n    }\n    EDeferred {\n        y: 240\n        width: 300\n        height: 100\n        once: false\n\n        EText {\n            padding: 20\n            text: ELocale.texts.DemoLoadedInViewport\n        }\n    }\n}\n"
            },
            {
                "name": "EDeferred",
                "title": "PrimeDeferredCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoScrollDown\n            anchors.centerIn: parent\n        }\n    }\n    EDeferred {\n        y: 240\n        once: true\n        width: 300\n        height: 100\n\n        EText {\n            padding: 20\n            text: ELocale.texts.DemoLoadedInViewport\n        }\n    }\n}\n"
            },
            {
                "name": "EDeferred",
                "title": "PrimeDeferredCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoScrollDown\n            anchors.centerIn: parent\n        }\n    }\n    EDeferred {\n        y: 240\n        width: 300\n        height: 100\n        viewport: viewport\n\n        EText {\n            padding: 20\n            text: ELocale.texts.DemoLoadedInViewport\n        }\n    }\n}\n"
            },
            {
                "name": "EDeferred",
                "title": "PrimeDeferredCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoScrollDown\n            anchors.centerIn: parent\n        }\n    }\n    EDeferred {\n        y: 240\n        margin: 80\n        width: 300\n        height: 100\n\n        EText {\n            padding: 20\n            text: ELocale.texts.DemoLoadedInViewport\n        }\n    }\n}\n"
            }
        ]
    },
    "EAnimateOnScroll": {
        "name": "EAnimateOnScroll",
        "cases": [
            {
                "name": "EAnimateOnScroll",
                "title": "PrimeAnimateOnScrollCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: \"Scroll down ↓\"\n            anchors.centerIn: parent\n        }\n    }\n    EAnimateOnScroll {\n        y: 240\n        width: 300\n        height: 100\n\n        ERectangle {\n            radius: 8\n            height: 90\n            width: 280\n            color: \"#409eff\"\n\n            EText {\n                color: \"white\"\n                anchors.centerIn: parent\n                text: \"Scroll animation\"\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EAnimateOnScroll",
                "title": "PrimeAnimateOnScrollCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: \"Scroll down ↓\"\n            anchors.centerIn: parent\n        }\n    }\n    EAnimateOnScroll {\n        y: 240\n        width: 300\n        height: 100\n        once: false\n\n        ERectangle {\n            radius: 8\n            height: 90\n            width: 280\n            color: \"#409eff\"\n\n            EText {\n                color: \"white\"\n                anchors.centerIn: parent\n                text: \"Scroll animation\"\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EAnimateOnScroll",
                "title": "PrimeAnimateOnScrollCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: \"Scroll down ↓\"\n            anchors.centerIn: parent\n        }\n    }\n    EAnimateOnScroll {\n        y: 240\n        once: true\n        width: 300\n        height: 100\n\n        ERectangle {\n            radius: 8\n            height: 90\n            width: 280\n            color: \"#409eff\"\n\n            EText {\n                color: \"white\"\n                anchors.centerIn: parent\n                text: \"Scroll animation\"\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EAnimateOnScroll",
                "title": "PrimeAnimateOnScrollCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: \"Scroll down ↓\"\n            anchors.centerIn: parent\n        }\n    }\n    EAnimateOnScroll {\n        y: 240\n        width: 300\n        height: 100\n        viewport: viewport\n\n        ERectangle {\n            radius: 8\n            height: 90\n            width: 280\n            color: \"#409eff\"\n\n            EText {\n                color: \"white\"\n                anchors.centerIn: parent\n                text: \"Scroll animation\"\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EAnimateOnScroll",
                "title": "PrimeAnimateOnScrollCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nFlickable {\n    id: viewport\n\n    clip: true\n    width: 340\n    height: 180\n    contentHeight: 500\n\n    Rectangle {\n        y: 0\n        width: 320\n        height: 100\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: \"Scroll down ↓\"\n            anchors.centerIn: parent\n        }\n    }\n    EAnimateOnScroll {\n        y: 240\n        width: 300\n        height: 100\n        duration: 600\n        enterEffect: \"slideInUp\"\n\n        ERectangle {\n            radius: 8\n            height: 90\n            width: 280\n            color: \"#409eff\"\n\n            EText {\n                color: \"white\"\n                anchors.centerIn: parent\n                text: \"Scroll animation\"\n            }\n        }\n    }\n}\n"
            }
        ]
    },
    "ERipple": {
        "name": "ERipple",
        "cases": [
            {
                "name": "ERipple",
                "title": "PrimeRippleCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nERipple {\n    height: 80\n    width: 280\n\n    ERectangle {\n        radius: 8\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoClickAnywhere\n            anchors.centerIn: parent\n        }\n    }\n}\n"
            },
            {
                "name": "ERipple",
                "title": "PrimeRippleCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nERipple {\n    height: 80\n    width: 280\n    duration: 900\n\n    ERectangle {\n        radius: 8\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoClickAnywhere\n            anchors.centerIn: parent\n        }\n    }\n}\n"
            },
            {
                "name": "ERipple",
                "title": "PrimeRippleCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nERipple {\n    height: 80\n    width: 280\n    color: \"#67c23a\"\n\n    ERectangle {\n        radius: 8\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoClickAnywhere\n            anchors.centerIn: parent\n        }\n    }\n}\n"
            },
            {
                "name": "ERipple",
                "title": "PrimeRippleCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nERipple {\n    height: 48\n    width: 180\n\n    ERectangle {\n        radius: 8\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoClickAnywhere\n            anchors.centerIn: parent\n        }\n    }\n}\n"
            },
            {
                "name": "ERipple",
                "title": "PrimeRippleCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nERipple {\n    height: 80\n    width: 280\n    enabled: false\n\n    ERectangle {\n        radius: 8\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            text: ELocale.texts.DemoClickAnywhere\n            anchors.centerIn: parent\n        }\n    }\n}\n"
            }
        ]
    },
    "EFocusTrap": {
        "name": "EFocusTrap",
        "cases": [
            {
                "name": "EFocusTrap",
                "title": "PrimeFocusTrapCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFocusTrap {\n    width: 420\n    height: 110\n\n    Column {\n        spacing: 10\n\n        EText {\n            text: \"Tab / Shift+Tab\"\n        }\n        Row {\n            spacing: 10\n\n            EInput {\n                width: 180\n                placeholderText: ELocale.texts.DemoFocusHere\n            }\n            EButton {\n                text: ELocale.texts.Next\n            }\n            EButton {\n                text: ELocale.texts.DemoLast\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EFocusTrap",
                "title": "PrimeFocusTrapCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFocusTrap {\n    width: 420\n    height: 110\n\n    Column {\n        spacing: 10\n\n        EText {\n            text: \"Shift+Tab: move backwards\"\n        }\n        Row {\n            spacing: 10\n\n            EInput {\n                width: 180\n                placeholderText: ELocale.texts.DemoFocusHere\n            }\n            EButton {\n                text: \"Previous\"\n            }\n            EButton {\n                text: ELocale.texts.DemoLast\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EFocusTrap",
                "title": "PrimeFocusTrapCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFocusTrap {\n    width: 420\n    height: 110\n    active: false\n\n    Column {\n        spacing: 10\n\n        EText {\n            text: \"Tab / Shift+Tab\"\n        }\n        Row {\n            spacing: 10\n\n            EInput {\n                width: 180\n                placeholderText: ELocale.texts.DemoFocusHere\n            }\n            EButton {\n                text: ELocale.texts.Next\n            }\n            EButton {\n                text: ELocale.texts.DemoLast\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EFocusTrap",
                "title": "PrimeFocusTrapCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFocusTrap {\n    width: 420\n    height: 110\n    enabled: false\n\n    Column {\n        spacing: 10\n\n        EText {\n            text: \"Tab / Shift+Tab\"\n        }\n        Row {\n            spacing: 10\n\n            EInput {\n                width: 180\n                placeholderText: ELocale.texts.DemoFocusHere\n            }\n            EButton {\n                text: ELocale.texts.Next\n            }\n            EButton {\n                text: ELocale.texts.DemoLast\n            }\n        }\n    }\n}\n"
            },
            {
                "name": "EFocusTrap",
                "title": "PrimeFocusTrapCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\n\nColumn {\n    spacing: 16\n\n    EFocusTrap {\n        height: 50\n        width: 420\n\n        Row {\n            spacing: 12\n\n            EInput {\n                width: 180\n                placeholderText: \"First region\"\n            }\n            EButton { text: \"First region action\" }\n        }\n    }\n    EFocusTrap {\n        height: 50\n        width: 420\n\n        Row {\n            spacing: 12\n\n            EInput {\n                width: 180\n                placeholderText: \"Second region\"\n            }\n            EButton { text: \"Second region action\" }\n        }\n    }\n}\n"
            }
        ]
    },
    "EDialogService": {
        "name": "EDialogService",
        "cases": [
            {
                "name": "EDialogService",
                "title": "PrimeDialogServiceCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        }, {\n            \"title\": ELocale.texts.DemoServiceDialog,\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : ELocale.texts.DemoCancelled)\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDialogService",
                "title": "PrimeDialogServiceCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": \"Parameters: EUI\"\n        }, {\n            \"title\": ELocale.texts.DemoServiceDialog,\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : ELocale.texts.DemoCancelled)\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDialogService",
                "title": "PrimeDialogServiceCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        }, {\n            \"title\": ELocale.texts.DemoServiceDialog,\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : ELocale.texts.DemoCancelled)\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true, \"name\": \"EUI\", \"count\": 3\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDialogService",
                "title": "PrimeDialogServiceCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        }, {\n            \"title\": ELocale.texts.DemoServiceDialog,\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : ELocale.texts.DemoCancelled)\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: \"Cancel dialog\"\n\n                onClicked: parent.dialogRef.reject()\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDialogService",
                "title": "PrimeDialogServiceCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 520\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        }, {\n            \"title\": \"Multiple dialogs\", \"width\": 360,\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : ELocale.texts.DemoCancelled)\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            }
        ]
    },
    "EDynamicDialog": {
        "name": "EDynamicDialog",
        "cases": [
            {
                "name": "EDynamicDialog",
                "title": "PrimeDynamicDialogCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialog.openComponent(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        })\n    }\n    EDynamicDialog {\n        id: dialog\n\n        title: ELocale.texts.DemoDynamicDialog\n\n        onFinished: function(result, accepted) { sampleFeedback.open(accepted ? JSON.stringify(result) : ELocale.texts.DemoCancelled) }\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDynamicDialog",
                "title": "PrimeDynamicDialogCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialog.openComponent(content, {\n            \"greeting\": \"Parameters: EUI\"\n        })\n    }\n    EDynamicDialog {\n        id: dialog\n\n        title: ELocale.texts.DemoDynamicDialog\n\n        onFinished: function(result, accepted) { sampleFeedback.open(accepted ? JSON.stringify(result) : ELocale.texts.DemoCancelled) }\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDynamicDialog",
                "title": "PrimeDynamicDialogCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialog.openComponent(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        })\n    }\n    EDynamicDialog {\n        id: dialog\n\n        title: ELocale.texts.DemoDynamicDialog\n\n        onFinished: function(result, accepted) { sampleFeedback.open(accepted ? JSON.stringify(result) : ELocale.texts.DemoCancelled) }\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true, \"name\": \"EUI\", \"count\": 3\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDynamicDialog",
                "title": "PrimeDynamicDialogCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialog.openComponent(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        })\n    }\n    EDynamicDialog {\n        id: dialog\n\n        title: ELocale.texts.DemoDynamicDialog\n\n        onFinished: function(result, accepted) { sampleFeedback.open(accepted ? JSON.stringify(result) : ELocale.texts.DemoCancelled) }\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: \"Cancel dialog\"\n\n                onClicked: parent.dialogRef.reject()\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EDynamicDialog",
                "title": "PrimeDynamicDialogCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: ELocale.texts.OpenDialog\n\n        onClicked: dialog.openComponent(content, {\n            \"greeting\": ELocale.texts.PrimeDialogServiceCase1\n        })\n    }\n    EDynamicDialog {\n        id: dialog\n\n        destroyOnClose: false\n        title: ELocale.texts.DemoDynamicDialog\n\n        onFinished: function(result, accepted) { sampleFeedback.open(accepted ? JSON.stringify(result) : ELocale.texts.DemoCancelled) }\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: ELocale.texts.DemoGreeting\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: ELocale.texts.DemoReturnResult\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            }
        ]
    },
    "EScheduler": {
        "name": "EScheduler",
        "cases": [
            {
                "name": "EScheduler",
                "title": "PrimeSchedulerCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEScheduler {\n    height: 500\n    date: new Date(2026, 9, 15)\n    width: Math.min(860, parent.width)\n    events: [{\n        \"key\": \"design\",\n        \"title\": ELocale.texts.DemoDesignReview,\n        \"start\": new Date(2026, 9, 15, 9),\n        \"end\": new Date(2026, 9, 15, 10)\n    }, {\n        \"key\": \"release\",\n        \"title\": ELocale.texts.DemoRelease,\n        \"start\": new Date(2026, 9, 16),\n        \"end\": new Date(2026, 9, 18),\n        \"allDay\": true,\n        \"color\": \"#67c23a\"\n    }]\n}\n"
            },
            {
                "name": "EScheduler",
                "title": "PrimeSchedulerCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEScheduler {\n    height: 500\n    view: \"week\"\n    date: new Date(2026, 9, 15)\n    width: Math.min(860, parent.width)\n    events: [{\n        \"key\": \"design\",\n        \"title\": ELocale.texts.DemoDesignReview,\n        \"start\": new Date(2026, 9, 15, 9),\n        \"end\": new Date(2026, 9, 15, 10)\n    }, {\n        \"key\": \"release\",\n        \"title\": ELocale.texts.DemoRelease,\n        \"start\": new Date(2026, 9, 16),\n        \"end\": new Date(2026, 9, 18),\n        \"allDay\": true,\n        \"color\": \"#67c23a\"\n    }]\n}\n"
            },
            {
                "name": "EScheduler",
                "title": "PrimeSchedulerCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEScheduler {\n    height: 500\n    view: \"day\"\n    date: new Date(2026, 9, 15)\n    width: Math.min(860, parent.width)\n    events: [{\n        \"key\": \"design\",\n        \"title\": ELocale.texts.DemoDesignReview,\n        \"start\": new Date(2026, 9, 15, 9),\n        \"end\": new Date(2026, 9, 15, 10)\n    }, {\n        \"key\": \"release\",\n        \"title\": ELocale.texts.DemoRelease,\n        \"start\": new Date(2026, 9, 16),\n        \"end\": new Date(2026, 9, 18),\n        \"allDay\": true,\n        \"color\": \"#67c23a\"\n    }]\n}\n"
            },
            {
                "name": "EScheduler",
                "title": "PrimeSchedulerCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEScheduler {\n    height: 500\n    date: new Date(2026, 9, 15)\n    width: Math.min(860, parent.width)\n    events: [{\n        \"key\": \"design\",\n        \"title\": ELocale.texts.DemoDesignReview,\n        \"start\": new Date(2026, 9, 15, 9),\n        \"end\": new Date(2026, 9, 15, 10)\n    }, {\n        \"key\": \"release\",\n        \"title\": ELocale.texts.DemoRelease,\n        \"start\": new Date(2026, 9, 16),\n        \"end\": new Date(2026, 9, 18),\n        \"allDay\": true,\n        \"color\": \"#67c23a\"\n    }]\n\n    onEventClicked: function(event) { sampleFeedback.open(event.title) }\n    onSlotClicked: function(date) { sampleFeedback.open(Qt.formatDate(date, \"yyyy-MM-dd\")) }\n\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            },
            {
                "name": "EScheduler",
                "title": "PrimeSchedulerCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEScheduler {\n    height: 500\n    readOnly: true\n    date: new Date(2026, 9, 15)\n    width: Math.min(860, parent.width)\n    events: [{\n        \"key\": \"design\",\n        \"title\": ELocale.texts.DemoDesignReview,\n        \"start\": new Date(2026, 9, 15, 9),\n        \"end\": new Date(2026, 9, 15, 10)\n    }, {\n        \"key\": \"release\",\n        \"title\": ELocale.texts.DemoRelease,\n        \"start\": new Date(2026, 9, 16),\n        \"end\": new Date(2026, 9, 18),\n        \"allDay\": true,\n        \"color\": \"#67c23a\"\n    }]\n}\n"
            }
        ]
    },
    "ETaskBoard": {
        "name": "ETaskBoard",
        "cases": [
            {
                "name": "ETaskBoard",
                "title": "PrimeTaskBoardCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETaskBoard {\n    height: 310\n    width: Math.min(860, parent.width)\n    tasks: [{\n        \"key\": 1,\n        \"title\": ELocale.texts.TaskDesignComponents,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 2,\n        \"title\": ELocale.texts.TaskImplementInteractions,\n        \"status\": \"doing\"\n    }, {\n        \"key\": 3,\n        \"title\": ELocale.texts.TaskWriteTests,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 4,\n        \"title\": ELocale.texts.TaskDocumentApi,\n        \"status\": \"done\"\n    }]\n}\n"
            },
            {
                "name": "ETaskBoard",
                "title": "PrimeTaskBoardCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETaskBoard {\n    height: 310\n    filterable: true\n    width: Math.min(860, parent.width)\n    tasks: [{\n        \"key\": 1,\n        \"title\": ELocale.texts.TaskDesignComponents,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 2,\n        \"title\": ELocale.texts.TaskImplementInteractions,\n        \"status\": \"doing\"\n    }, {\n        \"key\": 3,\n        \"title\": ELocale.texts.TaskWriteTests,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 4,\n        \"title\": ELocale.texts.TaskDocumentApi,\n        \"status\": \"done\"\n    }]\n}\n"
            },
            {
                "name": "ETaskBoard",
                "title": "PrimeTaskBoardCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETaskBoard {\n    height: 310\n    width: Math.min(860, parent.width)\n    columns: [{\n        \"key\": \"todo\",\n        \"title\": ELocale.texts.TaskTodo\n    }, {\n        \"key\": \"doing\",\n        \"title\": ELocale.texts.TaskDoing,\n        \"limit\": 1\n    }, {\n        \"key\": \"done\",\n        \"title\": ELocale.texts.TaskDone\n    }]\n    tasks: [{\n        \"key\": 1,\n        \"title\": ELocale.texts.TaskDesignComponents,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 2,\n        \"title\": ELocale.texts.TaskImplementInteractions,\n        \"status\": \"doing\"\n    }, {\n        \"key\": 3,\n        \"title\": ELocale.texts.TaskWriteTests,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 4,\n        \"title\": ELocale.texts.TaskDocumentApi,\n        \"status\": \"done\"\n    }]\n}\n"
            },
            {
                "name": "ETaskBoard",
                "title": "PrimeTaskBoardCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETaskBoard {\n    height: 310\n    width: Math.min(860, parent.width)\n    cardDelegate: EText {\n        wrapMode: Text.Wrap\n        text: \"#\" + parent.taskData.key + \"  \" + parent.taskData.title\n    }\n    tasks: [{\n        \"key\": 1,\n        \"title\": ELocale.texts.TaskDesignComponents,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 2,\n        \"title\": ELocale.texts.TaskImplementInteractions,\n        \"status\": \"doing\"\n    }, {\n        \"key\": 3,\n        \"title\": ELocale.texts.TaskWriteTests,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 4,\n        \"title\": ELocale.texts.TaskDocumentApi,\n        \"status\": \"done\"\n    }]\n}\n"
            },
            {
                "name": "ETaskBoard",
                "title": "PrimeTaskBoardCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETaskBoard {\n    height: 310\n    readOnly: true\n    width: Math.min(860, parent.width)\n    tasks: [{\n        \"key\": 1,\n        \"title\": ELocale.texts.TaskDesignComponents,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 2,\n        \"title\": ELocale.texts.TaskImplementInteractions,\n        \"status\": \"doing\"\n    }, {\n        \"key\": 3,\n        \"title\": ELocale.texts.TaskWriteTests,\n        \"status\": \"todo\"\n    }, {\n        \"key\": 4,\n        \"title\": ELocale.texts.TaskDocumentApi,\n        \"status\": \"done\"\n    }]\n}\n"
            }
        ]
    },
    "ETextEditor": {
        "name": "ETextEditor",
        "cases": [
            {
                "name": "ETextEditor",
                "title": "PrimeTextEditorCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETextEditor {\n    height: 260\n    width: Math.min(650, parent.width)\n    text: ELocale.texts.DemoEditorDocument\n}\n"
            },
            {
                "name": "ETextEditor",
                "title": "PrimeTextEditorCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETextEditor {\n    height: 260\n    readOnly: true\n    width: Math.min(650, parent.width)\n    text: ELocale.texts.DemoEditorDocument\n}\n"
            },
            {
                "name": "ETextEditor",
                "title": "PrimeTextEditorCase3",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETextEditor {\n    height: 260\n    showToolbar: false\n    width: Math.min(650, parent.width)\n    text: ELocale.texts.DemoEditorDocument\n}\n"
            },
            {
                "name": "ETextEditor",
                "title": "PrimeTextEditorCase4",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETextEditor {\n    height: 260\n    width: Math.min(650, parent.width)\n    text: ELocale.texts.DemoEditorDocument\n\n    Component.onCompleted: {\n        editor.select(0, 3)\n        applyFormat(\"color\", \"#409eff\")\n    }\n}\n"
            },
            {
                "name": "ETextEditor",
                "title": "PrimeTextEditorCase5",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETextEditor {\n    text: \"\"\n    height: 260\n    placeholderText: \"Start writing…\"\n    width: Math.min(650, parent.width)\n}\n"
            }
        ]
    },
    "EInput": {
        "name": "EInput",
        "cases": [
            {
                "name": "EInput",
                "title": "PrimeInputCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInput {\n    width: 320\n    text: \"Eui2026!\"\n    showPassword: true\n    showPasswordStrength: true\n}\n"
            },
            {
                "name": "EInput",
                "title": "PrimeInputCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEInput {\n    width: 320\n    showPassword: true\n    showPasswordStrength: true\n    passwordRules: [{\n        \"label\": \"Minimum 12 characters\",\n        \"minLength\": 12\n    }, {\n        \"label\": \"At least one digit\",\n        \"pattern\": /[0-9]/\n    }]\n}\n"
            }
        ]
    },
    "ETransfer": {
        "name": "ETransfer",
        "cases": [
            {
                "name": "ETransfer",
                "title": "PrimeTransferCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETransfer {\n    value: [2, 3]\n    reorderable: true\n    width: Math.min(700, parent.width)\n    data: [{\n        \"key\": 1,\n        \"label\": \"Design\"\n    }, {\n        \"key\": 2,\n        \"label\": \"Develop\"\n    }, {\n        \"key\": 3,\n        \"label\": \"Review\"\n    }]\n}\n"
            },
            {
                "name": "ETransfer",
                "title": "PrimeTransferCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETransfer {\n    value: [3]\n    draggable: true\n    reorderable: true\n    width: Math.min(700, parent.width)\n    data: [{\n        \"key\": 1,\n        \"label\": \"Design\"\n    }, {\n        \"key\": 2,\n        \"label\": \"Develop\"\n    }, {\n        \"key\": 3,\n        \"label\": \"Review\"\n    }]\n}\n"
            }
        ]
    },
    "EDropdown": {
        "name": "EDropdown",
        "cases": [
            {
                "name": "EDropdown",
                "title": "PrimeDropdownCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEDropdown {\n    width: 420\n    height: 100\n    trigger: \"contextmenu\"\n    model: [{\n        \"label\": \"Copy\",\n        \"command\": \"copy\"\n    }, {\n        \"label\": \"Paste\",\n        \"command\": \"paste\"\n    }]\n\n    ERectangle {\n        anchors.fill: parent\n        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)\n\n        EText {\n            anchors.centerIn: parent\n            text: \"Right-click anywhere\"\n        }\n    }\n}\n"
            },
            {
                "name": "EDropdown",
                "title": "PrimeDropdownCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 60\n    width: 420\n\n    EButton {\n        text: \"Open at (120, 40)\"\n\n        onClicked: menu.openAt(120, 40)\n    }\n    EDropdown {\n        id: menu\n\n        model: [{\n            \"label\": \"Action\",\n            \"command\": \"action\"\n        }]\n    }\n}\n"
            }
        ]
    },
    "EImage": {
        "name": "EImage",
        "cases": [
            {
                "name": "EImage",
                "title": "PrimeImageCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEImage {\n    width: 260\n    height: 160\n    preview: true\n    showThumbnails: true\n    source: \"qrc:/example/images/gallery/lake.jpg\"\n    previewSrcList: [\"qrc:/example/images/gallery/lake.jpg\",\n        \"qrc:/example/images/gallery/neon-red.jpg\",\n        \"qrc:/example/images/gallery/neon-purple.jpg\",\n        \"qrc:/example/images/gallery/tree.jpg\",\n        \"qrc:/example/images/gallery/ocean.jpg\"]\n}\n"
            },
            {
                "name": "EImage",
                "title": "PrimeImageCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEImage {\n    width: 260\n    height: 160\n    preview: true\n    allowDownload: false\n    showThumbnails: true\n    source: \"qrc:/example/images/gallery/lake.jpg\"\n    previewSrcList: [\"qrc:/example/images/gallery/lake.jpg\",\n        \"qrc:/example/images/gallery/neon-red.jpg\",\n        \"qrc:/example/images/gallery/neon-purple.jpg\",\n        \"qrc:/example/images/gallery/tree.jpg\",\n        \"qrc:/example/images/gallery/ocean.jpg\"]\n}\n"
            }
        ]
    },
    "EImageViewer": {
        "name": "EImageViewer",
        "cases": [
            {
                "name": "EImageViewer",
                "title": "PrimeImageViewerCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEImage {\n    width: 260\n    height: 160\n    preview: true\n    showThumbnails: true\n    source: \"qrc:/example/images/gallery/lake.jpg\"\n    previewSrcList: [\"qrc:/example/images/gallery/lake.jpg\",\n        \"qrc:/example/images/gallery/neon-red.jpg\",\n        \"qrc:/example/images/gallery/neon-purple.jpg\",\n        \"qrc:/example/images/gallery/tree.jpg\",\n        \"qrc:/example/images/gallery/ocean.jpg\"]\n}\n"
            },
            {
                "name": "EImageViewer",
                "title": "PrimeImageViewerCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEImage {\n    width: 260\n    height: 160\n    preview: true\n    allowDownload: false\n    showThumbnails: true\n    source: \"qrc:/example/images/gallery/lake.jpg\"\n    previewSrcList: [\"qrc:/example/images/gallery/lake.jpg\",\n        \"qrc:/example/images/gallery/neon-red.jpg\",\n        \"qrc:/example/images/gallery/neon-purple.jpg\",\n        \"qrc:/example/images/gallery/tree.jpg\",\n        \"qrc:/example/images/gallery/ocean.jpg\"]\n}\n"
            }
        ]
    },
    "ETag": {
        "name": "ETag",
        "cases": [
            {
                "name": "ETag",
                "title": "PrimeTagCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETag {\n    text: \"EUI\"\n    iconSource: EIcons.HOUSE\n}\n"
            },
            {
                "name": "ETag",
                "title": "PrimeTagCase2",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nETag {\n    text: \"EUI\"\n    avatarSource: \"qrc:/example/images/gallery/avatar-02.jpg\"\n}\n"
            }
        ]
    },
    "EFormItem": {
        "name": "EFormItem",
        "cases": [
            {
                "name": "EFormItem",
                "title": "PrimeFormItemCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEFormItem {\n    width: 420\n    label: \"Account\"\n\n    EInput {\n        width: 280\n        placeholderText: \"Click Account to focus\"\n    }\n}\n"
            }
        ]
    },
    "EDialog": {
        "name": "EDialog",
        "cases": [
            {
                "name": "EDialog",
                "title": "PrimeDialogCase1",
                "code": "import EUI 1.0\nimport EUI 1.0\nimport QtQuick 2.15\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\nimport QtQuick.Controls 2.15\n\nItem {\n    height: 50\n    width: 420\n\n    EButton {\n        text: \"Open dialog\"\n\n        onClicked: dialogs.open(content, {\n            \"greeting\": \"Dynamic content\"\n        }, {\n            \"title\": \"Service dialog\",\n            \"onClose\": function(value, accepted) {\n                sampleFeedback.open(accepted ? JSON.stringify(value) : \"Cancelled\")\n            }\n        })\n    }\n    EDialogService {\n        id: dialogs\n    }\n    Component {\n        id: content\n\n        Column {\n            property var dialogRef\n            property string greeting: \"Hello\"\n\n            spacing: 12\n\n            EText {\n                text: parent.greeting\n            }\n            EButton {\n                text: \"Return result\"\n\n                onClicked: parent.dialogRef.resolve({\n                    \"saved\": true\n                })\n            }\n        }\n    }\n    EMessage {\n        id: sampleFeedback\n\n        type: EStyle.Info\n        objectName: \"sampleFeedback\"\n    }\n}\n"
            }
        ]
    },
    "EApp": {
        "name": "EApp",
        "cases": [
            {
                "name": "EApp",
                "title": "PrimeAppCase1",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Layouts 1.15\nimport QtQuick.Controls 2.15\n\nEApp {\n    id: app\n\n    height: 60\n    width: 420\n\n    EButton {\n        text: \"Open from app\"\n\n        onClicked: app.dialog.open(content, {\n            \"greeting\": \"Application context\"\n        }, {\n            \"title\": \"Dialog\"\n        })\n    }\n    Component {\n        id: content\n\n        EText {\n            property var dialogRef\n            property string greeting\n\n            height: 80\n            text: greeting\n        }\n    }\n}\n"
            }
        ]
    }
}
