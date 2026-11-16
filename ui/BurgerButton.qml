import QtQuick
import QtQuick.Controls.Basic

// Round "three lines" button
ToolButton {
    id: control
    implicitWidth: 36; implicitHeight: 36

    background: Rectangle {
        radius: width / 2
        color: control.down ? Qt.alpha(control.palette.windowText, 0.12)
             : control.hovered ? Qt.alpha(control.palette.windowText, 0.07)
             : "transparent"
    }

    contentItem: Item {
        Column {
            anchors.centerIn: parent
            spacing: 4
            Repeater {
                model: 3
                Rectangle {
                    width: 16; height: 2; radius: 1
                    color: control.palette.windowText
                }
            }
        }
    }
}
