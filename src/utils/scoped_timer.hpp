#pragma once
#include <chrono>
#include <string_view>

namespace graphai
{

class ScopedTimer
{
public:
    explicit ScopedTimer(std::string_view name);
    ~ScopedTimer();
private:
    std::string_view name;
    std::chrono::steady_clock::time_point start;
};

} // namespace graphai

