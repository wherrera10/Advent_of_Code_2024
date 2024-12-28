const DIR = "aoc_2024"

right_turn6(d) = mod1(d + 1, 4)
function day06()
    part = [0, 0]
    DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    grid = stack((collect(line) for line in split(read("$DIR/day06.txt", String), "\n")), dims = 1)
    rows, cols = size(grid)
    guard = findfirst(==('^'), grid)
    pos = [guard[1], guard[2]]
    visited = Set{Vector{Int}}()
    guard_states = Dict{Vector{Int}, Vector{Int}}()
    d = 1 # guard is facing north ^ at start
    while true
        push!(visited, pos)
        next = pos .+ DIRECTIONS[d]
        !(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
        if grid[next[1], next[2]] == '#'
            d = right_turn6(d)
        else
            if next ∉ visited
                guard_states[[pos[1], pos[2], d]] = [next[1], next[2]]
            end
            pos = next
        end
    end
    part[1] = length(visited)

    possible_jumps = Dict{Vector{Int}, Vector{Int}}()
    for ((x, y, d), (x_obstacle, y_obstacle)) in collect(guard_states) # every place for an obstacle
        visited2 = Set{Vector{Int}}()
        push!(visited2, [x, y, d]) # direction sensitive for part 2
        off_grid = false
        while true
            dx, dy = DIRECTIONS[d]
            old_state = [x, y, d]
            if x != x_obstacle && y != y_obstacle && haskey(possible_jumps, [x, y, d])
                x, y, d = possible_jumps[[x, y, d]]
                if x == 0
                    break
                end
            else
                while true # move along til obstruction or off grid
                    x += dx
                    y += dy
                    if !(1 <= x <= rows && 1 <= y <= cols)
                        possible_jumps[[x, y, d]] = [0, 0, 0] # off grid
                        off_grid = true
                        break
                    elseif x == x_obstacle && y == y_obstacle || grid[x, y] == '#'
                        x -= dx
                        y -= dy
                        d = right_turn6(d)
                        if x != x_obstacle && y != y_obstacle
                            possible_jumps[old_state] = [x, y, d]
                        end
                        break
                    end
                end
            end
            off_grid && break
            if [x, y, d] ∈ visited2
                part[2] += 1
                break
            else
                push!(visited2, [x, y, d])
            end
        end
    end

    return part

end

@show day06() # [4580, 1480]
