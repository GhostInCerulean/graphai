import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App

ApplicationWindow {
    title: "Graphai"
    id: root
    required property BibleViewModel bible
    visible: true; width: 800; height: 600
    color: palette.window

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {                      // top bar
            Layout.fillWidth: true
            spacing: 8

            ComboBox {                   // book picker
                Layout.preferredWidth: 200
                model: root.bible.books
                textRole: "bookName"
                currentIndex: root.bible.bookIndex
                onActivated: (index) => root.bible.bookIndex = index
            }

            ComboBox {                   // chapter picker
                Layout.preferredWidth: 90
                model: root.bible.chapterCount          // integer model: 0..n-1
                currentIndex: root.bible.chapterIndex
                displayText: currentIndex + 1           // show 1-based
                delegate: ItemDelegate {
                    required property int index
                    width: ListView.view ? ListView.view.width : implicitWidth
                    text: index + 1
                    highlighted: index === root.bible.chapterIndex
                }
                onActivated: (index) => root.bible.chapterIndex = index
            }

            TextField {                  // prompt, e.g. "john 2"
                id: prompt
                Layout.fillWidth: true
                placeholderText: "Go to… (e.g. john 2)"
                onAccepted: {
                    // TODO: parse prompt.text into book + chapter
                }
            }
        }

        ListView {
            id: verseList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.bible.verses
            clip: true
            spacing: 10
            topMargin: 12
            bottomMargin: 24
            boundsBehavior: Flickable.DragOverBounds
            ScrollBar.vertical: ScrollBar {}

            readonly property real pullThreshold: 80
            property real wheelAccum: 0

            // touch / mouse drag: decide when the drag is released
            onDragEnded: {
                if (contentY < originY - pullThreshold)
                    root.goPrev()
                else if (contentY > originY + contentHeight - height + pullThreshold)
                    root.goNext()
            }

            // mouse wheel / touchpad: count scrolling that happens while already at an edge
            WheelHandler {
                blocking: false
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (event) => {
                    const atTop = verseList.atYBeginning && event.angleDelta.y > 0
                    const atBottom = verseList.atYEnd && event.angleDelta.y < 0
                    if (!atTop && !atBottom) { verseList.wheelAccum = 0; return }

                    verseList.wheelAccum += Math.abs(event.angleDelta.y)
                    resetTimer.restart()
                    if (verseList.wheelAccum >= 360) {          // ~3 wheel notches
                        verseList.wheelAccum = 0
                        atTop ? root.goPrev() : root.goNext()
                    }
                }
            }
            Timer { id: resetTimer; interval: 400; onTriggered: verseList.wheelAccum = 0 }

            delegate: Item {
                id: verse
                required property int verseNumber
                required property string verseText

                width: ListView.view.width
                height: row.implicitHeight

                RowLayout {
                    id: row
                    width: Math.min(verse.width - 32, 640)   // readable line length
                    x: (verse.width - width) / 2             // centered column
                    spacing: 12

                    Label {                                  // verse number
                        Layout.preferredWidth: 28
                        Layout.alignment: Qt.AlignTop
                        topPadding: 4
                        horizontalAlignment: Text.AlignRight
                        text: verse.verseNumber
                        font.pixelSize: 12
                        font.bold: true
                        color: Qt.alpha(palette.windowText, 0.45)
                    }

                    Label {                                  // verse text
                        Layout.fillWidth: true
                        text: verse.verseText
                        wrapMode: Text.Wrap
                        font.pixelSize: 17
                        lineHeight: 1.35
                    }
                }
            }
        }
    }

    function goNext() {
        if (bible.chapterIndex + 1 < bible.chapterCount) {
            bible.chapterIndex++
        } else if (bible.bookIndex + 1 < bible.bookCount) {   // assumed property
            bible.bookIndex++
            bible.chapterIndex = 0
        } else return
        Qt.callLater(() => verseList.positionViewAtBeginning())
    }

    function goPrev() {
        if (bible.chapterIndex > 0) {
            bible.chapterIndex--
        } else if (bible.bookIndex > 0) {
            bible.bookIndex--
            Qt.callLater(() => bible.chapterIndex = bible.chapterCount - 1)
        } else return
        Qt.callLater(() => verseList.positionViewAtEnd())
    }
}