import QtQuick
import QtQuick.Controls.Basic   // Basic style: the only built-in one that fully supports custom backgrounds
import QtQuick.Layouts
import App

ApplicationWindow {
    id: root
    title: "Graphai"
    required property BibleViewModel bible
    visible: true; width: 860; height: 640
    minimumWidth: 480; minimumHeight: 360

    // ── Theme ────────────────────────────────────────────────────────────
    // Colors come straight from the operating system's palette, so light/dark mode
    // and the accent color are followed live. The Basic style ignores the system
    // theme by itself, which is why we feed it the platform palette here.
    // Every component below reads its colors from its own `palette`, which
    // inherits from this window.
    SystemPalette { id: sys; colorGroup: SystemPalette.Active }

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

    // First installed serif from the list (font.families isn't available in every Qt 6 build)
    readonly property string serif: {
        const installed = Qt.fontFamilies()
        for (const f of ["Source Serif 4", "Charter", "Georgia", "Noto Serif", "Palatino Linotype", "Times New Roman"])
            if (installed.indexOf(f) !== -1) return f
        return ""    // empty = application default font
    }

    // ── Selection ────────────────────────────────────────────────────────
    VerseSelection { id: selection }

    // A selection only makes sense within one chapter
    Connections {
        target: root.bible
        function onChapterIndexChanged() { selection.clear() }
        function onBookIndexChanged() { selection.clear() }
    }

    Shortcut { sequence: "Escape"; onActivated: selection.clear() }

    VerseMenu { id: verseMenu; selection: selection }

    // ── Layout ───────────────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            id: topBar
            Layout.fillWidth: true
            bible: root.bible
            onReferenceSubmitted: (text) => {
                // TODO: parse text into book + chapter
            }
        }

        ReadingView {
            id: reader
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.bible.verses
            selection: selection
            bookName: topBar.bookName
            chapter: root.bible.chapterIndex + 1
            serifFamily: root.serif

            onPreviousRequested: root.goPrev()
            onNextRequested: root.goNext()
            onContextMenuRequested: verseMenu.popup()
        }
    }

    function goNext() {
        if (bible.chapterIndex + 1 < bible.chapterCount) {
            bible.chapterIndex++
        } else if (bible.bookIndex + 1 < bible.bookCount) {   // assumed property
            bible.bookIndex++
            bible.chapterIndex = 0
        } else return
        Qt.callLater(() => reader.positionViewAtBeginning())
    }

    function goPrev() {
        if (bible.chapterIndex > 0) {
            bible.chapterIndex--
        } else if (bible.bookIndex > 0) {
            bible.bookIndex--
            Qt.callLater(() => bible.chapterIndex = bible.chapterCount - 1)
        } else return
        Qt.callLater(() => reader.positionViewAtEnd())
    }
}
