import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property alias text: mText.text

    width: mText.width * 2
    height: mText.height

    color: mMouse.containsMouse ? "#50000000" : "#28000000"


    Label {
        id: mText
        padding: 6.5
        anchors.centerIn: parent
    }

    MouseArea {
        id: mMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
