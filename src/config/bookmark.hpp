#pragma once
#include "src/data/reference.hpp"

#include <optional>
#include <string>

namespace graphai
{
using namespace std;

struct Bookmark
{
    BibleReference reference;
    optional<string> note;
};

}