import EUI 1.0
import QtQuick

EApplicationWindow {
    id: window

    property int clickCount: 0

    readonly property bool english: ELocale.language === "en"

    width: 640
    height: 420
    visible: true
    title: "EUI Demo"

    EApp {
        id: app

        anchors.fill: parent

        Column {
            x: 24
            y: 24
            spacing: 16

            EText {
                text: (window.english ? "Clicks: " : "点击次数：") + window.clickCount
            }
            EButton {
                objectName: "addOneButton"
                text: window.english ? "Add one" : "加一"
                styleType: EStyle.Primary

                onClicked: {
                    window.clickCount += 1
                    app.message.open(window.english ? "Clicked " + window.clickCount + " times"
                        : "已点击 " + window.clickCount + " 次")
                }
            }
        }
    }
}
