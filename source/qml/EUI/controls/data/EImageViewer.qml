import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

EImage {
    id: control

    property alias urlList: control.previewSrcList

    function openWhenReady() {
        if (visible && status === Image.Ready)
            openPreview(initialIndex)
    }

    width: 0
    height: 0
    preview: true
    source: EDataUtils.isArray(previewSrcList) && previewSrcList.length > 0
        ? previewSrcList[Math.max(0, Math.min(previewSrcList.length - 1, initialIndex))] : ""

    onLoaded: Qt.callLater(openWhenReady)
    Component.onCompleted: Qt.callLater(openWhenReady)
    onVisibleChanged: {
        if (visible && status === Image.Ready)
            openPreview(initialIndex)
        else if (!visible)
            closePreview()
    }
}
