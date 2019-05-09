QT += quick quickcontrols2
CONFIG += c++11 qtquickcompiler warn_on

DEFINES += \
    QT_DEPRECATED_WARNINGS \
    QT_DISABLE_DEPRECATED_BEFORE=0x060000 \
    QT_NO_CAST_TO_ASCII \
    QT_NO_CAST_FROM_ASCII \
    QT_NO_CAST_FROM_BYTEARRAY \

SOURCES += \
    main.cpp

RESOURCES += frontend/qml.qrc


unix:!android: target.path = /opt/$${TARGET}/
!isEmpty(target.path): INSTALLS += target
