import EUI 1.0
import "PrimeSamples.js" as Samples
import QtQuick 2.15

Column {
    id: control

    property var names: []

    readonly property var definitions: {
        ELocale.texts
        return names.map(function(name) { return Samples.definitions[name] })
    }

    spacing: 24
    width: parent ? parent.width : 0

    Repeater {
        model: control.definitions

        ExampleSection {
            id: section

            property var definition: modelData

            componentName: definition.name
            exampleCount: definition.cases.length

            Column {
                readonly property bool hasSource: true

                spacing: 24
                width: parent ? parent.width : 0

                Repeater {
                    model: section.definition.cases

                    ExampleCase {
                        id: scenario

                        property var sample: null
                        property var definition: modelData

                        code: definition.code
                        title: ELocale.texts[definition.title]
                        objectName: "showcase" + section.componentName + index

                        Item {
                            id: preview

                            width: parent.width
                            implicitHeight: scenario.sample ? Math.max(48, scenario.sample.height) : 160

                            Component.onCompleted: scenario.sample = Qt.createQmlObject(scenario.code, preview, scenario.objectName)
                        }
                    }
                }
            }
        }
    }
}
