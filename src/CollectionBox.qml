import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ScrollView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    contentWidth: width - ScrollBar.vertical.width * 0.5

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

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
            label: "Shortened name"
        }

        InputArea {
            label: "Summary (short description)"
        }
        InputArea {
            label: "Description"
        }
        InputArea {
            label: "Default launch command"
            font.family: "Monospace"
        }
        TinyLabel {
            text: "The launch command is a single value, but you can break "
                + "it up to multiple lines for better readability. You can use "
                + "the following variables in it:"
            Layout.fillWidth: true
        }
        GridLayout {
            columns: 2
            columnSpacing: 32
            Layout.leftMargin: 16

            TinyLabel { text: "{file.path}" }
            TinyLabel { text: "Absolute path to the launched file" }
            TinyLabel { text: "{file.name}" }
            TinyLabel { text: "The file name part of the path" }
            TinyLabel { text: "{file.basename}" }
            TinyLabel { text: "The file name without extension" }
            TinyLabel { text: "{file.dir}" }
            TinyLabel { text: "The directory where the file is located" }
            TinyLabel { text: "{env.MYVAR}" }
            TinyLabel { text: "The value of the environment variable MYVAR, if defined" }
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

            topPadding: font.pixelSize * 2.5
            bottomPadding: font.pixelSize * 0.5
        }

        Label {
            Layout.fillWidth: true
            text: "By default Pegasus will search for games only in the directory (and subdirectories) "
                + "of the metadata file. You can add additional search directories here."
            wrapMode: Text.Wrap
        }
        Label {
            Layout.fillWidth: true
            text: "Note that the \"include/exclude file\" rules above are still relative to the metadata file!"
            wrapMode: Text.Wrap
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow { placeholderText: "directory path..." }
                FlatButton { text: "+" }
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

        Item { width: 1; height: 1 }


        Label {
            text: "Anything else"
            font.pointSize: 17
            font.capitalization: Font.AllUppercase

            topPadding: font.pixelSize * 2.5
            bottomPadding: font.pixelSize * 0.5
        }
        Label {
            Layout.fillWidth: true
            text: "Any kind of additional information you wish to store. "
                + "These entries will not be used by Pegasus."
            wrapMode: Text.Wrap
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow {
                    placeholderText: "key..."
                    Layout.fillWidth: true
                }
                InputLineNarrow {
                    placeholderText: "value..."
                    Layout.fillWidth: true
                }
                FlatButton {
                    text: "+"
                }
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
