lessThan(QT_MAJOR_VERSION, 5) | lessThan(QT_MINOR_VERSION, 12) {
    error("This project requires Qt 5.12 or later")
}

TEMPLATE = subdirs
SUBDIRS += src
