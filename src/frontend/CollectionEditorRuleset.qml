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

    Layout.fillWidth: true

    spacing: 10


    Label {
        id: mHeader

        text: "Include rules"
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
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        RowLayout {
            Layout.fillWidth: true

            InputLineNarrow { placeholderText: "extension..." }
            FlatButton { text: "+" }
        }
        ListView {
            Layout.fillWidth: true

            Layout.minimumHeight: contentHeight

            model: cdata ? cdata.extensions : 0
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
        id: mFileDesc
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        RowLayout {
            Layout.fillWidth: true

            InputLineNarrow { placeholderText: "path..." }
            FlatButton { text: "+" }
        }
        ListView {
            Layout.fillWidth: true

            Layout.minimumHeight: contentHeight

            model: cdata ? cdata.files : 0
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
                opacity: 0.1
                border.color: "#000"
                border.width: 1
                z: -1
            }
        }
    }

    Item { width: 1; height: 1 }

    Label {
        id: mRegexDesc
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
    RowLayout {
        Layout.fillWidth: true

        InputLineNarrow {
            text: cdata ? cdata.regex : ""
            placeholderText: "regular expression..."
            onTextEdited: if (cdata) cdata.regex = text;
        }
        FlatButton { text: "+" }
    }
}
