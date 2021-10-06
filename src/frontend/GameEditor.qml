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


    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 32
        anchors.margins: 16
        spacing: 10

        InputLine {
            label: "Game title (required)"
            text: get_str("title")
            font.pointSize: 20
            onTextEdited: set_val("title", text)
        }
        InputLine {
            label: "Sort by"
            text: get_str("sortby")
            onTextChanged: set_val("sortby", text)
            placeholderText: "Same as game title"
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
            anchors.left: parent.left
            anchors.right: parent.right
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
            anchors.left: parent.left
            anchors.right: parent.right
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
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            InputLine {
                id: mRelYear

                readonly property int cdataNum: cdata ? cdata.release_year : 0

                label: "Release year"
                text: cdataNum ? cdataNum : ""
                placeholderText: "YYYY"
                onTextChanged: {
                    if (acceptableInput)
                        set_val("release_year", text);
                    else if (!text)
                        set_val("release_year", 0);
                }
                validator: IntValidator { bottom: 1900; top: 2100 }

                anchors.left: undefined
                anchors.right: undefined
                Layout.fillWidth: true
            }
            InputLine {
                id: mRelMonth

                readonly property int cdataNum: cdata ? cdata.release_month : 0

                label: "Release month"
                text: cdataNum ? cdataNum : ""
                placeholderText: "1-12"
                onTextChanged: {
                    if (acceptableInput)
                        set_val("release_month", text);
                    else if (!text)
                        set_val("release_month", 0);
                }
                validator: IntValidator { bottom: 1; top: 12 }

                anchors.left: undefined
                anchors.right: undefined
                Layout.minimumWidth: parent.width * 0.33

                enabled: mRelYear.acceptableInput
            }
            InputLine {
                readonly property int cdataNum: cdata ? cdata.release_day : 0

                label: "Release day"
                text: cdataNum ? cdataNum : ""
                placeholderText: "1-31"
                onTextChanged: {
                    if (acceptableInput)
                        set_val("release_day", text);
                    else if (!text)
                        set_val("release_day", 0);
                }
                validator: IntValidator { bottom: 1; top: 31 }

                anchors.left: undefined
                anchors.right: undefined
                Layout.minimumWidth: parent.width * 0.33

                enabled: mRelMonth.enabled && mRelMonth.acceptableInput
            }
        }


        BigLabel {
            text: "Files"
        }
        Label {
            text: "The following files will belong to this game. There can be more than one (eg. disks, clones). "
                + "The paths should be relative to the metadata file or absolute."
            wrapMode: Text.Wrap
            anchors.left: parent.left
            anchors.right: parent.right
        }
        StringListEditor {
            model: cdata ? cdata.files : 0
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Item { width: 1; height: 32 }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right

            Label {
                Layout.minimumWidth: parent.parent.width * 0.25
                Layout.fillHeight: true

                text: "Developers"
                font.pointSize: 16
            }
            StringListEditor {
                Layout.fillWidth: true
                model: cdata ? cdata.developers : 0
            }
        }

        Item { width: 1; height: 1 }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right

            Label {
                Layout.minimumWidth: parent.parent.width * 0.25
                Layout.fillHeight: true

                text: "Publishers"
                font.pointSize: 16
            }
            StringListEditor {
                Layout.fillWidth: true
                model: cdata ? cdata.publishers : 0
            }
        }

        Item { width: 1; height: 1 }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right

            Label {
                Layout.minimumWidth: parent.parent.width * 0.25
                Layout.fillHeight: true

                text: "Genres"
                font.pointSize: 16
            }
            StringListEditor {
                Layout.fillWidth: true
                model: cdata ? cdata.genres : 0
            }
        }

        BigLabel {
            text: "Launching"
        }
        Label {
            text: "If this game requires a special launch command or working directory, you can set it here. "
                + "By default Pegasus will use the values from the collection that contains this game"
            wrapMode: Text.Wrap
            anchors.left: parent.left
            anchors.right: parent.right
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
            anchors.left: parent.left
            anchors.right: parent.right
        }
        GridLayout {
            columns: 2
            columnSpacing: 32
            anchors.leftMargin: 16
            anchors.left: parent.left
            anchors.right: parent.right

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


        Item { width: 1; height: 64 }
    }
}
