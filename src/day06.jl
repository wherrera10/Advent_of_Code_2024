using BenchmarkTools

const DIR = "aoc_2024"

function day06()
    part = [0, 0]
    DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    right_turn(d) = mod1(d + 1, 4)
    grid = stack((collect(line) for line in split(read("$DIR/day06.txt", String), "\n")), dims=1)
    rows, cols = size(grid)
    guard = findfirst(==('^'), grid)
    pos = [guard[1], guard[2]]
    visited = Set{Vector{Int}}()
    d = 1
    while true
        push!(visited, pos)
        next = pos .+ DIRECTIONS[d]
        !(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
        if grid[next[1], next[2]] == '#'
            d = right_turn(d)
        else
            pos = next
        end
    end
    part[1] = length(visited)

    visited_d = Set{Vector{Int}}()
    for v in visited
        target = grid[v[1], v[2]]
        if target != '#'
            grid[v[1], v[2]] = '#'
            d = 1
            pos = [guard[1], guard[2]]
            while true
                state = [pos[1], pos[2], d]
                if state in visited_d
                    part[2] += 1
                    break
                end
                push!(visited_d, state)
                next = pos .+ DIRECTIONS[d]
                !(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
                if grid[next[1], next[2]] == '#'
                    d = right_turn(d)
                else
                    pos = next
                end
            end
            empty!(visited_d)
            grid[v[1], v[2]] = target
        end
    end
    return part

end

@show day06()
