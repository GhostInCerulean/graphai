#pragma once
#include <chrono>
#include <string>

namespace graphai
{
std::string formatDuration(std::chrono::duration<double, std::nano> duration);
}