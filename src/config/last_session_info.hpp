#pragma once
#include "src/data/reference.hpp"

#include <optional>

namespace graphai
{
using namespace std;

class LastSessionInfo
{
    optional<BibleReference> selection; // verse is set to the first verse
};

} // namespace graphai
