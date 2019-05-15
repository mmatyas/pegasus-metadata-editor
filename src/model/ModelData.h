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

#include "utils/MoveOnly.h"

#include <QDate>
#include <QString>
#include <QStringList>
#include <QVariantMap>


namespace modeldata {

struct CollectionFilter {
    QStringList extensions;
    QStringList files;
    QString regex;

    CollectionFilter();
    MOVE_ONLY(CollectionFilter)
};

struct Collection {
    QString name;
    QString shortname;
    QString summary;
    QString description;

    QStringList directories;
    CollectionFilter include;
    CollectionFilter exclude;

    QString launch_cmd;
    QString launch_workdir;

    QVariantMap assets;
    QVariantMap extra;

    Collection();
    MOVE_ONLY(Collection)
};

struct Game {
    QString title;
    QString summary;
    QString description;

    QString launch_cmd;
    QString launch_workdir;

    int max_players;
    float rating;
    QDate release_date;

    QStringList developers;
    QStringList publishers;
    QStringList genres;

    QStringList files;
    QVariantMap assets;
    QVariantMap extra;

    Game();
    MOVE_ONLY(Game)
};

} // namespace modeldata
