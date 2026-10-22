import EUI 1.0
import QtQuick

EApplicationWindow {
    width: 640
    height: 420
    visible: true
    title: "我的 EUI 应用"

    Column {
        spacing: 16
        anchors.centerIn: parent

        EText {
            id: greeting

            text: "欢迎使用 EUI"
        }
        EInput {
            id: nameInput

            width: 260
            placeholderText: "请输入姓名"
        }
        EButton {
            text: "打招呼"
            styleType: EStyle.Primary

            onClicked: greeting.text = "你好，" + (nameInput.text || "访客")
        }
    }
}
