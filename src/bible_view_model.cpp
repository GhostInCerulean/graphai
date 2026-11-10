#include "bible_view_model.hpp"

BibleViewModel::BibleViewModel(const Bible &bible, QObject *parent)
    : QObject(parent), bible_(bible), books_(bible), verses_(bible)
{
    setBookIndex(0);
}

QAbstractItemModel *BibleViewModel::books()
{
    return &books_;
}

QAbstractItemModel *BibleViewModel::verses()
{
    return &verses_;
}

int BibleViewModel::bookIndex() const
{
    return book_index_;
}

int BibleViewModel::chapterIndex() const
{
    return chapter_index_;
}

int BibleViewModel::chapterCount() const
{
    return bible_.chapterCount(book_index_);
}

void BibleViewModel::setBookIndex(int b)
{
    if (b == book_index_ || b < 0 || b >= bible_.bookCount())
        return;
    book_index_ = b;
    emit bookIndexChanged();
    setChapterIndex(0); // also refreshes verses
}

void BibleViewModel::setChapterIndex(int c)
{
    if (c < 0 || c >= chapterCount())
        return;
    chapter_index_ = c;
    verses_.setChapter(book_index_, chapter_index_);
    emit chapterIndexChanged();
}
