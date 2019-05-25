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


#include "MetaformatUtils.h"

#include <QRegularExpression>


namespace {
int qstrlen_accumulator(const int acc, const QString& str)
{
    return acc + str.length();
}
} // namespace


namespace metaformat {
QString first_line_of(const metafile::Entry& entry, ParseErrorCB error_cb) {
    Q_ASSERT(!entry.key.isEmpty());
    Q_ASSERT(!entry.values.empty());

    if (entry.values.size() > 1) {
        error_cb(entry.line,
            QStringLiteral("expected single line value for `%1` but got more. "
                "The rest of the lines will be ignored.").arg(entry.key));
    }

    return entry.values.front();
};

QString join(const std::vector<QString>& vec)
{
    if (vec.empty())
        return QString();

    const int newline_cnt = static_cast<int>(vec.size()) - 1;
    const int out_len = std::accumulate(vec.cbegin(), vec.cend(), newline_cnt, qstrlen_accumulator);

    QString out(vec.front());
    out.reserve(out_len);

    for (auto it = ++vec.cbegin(); it != vec.cend(); ++it) {
        out.append(QChar('\n'));
        out.append(*it);
    }

    return out;
}
} // namespace metaformat
