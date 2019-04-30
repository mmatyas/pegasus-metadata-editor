import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ScrollView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    contentWidth: width

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    background: Rectangle {
        color: "#fff"
        border.color: "#28000000"
        border.width: 1
    }


    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 10

        Item { width: 1; height: 1 } // padding

        InputLine {
            text: "Nintendo Entertainment System"
            label: "Collection name (required)"

            font.pointSize: 20
        }
        InputLine {
            label: "Short name"
        }

        InputArea {
            label: "Summary (short description)"
        }
        InputArea {
            label: "Description"
        }
        InputArea {
            label: "Launch command"
        }


        Ruleset {
            header: "Include rules"
            extensionsText: "Include all files with the following extensions:"
            filesText: "In addition, also include the following files (the paths should be relative to the metadata file):"
            regexText: "In addition, also include files matching the following Perl regular expression:"
        }

        Ruleset {
            header: "Exclude rules"
            extensionsText: "Exclude all files with the following extensions:"
            filesText: "In addition, also exclude the following files (the paths should be relative to the metadata file):"
            regexText: "In addition, also exclude files matching the following Perl regular expression:"
        }


        Label {
            text: "Directories"
            font.pointSize: 17
            font.capitalization: Font.AllUppercase

            topPadding: font.pixelSize * 2
        }

        Item { width: 1; height: 1 }

        Label {
            Layout.fillWidth: true
            text: "By default Pegasus will search for games only in the directory (and subdirectories) "
                + "of the metadata file. You can add additional search directories here."
            wrapMode: Text.Wrap
        }
        Label {
            Layout.fillWidth: true
            text: "Note that the \"include/exclude file\" rules above are still relative to the metadata file."
            wrapMode: Text.Wrap
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            InputLineNarrow {
                placeholderText: "directory path..."
            }
            ListView {
                Layout.fillWidth: true

                Layout.minimumHeight: contentHeight

                model: 5
                delegate: Label {
                    width: parent.width

                    text: modelData
                    font.pointSize: 10

                    padding: font.pixelSize * 0.3
                    leftPadding: font.pixelSize * 0.6
                    rightPadding: leftPadding
                }

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    opacity: 0.25
                    border.color: "#000"
                    border.width: 1
                    z: -1
                }
            }
        }


        Item { width: 1; height: 1 } // padding
    }
}
