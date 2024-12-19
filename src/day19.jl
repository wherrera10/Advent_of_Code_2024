using BenchmarkTools

using Memoization

const DIR = "aoc_2024"

@memoize function can_make19(design, patterns)
    for p in patterns
        p == design && return true
    end
    for p in patterns
        if startswith(design, p)
            design2 = design[length(p)+1:end]
            if can_make19(design2, patterns)
                return true
            end
        end
    end
    return false
end

@memoize function all_can_make19(design, patterns)
    can_count = 0
    for p in patterns
        p == design && (can_count += 1)
    end
    for p in patterns
        if startswith(design, p)
            design2 = design[length(p)+1:end]
            can_count += all_can_make19(design2, patterns)
        end
    end
    return can_count
end

function day19()
    part = [0, 0]

    text1, text2 = split(read("$DIR/day19.txt", String), "\n\n")
    patterns = filter(!isempty, split(text1, r"\s?,\s?"))
    desired = split(text2, r"\s+")
    part[1] = count(can_make19(d, patterns) for d in desired)
    part[2] = sum(all_can_make19(d, patterns) for d in desired)
    return part
end

@show day19() #  [358, 600639829400603]
