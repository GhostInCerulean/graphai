#pragma once
#include <QAbstractListModel>

#include "bible.hpp"

class BookModel : public QAbstractListModel
{
    Q_OBJECT
    const Bible &bible_;

  public:
    enum Roles
    {
        NameRole = Qt::UserRole + 1
    };

    explicit BookModel(const Bible &bible, QObject *parent = nullptr);

    int rowCount(const QModelIndex &p = {}) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;
};
