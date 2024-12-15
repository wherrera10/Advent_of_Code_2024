const DIR = "aoc_2024"

function day15()
    part = [0, 0]

    room, move_chars = split(read("$DIR/day15.txt", String), "\n\n")
    base_mat = stack([collect(line) for line in split(room, "\n")], dims = 1)
    mat = deepcopy(base_mat)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    moves = map(ch -> findfirst(==(ch), "^>v<"), filter(c -> c in "^>v<", collect(move_chars)))

    score(p) = 100 * (p[1] - 1) + p[2] - 1
    total_score() = sum(map(score, filter(c -> mat[c] == 'O', CartesianIndices(mat))))

    function step(pos, mov)
        d = directions[mov]
        next_pos = CartesianIndex(pos[1] + d[1], pos[2] + d[2])
        !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols) && return pos
        mat[next_pos] == '#' && return pos
        if mat[next_pos] == '.'
            mat[pos] = '.'
            pos = next_pos
            mat[pos] = '@'
        elseif mat[next_pos] == 'O'
            tmp = deepcopy(next_pos)
            while true
                tmp = CartesianIndex(tmp[1] + d[1], tmp[2] + d[2])
                !(1 <= tmp[1] <= rows && 1 <= tmp[2] <= cols) && break
                (mat[tmp] == '#' || mat[tmp] == '@') && break
                if mat[tmp] == '.'
                    if mov == 1
                        for x in next_pos[1]:-1:tmp[1]
                            mat[x, tmp[2]] = 'O'
                        end
                    elseif mov == 2
                        for y in next_pos[2]:tmp[2]
                            mat[tmp[1], y] = 'O'
                        end
                    elseif mov == 3
                        for x in next_pos[1]:tmp[1]
                            mat[x, tmp[2]] = 'O'
                        end
                    else
                        for y in next_pos[2]:-1:tmp[2]
                            mat[tmp[1], y] = 'O'
                        end
                    end
                    mat[pos] = '.'
                    mat[next_pos] = '@'
                    pos = next_pos
                    break
                end
            end
        end # do nothing if mat[next_pos] == '#'
        return pos
    end

    pos = findfirst(==('@'), mat)
    for i in eachindex(moves)
        mov = moves[i]
        pos = step(pos, mov)
    end
    part[1] = total_score()

    function can_move_row(p, mov)
        indexes = [p]
        d = directions[mov]
        if mov ∈ [1, 3] # north, south
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

    function can_move(p, mov)
        indexes = can_move_row(p, mov)
        isempty(indexes) && return indexes
        d = directions[mov]
        for c in indexes
            p2 = CartesianIndex(c[1] + d[1], c[2] + d[2])
            mat[p2] == '#' && return empty(indexes)
            if mat[p2] != '.'
                indexes2 = can_move_row(p2, mov)
                isempty(indexes2) && return empty(indexes)
                append!(indexes, indexes2)
            end
        end
        return sort!(unique(indexes), rev = mov ∈ [2, 3])
    end

    function step2(pos, mov)
        d = directions[mov]
        next_pos = CartesianIndex(pos[1] + d[1], pos[2] + d[2])
        !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols) && return pos
        mat[next_pos] == '#' && return pos
        if mat[next_pos] == '.'
            mat[pos] = '.'
            pos = next_pos
            mat[pos] = '@'
        elseif mat[next_pos] in "[]"
            a = can_move(next_pos, mov)
            if !isempty(a)
                for c in a
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

    function total_score2()
        total = 0
        for y in 1:cols, x in 1:rows
            if mat[x, y] == '['
                total += 100 * (x - 1) + y - 1
            end
        end
        return total
    end

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
        pos = step2(pos, mov)
    end
    part[2] = total_score2()


    return part
end

@show day15() # (1530215, 26800609)
