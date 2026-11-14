#include "timing.hpp"

#include <array>

namespace graphai
{
struct Unit
{
    std::string_view suffix;
    double nsPerUnit;
    double upperBoundNs;
    int precision;
};

static constexpr std::array<Unit, 6> kUnits = {
    Unit{.suffix = "ns", .nsPerUnit = 1.0, .upperBoundNs = 1e3, .precision = 0},
    Unit{.suffix = "µs", .nsPerUnit = 1e3, .upperBoundNs = 1e6, .precision = 2},
    Unit{.suffix = "ms", .nsPerUnit = 1e6, .upperBoundNs = 1e9, .precision = 2},
    Unit{.suffix = "s", .nsPerUnit = 1e9, .upperBoundNs = 60e9, .precision = 2},
    Unit{.suffix = "min", .nsPerUnit = 60e9, .upperBoundNs = 3600e9, .precision = 2},
    Unit{.suffix = "h", .nsPerUnit = 3600e9, .upperBoundNs = 0, .precision = 2},
};

std::string formatDuration(std::chrono::duration<double, std::nano> duration)
{
    auto ns = duration.count();
    auto absNs = std::abs(ns);
    auto chosenUnit = &kUnits.at(0);

    for (const auto &unit : kUnits)
    {
        if (unit.upperBoundNs != 00 & absNs < unit.upperBoundNs)
        {
            chosenUnit = &unit;
            break;
        }
    }

    auto oss = std::ostringstream();
    oss << std::fixed << std::setprecision(chosenUnit->precision) << ns / chosenUnit->nsPerUnit << ' '
        << chosenUnit->suffix;
    return oss.str();
}
} // namespace graphai