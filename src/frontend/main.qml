import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.0
import "components"


ApplicationWindow {
    id: root

    title: "Pegasus Metadata Editor" + (Api.filePath ? " - " + Api.filePath : "")
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
    property bool canSave: false

    function uiEnable() {
        mEditor.enabled = true;
        canSave = true;
        uiResetOnNew();
    }
    function uiResetOnNew() {
        collectionSelector.focus = false;
        collectionSelector.resetIndex();
        collectionEditor.enabled = false;
        gameSelector.focus = false;
        gameSelector.resetIndex();
        gameEditor.enabled = false;
    }

    function documentSave() {
        if (Api.filePath)
            Api.save();
        else
            mSaveAsDialog.open();
    }


    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 0

            FancyToolButton {
                icon.source: "qrc:///icons/fa/file.svg"
                onClicked: {
                    if (Api.hasDocument)
                        mOnCreateSaveWarning.open();
                    else
                        Api.newDocument();
                }
                ToolTip.text: "Create New"
                ToolTip.visible: hovered
                ToolTip.delay: 500
            }
            FancyToolButton {
                icon.source: "qrc:///icons/fa/folder-open.svg"
                onClicked: {
                    if (Api.hasDocument)
                        mOnOpenSaveWarning.open();
                    else
                        mLoadDialog.open()
                }
                ToolTip.text: "Open"
                ToolTip.visible: hovered
                ToolTip.delay: 500
            }
            ToolSeparator{}
            FancyToolButton {
                icon.source: "qrc:///icons/fa/save.svg"
                onClicked: root.documentSave()
                enabled: root.canSave

                ToolTip.text: "Save"
                ToolTip.visible: hovered
                ToolTip.delay: 500
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
            enabled: root.canSave
            onTriggered: mSaveAsDialog.open()
        }

        MenuSeparator {}

        MenuItem {
            text: "About\u2026"
            onTriggered: mAbout.open()
        }
        MenuItem {
            text: "Quit"
            onTriggered: root.close()
        }
    }


    WelcomeText {
        visible: !mEditor.visible
    }

    RowLayout {
        id: mEditor

        anchors.fill: parent
        spacing: 0

        enabled: false
        visible: enabled

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
                    onCreateNew: Api.newCollection()
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
                    onCreateNew: Api.newGame()
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
        EntryEditHelpText {
            visible: !collectionEditor.visible && !gameEditor.visible
        }
    }


    LoadDialog {
        id: mLoadDialog
        onPick: Api.openFile(path)
    }
    SaveAsDialog {
        id: mSaveAsDialog
        onPick: Api.saveAs(path)
    }

    Connections {
        target: Api
        onOpenSuccess: {
            if (Api.errorLog) {
                mWarnings.isLoading = true;
                mWarnings.open();
            }
            root.uiEnable();
        }
        onSaveSuccess: {
            if (Api.errorLog) {
                mWarnings.isLoading = false;
                mWarnings.open();
            }
            mToast.show("File saved", 2000);
        }
        onOpenFail: mError.open()
        onSaveFail: mError.open()
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
    MessageDialog {
        id: mError
        title: "Error!"
        standardButtons: Dialog.Ok
        text: Api.errorLog ? Api.errorLog
            : "The save/load operation failed for an unknown reason."
            + " If this problem keeps appearing, please report it to the developers."
    }
    MessageDialog {
        id: mOnCreateSaveWarning
        standardButtons: Dialog.Yes | Dialog.Cancel
        text: "You are about to create a new metadata file. There is already one open, "
            + " so in case you forgot to save it, you can still go back now."
            + "\n\nCan I close the currently open file?"

        onRejected: close()
        onAccepted: Api.newDocument()
    }
    MessageDialog {
        id: mOnOpenSaveWarning
        standardButtons: Dialog.Yes | Dialog.Cancel
        text: "You are about to load a metadata file. There is already one open, "
            + " so in case you forgot to save it, you can still go back now."
            + "\n\nCan I close the currently open file?"

        onRejected: close()
        onAccepted: mLoadDialog.open()
    }


    Item {
        // toast position
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        ToolTip { id: mToast }
    }


    AboutDialog { id: mAbout }
}
