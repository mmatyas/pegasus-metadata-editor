import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Frame {
    readonly property int mRadius: 5

    Layout.fillWidth: true

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    background: Rectangle {
        color: '#fff'
        border.color: '#28000000'
        border.width: 1
        radius: 5
    }

    ColumnLayout {
        anchors.fill: parent

        TextField {
            Layout.fillWidth: true

            leftPadding: mRadius * 2
            rightPadding: leftPadding
            bottomPadding: 2

            font.pointSize: 10
            placeholderText: "Search..."
            font.italic: !text

            Image {
                source: "qrc:///icons/fa/search.svg"
                sourceSize { width: 32; height: 32 }
                asynchronous: true

                //height: parent.height * 0.6
                height: parent.font.pixelSize * 1.2
                fillMode: Image.PreserveAspectFit

                anchors.right: parent.right
                anchors.rightMargin: parent.rightPadding * 0.75
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 3

                opacity: 0.2
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: 100
            delegate: Text {
                text: modelData
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }

}
