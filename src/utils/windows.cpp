#include "windows.hpp"
#include <stdexcept>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

static bool isValidHandle(DWORD id)
{
    auto handle = GetStdHandle(id);
    return handle && handle != INVALID_HANDLE_VALUE;
}
#endif

namespace graphai
{
void attachToParentConsoleOnWindows()
{
#ifdef _WIN32
    auto outOk = isValidHandle(ATTACH_PARENT_PROCESS);
    auto errOk = isValidHandle(ATTACH_PARENT_PROCESS);

    if (AttachConsole(ATTACH_PARENT_PROCESS))
    {
        auto f = (FILE*)nullptr;
        if (!outOk)
            freopen_s(&f, "CONOUT$", "w", stdout);
        if (!errOk)
            freopen_s(&f, "CONOUT$", "w", stderr);
    }
#endif
}
}