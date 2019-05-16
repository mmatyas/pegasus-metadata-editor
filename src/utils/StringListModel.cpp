#include "StringListModel.h"


StringListModel::StringListModel(const QStringList& data, QObject *parent)
    : QStringListModel(data, parent)
{}

void StringListModel::create()
{
    insertRow(rowCount());
}

void StringListModel::append(QString str)
{
    create();
    const QModelIndex idx = index(rowCount() - 1);
    setData(idx, str);
}

void StringListModel::remove(int idx)
{
    removeRow(idx);
}
