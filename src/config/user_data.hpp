#pragma once
#include "bookmark.hpp"

#include <vector>

namespace graphai
{
using namespace std;

struct UserData
{
    vector<Bookmark> bookmarks;
};

} // namespace graphai
