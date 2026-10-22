import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias actions: actionRow.data

    property int iconSource: 0
    property bool showClose: true
    property bool showMaximize: true
    property bool showMinimize: true
    property color textColor: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
    property string title: control.Window.window ? control.Window.window.title : ""
    property color backgroundColor: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

    readonly property bool macOS: Qt.platform.os === "osx"
    readonly property color buttonHoverColor: ETheme.dark ? "#414145" : "#D8D8DE"
    readonly property color buttonPressedColor: ETheme.dark ? "#55555B" : "#C2C2CA"

    signal closeRequested()

    topPadding: 0
    bottomPadding: 0
    implicitHeight: 40
    background: Rectangle {
        color: control.backgroundColor
    }
    leftPadding: control.macOS ? windowButtons.width + 16 : 16
    rightPadding: actionRow.width + (control.macOS ? 16 : windowButtons.width + 12)
    contentItem: Item {
        EIcon {
            id: titleIcon

            width: 18
            height: 18
            iconSize: 16
            color: control.textColor
            iconSource: control.iconSource
            visible: !control.macOS && control.iconSource > 0
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        }
        EText {
            font.pixelSize: 13
            text: control.title
            elide: Text.ElideRight
            color: control.textColor
            objectName: "eAppBarTitle"
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            horizontalAlignment: control.macOS ? Text.AlignHCenter : Text.AlignLeft
            x: control.macOS ? (control.width - width) / 2 - control.leftPadding
                : (titleIcon.visible ? titleIcon.width + 10 : 0)
            width: control.macOS
                ? Math.max(0, control.width - 2 * Math.max(control.leftPadding, control.rightPadding))
                : Math.max(0, parent.width - x)
        }
    }

    MouseArea {
        height: control.height
        objectName: "eAppBarDragArea"
        acceptedButtons: Qt.LeftButton
        x: control.macOS ? control.leftPadding : 0
        width: Math.max(0, control.width - x - control.rightPadding)

        onPressed: windowActions.move(control)
        onDoubleClicked: {
            if (control.showMaximize)
                windowActions.toggleMaximized(control)
        }
    }
    Row {
        id: actionRow

        spacing: 12
        objectName: "eAppBarActions"
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        x: control.width - width - (control.macOS ? 16 : windowButtons.width + 12)
    }
    Item {
        id: windowButtons

        height: control.height
        objectName: "eAppBarWindowButtons"
        x: control.macOS ? 8 : control.width - width
        width: (closeButton.visible ? closeButton.width : 0)
            + (minimizeButton.visible ? minimizeButton.width : 0)
            + (maximizeButton.visible ? maximizeButton.width : 0)

        ETextButton {
            id: closeButton

            text: ""
            padding: 0
            height: control.height
            iconSource: EIcons.XMARK
            styleType: EStyle.Danger
            visible: control.showClose
            width: control.macOS ? 28 : 44
            objectName: "eAppBarCloseButton"
            accessibleName: EControlConfig.textFor(control, "Close", ELocale.texts)
            x: control.macOS ? 0 : (minimizeButton.visible ? minimizeButton.width : 0)
                + (maximizeButton.visible ? maximizeButton.width : 0)
            contentItem: EIcon {
                iconSize: control.macOS ? 8 : 12
                iconSource: closeButton.iconSource
                visible: !control.macOS || closeButton.hovered
                color: control.macOS ? "#6B2420" : (closeButton.hovered ? "white" : control.textColor)
            }
            background: Rectangle {
                anchors.centerIn: parent
                radius: control.macOS ? 6 : 0
                width: control.macOS ? 12 : closeButton.width
                height: control.macOS ? 12 : closeButton.height
                color: control.macOS ? "#FF5F57" : (closeButton.pressed ? "#991B1B"
                    : (closeButton.hovered ? "#C42B1C" : "transparent"))
            }

            onClicked: {
                control.closeRequested()
                windowActions.close(control)
            }
        }
        ETextButton {
            id: minimizeButton

            text: ""
            padding: 0
            height: control.height
            iconSource: EIcons.MINUS
            visible: control.showMinimize
            width: control.macOS ? 28 : 44
            objectName: "eAppBarMinimizeButton"
            x: control.macOS && closeButton.visible ? closeButton.width : 0
            accessibleName: EControlConfig.textFor(control, "Minimize", ELocale.texts)
            contentItem: EIcon {
                iconSize: control.macOS ? 8 : 12
                iconSource: minimizeButton.iconSource
                visible: !control.macOS || minimizeButton.hovered
                color: control.macOS ? "#725019" : control.textColor
            }
            background: Rectangle {
                anchors.centerIn: parent
                radius: control.macOS ? 6 : 0
                width: control.macOS ? 12 : minimizeButton.width
                height: control.macOS ? 12 : minimizeButton.height
                color: control.macOS ? "#FEBC2E" : (minimizeButton.pressed
                    ? control.buttonPressedColor
                    : (minimizeButton.hovered ? control.buttonHoverColor
                        : "transparent"))
            }

            onClicked: windowActions.minimize(control)
        }
        ETextButton {
            id: maximizeButton

            text: ""
            padding: 0
            height: control.height
            visible: control.showMaximize
            width: control.macOS ? 28 : 44
            objectName: "eAppBarMaximizeButton"
            x: (minimizeButton.visible ? minimizeButton.width : 0)
                + (control.macOS && closeButton.visible ? closeButton.width : 0)
            iconSource: control.macOS ? EIcons.CHEVRONS_EXPAND_UP_RIGHT
                : (control.Window.window && control.Window.window.visibility === Window.Maximized
                    ? EIcons.COPY : EIcons.SQUARE)
            contentItem: EIcon {
                iconSize: control.macOS ? 8 : 12
                iconSource: maximizeButton.iconSource
                visible: !control.macOS || maximizeButton.hovered
                color: control.macOS ? "#1B6328" : control.textColor
            }
            background: Rectangle {
                anchors.centerIn: parent
                radius: control.macOS ? 6 : 0
                width: control.macOS ? 12 : maximizeButton.width
                height: control.macOS ? 12 : maximizeButton.height
                color: control.macOS ? "#28C840" : (maximizeButton.pressed
                    ? control.buttonPressedColor
                    : (maximizeButton.hovered ? control.buttonHoverColor
                        : "transparent"))
            }
            accessibleName: control.Window.window
                && (control.Window.window.visibility === Window.Maximized
                    || control.Window.window.visibility === Window.FullScreen)
                ? EControlConfig.textFor(control, "Restore", ELocale.texts)
                : (control.macOS ? EControlConfig.textFor(control, "FullScreen", ELocale.texts)
                    : EControlConfig.textFor(control, "Maximize", ELocale.texts))

            onClicked: {
                if (control.macOS)
                    windowActions.toggleFullScreen(control)
                else
                    windowActions.toggleMaximized(control)
            }
        }
    }
    WindowActions {
        id: windowActions
    }
}
