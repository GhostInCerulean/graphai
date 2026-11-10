import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App

ApplicationWindow {
    id: root
    required property BibleViewModel bible
    visible: true; width: 800; height: 600

    RowLayout {
        anchors.fill: parent

        ListView {                       // books
            Layout.preferredWidth: 180
            Layout.fillHeight: true
            model: root.bible.books
            clip: true
            delegate: ItemDelegate {
                required property int index
                required property string bookName
                width: ListView.view.width
                text: bookName
                highlighted: index === root.bible.bookIndex
                onClicked: root.bible.bookIndex = index
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            SpinBox {                    // chapter picker
                from: 1
                to: root.bible.chapterCount
                value: root.bible.chapterIndex + 1
                onValueModified: root.bible.chapterIndex = value - 1
            }

            ListView {                   // verses
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: root.bible.verses
                clip: true
                delegate: Text {
                    required property int verseNumber
                    required property string verseText
                    width: ListView.view.width
                    wrapMode: Text.Wrap
                    text: verseNumber + "  " + verseText
                }
            }
        }
    }
}