import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Pegasus.FolderListModel 1.0


Dialog {
    id: root

    width: parent.width * 0.75
    height: parent.height * 0.95
    anchors.centerIn: parent

    modal: true
    standardButtons: Dialog.Cancel

    leftPadding: 0
    topPadding: 0
    rightPadding: 0
    bottomPadding: 0

    signal pick(string path)


    FolderListModel {
        id: folderModel
        files: [
            "metadata.pegasus.txt",
            "metadata.txt",
        ]
        extensions: [
            ".metadata.pegasus.txt",
            ".metadata.txt",
        ]
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            Layout.fillWidth: true

            text: folderModel.folder
            lineHeight: 2.25
            verticalAlignment: Text.AlignVCenter
            leftPadding: 16
            rightPadding: 16
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            clip: true

            /*ListView {
                Layout.minimumWidth: parent.width * 0.25
                Layout.fillHeight: true

                model: 100
                delegate: Text { text: modelData; }

                Rectangle {
                    anchors.fill: parent
                    color: Material.toolBarColor
                    z: -1
                }
            }*/

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: folderModel
                delegate: fileDelegate


                Rectangle {
                    anchors.fill: parent
                    color: "#f1f2f3"
                    z: -1
                }
            }
        }
    }



    Component {
        id: fileDelegate

        Rectangle {
            readonly property bool highlighted: ListView.isCurrentItem || mouseArea.containsMouse

            color: highlighted ? "#d1d2d3" : "transparent"
            width: ListView.view.width
            height: label.height

            function pickItem() {
                if (isDir) {
                    folderModel.cd(name);
                }
                else {
                    root.pick(folderModel.folder + "/" + name);
                    root.close();
                }
            }

            Keys.onPressed: {
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    pickItem();
                }
            }


            Image {
                id: icon
                source: isDir ? "qrc:///icons/fa/folder.svg" : "";
                sourceSize { width: 32; height: 32 }

                fillMode: Image.PreserveAspectFit
                height: parent.height * 0.5
                width: height

                anchors.left: parent.left
                anchors.leftMargin: height * 0.5
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: label
                text: name
                verticalAlignment: Text.AlignVCenter
                lineHeight: 2.5

                color: "#111"
                font.bold: !isDir

                anchors.left: icon.right
                anchors.right: parent.right
                leftPadding: parent.height * 0.25
                rightPadding: parent.height * 0.5
                elide: Text.ElideRight
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: pickItem()
            }
        }
    }
}
