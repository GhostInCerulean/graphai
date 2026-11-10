#include "verse_model.hpp"

VerseModel::VerseModel(const Bible &bible, QObject *parent) : QAbstractListModel(parent), m_bible(bible)
{
}

void VerseModel::setChapter(int book, int chapter)
{
    beginResetModel();
    m_book = book;
    m_chapter = chapter;
    endResetModel();
}

int VerseModel::rowCount(const QModelIndex &p) const
{
    if (p.isValid() || m_book < 0)
        return 0;
    return m_bible.verses(m_book, m_chapter).size();
}

QVariant VerseModel::data(const QModelIndex &i, int role) const
{
    if (!i.isValid() || m_book < 0)
        return {};
    switch (role)
    {
    case NumberRole:
        return i.row() + 1;
    case TextRole:
        return QString::fromUtf8(m_bible.verses(m_book, m_chapter)[i.row()]);
    }
    return {};
}

QHash<int, QByteArray> VerseModel::roleNames() const
{
    return {{NumberRole, "verseNumber"}, {TextRole, "verseText"}};
}
