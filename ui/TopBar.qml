import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import App

// Burger menu, book / chapter pickers and the reference bar ("john 2")
Pane {
    id: root
    required property BibleViewModel bible

    readonly property string bookName: bookBox.currentText
    signal referenceSubmitted(string text)

    topPadding: 12; bottomPadding: 12
    leftPadding: 16; rightPadding: 16

    background: Rectangle {
        color: root.palette.window
        Rectangle {                              // hairline
            anchors.bottom: parent.bottom
            width: parent.width; height: 1
            color: root.palette.mid
        }
    }

    contentItem: RowLayout {
        spacing: 8

        BurgerButton {
            id: burger
            onClicked: mainMenu.popup(burger, 0, burger.height + 6)
        }

        PillCombo {                              // book picker
            id: bookBox
            Layout.preferredWidth: 190
            model: root.bible.books
            textRole: "bookName"
            currentIndex: root.bible.bookIndex
            onActivated: (index) => root.bible.bookIndex = index
        }

        PillCombo {                              // chapter picker
            Layout.preferredWidth: 84
            oneBased: true
            model: root.bible.chapterCount
            currentIndex: root.bible.chapterIndex
            onActivated: (index) => root.bible.chapterIndex = index
        }

        PillField {                              // reference bar: takes all remaining width
            Layout.fillWidth: true
            Layout.minimumWidth: 80
            placeholderText: "Go to..."
            onAccepted: root.referenceSubmitted(text)
        }
    }

    MainMenu { id: mainMenu }
}
