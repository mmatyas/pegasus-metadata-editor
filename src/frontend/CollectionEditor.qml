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
            tooltipText: "A pretty name for your collection"
        }
        InputLine {
            label: "Shortened name"
            text: get_str("shortname")
            onTextEdited: set_val("shortname", text)
            tooltipText: "A short name or an abbreviation (eg. GameBoy Advance \u2192 GBA); "
                + "some themes use this for picking the correct icon or logo for a collection"
        }
        InputLine {
            label: "Sort by"
            text: get_str("sortby")
            onTextChanged: set_val("sortby", text)
            placeholderText: "(sort by the collection name)"
            tooltipText: "The collections will be sorted by this field; "
                + "useful if the name starts with eg. roman numerals or an article"
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


        BigLabel {
            text: "Launching"
        }
        InputArea {
            label: "Default launch command"
            font.family: "Monospace"
            text: get_str("launch_cmd")
            onTextChanged: set_val("launch_cmd", text)
            tooltipText: "This is the command Pegasus will run when you launch a game, "
                + "if it doesn't have a custom command"
        }
        CommandVarsLabel {}
        CommandVarsHelp {}
        InputLine {
            label: "Default working directory"
            text: get_str("launch_workdir")
            onTextEdited: set_val("launch_workdir", text)
            placeholderText: "(directory of the command or file)"
            tooltipText: "This is where the launch command will be called from"
        }


        CollectionEditorRuleset {
            header: "Include rules"
            extensionsText: "Include all files with the following extensions (without the leading dot):"
            filesText: "In addition, also include the following files (paths relative to the metadata file):"
            regexText: "In addition, also include files matching the following Perl regular expression:"
            cdata: root.cdata ? root.cdata.include : null
        }

        CollectionEditorRuleset {
            header: "Exclude rules"
            extensionsText: "Exclude all files with the following extensions (without the leading dot):"
            filesText: "In addition, also exclude the following files (paths relative to the metadata file):"
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
