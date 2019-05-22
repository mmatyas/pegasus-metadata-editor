import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Pegasus.FolderListModel 1.0
import "components"


// NOTE: Qt had troubles with modal dialog chains, so this became a Popup
Popup {
    id: root

    readonly property string mSelectedPath: mFolderModel.folder + "/" + mFileName.text

    signal pick(string path)

    width: parent.width * 0.75
    height: parent.height * 0.95
    anchors.centerIn: parent

    modal: true

    leftPadding: 0
    topPadding: 0
    rightPadding: 0
    bottomPadding: 0


    FolderListModel {
        id: mFolderModel
        nameFilters: [
            "metadata.pegasus.txt",
            "metadata.txt",
            "collections.pegasus.txt",
            "collections.txt",
        ]
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            Layout.fillWidth: true

            text: mFolderModel.folder
            lineHeight: 2.25
            verticalAlignment: Text.AlignVCenter
            leftPadding: 16
            rightPadding: 16
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: mFolderModel
            delegate: fileDelegate

            Rectangle {
                anchors.fill: parent
                color: "#f1f2f3"
                z: -1
            }
        }

        Item { width: 1;  height: 8 }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Name:"
                leftPadding: 14
                rightPadding: leftPadding
            }
            InputLineNarrow {
                id: mFileName
                text: "metadata.pegasus.txt"
                Layout.rightMargin: 14
            }
        }

        DialogButtonBox {
            Layout.fillWidth: true
            alignment: Qt.AlignRight

            onAccepted: {
                if (!mFileName.text)
                    return;

                if (mFolderModel.fileExists(mSelectedPath)) {
                    mOverwrite.open();
                    return;
                }

                root.pick(mSelectedPath);
                root.close();
            }

            onRejected: root.close()

            Button {
                text: "Save"
                flat: true
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                enabled: mFileName.text
            }
            Button {
                text: "Cancel"
                flat: true
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }
    }

    Dialog {
        id: mOverwrite
        modal: true
        standardButtons: Dialog.Yes | Dialog.Cancel
        anchors.centerIn: parent
        title: "Warning!"

        onAccepted: {
            close();
            root.pick(mSelectedPath);
            root.close();
        }

        Label {
            text: "A file already exists with this name.\nWould you like to overwrite it?"
        }
    }


    Component {
        id: fileDelegate

        Rectangle {
            readonly property bool highlighted: ListView.isCurrentItem || mouseArea.containsMouse

            color: highlighted ? "#d1d2d3" : "transparent"
            width: parent.width
            height: label.height

            function pickItem() {
                if (isDir)
                    mFolderModel.cd(name);
                else
                    mFileName.text = name;
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
