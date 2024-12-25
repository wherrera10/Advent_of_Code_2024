
const DIR = "aoc_2024"

function day25()
    tops, bottoms = Matrix{Char}[], Matrix{Char}[]
    for s in split(read("$DIR/day25.txt", String), "\n\n")
        push!((s[1] == '#' ? tops : bottoms), stack([collect(line) for line in split(s, "\n")], dims = 1))
    end
    rows, cols = size(tops[1])

    key_sums = [[count(==('#'), @view t[:, i]) for i in 1:cols] for t in tops]
    lock_sums = [[count(==('#'), @view t[:, i]) for i in 1:cols] for t in bottoms]
    return count(all(c -> t[c] + b[c] <= rows, 1:cols) for t in key_sums, b in lock_sums)
end

@show day25() # 2978
