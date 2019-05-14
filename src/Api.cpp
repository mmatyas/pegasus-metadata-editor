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


#include "Api.h"

#include "parser/Metafile.h"

#include <QRegularExpression>


namespace {

enum class ParsedBlockType: unsigned char {
    UNDEFINED,
    GAME,
    COLLECTION,
};


void print_line_error(const size_t line, const QString& message, QStringList& errors)
{
    errors += QStringLiteral("Line %1: %2").arg(QString::number(line), message);
}

QString first_line_of(const metafile::Entry& entry, QStringList& errors) {
    Q_ASSERT(!entry.key.isEmpty());
    Q_ASSERT(!entry.values.empty());

    if (entry.values.size() > 1) {
        print_line_error(
            entry.line,
            QStringLiteral("expected single line value for `%1` but got more. "
                "The rest of the lines will be ignored.").arg(entry.key),
            errors
        );
    }

    return entry.values.front();
};

bool is_multiasset(const QString& asset_key)
{
    return asset_key == QLatin1String("video")
        || asset_key == QLatin1String("videos")
        || asset_key == QLatin1String("screenshot")
        || asset_key == QLatin1String("screenshots");
}

void replace_newlines(QString& text)
{
    static const QRegularExpression rx(QStringLiteral("([^\\\\])?\\n +"));
    Q_ASSERT(rx.isValid());
    text.replace(rx, QStringLiteral("\\1\\n"));
}


bool parse_asset_entry_maybe(const metafile::Entry& entry, QVariantMap& assets, QStringList& errors)
{
    static const auto ASSET_PREFIX = QStringLiteral("assets.");

    if (!entry.key.startsWith(ASSET_PREFIX))
        return false;

    QString asset_key = entry.key.mid(ASSET_PREFIX.length());
    QString asset_val;

    if (is_multiasset(asset_key)) {
        // join
        asset_val = entry.values.front();
        for (auto it = ++entry.values.cbegin(); it != entry.values.cend(); ++it) {
            asset_val += QChar('\n');
            asset_val += *it;
        }
        // pluralize
        if (!asset_key.endsWith(QChar('s')))
            asset_key += QChar('s');
    }
    else {
        asset_val = first_line_of(entry, errors);
    }

    assets.insert(asset_key, asset_val);
    return true;
}


void parse_collection_entry(const metafile::Entry& entry, modeldata::Collection& collection, QStringList& errors)
{
    if (entry.key.startsWith(QLatin1String("x-"))) {
        collection.extra[entry.key.mid(2)] = metafile::merge_lines(entry.values);
        return;
    }

    if (entry.key == QLatin1String("shortname")) {
        collection.shortname = first_line_of(entry, errors);
        return;
    }
    if (entry.key == QLatin1String("summary")) {
        collection.summary = metafile::merge_lines(entry.values);
        replace_newlines(collection.summary);
        return;
    }
    if (entry.key == QLatin1String("description")) {
        collection.description = metafile::merge_lines(entry.values);
        replace_newlines(collection.description);
        return;
    }
    if (entry.key == QLatin1String("launch") || entry.key == QLatin1String("command")) {
        collection.launch_cmd = metafile::merge_lines(entry.values);
        return;
    }
    if (entry.key == QLatin1String("workdir") || entry.key == QLatin1String("cwd")) {
        collection.launch_workdir = first_line_of(entry, errors);
        return;
    }
    if (entry.key == QLatin1String("directory") || entry.key == QLatin1String("directories")) {
        collection.directories.reserve(collection.directories.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(collection.directories));
        return;
    }
    if (entry.key == QLatin1String("extension") || entry.key == QLatin1String("extensions")) {
        QVector<QStringRef> extrefs = first_line_of(entry, errors)
            .toLower()
            .splitRef(QChar(','));

        collection.include.exts.reserve(collection.include.exts.size() + extrefs.size());
        for (const QStringRef& extref : extrefs)
            collection.include.exts.append(extref.trimmed().toString());

        return;
    }
    if (entry.key == QLatin1String("file") || entry.key == QLatin1String("files")) {
        collection.include.files.reserve(collection.directories.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(collection.include.files));
        return;
    }
    if (entry.key == QLatin1String("regex")) {
        collection.include.regex = first_line_of(entry, errors);
        return;
    }
    // FIXME: remove duplication
    if (entry.key == QLatin1String("ignore-extension") || entry.key == QLatin1String("ignore-extensions")) {
        QVector<QStringRef> extrefs = first_line_of(entry, errors)
            .toLower()
            .splitRef(QChar(','));

        collection.exclude.exts.reserve(collection.include.exts.size() + extrefs.size());
        for (const QStringRef& extref : extrefs)
            collection.exclude.exts.append(extref.trimmed().toString());

        return;
    }
    if (entry.key == QLatin1String("ignore-file") || entry.key == QLatin1String("ignore-files")) {
        collection.exclude.files.reserve(collection.directories.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(collection.exclude.files));
        return;
    }
    if (entry.key == QLatin1String("ignore-regex")) {
        collection.exclude.regex = first_line_of(entry, errors);
        return;
    }

    print_line_error(entry.line, QStringLiteral("Unknown attribute `%1`").arg(entry.key), errors);
}

void parse_game_entry(const metafile::Entry& entry, modeldata::Game& game, QStringList& errors)
{
    if (entry.key.startsWith(QLatin1String("x-"))) {
        game.extra[entry.key.mid(2)] = metafile::merge_lines(entry.values);
        return;
    }
    if (entry.key == QLatin1String("file") || entry.key == QLatin1String("files")) {
        game.files.reserve(game.files.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(game.files));
        return;
    }
    if (entry.key == QLatin1String("developer") || entry.key == QLatin1String("developers")) {
        game.developers.reserve(game.developers.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(game.developers));
        return;
    }
    if (entry.key == QLatin1String("publisher") || entry.key == QLatin1String("publishers")) {
        game.publishers.reserve(game.publishers.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(game.publishers));
        return;
    }
    if (entry.key == QLatin1String("genre") || entry.key == QLatin1String("genres")) {
        game.genres.reserve(game.genres.size() + static_cast<int>(entry.values.size()));
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(game.genres));
        return;
    }
    if (entry.key == QLatin1String("summary")) {
        game.summary = metafile::merge_lines(entry.values);
        replace_newlines(game.summary);
        return;
    }
    if (entry.key == QLatin1String("description")) {
        game.description = metafile::merge_lines(entry.values);
        replace_newlines(game.description);
        return;
    }
    if (entry.key == QLatin1String("players")) {
        static const QRegularExpression rx(QStringLiteral("^(\\d+)(-(\\d+))?$"));
        Q_ASSERT(rx.isValid());

        const QRegularExpressionMatch rx_match = rx.match(first_line_of(entry, errors));
        if (rx_match.hasMatch()) {
            if (!rx_match.captured(1).isEmpty())
                game.max_players = rx_match.captured(1).toInt();
            if (!rx_match.captured(3).isEmpty())
                game.max_players = std::max(game.max_players, rx_match.captured(3).toInt());
        }
        return;
    }
    if (entry.key == QLatin1String("release")) {
        static const QRegularExpression rx(QStringLiteral("^(\\d{4})(-(\\d{1,2}))?(-(\\d{1,2}))?$"));
        Q_ASSERT(rx.isValid());

        const QRegularExpressionMatch rx_match = rx.match(first_line_of(entry, errors));
        if (rx_match.hasMatch()) {
            const int y = rx_match.captured(1).toInt();

            int m = 1;
            if (!rx_match.captured(3).isEmpty())
                m = qBound(1, rx_match.captured(3).toInt(), 12);

            int d = 1;
            if (!rx_match.captured(5).isEmpty())
                m = qBound(1, rx_match.captured(5).toInt(), 12);

            game.release_date.setDate(y, m, d);
            return;
        }

        print_line_error(entry.line,
            QStringLiteral("incorrect date format, should be YYYY, YYYY-MM or YYYY-MM-DD"), errors);
        return;
    }
    if (entry.key == QLatin1String("rating")) {
        static const QRegularExpression rx_percent(QStringLiteral("^\\d+%$"));
        static const QRegularExpression rx_float(QStringLiteral("^\\d(\\.\\d+)?$"));
        Q_ASSERT(rx_percent.isValid());
        Q_ASSERT(rx_float.isValid());

        const QString rating_str = first_line_of(entry, errors);

        QRegularExpressionMatch rx_match = rx_percent.match(rating_str);
        if (rx_match.hasMatch()) {
            const float float_val = rating_str.leftRef(rating_str.length() - 1).toFloat();
            game.rating = qBound(0.f, float_val / 100.f, 1.f);
            return;
        }

        rx_match = rx_percent.match(rating_str);
        if (rx_match.hasMatch()) {
            bool success = false;
            const float float_val = rating_str.toFloat(&success);
            if (success)
                game.rating = qBound(0.f, float_val, 1.f);
            return;
        }

        print_line_error(entry.line,
            QStringLiteral("failed to parse rating value"), errors);
        return;
    }
    if (entry.key == QLatin1String("launch") || entry.key == QLatin1String("command")) {
        game.launch_cmd = first_line_of(entry, errors);
        return;
    }
    if (entry.key == QLatin1String("workdir") || entry.key == QLatin1String("cwd")) {
        game.launch_workdir = first_line_of(entry, errors);
        return;
    }

    print_line_error(entry.line, QStringLiteral("Unknown attribute `%1`").arg(entry.key), errors);
}
} // namespace


Api::Api(QObject* parent)
    : QObject(parent)
{
}

void Api::openFile(QString path)
{
    QStringList errors;
    auto parsed_block_type = ParsedBlockType::UNDEFINED;

    std::vector<modeldata::Game> games;
    std::vector<modeldata::Collection> collections;



    const auto on_entry = [&](const metafile::Entry& entry){
        if (entry.key == QLatin1String("collection")) {
            const QString& name = first_line_of(entry, errors);

            // Find next by name

            parsed_block_type = ParsedBlockType::COLLECTION;

            collections.emplace_back();
            collections.back().name = name;
            return;
        }
        if (entry.key == QLatin1String("game")) {
            const QString& title = first_line_of(entry, errors);

            // Find next by name

            parsed_block_type = ParsedBlockType::GAME;

            games.emplace_back();
            games.back().title = title;
            return;
        }

        switch (parsed_block_type) {
            case ParsedBlockType::UNDEFINED:
                print_line_error(entry.line, QStringLiteral("no `collection` or `game` defined yet, entry ignored"), errors);
                return;
            case ParsedBlockType::COLLECTION:
                Q_ASSERT(!collections.empty());
                if (parse_asset_entry_maybe(entry, collections.back().assets, errors))
                    return;

                parse_collection_entry(entry, collections.back(), errors);
                break;
            case ParsedBlockType::GAME:
                Q_ASSERT(!games.empty());
                if (parse_asset_entry_maybe(entry, games.back().assets, errors))
                    return;

                parse_game_entry(entry, games.back(), errors);
                break;
        }
    };
    const auto on_error = [&](const metafile::Error& error) {
        print_line_error(error.line, error.message, errors);
    };


    if (!metafile::read_file(path, on_entry, on_error)) {
        m_error_log = QStringLiteral("Error: Could not open the file");
        emit errorLogChanged();
        return;
    }

    m_error_log = errors.join(QChar('\n'));
    emit errorLogChanged();


    {
        QVector<model::Collection*> new_colls;
        new_colls.reserve(static_cast<int>(collections.size()));

        for (modeldata::Collection& colldata : collections)
            new_colls.append(new model::Collection(std::move(colldata)));

        m_collections.clear();
        m_collections.append(new_colls);
    }{
        QVector<model::Game*> new_games;
        new_games.reserve(static_cast<int>(games.size()));

        for (modeldata::Game& gamedata : games)
            new_games.append(new model::Game(std::move(gamedata)));

        m_games.clear();
        m_games.append(new_games);
    }
}
