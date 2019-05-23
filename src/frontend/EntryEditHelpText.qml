import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Label {
    text: "Select an item from the left to edit.\n"
        + "Use the + button to add a new item.\n"
        + "Use the \xd7 button to delete an item."
    font.pointSize: 12
    opacity: 0.6

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Layout.fillWidth: true
    Layout.fillHeight: true
}
