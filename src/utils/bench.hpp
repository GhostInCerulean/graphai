#pragma once
#include "bench.hpp"
#include "timing.hpp"

#include <QElapsedTimer>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace graphai
{
void measureFirstFrameTime(QGuiApplication &app, QQmlApplicationEngine &engine, QElapsedTimer timer);
} // namespace graphai