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


#include "Model.h"


#define BIND_MODEL_PTR(field) \
    connect(&m_##field, &StringListModel::dataChanged, \
            this, [this](){ m_data->field = m_##field.stringList(); }); \
    connect(&m_##field, &StringListModel::rowsRemoved, \
            this, [this](){ m_data->field = m_##field.stringList(); });

#define BIND_MODEL(field) \
    connect(&m_##field, &StringListModel::dataChanged, \
            this, [this](){ m_data.field = m_##field.stringList(); }); \
    connect(&m_##field, &StringListModel::rowsRemoved, \
            this, [this](){ m_data.field = m_##field.stringList(); });


namespace model {

CollectionFilter::CollectionFilter(modeldata::CollectionFilter* const data, QObject* parent)
    : QObject(parent)
    , m_data(data)
    , m_extensions(m_data->extensions)
    , m_files(m_data->files)
{
    Q_ASSERT(m_data);
    BIND_MODEL_PTR(extensions)
    BIND_MODEL_PTR(files)
}


Collection::Collection(modeldata::Collection data, QObject* parent)
    : QObject(parent)
    , m_data(std::move(data))
    , m_directories(m_data.directories)
    , m_include(&m_data.include)
    , m_exclude(&m_data.exclude)
{
    BIND_MODEL(directories)
}


Game::Game(modeldata::Game data, QObject* parent)
    : QObject(parent)
    , m_data(std::move(data))
    , m_developers(m_data.developers)
    , m_publishers(m_data.publishers)
    , m_genres(m_data.genres)
    , m_files(m_data.files)
{
    BIND_MODEL(developers)
    BIND_MODEL(publishers)
    BIND_MODEL(genres)
    BIND_MODEL(files)
}

} // namespace model
