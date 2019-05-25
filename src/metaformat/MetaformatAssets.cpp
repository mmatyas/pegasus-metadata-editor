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


#include "MetaformatAssets.h"

#include "MetaformatUtils.h"


namespace {
static const auto ASSET_PREFIX(QStringLiteral("assets."));

bool is_multiasset(const QString& asset_key)
{
    return asset_key == QLatin1String("video")
        || asset_key == QLatin1String("videos")
        || asset_key == QLatin1String("screenshot")
        || asset_key == QLatin1String("screenshots");
}
} // namespace


namespace metaformat {
bool parse_asset_entry_maybe(const metafile::Entry& entry, QVariantMap& assets, ParseErrorCB error_cb)
{
    if (!entry.key.startsWith(ASSET_PREFIX))
        return false;

    QString asset_key = entry.key.mid(ASSET_PREFIX.length());
    QString asset_val;

    if (is_multiasset(asset_key)) {
        // TODO: reserve
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
        asset_val = first_line_of(entry, error_cb);
    }

    assets.insert(asset_key, asset_val);
    return true;
}

QStringList render_assets(const QVariantMap& map)
{
    QStringList out;

    for (auto it = map.cbegin(); it != map.cend(); ++it)
        out.append(ASSET_PREFIX + it.key() + QStringLiteral(": ") + it.value().toString());

    return out;
}
} // namespace metaformat
