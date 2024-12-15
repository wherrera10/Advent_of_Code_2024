const DIR = "aoc_2024"

function row_tiles_to_move_day15(mat, dir, p, mov)
    indexes = [p]
    d = dir[mov]
    if mat[p] != 'O' && mov ∈ [1, 3] # north, south
        if mat[p] == '['
            push!(indexes, CartesianIndex(p[1], p[2] + 1))
        elseif mat[p] == ']'
            push!(indexes, CartesianIndex(p[1], p[2] - 1))
        end
    end
    for q in indexes
        x, y = q[1] + d[1], q[2] + d[2]
        mat[x, y] == '#' && return empty(indexes)
    end
    return indexes
end

function step_day15(mat, rows, cols, directions, pos, mov)
    d = directions[mov]
    next_pos = CartesianIndex(pos[1] + d[1], pos[2] + d[2])
    !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols) && return pos
    mat[next_pos] == '#' && return pos
    if mat[next_pos] == '.'
        mat[pos] = '.'
        pos = next_pos
        mat[pos] = '@'
    elseif mat[next_pos] in "[]O"
        indexes = row_tiles_to_move_day15(mat, directions, next_pos, mov)
        if !isempty(indexes)
            d = directions[mov]
            for c in indexes
                p2 = CartesianIndex(c[1] + d[1], c[2] + d[2])
                if mat[p2] == '#'
                    empty!(indexes)
                    break
                end
                if mat[p2] != '.'
                    indexes2 = row_tiles_to_move_day15(mat, directions, p2, mov)
                    if isempty(indexes2)
                        empty!(indexes)
                        break
                    end
                    append!(indexes, indexes2)
                end
            end
        end
        if !isempty(indexes)
            for c in reverse!(indexes)
                x, y = c[1] + d[1], c[2] + d[2]
                mat[c], mat[x, y] = mat[x, y], mat[c]
            end
            mat[pos] = '.'
            mat[next_pos] = '@'
            pos = next_pos
        end
    end # do nothing if mat[next_pos] == '#'
    return pos
end

score15(p) = 100 * (p[1] - 1) + p[2] - 1
total_score15(mat) = sum(map(score15, filter(c -> mat[c] ∈ "[O", CartesianIndices(mat))))

function day15()
    part = [0, 0]

    room, move_chars = split(read("$DIR/day15.txt", String), "\n\n")
    base_mat = stack([collect(line) for line in split(room, "\n")], dims = 1)
    mat = deepcopy(base_mat)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    moves = map(ch -> findfirst(==(ch), "^>v<"), filter(c -> c in "^>v<", collect(move_chars)))

    pos = findfirst(==('@'), mat)
    for i in eachindex(moves)
        mov = moves[i]
        pos = step_day15(mat, rows, cols, directions, pos, mov)
    end
    part[1] = total_score15(mat)

    cols *= 2
    mat = fill('.', rows, cols)
    for c in CartesianIndices(base_mat)
        x, y = c[1], 2 * c[2]
        s = base_mat[c]
        mat[x, y-1] = s == 'O' ? '[' : s
        if s != '@'
            mat[x, y] = s == 'O' ? ']' : s
        end
    end

    pos = findfirst(==('@'), mat)
    for i in eachindex(moves)
        mov = moves[i]
        pos = step_day15(mat, rows, cols, directions, pos, mov)
    end
    part[2] = total_score15(mat)

    return part
end

@show day15() # [1509863, 1548815]
