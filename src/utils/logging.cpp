#include "logging.hpp"

#include <QString>
#include <qlogging.h>
#include <qtenvironmentvariables.h>
#include <stdio.h>

#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif

static bool stdErrIsTerminal()
{
#ifdef _WIN32
    return _isatty(_fileno(stderr)) != 0;
#else
    return isatty(fileno(stderr)) != 0;
#endif
}

namespace graphai
{
void setupLogging()
{
    // NO_COLOR is a common convention for opting out
    const bool color = stdErrIsTerminal() && !qEnvironmentVariableIsSet("NO_COLOR");

    QString pattern;
    if (color) {
        pattern += "%{if-debug}\033[36m%{endif}"
                   "%{if-warning}\033[33m%{endif}"
                   "%{if-critical}\033[31m%{endif}"
                   "%{if-fatal}\033[1;31m%{endif}";
    }
    pattern += "%{time hh:mm:ss.zzz} %{if-category}[%{category}] %{endif}%{message}";
    if (color)
        pattern += "\033[0m";

    qSetMessagePattern(pattern);
}
} // namespace graphai