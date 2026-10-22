import EUI 1.0
import QtQuick 2.15

EText {
    id: control

    property int iconSource
    property int iconSize: 20

    font.family: EDefaultConfig.font
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: Math.max(1, iconSize)
    horizontalAlignment: Text.AlignHCenter
    color: EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark)
    width: Math.max(implicitWidth, graphic.visible ? graphic.width + leftPadding + rightPadding : 0)
    height: Math.max(implicitHeight, graphic.visible ? graphic.height + topPadding + bottomPadding : 0)
    text: graphic.source.toString().length > 0 ? " "
        : iconSize > 0 ? String.fromCharCode(iconSource) : ""

    FontLoader {
        source: Qt.resolvedUrl(EDefaultConfig.fontLib)
    }
    Image {
        id: graphic

        height: width
        objectName: "eIconGraphic"
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(width, height)
        width: Math.max(0, control.iconSize)
        source: EDefaultConfig.iconGraphic(control.iconSource)
        visible: source.toString().length > 0 && control.text === " "
        y: control.verticalAlignment === Text.AlignTop ? control.topPadding
            : control.verticalAlignment === Text.AlignBottom ? control.height - control.bottomPadding - height
            : control.topPadding + (control.height - control.topPadding - control.bottomPadding - height) / 2
        x: control.horizontalAlignment === Text.AlignLeft ? control.leftPadding
            : control.horizontalAlignment === Text.AlignRight ? control.width - control.rightPadding - width
            : control.leftPadding + (control.width - control.leftPadding - control.rightPadding - width) / 2
    }
    EText {
        font: control.font
        anchors.fill: parent
        color: control.color
        style: control.style
        objectName: "eIconDotLayer"
        renderType: control.renderType
        styleColor: control.styleColor
        topPadding: control.topPadding
        leftPadding: control.leftPadding
        rightPadding: control.rightPadding
        bottomPadding: control.bottomPadding
        verticalAlignment: control.verticalAlignment
        horizontalAlignment: control.horizontalAlignment
        text: visible ? String.fromCharCode(control.iconSource + 1) : ""
        visible: control.iconSize > 0 && control.text === String.fromCharCode(control.iconSource)
            && (control.iconSource === EIcons.BELL_DOT
                || control.iconSource === EIcons.CIRCLE_QUESTION_DOT
                || control.iconSource === EIcons.GEAR_DOT)
    }
}
