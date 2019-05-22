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


#include "MetaformatCollections.h"

#include "MetaformatAssets.h"
#include "MetaformatUtils.h"

#include <QString>
#include <QVector>


namespace metaformat {
modeldata::Collection new_collection(const metafile::Entry& entry, ParseErrorCB error_cb)
{
    modeldata::Collection coll;
    coll.name = first_line_of(entry, error_cb);
    return coll;
}

void parse_collection_entry(const metafile::Entry& entry, modeldata::Collection& collection, ParseErrorCB error_cb)
{
    if (parse_asset_entry_maybe(entry, collection.assets, error_cb))
        return;

    if (entry.key.startsWith(QLatin1String("x-"))) {
        collection.extra[entry.key] = metaformat::join(entry.values);
        return;
    }

    SINGLE_VALUE(shortname, collection.shortname)
    TEXT_LINES(summary, collection.summary)
    TEXT_LINES(description, collection.description)

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

    error_cb(entry.line, QStringLiteral("Unknown attribute `%1`.").arg(entry.key));
}

QString render_collection(const modeldata::Collection& data, WriteErrorCB error_cb)
{
    if (data.name.isEmpty()) {
        error_cb(QStringLiteral("Collection #%1 has no name, entry ignored."));
        return QString();
    }

    QStringList lines;
    lines.append(QStringLiteral("collection: ") + data.name);

    RENDER_SINGLE(shortname, shortname)
    RENDER_TEXT(summary, summary)
    RENDER_TEXT(description, description)

    RENDER_LIST(directory, directories, directories)

    RENDER_EXTS(extension, extensions, include.extensions)
    RENDER_LIST(file, files, include.files)
    RENDER_SINGLE(regex, include.regex)

    RENDER_EXTS(ignore-extension, ignore-extensions, exclude.extensions)
    RENDER_LIST(ignore-file, ignore-files, exclude.files)
    RENDER_SINGLE(ignore-regex, exclude.regex)

    RENDER_SINGLE(launch, launch_cmd)
    RENDER_SINGLE(workdir, launch_workdir)

    lines.append(render_assets(data.assets));

    for (auto it = data.extra.cbegin(); it != data.extra.cend(); ++it)
        lines.append(it.key() + QStringLiteral(": ") + it.value().toString());

    return lines.join(QChar('\n'));
}
} // namespace metaformat
