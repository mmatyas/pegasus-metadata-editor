import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ScrollView {
    id: root

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
            label: "Collection name (required)"
            text: get_str("name")
            font.pointSize: 20
            onTextEdited: set_val("name", text)
        }
        InputLine {
            label: "Shortened name"
            text: get_str("shortname")
            onTextEdited: set_val("shortname", text)
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
        InputArea {
            label: "Default launch command"
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
            label: "Default working directory"
            text: get_str("launch_workdir")
            onTextEdited: set_val("launch_workdir", text)
        }


        CollectionEditorRuleset {
            header: "Include rules"
            extensionsText: "Include all files with the following extensions:"
            filesText: "In addition, also include the following files (the paths should be relative to the metadata file):"
            regexText: "In addition, also include files matching the following Perl regular expression:"
            cdata: root.cdata ? root.cdata.include : null
        }

        CollectionEditorRuleset {
            header: "Exclude rules"
            extensionsText: "Exclude all files with the following extensions:"
            filesText: "In addition, also exclude the following files (the paths should be relative to the metadata file):"
            regexText: "In addition, also exclude files matching the following Perl regular expression:"
            cdata: root.cdata ? root.cdata.exclude : null
        }


        BigLabel {
            text: "Directories"
        }
        Label {
            text: "By default Pegasus will search for games only in the directory (and subdirectories) "
                + "of the metadata file. You can add additional search directories here."
            wrapMode: Text.Wrap
            anchors.left: parent.left
            anchors.right: parent.right
        }
        Label {
            text: "Note that the \"include/exclude file\" rules above are still relative to the metadata file!"
            wrapMode: Text.Wrap
            anchors.left: parent.left
            anchors.right: parent.right
        }
        StringListEditor {
            model: root.cdata ? cdata.directories : 0
            anchors.left: parent.left
            anchors.right: parent.right
        }


        Item { width: 1; height: 64 }
    }
}
