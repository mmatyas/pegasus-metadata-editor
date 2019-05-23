import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import SortFilterProxyModel 0.2
import "components"


Panel {
    id: root

    property string modelNameKey
    property alias title: mTitle.text
    property alias model: mModelFilter.sourceModel
    readonly property int currentIndex: mModelFilter.mapToSource(mView.currentIndex)

    signal picked
    signal createNew


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            id: mTitle

            font.capitalization: Font.AllUppercase
            font.weight: Font.Light
            padding: 8

            Layout.fillWidth: true

            Label {
                id: addBtn

                width: height
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                text: "+"
                font.bold: addBtnMouse.containsMouse
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter

                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "transparent"
                    border.width: 1
                    border.color: "#000"
                    opacity: 0.4
                    visible: addBtnMouse.containsMouse
                }

                MouseArea {
                    id: addBtnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.createNew()
                }
            }
        }

        InputLineNarrow {
            id: mSearch
            font.pointSize: 10
            placeholderText: "Search..."

            leftPadding: font.pixelSize * 0.6
            rightPadding: leftPadding

            Image {
                source: "qrc:///icons/fa/search.svg"
                sourceSize { width: 32; height: 32 }
                asynchronous: true

                height: parent.font.pixelSize * 1.2
                fillMode: Image.PreserveAspectFit

                anchors.right: parent.right
                anchors.rightMargin: parent.rightPadding * 0.75
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1

                opacity: 0.2
            }
        }

        SortFilterProxyModel {
            id: mModelFilter
            filters: RegExpFilter {
                roleName: modelNameKey
                pattern: mSearch.text
                caseSensitivity: Qt.CaseInsensitive
            }
        }

        ListView {
            id: mView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: mModelFilter
            delegate: mViewDelegate

            ScrollBar.vertical: ScrollBar {}
        }
    }

    Component {
        id: mViewDelegate

        Text {
            readonly property string name: modelData[modelNameKey]

            text: name ? name : "(unnamed)"
            color: name ? Material.foreground : Material.color(Material.Red)
            font.italic: !name

            width: ListView.view.width
            padding: font.pixelSize * 0.3
            leftPadding: font.pixelSize * 0.6
            rightPadding: leftPadding

            function pick() {
                ListView.view.currentIndex = index;
                root.picked();
            }

            Rectangle {
                anchors.fill: parent
                z: -1
                color: root.focus && parent.ListView.isCurrentItem ? "#ebe"
                     : mouse.containsMouse ? "#ddd"
                     : "transparent"
                visible: color != "transparent"
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: parent.pick()
            }


            Label {
                id: delBtn

                width: height * 1.25
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                text: "\xd7"
                font.pointSize: 14
                visible: mouse.containsMouse
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.model.remove(index)
                }
            }
        }
    }
}
