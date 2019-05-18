import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "components"


ColumnLayout {
    property alias model: mList.model

    spacing: 0


    Rectangle {
        Layout.fillWidth: true
        Layout.minimumHeight: mList.contentHeight

        color: "transparent"
        border.color: "#40000000"
        border.width: 1

        ListView {
            id: mList

            anchors.fill: parent

            delegate: mListDelegate
        }
    }
    FlatButton {
        Layout.fillWidth: true
        text: "+"
        onPressed: model.create()
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

            placeholderText: "(enter value)"

            Label {
                id: delBtn

                width: height * 1.25
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

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
