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

#include "Metafile.h"
#include "ParserErrorCB.h"

#include <QString>


#define SINGLE_VALUE(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        target = first_line_of(entry, error_cb); \
        return; \
    }
#define MERGED_TEXT(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        target = metafile::merge_lines(entry.values); \
        replace_newlines(target); \
        return; \
    }
#define MULTI_VALUE(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        target.reserve(target.size() + static_cast<int>(entry.values.size())); \
        std::copy(entry.values.begin(), entry.values.end(), std::back_inserter(target)); \
        return; \
    }
#define EXT_LIST(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        QVector<QStringRef> extrefs = first_line_of(entry, error_cb) \
            .toLower() \
            .splitRef(QChar(',')); \
    \
        target.reserve(target.size() + extrefs.size()); \
        for (const QStringRef& extref : extrefs) \
            target.append(extref.trimmed().toString()); \
    \
        return; \
    }


namespace parser {
QString first_line_of(const metafile::Entry&, ErrorCB);
void replace_newlines(QString&);
} // namespace parser
