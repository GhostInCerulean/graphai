import QtQuick

// Right-click menu for the selected verses (placeholder actions)
AppMenu {
    id: root
    required property VerseSelection selection

    AppMenuItem { text: root.selection.label(); enabled: false }
    AppMenuSeparator {}
    AppMenuItem { text: "Copy";                 onTriggered: console.log("TODO copy", root.selection.numbers()) }
    AppMenuItem { text: "Copy with reference";  onTriggered: console.log("TODO copy with reference", root.selection.numbers()) }
    AppMenuItem { text: "Highlight";            onTriggered: console.log("TODO highlight", root.selection.numbers()) }
    AppMenuItem { text: "Add note…";            onTriggered: console.log("TODO note", root.selection.numbers()) }
    AppMenuItem { text: "Bookmark";             onTriggered: console.log("TODO bookmark", root.selection.numbers()) }
    AppMenuItem { text: "Share…";               onTriggered: console.log("TODO share", root.selection.numbers()) }
    AppMenuSeparator {}
    AppMenuItem { text: "Clear selection";      onTriggered: root.selection.clear() }
}
