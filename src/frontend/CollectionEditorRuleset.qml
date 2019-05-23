import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ColumnLayout {
    property alias header: mHeader.text
    property alias extensionsText: mExtDesc.text
    property alias filesText: mFileDesc.text
    property alias regexText: mRegexDesc.text
    property var cdata

    anchors.left: parent.left
    anchors.right: parent.right

    spacing: 10


    Label {
        id: mHeader

        font.pointSize: 17
        font.capitalization: Font.AllUppercase

        topPadding: font.pixelSize * 2.5
    }

    Item { width: 1; height: 1 }

    Label {
        id: mExtDesc
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
    StringListEditor {
        Layout.fillWidth: true
        model: cdata ? cdata.extensions : 0
    }

    Item { width: 1; height: 1 }

    Label {
        id: mFileDesc
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
    StringListEditor {
        Layout.fillWidth: true
        model: cdata ? cdata.files : 0
    }

    Item { width: 1; height: 1 }

    Label {
        id: mRegexDesc
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
    InputLineNarrow {
        text: cdata ? cdata.regex : ""
        placeholderText: "regular expression..."
        onTextEdited: if (cdata) cdata.regex = text;
        Layout.fillWidth: true
    }
}
