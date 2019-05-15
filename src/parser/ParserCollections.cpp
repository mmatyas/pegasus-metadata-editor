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


#include "ParserCollections.h"

#include "ParserAssets.h"
#include "ParserUtils.h"

#include <QString>
#include <QVector>


namespace parser {
modeldata::Collection new_collection(const metafile::Entry& entry, ErrorCB error_cb)
{
    modeldata::Collection coll;
    coll.name = first_line_of(entry, error_cb);
    return coll;
}

void parse_collection_entry(const metafile::Entry& entry, modeldata::Collection& collection, ErrorCB error_cb)
{
    if (parse_asset_entry_maybe(entry, collection.assets, error_cb))
        return;

    if (entry.key.startsWith(QLatin1String("x-"))) {
        collection.extra[entry.key.mid(2)] = metafile::merge_lines(entry.values);
        return;
    }

    SINGLE_VALUE(shortname, collection.shortname)
    MERGED_TEXT(summary, collection.summary)
    MERGED_TEXT(description, collection.description)

    SINGLE_VALUE(launch, collection.launch_cmd)
    SINGLE_VALUE(command, collection.launch_cmd)
    SINGLE_VALUE(workdir, collection.launch_workdir)
    SINGLE_VALUE(cwd, collection.launch_workdir)

    MULTI_VALUE(directory, collection.directories);
    MULTI_VALUE(directories, collection.directories);

    MULTI_VALUE(file, collection.include.files);
    MULTI_VALUE(files, collection.include.files);
    MULTI_VALUE(ignore-file, collection.exclude.files);
    MULTI_VALUE(ignore-files, collection.exclude.files);

    SINGLE_VALUE(regex, collection.include.regex)
    SINGLE_VALUE(ignore-regex, collection.exclude.regex)

    EXT_LIST(extension, collection.include.extensions)
    EXT_LIST(extensions, collection.include.extensions)
    EXT_LIST(ignore-extension, collection.exclude.extensions)
    EXT_LIST(ignore-extensions, collection.exclude.extensions)

    error_cb(entry.line, QStringLiteral("Unknown attribute `%1`").arg(entry.key));
}
} // namespace parser
