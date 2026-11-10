#include <QObject>
#include <QQmlEngine>

#include "bible.hpp"
#include "book_model.hpp"
#include "verse_model.hpp"

class BibleViewModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Provided by C++")
    Q_PROPERTY(QAbstractItemModel *books READ books CONSTANT)
    Q_PROPERTY(QAbstractItemModel *verses READ verses CONSTANT)
    Q_PROPERTY(int bookIndex READ bookIndex WRITE setBookIndex NOTIFY bookIndexChanged)
    Q_PROPERTY(int chapterIndex READ chapterIndex WRITE setChapterIndex NOTIFY chapterIndexChanged)
    Q_PROPERTY(int chapterCount READ chapterCount NOTIFY bookIndexChanged)

    const Bible &bible_;
    BookModel books_;
    VerseModel verses_;
    int book_index_ = -1, chapter_index_ = 0;
  public:
    explicit BibleViewModel(const Bible &bible, QObject *parent = nullptr);

    QAbstractItemModel *books();
    QAbstractItemModel *verses();
    int bookIndex() const;
    int chapterIndex() const;
    int chapterCount() const;

    void setBookIndex(int b);
    void setChapterIndex(int c);

  signals:
    void bookIndexChanged();
    void chapterIndexChanged();
};
