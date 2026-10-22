import EUI 1.0
import QtQuick 2.15

EText {
    property int level: 0

    font.bold: level > 0
    wrapMode: Text.WordWrap
    font.pixelSize: level > 0 ? Math.max(16, 36 - Math.min(6, level) * 4) : 14
}
