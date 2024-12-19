using BenchmarkTools

using Graphs

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

scalar18(c, n) = (c[1] - 1) * n + c[2]
scalar18(x, y, n) = (x - 1) * n + y

function day18()
    part = [0, Tuple{Int}]
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    numbers = parse.(Int, split(read("$DIR/day18.txt", String), r"\D+"))
    bytes = [[numbers[i-1] + 1, numbers[i] + 1] for i in 2:2:length(numbers)]
    rows, cols = 71, 71


    grid = zeros(Int8, rows, cols)
    g = SimpleGraph{Int32}(rows * cols)
    start_c = [1, 1]
    stop_c = [rows, cols]
    start_vertex = scalar18(start_c, cols)
    stop_vertex = scalar18(stop_c, cols)
    for p in @view bytes[1:1024]
        grid[p[1], p[2]] += 1
    end
    for c in CartesianIndices(grid)
        grid[c] > 0 && continue
        x, y = c[1], c[2]
        for d in directions
            x2, y2 = x + d[1], y + d[2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && grid[x2, y2] == 0
                add_edge!(g, scalar18(c, cols), scalar18(x2, y2, cols))
            end
        end
    end

    path = a_star(g, start_vertex, stop_vertex)
    part[1] = length(path)

    for p in @view bytes[1025:end]
        x, y = p[1], p[2]
        grid[x, y] > 0 && continue
        grid[x, y] += 1
        for d in directions
            x2, y2 = x + d[1], y + d[2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && grid[x2, y2] == 0
                rem_edge!(g, scalar18(x2, y2, cols), scalar18(x, y, cols))
                rem_edge!(g, scalar18(x, y, cols), scalar18(x2, y2, cols))
            end
        end
        path = a_star(g, start_vertex, stop_vertex)
        if length(path) < 1
            part[2] = (x - 1, y - 1)
            break
        end
    end

    return part
end

@btime day18()

@show day18() # [436, (61, 50)]
