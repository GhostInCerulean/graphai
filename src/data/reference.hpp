#pragma once
#include <cstddef>
#include <variant>

namespace graphai
{
using namespace std;

struct SingleVerseReference
{
    size_t verse;
};

/// [start_verse; end_verse]
struct VerseSpanReference
{
    size_t startVerse;
    size_t endVerse;
};

using VerseReference = variant<SingleVerseReference, VerseSpanReference>;

struct BibleReference
{
    VerseReference verses;
    int chapter;
    int book;
};

} // namespace graphai
