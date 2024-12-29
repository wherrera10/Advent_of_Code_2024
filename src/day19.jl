using Memoization

const DIR = "aoc_2024"

@memoize all19(s, a) = sum((p == s) + (startswith(s, p) ? (all19(s[length(p)+1:end], a)) : 0) for p in a)

function day19()
    text1, text2 = split(read("$DIR/day19.txt", String), "\n\n")
    patterns, desired = split(text1, r"\s?,\s?"), split(text2, r"\s+")
    locker = ReentrantLock()
    n_can, n_all = 0, 0
    @Threads.threads for s in desired
        k = all19(s, patterns)
        if k > 0
            lock(locker)
            n_can += 1
            n_all += k 
            unlock(locker)
        end
    end
    n_can, n_all
end

@show day19() #  [358, 600639829400603]
