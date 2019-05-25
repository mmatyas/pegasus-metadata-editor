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


#pragma once

#include "Metafile.h"
#include "MetaformatErrorCB.h"

#include <QString>
#include <QVector>


#define SINGLE_VALUE(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        target = first_line_of(entry, error_cb); \
        return; \
    }
#define TEXT_LINES(name, target) \
    if (entry.key == QLatin1String(#name)) { \
        target = metaformat::join(entry.values); \
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
        QString line_lower = first_line_of(entry, error_cb).toLower(); \
        QVector<QStringRef> extrefs = line_lower.splitRef(QChar(',')); \
    \
        target.reserve(target.size() + extrefs.size()); \
        for (const QStringRef& extref : extrefs) \
            target.append(extref.trimmed().toString()); \
    \
        return; \
    }


#define RENDER_SINGLE(name, field) \
    if (!data.field.isEmpty()) { \
        lines.append(QStringLiteral(#name ": ") + data.field); \
    }
#define RENDER_TEXT(name, field) \
    if (!data.field.isEmpty()) { \
        lines.append(QStringLiteral(#name ":")); \
        const QVector<QStringRef> sublines = data.field.splitRef(QChar('\n')); \
        for (const QStringRef& ref : sublines) \
            if (ref.isEmpty()) \
                lines.append(QStringLiteral("  .")); \
            else \
                lines.append(QStringLiteral("  ") + ref); \
    }
#define RENDER_LIST(name_single, name_multi, field) \
    if (data.field.size() == 1) { \
        lines.append(QStringLiteral(#name_single ": ") + data.field.first()); \
    } \
    if (data.field.size() > 1) { \
        lines.append(QStringLiteral(#name_multi ":")); \
        for (const QString& entry : data.field) \
            lines.append(QStringLiteral("  ") + entry); \
    }
#define RENDER_EXTS(name_single, name_multi, field) \
    if (!data.field.empty()) { \
        const QString merged = data.field.join(QLatin1String(", ")); \
        if (data.field.size() == 1) \
            lines.append(QStringLiteral(#name_single ": ") + merged); \
        else \
            lines.append(QStringLiteral(#name_multi ": ") + merged); \
    }


namespace metaformat {
QString first_line_of(const metafile::Entry&, ParseErrorCB);
QString join(const std::vector<QString>&);
} // namespace metaformat
