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


#include "ModelData.h"


namespace modeldata {

CollectionFilter::CollectionFilter() = default;
Collection::Collection() = default;

Game::Game()
    : rating(0.0)
    , max_players(1)
    , release_year(0)
    , release_month(0)
    , release_day(0)
{}

} // namespace modeldata
