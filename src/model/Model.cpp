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


#include "Model.h"


namespace model {

CollectionFilter::CollectionFilter(modeldata::CollectionFilter* const data, QObject* parent)
    : QObject(parent)
    , m_data(data)
{
    Q_ASSERT(m_data);
}


Collection::Collection(modeldata::Collection data, QObject* parent)
    : QObject(parent)
    , m_data(std::move(data))
    , m_filter_include(&m_data.include)
    , m_filter_exclude(&m_data.exclude)
{}


Game::Game(modeldata::Game data, QObject* parent)
    : QObject(parent)
    , m_data(std::move(data))
{}

} // namespace model
