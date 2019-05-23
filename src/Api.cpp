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

#include "metaformat/Metaformat.h"


namespace {
void build_qml_layer(metaformat::Entries& data, Api& api)
{
#define GENERATE(type, field) \
    { \
        QVector<model::type*> new_##field; \
        new_##field.reserve(static_cast<int>(data.field.size())); \
        \
        for (modeldata::type& dataitem : data.field) \
            new_##field.append(new model::type(std::move(dataitem))); \
        \
        api.field()->clear(); \
        api.field()->append(new_##field); \
    }

    GENERATE(Collection, collections)
    GENERATE(Game, games)

#undef GENERATE
}
} // namespace


Api::Api(QObject* parent)
    : QObject(parent)
    , m_has_document(false)
{}

void Api::newDocument()
{
    m_error_log.clear();
    emit errorLogChanged();

    m_file_path.clear();
    emit filePathChanged();

    m_collections.clear();
    m_games.clear();
    emit openSuccess();

    m_has_document = true;
    emit hasDocumentChanged();
}

void Api::openFile(QString path)
{
    Q_ASSERT(!path.isEmpty());
    if (path.isEmpty())
        return;

    QStringList errors;
    const auto render_line_error = [&errors](const size_t linenum, const QString& message) {
        errors += QStringLiteral("Line %1: %2").arg(QString::number(linenum), message);
    };

    metaformat::Entries parsed;
    const bool success = metaformat::parse(path, parsed, render_line_error);
    if (!success)
        m_error_log = QStringLiteral("Error: Could not open the file");

    m_error_log = errors.join(QChar('\n'));
    emit errorLogChanged();

    if (success) {
        m_file_path = path;
        emit filePathChanged();

        build_qml_layer(parsed, *this);
        emit openSuccess();

        m_has_document = true;
        emit hasDocumentChanged();
    }
    else {
        emit openFail();
    }
}

void Api::save()
{
    saveAs(m_file_path);
}

void Api::saveAs(QString path)
{
    Q_ASSERT(!path.isEmpty());
    if (path.isEmpty())
        return;

    QStringList errors;
    const auto on_error_cb = [&errors](QString error){
        errors << error;
    };

    metaformat::EntryRefs entryrefs;
    for (const model::Collection* const coll : m_collections)
        entryrefs.collections.emplace_back(&coll->data());
    for (const model::Game* const game : m_games)
        entryrefs.games.emplace_back(&game->data());

    const bool success = metaformat::write(path, entryrefs, on_error_cb);

    m_error_log = errors.join(QChar('\n'));
    emit errorLogChanged();

    if (success) {
        emit saveSuccess();

        if (m_file_path != path) {
            m_file_path = path;
            emit filePathChanged();
        }
    }
    else {
        emit saveFail();
    }
}

void Api::newCollection()
{
    m_collections.append(new model::Collection({}));
}

void Api::newGame()
{
    m_games.append(new model::Game({}));
}
