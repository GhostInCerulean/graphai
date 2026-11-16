import QtQuick
import QtQuick.Controls.Basic

// Pill-style combo box
ComboBox {
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
