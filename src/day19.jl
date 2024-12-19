using BenchmarkTools

using Memoization

const DIR = "aoc_2024"

@memoize can19(s, a) = any(p == s || startswith(s, p) && can19(s[length(p)+1:end], a) for p in a)

@memoize all19(s, a) = sum((p == s) + (startswith(s, p) ? (all19(s[length(p)+1:end], a)) : 0) for p in a)

function day19()
    text1, text2 = split(read("$DIR/day19.txt", String), "\n\n")
    patterns, desired = split(text1, r"\s?,\s?"), split(text2, r"\s+")
    count(can19(d, patterns) for d in desired), sum(all19(d, patterns) for d in desired)
end

@show day19() #  [358, 600639829400603]
