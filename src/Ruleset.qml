import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ColumnLayout {
    property alias header: mHeader.text
    property alias extensionsText: mExtDesc.text
    property alias filesText: mFileDesc.text
    property alias regexText: mRegexDesc.text

    Layout.fillWidth: true

    spacing: 10


    Label {
        id: mHeader

        text: "Include rules"
        font.pointSize: 17
        font.capitalization: Font.AllUppercase

        topPadding: font.pixelSize * 2
    }

    Item { width: 1; height: 1 }

    Label {
        id: mExtDesc
    }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        InputLineNarrow {
            placeholderText: "extension..."
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
        id: mFileDesc
    }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        InputLineNarrow {
            placeholderText: "path..."
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
    }
    InputLineNarrow {
        placeholderText: "regular expression..."
    }
}
