using BenchmarkTools

using Memoization

const DIR = "aoc_2024"

@memoize function can19(design, patterns)
    for p in patterns
        p == design && return true
    end
    for p in patterns
        startswith(design, p) && can19(design[length(p)+1:end], patterns) && return true
    end
    return false
end

@memoize function all19(design, patterns)
    n = 0
    for p in patterns
        p == design && (n += 1)
    end
    for p in patterns
        startswith(design, p) && (n += all19(design[length(p)+1:end], patterns))
    end
    return n
end

function day19()
    text1, text2 = split(read("$DIR/day19.txt", String), "\n\n")
    patterns, desired = split(text1, r"\s?,\s?"), split(text2, r"\s+")
    count(can19(d, patterns) for d in desired), sum(all19(d, patterns) for d in desired)
end

@show day19() #  [358, 600639829400603]
