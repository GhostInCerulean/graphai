import QtQuick

// Burger menu (placeholder actions)
AppMenu {
    AppMenuItem { text: "Bookmarks";     onTriggered: console.log("TODO bookmarks") }
    AppMenuItem { text: "Notes";         onTriggered: console.log("TODO notes") }
    AppMenuItem { text: "Translations";  onTriggered: console.log("TODO translations") }
    AppMenuSeparator {}
    AppMenuItem { text: "Settings…";     onTriggered: console.log("TODO settings") }
    AppMenuItem { text: "About Graphai"; onTriggered: console.log("TODO about") }
}
