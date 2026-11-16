import QtQuick
import QtQuick.Controls.Basic   // Basic style: the only built-in one that fully supports custom backgrounds
import QtQuick.Layouts
import App

ApplicationWindow {
    id: root
    title: "Graphai"
    required property BibleViewModel bible
    visible: true; width: 860; height: 640
    minimumWidth: 420; minimumHeight: 360

    // ── Theme ────────────────────────────────────────────────────────────
    // Colors come straight from the operating system's palette, so light/dark mode
    // and the accent color are followed live. The Basic style ignores the system
    // theme by itself, which is why we feed it the platform palette here.
    SystemPalette { id: sys; colorGroup: SystemPalette.Active }

    // First installed serif from the list (font.families isn't available in every Qt 6 build)
    readonly property string serif: {
        const installed = Qt.fontFamilies()
        for (const f of ["Source Serif 4", "Charter", "Georgia", "Noto Serif", "Palatino Linotype", "Times New Roman"])
            if (installed.indexOf(f) !== -1) return f
        return ""    // empty = application default font
    }

    palette.window:          sys.window
    palette.windowText:      sys.windowText
    palette.base:            sys.base
    palette.text:            sys.text
    palette.button:          sys.base
    palette.buttonText:      sys.buttonText
    palette.mid:             Qt.tint(sys.window, Qt.alpha(sys.windowText, 0.16))   // hairlines
    palette.highlight:       sys.highlight                                          // system accent
    palette.highlightedText: sys.highlightedText
    palette.placeholderText: Qt.alpha(sys.windowText, 0.5)

    color: palette.window

    // ── Reusable pill-style combo box ────────────────────────────────────
    component PillCombo: ComboBox {
        id: control
        property bool oneBased: false           // for integer models (chapters)
        implicitHeight: 36
        font.pixelSize: 14
        displayText: oneBased ? currentIndex + 1 : currentText

        background: Rectangle {
            radius: height / 2
            color: control.palette.base
            border.width: 1
            border.color: control.activeFocus || control.popup.visible
                ? control.palette.highlight : control.palette.mid
        }

        contentItem: Text {
            leftPadding: 16
            rightPadding: 30
            text: control.displayText
            font: control.font
            color: control.palette.text
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        indicator: Canvas {                      // small chevron
            x: control.width - width - 14
            y: (control.height - height) / 2
            width: 10; height: 6
            onPaint: {
                const c = getContext("2d")
                c.reset()
                c.strokeStyle = control.palette.placeholderText
                c.lineWidth = 1.5
                c.lineCap = "round"; c.lineJoin = "round"
                c.beginPath()
                c.moveTo(1, 1); c.lineTo(width / 2, height - 1); c.lineTo(width - 1, 1)
                c.stroke()
            }
        }

        delegate: ItemDelegate {
            id: item
            required property int index
            required property var model
            width: ListView.view ? ListView.view.width : implicitWidth
            height: 34
            highlighted: control.highlightedIndex === index
            contentItem: Text {
                text: control.oneBased ? item.index + 1
                    : (control.textRole ? item.model[control.textRole] : item.model.modelData)
                font: control.font
                color: item.index === control.currentIndex ? control.palette.highlight
                    : control.palette.text
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                radius: 6
                color: item.highlighted ? Qt.alpha(control.palette.highlight, 0.12) : "transparent"
            }
        }

        popup: Popup {
            y: control.height + 6
            width: Math.max(control.width, 140)
            height: Math.min(contentItem.implicitHeight + 12, 360)
            padding: 6
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null
                currentIndex: control.highlightedIndex
                ScrollBar.vertical: ScrollBar {}
            }
            background: Rectangle {
                radius: 12
                color: control.palette.base
                border.width: 1
                border.color: control.palette.mid
            }
        }
    }

    // ── Layout ───────────────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top bar
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: bar.implicitHeight + 24
            color: root.palette.window

            RowLayout {
                id: bar
                anchors.fill: parent
                anchors.leftMargin: 16; anchors.rightMargin: 16
                anchors.topMargin: 12; anchors.bottomMargin: 12
                spacing: 8

                PillCombo {                      // book picker
                    id: bookBox
                    Layout.preferredWidth: 190
                    model: root.bible.books
                    textRole: "bookName"
                    currentIndex: root.bible.bookIndex
                    onActivated: (index) => root.bible.bookIndex = index
                }

                PillCombo {                      // chapter picker
                    id: chapterBox
                    Layout.preferredWidth: 84
                    oneBased: true
                    model: root.bible.chapterCount
                    currentIndex: root.bible.chapterIndex
                    onActivated: (index) => root.bible.chapterIndex = index
                }

                Item { Layout.fillWidth: true; Layout.minimumWidth: 8 }

                TextField {                      // prompt, e.g. "john 2"
                    id: prompt
                    Layout.preferredWidth: 260
                    Layout.maximumWidth: 320
                    implicitHeight: 36
                    leftPadding: 16; rightPadding: 16
                    placeholderText: "Go to… (e.g. john 2)"
                    font.pixelSize: 14
                    color: palette.text
                    selectByMouse: true
                    background: Rectangle {
                        radius: height / 2
                        color: "transparent"
                        border.width: 1
                        border.color: prompt.activeFocus ? palette.highlight : palette.mid
                    }
                    onAccepted: {
                        // TODO: parse prompt.text into book + chapter
                    }
                }
            }

            Rectangle {                          // hairline
                anchors.bottom: parent.bottom
                width: parent.width; height: 1
                color: root.palette.mid
            }
        }

        // Reading area
        ListView {
            id: verseList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.bible.verses
            clip: true
            spacing: 14
            topMargin: 8
            bottomMargin: 8
            boundsBehavior: Flickable.DragOverBounds
            reuseItems: true

            ScrollBar.vertical: ScrollBar {
                implicitWidth: 8
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: 2
                    color: Qt.alpha(root.palette.windowText, parent.pressed ? 0.45 : 0.22)
                    opacity: parent.active ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
                background: null
            }

            readonly property real pullThreshold: 80
            property real wheelAccum: 0

            // How far past the top / bottom edge the list is currently pulled (0 = not at all)
            readonly property real pullTop: Math.max(0, originY - contentY)
            readonly property real pullBottom: Math.max(0, contentY - (originY + contentHeight - height))

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

            // Chapter title: the memorable moment on the page
            header: Item {
                width: ListView.view.width
                height: title.implicitHeight + 72

                // Pull-down hint (previous chapter)
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 14
                    text: verseList.pullTop > verseList.pullThreshold ? "Release for previous chapter"
                        : "Pull down for previous chapter"
                    font.pixelSize: 12
                    color: verseList.pullTop > verseList.pullThreshold ? root.palette.highlight
                        : root.palette.placeholderText
                    opacity: Math.min(1, verseList.pullTop / 30)
                }

                ColumnLayout {
                    id: title
                    width: Math.min(parent.width - 48, 640)
                    x: (parent.width - width) / 2
                    y: 36
                    spacing: 0

                    Label {
                        text: bookBox.currentText
                        font.family: root.serif
                        font.pixelSize: 40
                        font.weight: Font.DemiBold
                        color: root.palette.windowText
                    }
                    Label {
                        text: "Chapter " + (root.bible.chapterIndex + 1)
                        font.pixelSize: 15
                        color: root.palette.highlight
                        topPadding: 2
                    }
                }
            }

            // Pull-up hint (next chapter)
            footer: Item {
                width: ListView.view.width
                height: 96

                Rectangle {                      // end-of-chapter mark
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 20
                    width: 32; height: 1
                    color: root.palette.mid
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 36
                    text: verseList.pullBottom > verseList.pullThreshold ? "Release for next chapter"
                        : "Keep scrolling for next chapter"
                    font.pixelSize: 12
                    color: verseList.pullBottom > verseList.pullThreshold ? root.palette.highlight
                        : root.palette.placeholderText
                }
            }

            delegate: Item {
                id: verse
                required property int verseNumber
                required property string verseText

                width: ListView.view.width
                height: row.implicitHeight

                RowLayout {
                    id: row
                    width: Math.min(verse.width - 48, 640)   // readable line length
                    x: (verse.width - width) / 2             // centered column
                    spacing: 14

                    Label {                                  // verse number
                        Layout.preferredWidth: 26
                        Layout.alignment: Qt.AlignTop
                        topPadding: 7
                        horizontalAlignment: Text.AlignRight
                        text: verse.verseNumber
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        font.features: { "tnum": 1 }         // tabular figures keep the column aligned
                        color: root.palette.highlight
                        opacity: 0.8
                    }

                    Label {                                  // verse text
                        Layout.fillWidth: true
                        text: verse.verseText
                        wrapMode: Text.Wrap
                        font.family: root.serif
                        font.pixelSize: 19
                        lineHeight: 1.5
                        color: root.palette.windowText
                        textFormat: Text.PlainText
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
