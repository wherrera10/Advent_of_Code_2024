const DIR = "aoc_2024"

left16(d) = mod1(d - 1, 4)
right16(d) = mod1(d + 1, 4)
function day16()
    part = [0, 0]

    mat = stack([collect(line) for line in readlines("$DIR/day16.txt")], dims = 1)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    start_c = findfirst(c -> mat[c] == 'S', CartesianIndices(mat))
    xb, yb = start_c[1], start_c[2]
    stop_c = findfirst(c -> mat[c] == 'E', CartesianIndices(mat))
    xe, ye = stop_c[1], stop_c[2]
    mat[stop_c] = '.'

    moves = [[0, xb, yb, 2]]
    costs_mat = fill(typemax(Int), rows, cols)
    costs_mat[xb, yb] = 0
    while !isempty(moves)
        sort!(moves)
        cost, x, y, d = popfirst!(moves)
        for (d2, c2) in [[d, cost + 1], [left16(d), cost + 1001], [right16(d), cost + 1001]]
            x2, y2 = x + directions[d2][1], y + directions[d2][2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && mat[x2, y2] != '#' && c2 < costs_mat[x2, y2]
                costs_mat[x2, y2] = c2
                push!(moves, [c2, x2, y2, d2])
            end
        end
    end
    part[1] = costs_mat[xe, ye]

    moves = [[costs_mat[xe, ye], xe, ye, 3], [costs_mat[xe, ye], xe, ye, 4]]
    visited = Set{Vector{Int}}()
    while !isempty(moves)
        sort!(moves)
        cost, x, y, d = popfirst!(moves)
        for (d2, c2) in [[d, cost - 1], [left16(d), cost - 1001], [right16(d), cost - 1001]]
            x2, y2 = x + directions[d2][1], y + directions[d2][2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && costs_mat[x2, y2] ∈ [c2, c2 - 1000] && [x2, y2] ∉ visited
                part[2] += 1
                push!(moves, [c2, x2, y2, d2])
                push!(visited, [x2, y2])
            end
        end
    end
    part[2] += 1

    return part
end

@show day16() # [106512, 563]
