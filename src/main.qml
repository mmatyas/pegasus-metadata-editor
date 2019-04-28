import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.0


ApplicationWindow {
    id: root

    title: qsTr("Pegasus Metadata Editor")
    width: 1024
    height: 600

    visible: true
    color: "#f0f3f7"


    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
    Shortcut {
        sequence: "Alt-F4"
        onActivated: Qt.quit()
    }


    readonly property real leftColumnWidth: width * 0.33


    header: ToolBar {
        Row {
            anchors.fill: parent

            ToolButton {
                icon.name: "document-open"
            }
        }
    }


    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            readonly property int mMargin: 16
            readonly property int mWidth: leftColumnWidth - 2 * mMargin

            Layout.fillHeight: true
            Layout.minimumWidth: mWidth
            Layout.maximumWidth: mWidth
            Layout.preferredWidth: mWidth
            Layout.margins: mMargin
            spacing: 8


            Label {
                text: "Collections"

                Layout.fillWidth: true
                font.capitalization: Font.AllUppercase
                font.weight: Font.Light
            }
            ModelBox {
                Layout.preferredHeight: root.height * 0.25
            }

            Item {
                // spacing
                Layout.minimumHeight: parent.spacing * 2
            }

            Label {
                text: "Games"

                Layout.fillWidth: true
                font.capitalization: Font.AllUppercase
                font.weight: Font.Light
            }
            ModelBox {
                Layout.fillHeight: true
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
