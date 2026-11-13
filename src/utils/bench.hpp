#pragma once
#include <QElapsedTimer>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace graphai
{
void measureFirstFrameTime(QGuiApplication &app, QQmlApplicationEngine &engine, QElapsedTimer timer);

enum class TimeUnit
{
    Nano,
    Micro,
    Mili
};

template <typename F, typename TUnits = std::chrono::milliseconds>
void trace(std::string_view name, F func, TimeUnit timeUnit = TimeUnit::Mili)
{
    auto start = std::chrono::steady_clock::now();
    func();
    auto end = std::chrono::steady_clock::now();

    switch (timeUnit)
    {
    case TimeUnit::Mili:
        qDebug() << name << ": " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        break;
    case TimeUnit::Micro:
        qDebug() << name << ": " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
        break;
    case TimeUnit::Nano:
        qDebug() << name << ": " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
        break;
    }
}
} // namespace graphai