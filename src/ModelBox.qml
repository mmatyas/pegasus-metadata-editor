import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Frame {
    property alias title: mTitle.text
    property alias model: mView.model
    readonly property int mRadius: 5

    Layout.fillWidth: true

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    background: Rectangle {
        color: '#fff'
        border.color: '#28000000'
        border.width: 1
        radius: 5
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            id: mTitle

            font.capitalization: Font.AllUppercase
            font.weight: Font.Light
            padding: 8

            Layout.fillWidth: true
        }

        TextField {
            id: mSearchField

            Layout.fillWidth: true

            leftPadding: mRadius * 2
            rightPadding: leftPadding
            topPadding: 4
            bottomPadding: topPadding

            font.pointSize: 10
            font.italic: !text
            placeholderText: "Search..."

            background: Rectangle {
                color: "#10000000"
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.activeFocus || parent.hovered ? 2 : 1
                color: parent.activeFocus ? Material.accentColor
                    : (parent.hovered ? Material.primaryTextColor : Material.hintTextColor)
            }

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

        ListView {
            id: mView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            delegate: Text {
                text: modelData
                padding: font.pixelSize * 0.3
                leftPadding: font.pixelSize * 0.6
                rightPadding: leftPadding
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }
}
