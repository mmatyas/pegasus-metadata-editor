QT += quick quickcontrols2 svg
CONFIG += c++11 qtquickcompiler warn_on

DEFINES += \
    QT_DEPRECATED_WARNINGS \
    QT_DISABLE_DEPRECATED_BEFORE=0x060000 \
    QT_NO_CAST_TO_ASCII \

HEADERS += \
    FolderListModel.h \

SOURCES += \
    main.cpp \
    FolderListModel.cpp \

RESOURCES += frontend/qml.qrc


include(utils/utils.pri)
include(model/model.pri)
include(../thirdparty/thirdparty.pri)


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


unix:!android: target.path = /opt/$${TARGET}/
!isEmpty(target.path): INSTALLS += target
