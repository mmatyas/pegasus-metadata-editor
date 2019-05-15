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


#include "ParserUtils.h"

#include <QRegularExpression>


namespace parser {
QString first_line_of(const metafile::Entry& entry, ErrorCB error_cb) {
    Q_ASSERT(!entry.key.isEmpty());
    Q_ASSERT(!entry.values.empty());

    if (entry.values.size() > 1) {
        error_cb(entry.line,
            QStringLiteral("expected single line value for `%1` but got more. "
                "The rest of the lines will be ignored.").arg(entry.key));
    }

    return entry.values.front();
};

void replace_newlines(QString& text)
{
    static const QRegularExpression rx(QStringLiteral("([^\\\\])?\\n +"));
    Q_ASSERT(rx.isValid());
    text.replace(rx, QStringLiteral("\\1\\n"));
}
} // namespace parser
