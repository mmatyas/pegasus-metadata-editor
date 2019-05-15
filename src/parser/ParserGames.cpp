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


#include "ParserGames.h"

#include "ParserAssets.h"
#include "ParserUtils.h"

#include <QRegularExpression>


namespace {
void try_parse_players(const metafile::Entry& entry, int& target, ErrorCB error_cb)
{
    static const QRegularExpression rx(QStringLiteral("^(\\d+)(-(\\d+))?$"));
    Q_ASSERT(rx.isValid());

    const QRegularExpressionMatch rx_match = rx.match(parser::first_line_of(entry, error_cb));
    if (rx_match.hasMatch()) {
        Q_ASSERT(!rx_match.captured(1).isEmpty());
        target = rx_match.captured(1).toInt();
        if (!rx_match.captured(3).isEmpty())
            target = std::max(target, rx_match.captured(3).toInt());
    }

    error_cb(entry.line,
        QStringLiteral("incorrect player count, should be a single number or a number range"));
}

void try_parse_date(const metafile::Entry& entry, QDate& target, ErrorCB error_cb)
{
    static const QRegularExpression rx(QStringLiteral("^(\\d{4})(-(\\d{1,2}))?(-(\\d{1,2}))?$"));
    Q_ASSERT(rx.isValid());

    const QRegularExpressionMatch rx_match = rx.match(parser::first_line_of(entry, error_cb));
    if (rx_match.hasMatch()) {
        const int y = rx_match.captured(1).toInt();

        int m = 1;
        if (!rx_match.captured(3).isEmpty())
            m = qBound(1, rx_match.captured(3).toInt(), 12);

        int d = 1;
        if (!rx_match.captured(5).isEmpty())
            m = qBound(1, rx_match.captured(5).toInt(), 12);

        target.setDate(y, m, d);
        return;
    }

    error_cb(entry.line, QStringLiteral("incorrect date format, should be YYYY, YYYY-MM or YYYY-MM-DD"));
}

void try_parse_rating(const metafile::Entry& entry, float& target, ErrorCB error_cb)
{
    static const QRegularExpression rx_percent(QStringLiteral("^\\d+%$"));
    static const QRegularExpression rx_float(QStringLiteral("^\\d(\\.\\d+)?$"));
    Q_ASSERT(rx_percent.isValid());
    Q_ASSERT(rx_float.isValid());

    const QString rating_str = parser::first_line_of(entry, error_cb);

    QRegularExpressionMatch rx_match = rx_percent.match(rating_str);
    if (rx_match.hasMatch()) {
        const float float_val = rating_str.leftRef(rating_str.length() - 1).toFloat();
        target = qBound(0.f, float_val / 100.f, 1.f);
        return;
    }

    rx_match = rx_percent.match(rating_str);
    if (rx_match.hasMatch()) {
        bool success = false;
        const float float_val = rating_str.toFloat(&success);
        if (success)
            target = qBound(0.f, float_val, 1.f);
        return;
    }

    error_cb(entry.line,
        QStringLiteral("incorrect rating value, should be a percentage or a floating-point value"));
}
} // namespace


namespace parser {
modeldata::Game new_game(const metafile::Entry& entry, ErrorCB error_cb)
{
    modeldata::Game game;
    game.title = first_line_of(entry, error_cb);
    return game;
}

void parse_game_entry(const metafile::Entry& entry, modeldata::Game& game, ErrorCB error_cb)
{
    if (parse_asset_entry_maybe(entry, game.assets, error_cb))
        return;

    if (entry.key.startsWith(QLatin1String("x-"))) {
        game.extra[entry.key.mid(2)] = metafile::merge_lines(entry.values);
        return;
    }

    MULTI_VALUE(file, game.files)
    MULTI_VALUE(files, game.files)

    MULTI_VALUE(developer, game.developers)
    MULTI_VALUE(developers, game.developers)
    MULTI_VALUE(publisher, game.publishers)
    MULTI_VALUE(publishers, game.publishers)
    MULTI_VALUE(genre, game.genres)
    MULTI_VALUE(genres, game.genres)

    MERGED_TEXT(summary, game.summary)
    MERGED_TEXT(description, game.description)

    SINGLE_VALUE(launch, game.launch_cmd)
    SINGLE_VALUE(command, game.launch_cmd)
    SINGLE_VALUE(workdir, game.launch_workdir)
    SINGLE_VALUE(cwd, game.launch_workdir)

    if (entry.key == QLatin1String("players")) {
        try_parse_players(entry, game.max_players, error_cb);
        return;
    }
    if (entry.key == QLatin1String("release")) {
        try_parse_date(entry, game.release_date, error_cb);
        return;
    }
    if (entry.key == QLatin1String("rating")) {
        try_parse_rating(entry, game.rating, error_cb);
        return;
    }

    error_cb(entry.line, QStringLiteral("Unknown attribute `%1`").arg(entry.key));
}
} // namespace parser
