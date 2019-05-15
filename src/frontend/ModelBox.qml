import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


Panel {
    id: root

    property string modelNameKey
    property alias title: mTitle.text
    property alias model: mView.model
    readonly property alias currentIndex: mView.currentIndex

    signal picked


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            id: mTitle

            font.capitalization: Font.AllUppercase
            font.weight: Font.Light
            padding: 8

            Layout.fillWidth: true
        }

        InputLineNarrow {
            font.pointSize: 10
            placeholderText: "Search..."

            leftPadding: font.pixelSize * 0.6
            rightPadding: leftPadding

            Image {
                source: "qrc:///icons/fa/search.svg"
                sourceSize { width: 32; height: 32 }
                asynchronous: true

                height: parent.font.pixelSize * 1.2
                fillMode: Image.PreserveAspectFit

                anchors.right: parent.right
                anchors.rightMargin: parent.rightPadding * 0.75
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1

                opacity: 0.2
            }
        }

        ListView {
            id: mView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            delegate: mViewDelegate

            ScrollBar.vertical: ScrollBar {}
        }
    }

    Component {
        id: mViewDelegate

        Text {
            text: modelData[modelNameKey]

            width: ListView.view.width
            padding: font.pixelSize * 0.3
            leftPadding: font.pixelSize * 0.6
            rightPadding: leftPadding

            function pick() {
                ListView.view.currentIndex = index;
                root.picked(index);
            }

            Rectangle {
                anchors.fill: parent
                z: -1
                color: root.focus && parent.ListView.isCurrentItem ? "#ebe"
                     : mouse.containsMouse ? "#ddd"
                     : "transparent"
                visible: color != "transparent"
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: parent.pick()
            }
        }
    }
}
