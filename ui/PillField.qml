import QtQuick
import QtQuick.Controls.Basic

// Pill-style text field
TextField {
    id: control
    implicitHeight: 36
    leftPadding: 16; rightPadding: 16
    font.pixelSize: 14
    color: palette.text
    selectByMouse: true

    background: Rectangle {
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: control.activeFocus ? control.palette.highlight : control.palette.mid
    }
}
