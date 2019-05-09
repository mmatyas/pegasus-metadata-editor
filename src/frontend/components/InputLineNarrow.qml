import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


TextField {
    Layout.fillWidth: true

    topPadding: font.pixelSize * 0.3
    bottomPadding: topPadding
    leftPadding: font.pixelSize * 0.6
    rightPadding: leftPadding

    font.italic: !text

    selectByMouse: true
    background: Rectangle {
        color: "#10000000"
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.activeFocus || parent.hovered ? 2 : 1
        color: parent.activeFocus
            ? Material.accentColor
            : (parent.hovered ? Material.primaryTextColor : Material.hintTextColor)
    }
}
