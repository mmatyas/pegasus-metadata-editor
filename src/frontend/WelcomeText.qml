import QtQuick 2.12
import QtQuick.Controls 2.12

Column {
    anchors.centerIn: parent
    opacity: 0.7
    spacing: 6

    readonly property int imgSize: 20
    readonly property int textSizePt: 13

    Label {
        text: "Welcome to the Pegasus Metadata Editor!"
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: textSizePt * 1.17
        bottomPadding: font.pixelSize * 0.9
    }
    Label {
        text: "You can use the toolbar buttons at the top to"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: textSizePt
    }
    Grid {
        columns: 2
        columnSpacing: 10
        verticalItemAlignment: Grid.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Image { sourceSize { width: imgSize; height: imgSize} asynchronous: true; source: "qrc:///icons/fa/folder-open.svg" }
        Label { text: "Open"; font.pointSize: textSizePt }
        Image { sourceSize { width: imgSize; height: imgSize} asynchronous: true; source: "qrc:///icons/fa/save.svg" }
        Label { text: "Save"; font.pointSize: textSizePt }
        Image { sourceSize { width: imgSize; height: imgSize} asynchronous: true; source: "qrc:///icons/fa/file.svg" }
        Label { text: "Create New"; font.pointSize: textSizePt }
    }
    Label {
        text: "metadata files. Happy editing!"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: textSizePt
    }
}
