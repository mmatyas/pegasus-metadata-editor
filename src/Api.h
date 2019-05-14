// Pegasus Frontend
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


#pragma once

#include "model/Model.h"

#include "QtQmlTricks/QQmlObjectListModel.h"
#include <QObject>


class Api: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString errorLog READ errorLog NOTIFY errorLogChanged)
    QML_OBJMODEL_PROPERTY(model::Collection, collections)
    QML_OBJMODEL_PROPERTY(model::Game, games)

public:
    explicit Api(QObject* parent = nullptr);

    Q_INVOKABLE void openFile(QString path);

    const QString& errorLog() const { return m_error_log; }

signals:
    void errorLogChanged();

private:
    QString m_error_log;
};