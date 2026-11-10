#include "bible.hpp"
Bible::Bible(QList<Book> books) : books_(std::move(books))
{
}

Bible Bible::testBible()
{
    return Bible({Book{.name = "Skibidians", .chapters = {{"dial", "maybe"}, {"actually not!", "i dont agree"}}},
                  Book{.name = "Romans",
                       .chapters = {{"You are Peter, and on this rock you shall found a church that goes against all "
                                     "of my teachings :)"}}}});
}

int Bible::bookCount() const
{
    return books_.size();
}

const Book &Bible::book(int i) const
{
    return books_.at(i);
}

int Bible::chapterCount(int b) const
{
    return book(b).chapters.size();
}

const std::vector<std::string> &Bible::verses(int b, int c) const
{
    return book(b).chapters.at(c);
}
