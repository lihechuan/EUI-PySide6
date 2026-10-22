import EUI 1.0
import QtQuick 2.15

Item {
    id: control
    default property alias content: configuration.data

    property alias size: configuration.size
    property alias locale: configuration.locale
    property alias disabled: configuration.disabled
    property alias dialogConfig: configuration.dialog
    property alias messageConfig: configuration.message

    readonly property bool euiApp: true
    readonly property alias modal: modalManager
    readonly property alias dialog: dialogManager
    readonly property alias message: messageManager
    readonly property alias notification: notificationManager

    function useApp() {
        return {
            "dialog": dialogManager,
            "message": messageManager,
            "modal": modalManager,
            "notification": notificationManager
        }
    }

    enabled: !disabled
    implicitWidth: configuration.childrenRect.width
    implicitHeight: configuration.childrenRect.height

    EConfigProvider {
        id: configuration

        anchors.fill: parent

        EMessage {
            id: messageManager
        }
        ENotification {
            id: notificationManager
        }
        EMessageBox {
            id: modalManager
        }
        EDialogService {
            id: dialogManager
        }
    }
}
