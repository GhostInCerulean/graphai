import QtQuick
import QtQuick.Controls.Basic

// Popup menu styled like the pill combo popups. Use with AppMenuItem / AppMenuSeparator.
Menu {
    id: menu
    padding: 6
    implicitWidth: Math.max(180, contentItem.implicitWidth + leftPadding + rightPadding)

    background: Rectangle {
        implicitWidth: 180
        radius: 12
        color: menu.palette.base
        border.width: 1
        border.color: menu.palette.mid
    }

    contentItem: ListView {
        implicitHeight: contentHeight
        model: menu.contentModel
        interactive: Window.window
            ? contentHeight + menu.topPadding + menu.bottomPadding > Window.window.height
            : false
        clip: true
        currentIndex: menu.currentIndex
    }
}
