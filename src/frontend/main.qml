import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.0
import "components"


ApplicationWindow {
    id: root

    title: qsTr("Pegasus Metadata Editor")
    width: 1024
    height: 600

    visible: true
    color: "#f0f3f7"


    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
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
        RowLayout {
            anchors.fill: parent
            spacing: 0

            FancyToolButton {
                icon.source: "qrc:///icons/fa/folder-open.svg"
                onClicked: filepicker.open()
            }
            FancyToolButton {
                icon.source: "qrc:///icons/fa/save.svg"
                onClicked: Api.save()
                enabled: false
            }

            Item { Layout.fillWidth: true }

            FancyToolButton {
                icon.source: "qrc:///icons/fa/ellipsis-v.svg"
                onClicked: mMenuMisc.popup()
            }
        }
    }

    Menu {
        id: mMenuMisc

        MenuItem {
            text: "Save As\u2026"
            enabled: false
            onTriggered: mSaveAsDialog.open()
        }

        MenuSeparator {}

        MenuItem {
            text: "About\u2026"
            onTriggered: mAbout.open()
        }
    }


    RowLayout {
        anchors.fill: parent
        spacing: 0

        FocusScope {
            readonly property int padding: 16
            readonly property int mWidth: leftColumnWidth - 2 * padding

            Layout.fillHeight: true
            Layout.minimumWidth: mWidth
            Layout.maximumWidth: mWidth
            Layout.preferredWidth: mWidth
            Layout.margins: padding

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                ModelBox {
                    id: collectionSelector
                    title: "Collections"
                    model: Api.collections
                    modelNameKey: "name"
                    onPicked: {
                        focus = true;
                        gameEditor.enabled = false;
                        collectionEditor.enabled = true;
                        collectionEditor.focus = true;
                    }
                    Layout.preferredHeight: root.height * 0.25
                }

                ModelBox {
                    id: gameSelector
                    title: "Games"
                    model: Api.games
                    modelNameKey: "title"
                    onPicked: {
                        focus = true;
                        collectionEditor.enabled = false;
                        gameEditor.enabled = true;
                        gameEditor.focus = true;
                    }
                    Layout.fillHeight: true
                }
            }
        }


        CollectionEditor {
            id: collectionEditor
            enabled: false
            visible: enabled && cdata
            cdata: Api.collections.get(collectionSelector.currentIndex)
        }
        GameEditor {
            id: gameEditor
            enabled: false
            visible: enabled && cdata
            cdata: Api.games.get(gameSelector.currentIndex)
        }
    }

    Connections {
        target: Api
        onOpenSuccess: {
            if (Api.errorLog) {
                mWarnings.isLoading = true;
                mWarnings.open();
            }
        }
        onSaveSuccess: {
            if (Api.errorLog) {
                mWarnings.isLoading = false;
                mWarnings.open();
            }
        }
        onOpenFail: mError.open()
        onSaveFail: mError.open()
    }

    FilePicker {
        id: filepicker
        onPick: {
            collectionSelector.focus = false;
            collectionEditor.enabled = false;
            gameSelector.focus = false;
            gameEditor.enabled = false;

            Api.openFile(path);
        }
    }

    SaveAsDialog {
        id: mSaveAsDialog
        onPick: Api.saveAs(path)
    }

    Dialog {
        id: mAbout

        width: parent.width * 0.45
        anchors.centerIn: parent

        modal: true
        standardButtons: Dialog.Ok

        Label {
            anchors.fill: parent
            text: "<h2>Pegasus Metadata Editor</h2>"
                + "<br>A graphical editor for the Metadata files of the Pegasus frontend."
                + "<br>Visit us at <a href=\"https://pegasus-frontend.org\">https://pegasus-frontend.org</a>!"
                + "<br><br>Copyright \xa9 2019 Mátyás Mustoha"
                + "<br><br>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
            wrapMode: Text.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

    Dialog {
        id: mWarnings

        property bool isLoading: true

        width: parent.width * 0.65
        anchors.centerIn: parent

        title: "Warning!"
        modal: true
        standardButtons: Dialog.Ok

        ScrollView {
            anchors.fill: parent
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Label {
                property string loadText: "The file has been opened successfully, but the following"
                                        + " non-critical issues were noticed in it:\n\n"
                property string saveText: "The file has been saved successfully, but the following"
                                        + " non-critical issues were noticed:\n\n"
                width: mWarnings.width - mWarnings.leftPadding - mWarnings.rightPadding
                text: (mWarnings.isLoading ? loadText : saveText) + Api.errorLog
                wrapMode: Text.Wrap
            }
        }
    }

    Dialog {
        id: mError

        width: parent.width * 0.45
        anchors.centerIn: parent

        title: "Error!"
        modal: true
        standardButtons: Dialog.Ok

        Label {
            id: mErrorText
            text: Api.errorLog ? Api.errorLog
                : "The save/load operation failed for an unknown reason."
                + " If this problem keeps appearing, please report it to the developers."
            width: mError.width - mError.leftPadding - mError.rightPadding
            wrapMode: Text.Wrap
        }
    }
}
