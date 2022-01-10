import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12


TextField {
    property alias label: mLabel.text
    property string tooltipText: ""

    readonly property color mAccentColor: activeFocus
        ? Material.accentColor
        : (hovered ? Material.primaryTextColor : Material.hintTextColor)

    anchors.left: parent.left
    anchors.right: parent.right

    leftPadding: mLabel.leftPadding
    rightPadding: leftPadding
    topPadding: mLabel.height * 1.1
    bottomPadding: font.pixelSize * 0.25

    selectByMouse: true
    background: Rectangle {
        color: "#10000000"
    }

    ToolTip.text: tooltipText
    ToolTip.visible: tooltipText ? hovered : false
    ToolTip.delay: 500

    Label {
        id: mLabel
        font.pointSize: 10
        padding: font.pixelSize * 0.5
        bottomPadding: 0
        color: mAccentColor
        font.family: "Roboto"
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.activeFocus || parent.hovered ? 2 : 1
        color: mAccentColor
    }
}
