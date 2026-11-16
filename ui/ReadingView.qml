import QtQuick
import QtQuick.Controls.Basic

// Scrollable chapter text. Pulling past the top / bottom edge (drag, wheel or touchpad)
// asks for the previous / next chapter. Set `model` to the verses model
// (roles: verseNumber, verseText).
ListView {
    id: view

    required property VerseSelection selection
    required property string bookName
    required property int chapter               // 1-based
    required property string serifFamily

    signal previousRequested()
    signal nextRequested()
    signal contextMenuRequested()

    clip: true
    spacing: 14
    topMargin: 8
    bottomMargin: 8
    boundsBehavior: Flickable.DragOverBounds
    reuseItems: true

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        implicitWidth: 8
        contentItem: Rectangle {
            implicitWidth: 4
            radius: 2
            color: Qt.alpha(scrollBar.palette.windowText, scrollBar.pressed ? 0.45 : 0.22)
            opacity: scrollBar.active ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
        background: null
    }

    // ── Pull-to-navigate ─────────────────────────────────────────────────
    readonly property real pullThreshold: 80
    property real wheelAccum: 0

    // How far past the top / bottom edge the list is currently pulled (0 = not at all)
    readonly property real pullTop: Math.max(0, originY - contentY)
    readonly property real pullBottom: Math.max(0, contentY - (originY + contentHeight - height))

    // touch / mouse drag: decide when the drag is released
    onDragEnded: {
        if (contentY < originY - pullThreshold)
            previousRequested()
        else if (contentY > originY + contentHeight - height + pullThreshold)
            nextRequested()
    }

    // mouse wheel / touchpad: count scrolling that happens while already at an edge
    WheelHandler {
        blocking: false
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
            const atTop = view.atYBeginning && event.angleDelta.y > 0
            const atBottom = view.atYEnd && event.angleDelta.y < 0
            if (!atTop && !atBottom) { view.wheelAccum = 0; return }

            view.wheelAccum += Math.abs(event.angleDelta.y)
            resetTimer.restart()
            if (view.wheelAccum >= 360) {                 // ~3 wheel notches
                view.wheelAccum = 0
                atTop ? view.previousRequested() : view.nextRequested()
            }
        }
    }
    Timer { id: resetTimer; interval: 400; onTriggered: view.wheelAccum = 0 }

    // ── Parts ────────────────────────────────────────────────────────────
    header: ChapterHeader {
        bookName: view.bookName
        chapter: view.chapter
        serif: view.serifFamily
        pullTop: view.pullTop
        pullThreshold: view.pullThreshold
    }

    footer: ChapterFooter {
        pullBottom: view.pullBottom
        pullThreshold: view.pullThreshold
    }

    delegate: VerseDelegate {
        serif: view.serifFamily
        // Derived from the selection object, so it stays correct when items are reused
        selected: view.selection.isSelected(verseNumber)

        onPlainClicked: view.selection.selectOnly(verseNumber)
        onShiftClicked: view.selection.extendTo(verseNumber)
        onCtrlClicked: view.selection.toggle(verseNumber)
        onContextRequested: {
            if (!selected) view.selection.selectOnly(verseNumber)
            view.contextMenuRequested()
        }
    }
}
