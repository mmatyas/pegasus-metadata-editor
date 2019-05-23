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


#include "MetaformatGames.h"

#include "MetaformatAssets.h"
#include "MetaformatUtils.h"

#include <QRegularExpression>
#include <cmath>


namespace {
void try_parse_players(const metafile::Entry& entry, int& target, metaformat::ParseErrorCB error_cb)
{
    static const QRegularExpression rx(QStringLiteral("^(\\d+)(-(\\d+))?$"));
    Q_ASSERT(rx.isValid());

    const QRegularExpressionMatch rx_match = rx.match(metaformat::first_line_of(entry, error_cb));
    if (rx_match.hasMatch()) {
        Q_ASSERT(!rx_match.captured(1).isEmpty());
        target = rx_match.captured(1).toInt();
        if (!rx_match.captured(3).isEmpty())
            target = std::max(target, rx_match.captured(3).toInt());

        return;
    }

    error_cb(entry.line,
        QStringLiteral("incorrect player count, should be a single number or a number range."));
}

void try_parse_date(const metafile::Entry& entry, int& year, int& month, int& day, metaformat::ParseErrorCB error_cb)
{
    static const QRegularExpression rx(QStringLiteral("^(\\d{4})(-(\\d{1,2}))?(-(\\d{1,2}))?$"));
    Q_ASSERT(rx.isValid());

    const QRegularExpressionMatch rx_match = rx.match(metaformat::first_line_of(entry, error_cb));
    if (rx_match.hasMatch()) {
        year = rx_match.captured(1).toInt();

        if (!rx_match.captured(3).isEmpty())
            month = qBound(1, rx_match.captured(3).toInt(), 12);

        if (!rx_match.captured(5).isEmpty())
            day = qBound(1, rx_match.captured(5).toInt(), 12);

        return;
    }

    error_cb(entry.line, QStringLiteral("incorrect date format, should be YYYY, YYYY-MM or YYYY-MM-DD."));
}

void try_parse_rating(const metafile::Entry& entry, float& target, metaformat::ParseErrorCB error_cb)
{
    static const QRegularExpression rx_percent(QStringLiteral("^\\d+%$"));
    static const QRegularExpression rx_float(QStringLiteral("^\\d(\\.\\d+)?$"));
    Q_ASSERT(rx_percent.isValid());
    Q_ASSERT(rx_float.isValid());

    const QString rating_str = metaformat::first_line_of(entry, error_cb);

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
        QStringLiteral("incorrect rating value, should be a percentage or a floating-point value."));
}
} // namespace


namespace metaformat {
modeldata::Game new_game(const metafile::Entry& entry, ParseErrorCB error_cb)
{
    modeldata::Game game;
    game.title = first_line_of(entry, error_cb);
    return game;
}

void parse_game_entry(const metafile::Entry& entry, modeldata::Game& game, ParseErrorCB error_cb)
{
    if (parse_asset_entry_maybe(entry, game.assets, error_cb))
        return;

    if (entry.key.startsWith(QLatin1String("x-"))) {
        game.extra[entry.key] = metaformat::join(entry.values);
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

    TEXT_LINES(summary, game.summary)
    TEXT_LINES(description, game.description)

    SINGLE_VALUE(launch, game.launch_cmd)
    SINGLE_VALUE(command, game.launch_cmd)
    SINGLE_VALUE(workdir, game.launch_workdir)
    SINGLE_VALUE(cwd, game.launch_workdir)

    if (entry.key == QLatin1String("players")) {
        try_parse_players(entry, game.max_players, error_cb);
        return;
    }
    if (entry.key == QLatin1String("release")) {
        try_parse_date(entry, game.release_year, game.release_month, game.release_day, error_cb);
        return;
    }
    if (entry.key == QLatin1String("rating")) {
        try_parse_rating(entry, game.rating, error_cb);
        return;
    }

    error_cb(entry.line, QStringLiteral("Unknown attribute `%1`.").arg(entry.key));
}

QString render_game(const modeldata::Game& data, WriteErrorCB error_cb)
{
    if (data.title.isEmpty()) {
        error_cb(QStringLiteral("Game #%1 has no name, entry ignored."));
        return QString();
    }

    QStringList lines;
    lines.append(QStringLiteral("game: ") + data.title);

    RENDER_LIST(file, files, files)

    RENDER_TEXT(summary, summary)
    RENDER_TEXT(description, description)

    RENDER_LIST(developer, developers, developers)
    RENDER_LIST(publisher, publishers, developers)
    RENDER_LIST(genre, genres, genres)

    if (data.release_year) {
        QString date_str = QString::number(data.release_year);

        if (data.release_month) {
            date_str += QChar('-');
            if (data.release_month < 10)
                date_str += QChar('0');

            date_str += QString::number(data.release_month);

            if (data.release_day) {
                date_str += QChar('-');
                if (data.release_day < 10)
                    date_str += QChar('0');

                date_str += QString::number(data.release_day);
            }
        }
        lines.append(QStringLiteral("release: ") + date_str);
    }

    if (data.max_players)
        lines.append(QStringLiteral("players: ") + QString::number(data.max_players));

    if (data.rating > 0.0001f) {
        const int percent = static_cast<int>(std::roundf(data.rating * 100.f));
        lines.append(QStringLiteral("rating: ") + QString::number(percent) + QChar('%'));
    }

    RENDER_SINGLE(launch, launch_cmd)
    RENDER_SINGLE(workdir, launch_workdir)

    lines.append(render_assets(data.assets));

    for (auto it = data.extra.cbegin(); it != data.extra.cend(); ++it)
        lines.append(it.key() + QStringLiteral(": ") + it.value().toString());

    return lines.join(QChar('\n'));
}
} // namespace metaformat
