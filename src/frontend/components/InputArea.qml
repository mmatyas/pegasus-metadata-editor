import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12


TextArea {
    property alias label: mLabel.text

    readonly property color mAccentColor: activeFocus
        ? Material.accentColor
        : (hovered ? Material.primaryTextColor : Material.hintTextColor)

    height: Math.max(font.pixelSize * 5.5, implicitHeight)

    anchors.left: parent.left
    anchors.right: parent.right

    leftPadding: mLabel.leftPadding
    rightPadding: leftPadding
    topPadding: mLabel.height
    bottomPadding: font.pixelSize * 0.25

    selectByMouse: true
    background: Rectangle {
        color: "#10000000"
    }

    wrapMode: Text.Wrap

    Label {
        id: mLabel
        font.pointSize: 10
        padding: font.pixelSize * 0.5
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
