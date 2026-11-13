#include "bible.hpp"
#include <QResource>
#include <glaze/glaze.hpp>

Bible::Bible(std::vector<Book> books) : books_(std::move(books))
{
}

Bible Bible::fromBeve(std::string_view beve)
{
    auto start = std::chrono::steady_clock::now();
    auto books = std::vector<Book>();
    if (auto ec = glz::read_beve(books, beve); ec)
        throw std::runtime_error("Failed to read BEVE: " + glz::format_error(ec, beve));
    auto end = std::chrono::steady_clock::now();

    return Bible(std::move(books));
}

Bible Bible::nkjv()
{
    auto rawBeve = QResource(":/assets/nkjv.beve");
    auto buf = std::string_view((const char*)rawBeve.data(), rawBeve.size());
    return fromBeve(buf);
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
