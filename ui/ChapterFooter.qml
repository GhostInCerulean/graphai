import QtQuick
import QtQuick.Controls.Basic

// End-of-chapter mark with the pull-up hint (next chapter)
Control {
    id: root
    required property real pullBottom
    required property real pullThreshold

    width: ListView.view.width
    height: 96

    Rectangle {                                 // end-of-chapter mark
        anchors.horizontalCenter: parent.horizontalCenter
        y: 20
        width: 32; height: 1
        color: root.palette.mid
    }
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 36
        text: root.pullBottom > root.pullThreshold ? "Release for next chapter"
            : "Keep scrolling for next chapter"
        font.pixelSize: 12
        color: root.pullBottom > root.pullThreshold ? root.palette.highlight
            : root.palette.placeholderText
    }
}
