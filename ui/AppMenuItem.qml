import QtQuick
import QtQuick.Controls.Basic

MenuItem {
    id: control
    implicitHeight: 34
    leftPadding: 12; rightPadding: 12
    font.pixelSize: 14

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? control.palette.text : control.palette.placeholderText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        radius: 6
        color: control.highlighted && control.enabled
            ? Qt.alpha(control.palette.highlight, 0.12) : "transparent"
    }
}
