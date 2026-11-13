#pragma once
#include <QElapsedTimer>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace graphai
{
void measureFirstFrameTime(QGuiApplication &app, QQmlApplicationEngine &engine, QElapsedTimer timer);
}