#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "bible.hpp"
#include "bible_view_model.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app, [] { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    auto bible = Bible::nkjv();
    auto vm = BibleViewModel(bible);

    engine.setInitialProperties({{"bible", QVariant::fromValue(&vm)}});

    engine.loadFromModule("App", "Main");
    return app.exec();
}