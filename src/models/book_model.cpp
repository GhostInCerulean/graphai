#include "book_model.hpp"

BookModel::BookModel(const Bible &bible, QObject *parent) : QAbstractListModel(parent), bible_(bible)
{
}

int BookModel::rowCount(const QModelIndex &p) const
{
    return p.isValid() ? 0 : bible_.bookCount();
}

QHash<int, QByteArray> BookModel::roleNames() const
{
    return {{NameRole, "bookName"}};
}

QVariant BookModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || (role != NameRole && role != Qt::DisplayRole))
        return {};
    const std::string &name = bible_.book(index.row()).name;
    return QString::fromUtf8(name.data(), static_cast<qsizetype>(name.size()));
}