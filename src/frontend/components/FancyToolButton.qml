import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ToolButton {
    leftPadding: 12
    rightPadding: leftPadding
    Layout.fillHeight: true

    background: Rectangle {
        anchors.fill: parent
        visible: parent.hovered
        color: parent.Material.rippleColor
    }
}
