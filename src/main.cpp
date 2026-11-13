#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QElapsedTimer>
#include <QQuickWindow>

#include "bible.hpp"
#include "bible_view_model.hpp"
#include "utils/bench.hpp"

int main(int argc, char *argv[])
{
    auto timer = QElapsedTimer();
    timer.start();

    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("graphai");
    QGuiApplication::setApplicationDisplayName("Graphai");
    QGuiApplication::setWindowIcon(QIcon(":/icons/icon.png"));
    QGuiApplication::setDesktopFileName("graphai");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app, [] { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    auto bible = Bible::nkjv();
    auto vm = BibleViewModel(bible);

    engine.setInitialProperties({{"bible", QVariant::fromValue(&vm)}});

    engine.loadFromModule("App", "Main");

    graphai::measureFirstFrameTime(app, engine, timer);

    return app.exec();
}