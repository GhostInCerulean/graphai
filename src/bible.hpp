#pragma once
#include <QList>
#include <QString>

struct Book
{
    std::string name;
    std::vector<std::vector<std::string>> chapters;
};

class Bible
{
    QList<Book> books_;

  public:
    explicit Bible(QList<Book> books);
    static Bible testBible();

    int bookCount() const;
    const Book &book(int i) const;

    int chapterCount(int book) const;
    const std::vector<std::string> &verses(int book, int chapter) const;
};