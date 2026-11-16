import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Chapter title shown at the top of the reading list, with the pull-down hint
Control {
    id: root
    required property string bookName
    required property int chapter              // 1-based
    required property string serif
    required property real pullTop
    required property real pullThreshold

    width: ListView.view.width
    height: title.implicitHeight + 72

    Label {                                     // pull-down hint (previous chapter)
        anchors.horizontalCenter: parent.horizontalCenter
        y: 14
        text: root.pullTop > root.pullThreshold ? "Release for previous chapter"
            : "Pull down for previous chapter"
        font.pixelSize: 12
        color: root.pullTop > root.pullThreshold ? root.palette.highlight
            : root.palette.placeholderText
        opacity: Math.min(1, root.pullTop / 30)
    }

    ColumnLayout {
        id: title
        width: Math.min(parent.width - 48, 640)
        x: (parent.width - width) / 2
        y: 36
        spacing: 0

        Label {
            text: root.bookName
            font.family: root.serif
            font.pixelSize: 40
            font.weight: Font.DemiBold
            color: root.palette.windowText
        }
        Label {
            text: "Chapter " + root.chapter
            font.pixelSize: 15
            color: root.palette.highlight
            topPadding: 2
        }
    }
}
