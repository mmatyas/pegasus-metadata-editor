import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ScrollView {
    property var cdata

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


    function get_str(field) {
        return cdata ? cdata[field] : "";
    }
    function set_val(field, text) {
        if (cdata) cdata[field] = text;
    }


    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        width: parent.width - 3*16
        spacing: 10

        InputLine {
            label: "Game title (required)"
            text: get_str("title")
            font.pointSize: 20
            onTextEdited: set_val("title", text)
        }
        InputArea {
            label: "Summary (short description)"
            text: get_str("summary")
            onTextChanged: set_val("summary", text)
        }
        InputArea {
            label: "Description"
            text: get_str("description")
            onTextChanged: set_val("description", text)
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
                value: cdata ? cdata.max_players : 1
                stepSize: 1
                snapMode: Slider.SnapOnRelease
                onMoved: set_val("max_players", value)
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
                value: cdata ? (cdata.rating * 100) : 0
                stepSize: 1
                snapMode: Slider.SnapOnRelease
                onMoved: set_val("rating", value / 100)
            }
            Label {
                text: (mRating.value > 0.5) ? (mRating.value.toFixed(0) + "%") : "--"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: font.pixelSize * 2
            }
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

            ListView {
                Layout.fillWidth: true

                Layout.minimumHeight: contentHeight

                model: cdata ? cdata.files : 0
                delegate: mListDelegate

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    opacity: 0.25
                    border.color: "#000"
                    border.width: 1
                    z: -1
                }
            }
            FlatButton {
                Layout.fillWidth: true
                text: "+"
                onPressed: if (cdata) cdata.files.create()
            }
        }


        BigLabel {
            text: "Developers"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            ListView {
                Layout.fillWidth: true

                Layout.minimumHeight: contentHeight

                model: cdata ? cdata.developers : 0
                delegate: mListDelegate

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    opacity: 0.25
                    border.color: "#000"
                    border.width: 1
                    z: -1
                }
            }
            FlatButton {
                Layout.fillWidth: true
                text: "+"
                onPressed: if (cdata) cdata.developers.create()
            }
        }


        BigLabel {
            text: "Publishers"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            ListView {
                Layout.fillWidth: true

                Layout.minimumHeight: contentHeight

                model: cdata ? cdata.publishers : 0
                delegate: mListDelegate

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    opacity: 0.25
                    border.color: "#000"
                    border.width: 1
                    z: -1
                }
            }
            FlatButton {
                Layout.fillWidth: true
                text: "+"
                onPressed: if (cdata) cdata.publishers.create()
            }
        }


        BigLabel {
            text: "Genres"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            ListView {
                Layout.fillWidth: true

                Layout.minimumHeight: contentHeight

                model: cdata ? cdata.genres : 0
                delegate: mListDelegate

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    opacity: 0.25
                    border.color: "#000"
                    border.width: 1
                    z: -1
                }
            }
            FlatButton {
                Layout.fillWidth: true
                text: "+"
                onPressed: if (cdata) cdata.genres.create()
            }
        }

        BigLabel {
            text: "Launching"
        }
        Label {
            Layout.fillWidth: true
            text: "If this game requires a special launch command or working directory, you can set it here. "
                + "By default Pegasus will use the values from the collection that contains this game"
            wrapMode: Text.Wrap
        }
        InputArea {
            label: "Game-specific launch command"
            font.family: "Monospace"
            text: get_str("launch_cmd")
            onTextChanged: set_val("launch_cmd", text)
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
            text: get_str("launch_workdir")
            onTextEdited: set_val("launch_workdir", text)
        }


        Item { width: 1; height: 1 }
    }

    Component {
        id: mListDelegate

        InputLineNarrow {
            id: inputLine

            width: ListView.view.width
            background: Item {}

            text: display
            onTextEdited: edit = text
            font.pointSize: 10

            placeholderText: "(empty)"

            Label {
                id: delBtn

                width: height * 1.25
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -2

                text: "\xd7"
                font.pointSize: 16
                visible: parent.hovered
                horizontalAlignment: Text.AlignHCenter
                font.italic: false

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.ArrowCursor
                    onClicked: inputLine.ListView.view.model.remove(index)
                }
            }
        }
    }
}
