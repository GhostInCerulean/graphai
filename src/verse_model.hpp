#pragma once
#include <QAbstractListModel>

#include "bible.hpp"

class VerseModel : public QAbstractListModel
{
    Q_OBJECT
  public:
    enum Roles
    {
        NumberRole = Qt::UserRole + 1,
        TextRole
    };

    explicit VerseModel(const Bible &bible, QObject *parent = nullptr);

    void setChapter(int book, int chapter);

    int rowCount(const QModelIndex &p = {}) const override;
    QVariant data(const QModelIndex &i, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

  private:
    const Bible &m_bible;
    int m_book = -1, m_chapter = 0;
};
