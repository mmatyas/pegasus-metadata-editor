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


#pragma once

#include "ModelData.h"
#include "utils/StringListModel.h"

#include <QObject>


#define FIELD_PROP(type, field) \
    private: \
        Q_PROPERTY(type field READ field WRITE set_##field NOTIFY field##Changed) \
        type field() const { return m_data.field; } \
        void set_##field(type val) { \
            if (m_data.field != val) { \
                m_data.field = val; \
                emit field##Changed(); \
            } \
        }

#define FIELD_PTR_PROP(type, field) \
    private: \
        Q_PROPERTY(type field READ field WRITE set_##field NOTIFY field##Changed) \
        type field() const { return m_data->field; } \
        void set_##field(type val) { \
            if (m_data->field != val) { \
                m_data->field = val; \
                emit field##Changed(); \
            } \
        }

#define FIELD_PROP_FLOAT(type, field) \
    private: \
        Q_PROPERTY(type field READ field WRITE set_##field NOTIFY field##Changed) \
        type field() const { return m_data.field; } \
        void set_##field(type val) { \
            m_data.field = val; \
            emit field##Changed(); \
        }

#define MODEL_PROP(type, name) \
    private: \
        Q_PROPERTY(type* name READ name CONSTANT) \
        type m_##name; \
        type* name() { return &m_##name; }

#define FIELD_SIGNAL(field) \
    void field##Changed();



namespace model {
class CollectionFilter: public QObject {
    Q_OBJECT
    FIELD_PTR_PROP(QString, regex)

public:
    explicit CollectionFilter(modeldata::CollectionFilter* const, QObject* parent = nullptr);

signals:
    // listing the signals manually because Moc is an idiot
    FIELD_SIGNAL(regex)

private:
    modeldata::CollectionFilter* m_data;

    MODEL_PROP(StringListModel, extensions)
    MODEL_PROP(StringListModel, files)
};


class Collection: public QObject {
    Q_OBJECT

    FIELD_PROP(QString, name)
    FIELD_PROP(QString, sortby)
    FIELD_PROP(QString, shortname)
    FIELD_PROP(QString, summary)
    FIELD_PROP(QString, description)

    FIELD_PROP(QString, launch_cmd)
    FIELD_PROP(QString, launch_workdir)

    FIELD_PROP(QVariantMap, assets)
    FIELD_PROP(QVariantMap, extra)

signals:
    FIELD_SIGNAL(name)
    FIELD_SIGNAL(sortby)
    FIELD_SIGNAL(shortname)
    FIELD_SIGNAL(summary)
    FIELD_SIGNAL(description)

    FIELD_SIGNAL(launch_cmd)
    FIELD_SIGNAL(launch_workdir)

    FIELD_SIGNAL(assets)
    FIELD_SIGNAL(extra)

public:
    explicit Collection(modeldata::Collection, QObject* parent = nullptr);

    const modeldata::Collection& data() const { return m_data; }

private:
    modeldata::Collection m_data;

    MODEL_PROP(StringListModel, directories)
    MODEL_PROP(CollectionFilter, include)
    MODEL_PROP(CollectionFilter, exclude)
};


class Game: public QObject {
    Q_OBJECT

    FIELD_PROP(QString, title)
    FIELD_PROP(QString, sortby)
    FIELD_PROP(QString, summary)
    FIELD_PROP(QString, description)

    FIELD_PROP(QString, launch_cmd)
    FIELD_PROP(QString, launch_workdir)

    FIELD_PROP(int, max_players)
    FIELD_PROP(int, release_year)
    FIELD_PROP(int, release_month)
    FIELD_PROP(int, release_day)
    FIELD_PROP_FLOAT(float, rating)

    FIELD_PROP(QVariantMap, assets)
    FIELD_PROP(QVariantMap, extra)

signals:
    FIELD_SIGNAL(title)
    FIELD_SIGNAL(sortby)
    FIELD_SIGNAL(summary)
    FIELD_SIGNAL(description)

    FIELD_SIGNAL(launch_cmd)
    FIELD_SIGNAL(launch_workdir)

    FIELD_SIGNAL(max_players)
    FIELD_SIGNAL(rating)
    FIELD_SIGNAL(release_year)
    FIELD_SIGNAL(release_month)
    FIELD_SIGNAL(release_day)

    FIELD_SIGNAL(assets)
    FIELD_SIGNAL(extra)

public:
    explicit Game(modeldata::Game, QObject* parent = nullptr);

    const modeldata::Game& data() const { return m_data; }

private:
    modeldata::Game m_data;

    MODEL_PROP(StringListModel, developers)
    MODEL_PROP(StringListModel, publishers)
    MODEL_PROP(StringListModel, genres)
    MODEL_PROP(StringListModel, files)
};
} // namespace model


#undef FIELD_PROP
#undef FIELD_PTR_PROP
#undef FIELD_SIGNAL
