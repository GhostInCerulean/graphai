#include "bench.hpp"

#include <QElapsedTimer>
#include <QQuickWindow>

namespace graphai
{

void measureFirstFrameTime(QGuiApplication &app, QQmlApplicationEngine &engine, QElapsedTimer timer)
{

    if (engine.rootObjects().isEmpty())
        throw std::runtime_error("No root objects");

    auto window = qobject_cast<QQuickWindow*>(engine.rootObjects().constFirst());
    auto reported = std::make_shared<bool>(false);

    QObject::connect(window, &QQuickWindow::frameSwapped, &app, [timer, reported] {
        if (*reported)
            return;

        *reported = true;
        qDebug() << "First frame time: " << timer.elapsed() << "ms";
    }, Qt::QueuedConnection);
}
} // namespace graphai