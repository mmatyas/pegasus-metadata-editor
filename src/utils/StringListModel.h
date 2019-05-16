#pragma once

#include <QStringListModel>


class StringListModel : public QStringListModel {
    Q_OBJECT

public:
    explicit StringListModel(const QStringList& data, QObject* parent = nullptr);

    Q_INVOKABLE void create();
    Q_INVOKABLE void append(QString str);
    Q_INVOKABLE void remove(int idx);
};
