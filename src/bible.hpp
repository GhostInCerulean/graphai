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
    std::vector<Book> books_;

  public:
    explicit Bible(std::vector<Book> books);
    static Bible fromBeve(std::string_view beve);
    static Bible nkjv();

    int bookCount() const;
    const Book &book(int i) const;

    int chapterCount(int book) const;
    const std::vector<std::string> &verses(int book, int chapter) const;
};