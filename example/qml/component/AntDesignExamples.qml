import EUI 1.0
import "AntDesignSamples.js" as Samples
import QtQuick 2.15

ExamplePage {
    id: page

    title: ELocale.texts.CoreExamples
    description: ELocale.texts.CoreExamplesDescription

    Repeater {
        model: ["EApp", "EBorderBeam", "EFlex", "EFlexItem", "EFloatButton", "EFloatButtonGroup", "EList", "EListItem", "EListy"]

        ExampleSection {
            id: section

            componentName: modelData
            exampleCount: (Samples.examples[componentName] || []).length

            ExampleCard {
                Repeater {
                    model: Samples.examples[section.componentName] || []

                    ExampleSection {
                        componentName: section.componentName

                        ExampleCase {
                            code: modelData.code
                            title: ELocale.texts[modelData.title]
                            description: ELocale.texts[modelData.description]
                            objectName: "showcase" + section.componentName + index

                            Item {
                                id: preview

                                property Item sample: null

                                function createSample() {
                                    if (sample)
                                        sample.destroy()

                                    sample = Qt.createQmlObject(modelData.code, preview, "coreSample")
                                    sample.width = Qt.binding(function() {
                                        return preview.width
                                    })
                                    if (page)
                                        Qt.callLater(page.updateExampleCount)
                                }

                                width: parent.width
                                implicitHeight: sample ? Math.max(80, sample.height) : 80

                                Component.onCompleted: createSample()
                            }
                        }
                    }
                }
            }
        }
    }
    PrimeShowcase { names: ["EApp"] }
}
