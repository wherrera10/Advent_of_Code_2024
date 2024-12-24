using BenchmarkTools

using Graphs, SparseArrays

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

vec20(c) = [c[1], c[2]]
scalar20(c, n) = Int32((c[1] - 1) * n + c[2])
city20(x1, y1, x2, y2) = abs(x1 - x2) + abs(y1 - y2)

const NIL20 = typemax(Int16)

function count_cheats20(distances, rows, cols, signs, cheat_time_allowed, min_time_savings)
    candidates = 0
    endpoints = Set{Vector{Int}}()
    for x in 1:rows, y in 1:cols
        if distances[x, y] < NIL20 # valid point                
            for t in 1:cheat_time_allowed
                for dx in 0:t  # x move
                    dy = t - dx # y move
                    for (sx, sy) in signs # quadrants
                        x2, y2 = x + dx * sx, y + dy * sy
                        if 2 <= x2 <= rows - 1 && 2 <= y2 <= cols - 1 && distances[x2, y2] < NIL20
                            push!(endpoints, [x2, y2])
                        end
                    end
                end
            end
            for (x2, y2) in endpoints
                dt = distances[x, y] - distances[x2, y2]
                if dt > 0 && dt - city20(x, y, x2, y2) >= min_time_savings
                    candidates += 1
                end
            end
            empty!(endpoints)
        end
    end
    return candidates
end

function day20()
    part = [0, 0]
    grid = stack([collect(line) for line in readlines("$DIR/day20.txt")], dims = 1)
    rows, cols = size(grid)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    signs = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
    start_c = vec20(findfirst(c -> grid[c] == 'S', CartesianIndices(grid)))
    stop_c = vec20(findfirst(c -> grid[c] == 'E', CartesianIndices(grid)))

    distances = fill(NIL20, rows, cols)
    delta, surround, new_surround = 0, [stop_c], Vector{Int}[]
    while !isempty(surround)
        for (x, y) in surround
            distances[x, y] = delta
        end
        for (x, y) in surround
            for (dx, dy) in directions
                x2, y2 = x + dx, y + dy
                grid[x2, y2] != '#' && distances[x2, y2] == NIL20 && push!(new_surround, [x2, y2])
            end
        end
        surround, new_surround = new_surround, surround
        empty!(new_surround)
        delta += 1
    end

    part[1] = count_cheats20(distances, rows, cols, signs, 2, 100)
    part[2] = count_cheats20(distances, rows, cols, signs, 20, 100)
    return part
end

@btime day20()

@show day20() # [1197, 944910]
