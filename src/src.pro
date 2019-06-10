TEMPLATE = app
TARGET = pegasus-metaed

QT += quick quickcontrols2 svg
CONFIG += c++11 qtquickcompiler warn_on

DEFINES += \
    QT_DEPRECATED_WARNINGS \
    QT_DISABLE_DEPRECATED_BEFORE=0x060000 \
    QT_NO_CAST_TO_ASCII \
    GIT_REVISION=\\\"$${GIT_REVISION}\\\" \
    GIT_DATE=\\\"$${GIT_DATE}\\\"

HEADERS += \
    Api.h \
    FolderListModel.h \

SOURCES += \
    Api.cpp \
    main.cpp \
    FolderListModel.cpp \

RESOURCES += frontend/qml.qrc
OTHER_FILES += ../.qmake.conf


include(utils/utils.pri)
include(model/model.pri)
include(metaformat/metaformat.pri)
include(../thirdparty/thirdparty.pri)


LONGNAME=pegasus-metadata-editor

unix:!android:!macx {
    target.path = /opt/$${LONGNAME}/
}
android {
    QT += androidextras

    SOURCES += AndroidHelpers.cpp
    HEADERS += AndroidHelpers.h

    OTHER_FILES += \
        platform/android/AndroidManifest.xml \
        platform/android/res/drawable/banner.png \
        platform/android/res/drawable-ldpi/icon.png \
        platform/android/res/drawable-mdpi/icon.png \
        platform/android/res/drawable-hdpi/icon.png \
        platform/android/res/drawable-xhdpi/icon.png \
        platform/android/res/drawable-xxhdpi/icon.png \
        platform/android/res/drawable-xxxhdpi/icon.png \
        platform/android/src/org/pegasus_frontend/metaed/MainActivity.java \

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/platform/android
}
win32 {
    QMAKE_TARGET_PRODUCT = "pegasus-metadata-editor"
    QMAKE_TARGET_COMPANY = "pegasus-frontend.org"
    QMAKE_TARGET_DESCRIPTION = "Metadata Editor for the Pegasus frontend"
    QMAKE_TARGET_COPYRIGHT = "Copyright (c) 2017-2019 Matyas Mustoha"
    RC_ICONS = platform/windows/app_icon.ico
    OTHER_FILES += $${RC_ICONS}

    target.path = C:/$${LONGNAME}/
}
macx {
    ICON = platform/macos/appicons.icns
    QMAKE_APPLICATION_BUNDLE_NAME = "Pegasus Metadata Editor"
    QMAKE_TARGET_BUNDLE_PREFIX = org.pegasus-frontend
    QMAKE_INFO_PLIST = platform/macos/Info.plist.in

    target.path = /usr/local/$${LONGNAME}/
}

!isEmpty(target.path): INSTALLS += target
