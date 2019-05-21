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


#include "Metaformat.h"

#include "Metafile.h"
#include "MetaformatCollections.h"
#include "MetaformatGames.h"


namespace {
enum class ParsedBlockType: unsigned char {
    UNDEFINED,
    GAME,
    COLLECTION,
};
} // namespace


namespace metaformat {
bool parse(const QString& path, Entries& out, ErrorCB error_cb)
{
    auto parsed_block_type = ParsedBlockType::UNDEFINED;


    const auto on_entry = [&](const metafile::Entry& entry){
        if (entry.key == QLatin1String("collection")) {
            // TODO: Find next by name
            out.collections.emplace_back(new_collection(entry, error_cb));
            parsed_block_type = ParsedBlockType::COLLECTION;
            return;
        }
        if (entry.key == QLatin1String("game")) {
            // TODO: Find next by name
            out.games.emplace_back(new_game(entry, error_cb));
            parsed_block_type = ParsedBlockType::GAME;
            return;
        }

        switch (parsed_block_type) {
            case ParsedBlockType::UNDEFINED:
                error_cb(entry.line, QStringLiteral("no `collection` or `game` defined yet, entry ignored"));
                return;
            case ParsedBlockType::COLLECTION:
                Q_ASSERT(!out.collections.empty());
                parse_collection_entry(entry, out.collections.back(), error_cb);
                break;
            case ParsedBlockType::GAME:
                Q_ASSERT(!out.games.empty());
                parse_game_entry(entry, out.games.back(), error_cb);
                break;
        }
    };
    const auto on_error = [&](const metafile::Error& error) {
        error_cb(error.line, error.message);
    };


    return metafile::read_file(path, on_entry, on_error);
}
} // namespace metaformat
