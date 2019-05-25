// Pegasus Metadata Editor
// Copyright (C) 2017-2019  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


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
