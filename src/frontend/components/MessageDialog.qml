import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog {
    id: root

    property alias text: mText.text

    width: parent.width * 0.4
    anchors.centerIn: parent

    modal: true
    standardButtons: Dialog.Ok

    Label {
        id: mText
        width: root.width - root.leftPadding - root.rightPadding
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignJustify
    }
}
