#include "scoped_timer.hpp"
#include "timing.hpp"

#include <QLoggingCategory>
#include <QString>

namespace graphai
{
ScopedTimer::ScopedTimer(std::string_view name) : name(name), start(std::chrono::steady_clock::now())
{
}

ScopedTimer::~ScopedTimer()
{
    const auto elapsed = std::chrono::steady_clock::now() - start;
    qDebug().noquote().nospace() << name << ": " << formatDuration(elapsed);
}
} // graphai