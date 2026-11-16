import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// One verse row: number + text, selection highlight, and click handling.
// It only reports what happened; the selection rules live in VerseSelection.
Control {
    id: root
    required property int verseNumber
    required property string verseText
    required property string serif
    property bool selected: false

    signal plainClicked()
    signal shiftClicked()
    signal ctrlClicked()
    signal contextRequested()

    width: ListView.view.width
    height: row.implicitHeight

    Rectangle {                                  // selection highlight
        anchors.fill: row
        anchors.margins: -7
        radius: 8
        color: Qt.alpha(root.palette.highlight, 0.14)
        visible: root.selected
    }

    RowLayout {
        id: row
        width: Math.min(root.width - 48, 640)    // readable line length
        x: (root.width - width) / 2              // centered column
        spacing: 14

        Label {                                  // verse number
            Layout.preferredWidth: 26
            Layout.alignment: Qt.AlignTop
            topPadding: 7
            horizontalAlignment: Text.AlignRight
            text: root.verseNumber
            font.pixelSize: 11
            font.weight: Font.Medium
            font.features: { "tnum": 1 }         // tabular figures keep the column aligned
            color: root.palette.highlight
            opacity: 0.8
        }

        Label {                                  // verse text
            Layout.fillWidth: true
            text: root.verseText
            wrapMode: Text.Wrap
            font.family: root.serif
            font.pixelSize: 19
            lineHeight: 1.5
            color: root.palette.windowText
            textFormat: Text.PlainText
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        acceptedModifiers: Qt.NoModifier
        onTapped: root.plainClicked()
    }
    TapHandler {
        acceptedButtons: Qt.LeftButton
        acceptedModifiers: Qt.ShiftModifier
        onTapped: root.shiftClicked()
    }
    TapHandler {
        acceptedButtons: Qt.LeftButton
        acceptedModifiers: Qt.ControlModifier
        onTapped: root.ctrlClicked()
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: root.contextRequested()
    }
}
