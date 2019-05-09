import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ScrollView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    contentWidth: width

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

    background: Rectangle {
        color: "#fff"
        border.color: "#28000000"
        border.width: 1
    }


    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        width: parent.width - 3*16
        spacing: 10

        InputLine {
            label: "Game title (required)"
            font.pointSize: 20
        }
        InputArea {
            label: "Summary (short description)"
        }
        InputArea {
            label: "Description"
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Max. players"
                Layout.fillWidth: true
            }
            Slider {
                id: mPlayerCnt
                from: 1
                to: 10
                value: 1
                stepSize: 1
                snapMode: Slider.SnapOnRelease
            }
            Label {
                text: mPlayerCnt.value
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: font.pixelSize * 2
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Rating"
                Layout.fillWidth: true
            }
            Slider {
                id: mRating
                from: 0
                to: 100
                value: 0
                stepSize: 1
                snapMode: Slider.SnapOnRelease
            }
            Label {
                text: (mRating.value > 0.5) ? (mRating.value + "%") : "--"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: font.pixelSize * 2
            }
        }

        InputArea {
            label: "Game-specific launch command"
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
        InputLine {
            label: "Game-specific working directory"
        }



        BigLabel {
            text: "Files"
        }
        Label {
            Layout.fillWidth: true
            text: "The following files will belong to this game. There can be more than one (eg. disks, clones). "
                + "The paths should be relative to the metadata file or absolute."
            wrapMode: Text.Wrap
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow { placeholderText: "file path..." }
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


        BigLabel {
            text: "Developers"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow { placeholderText: "developer..." }
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


        BigLabel {
            text: "Publishers"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow { placeholderText: "publisher..." }
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


        BigLabel {
            text: "Genres"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                InputLineNarrow { placeholderText: "genre..." }
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
    }
}
