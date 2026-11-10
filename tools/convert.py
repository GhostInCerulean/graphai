#!/usr/bin/env python3
"""Convert {book: {chapter: {verse: text}}} JSON to BEVE for glaze.

Output layout matches glaze's encoding of:
    struct Book { std::string name; std::vector<std::vector<std::string>> chapters; };
    std::vector<Book>
"""
import json
import sys

def cint(n: int) -> bytes:
    """BEVE compressed integer (2-bit size tag in the low bits, little endian)."""
    if n < 1 << 6:
        return bytes([n << 2])
    if n < 1 << 14:
        return ((n << 2) | 1).to_bytes(2, "little")
    if n < 1 << 30:
        return ((n << 2) | 2).to_bytes(4, "little")
    return ((n << 2) | 3).to_bytes(8, "little")

def raw_str(s: str) -> bytes:
    b = s.encode("utf-8")
    return cint(len(b)) + b

GENERIC_ARRAY = bytes([0b101])        # type 5
STRING_ARRAY = bytes([0b00111100])    # typed array, string flavor (0x3C)
STRING = bytes([0b010])               # type 2
OBJECT_STR_KEYS = bytes([0b011])      # type 3, string keys

def string_array(items) -> bytes:
    return STRING_ARRAY + cint(len(items)) + b"".join(raw_str(s) for s in items)

def encode_book(name: str, chapters: list) -> bytes:
    out = OBJECT_STR_KEYS + cint(2)
    out += raw_str("name") + STRING + raw_str(name)
    out += raw_str("chapters") + GENERIC_ARRAY + cint(len(chapters))
    out += b"".join(string_array(ch) for ch in chapters)
    return out

def ordered_values(d: dict, what: str) -> list:
    keys = sorted(d, key=int)
    expected = [str(i) for i in range(1, len(keys) + 1)]
    if keys != expected:
        raise ValueError(f"{what}: non-contiguous numbering {keys[:5]}...")
    return [d[k] for k in keys]

def main(src: str, dst: str) -> None:
    with open(src, encoding="utf-8") as f:
        data = json.load(f)   # dicts keep file order, so books stay canonical

    out = GENERIC_ARRAY + cint(len(data))
    verse_total = 0
    for name, chapters in data.items():
        chs = []
        for i, ch in enumerate(ordered_values(chapters, name), 1):
            verses = ordered_values(ch, f"{name} {i}")
            verse_total += len(verses)
            chs.append(verses)
        out += encode_book(name, chs)

    with open(dst, "wb") as f:
        f.write(out)
    print(f"{len(data)} books, {verse_total} verses -> {dst} ({len(out):,} bytes)")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(f"usage: {sys.argv[0]} bible.json bible.beve")
    main(sys.argv[1], sys.argv[2])