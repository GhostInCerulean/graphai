import QtQuick

// Selection state + rules for verses within one chapter (placeholder logic).
//   click            → select only that verse (click again to deselect)
//   Ctrl + click     → toggle that verse, keep the others
//   Shift + click    → select the range from the anchor verse to the clicked one
// Ranges assume verse numbers are contiguous within a chapter.
//
// `selection` is a map { verseNumber: true }. It is always *replaced* (never mutated
// in place) so bindings that read it are re-evaluated.
QtObject {
    id: root

    property var selection: ({})
    property int anchorVerse: 0

    readonly property int count: Object.keys(selection).length

    function isSelected(n) { return selection[n] === true }

    function numbers() {
        return Object.keys(selection).map(Number).sort((a, b) => a - b)
    }

    function set(list) {
        const s = {}
        for (const n of list) s[n] = true
        selection = s
    }

    function clear() {
        selection = ({})
        anchorVerse = 0
    }

    function selectOnly(n) {
        if (count === 1 && isSelected(n)) {
            clear()
        } else {
            set([n])
            anchorVerse = n
        }
    }

    function toggle(n) {
        const s = Object.assign({}, selection)
        if (s[n]) delete s[n]; else s[n] = true
        selection = s
        anchorVerse = n
    }

    function extendTo(n) {
        if (anchorVerse <= 0) { selectOnly(n); return }
        const lo = Math.min(anchorVerse, n), hi = Math.max(anchorVerse, n)
        const range = []
        for (let i = lo; i <= hi; ++i) range.push(i)
        set(range)                               // anchor stays put, like a file manager
    }

    // "Verse 3", "Verses 3–5, 8"
    function label() {
        const nums = numbers()
        if (nums.length === 0) return ""
        const parts = []
        let start = nums[0], prev = nums[0]
        for (let i = 1; i <= nums.length; ++i) {
            if (i < nums.length && nums[i] === prev + 1) { prev = nums[i]; continue }
            parts.push(start === prev ? "" + start : start + "–" + prev)
            if (i < nums.length) { start = nums[i]; prev = nums[i] }
        }
        return (nums.length === 1 ? "Verse " : "Verses ") + parts.join(", ")
    }
}
