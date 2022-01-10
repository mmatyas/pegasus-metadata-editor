import QtQuick.Layouts 1.12


GridLayout {
    columns: 2
    columnSpacing: 32
    anchors.leftMargin: 16
    anchors.left: parent.left
    anchors.right: parent.right

    TinyMonoLabel { text: "{file.path}" }
    TinyLabel { text: "Absolute path to the launched file" }
    TinyMonoLabel { text: "{file.name}" }
    TinyLabel { text: "The file name part of the path" }
    TinyMonoLabel { text: "{file.basename}" }
    TinyLabel { text: "The file name without extension" }
    TinyMonoLabel { text: "{file.dir}" }
    TinyLabel { text: "The directory where the file is located" }
    TinyMonoLabel { text: "{file.uri}" }
    TinyLabel { text: "Absolute path in URI format (mainly for Android)" }
    TinyMonoLabel { text: "{env.MYVAR}" }
    TinyLabel { text: "The value of the environment variable MYVAR, if defined" }
}
