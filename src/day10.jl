using BenchmarkTools

const DIR = "aoc_2024"

function day10()
    part = [0, 0]
    mat = parse.(Int8, stack([collect(line) for line in readlines("$DIR/day10.txt")], dims = 1))
    rows, cols = size(mat)
    options = [[0, 0], [0, 0], [0, 0], [0, 0]]
    for t in findall(==(0), mat)
        trails = [[t[1], t[2]]]
        new_trails = empty(trails)
        for wanted in 1:9
            for (x, y) in trails
                options .= [[x - 1, y], [x, y + 1], [x + 1, y], [x, y - 1]]
                append!(new_trails, filter(c -> 1 <= c[1] <= rows && 1 <= c[2] <= cols && mat[c[1], c[2]] == wanted, options))
            end
            trails, new_trails = new_trails, trails
            empty!(new_trails)
        end
        part[1] += length(unique(trails))
        part[2] += length(trails)
    end

    return part
end

@show day10() # [624, 1483]
