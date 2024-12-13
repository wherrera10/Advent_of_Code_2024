const DIR = "aoc_2024"

function day12()
    part = [0, 0]
    mat = UInt8.(stack([collect(line) for line in readlines("$DIR/day12.txt")], dims = 1))
    mat = vcat(mat[1, :]', mat, mat[1, :]')
    mat = hcat(mat[:, 1], mat, mat[:, 1])
    rows, cols = size(mat)
    mat[[1, rows], :] .= UInt8(' ')
    mat[:, [1, cols]] .= UInt8(' ')
    gardens = Vector{Vector{Int}}[]
    found = Set{Vector{Int}}()
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    right_turn(i) = directions[mod1(i + 1, 4)]
    left_turn(i) = directions[mod1(i - 1, 4)]

    function flood_fill(c)
        t = mat[c[1], c[2]]
        v = [c]
        new_v = empty(v)
        while true
            for p in v
                push!(new_v, p)
                for q in directions
                    r = p .+ q
                    mat[r[1], r[2]] == t && push!(new_v, r)
                end
            end
            new_v = unique(new_v)
            length(new_v) == length(v) && return new_v
            v, new_v = new_v, v
            empty!(new_v)
        end
    end

    function edges(garden_plot)
        edge_count = 0
        for p in garden_plot
            t = mat[p[1], p[2]]
            for q in directions
                r = p .+ q
                if mat[r[1], r[2]] != t
                    edge_count += 1
                end
            end
        end
        return edge_count
    end

    function sides(garden_plot)
        side_count = 0
        pairs_found = Set{Vector{Vector{Int}}}()
        t = mat[garden_plot[1][1], garden_plot[1][2]]
        for p in garden_plot
            for (i, d) in enumerate(directions)
                q = p .+ d
                if mat[q[1], q[2]] != t # edge
                    pair = [p, q]
                    if pair ∉ pairs_found
                        side_count += 1
                        push!(pairs_found, pair)
                        for d2 in (right_turn(i), left_turn(i))
                            p2 = copy(p)
                            q2 = copy(q)
                            while true
                                p2 = p2 .+ d2
                                q2 = q2 .+ d2
                                if mat[p2[1], p2[2]] == t && mat[q2[1], q2[2]] != t
                                    push!(pairs_found, [p2, q2])
                                else
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        return side_count
    end

    for c_index in CartesianIndices(mat)
        x, y = c_index[1], c_index[2]
        (x == 1 || x == rows || y == 1 || y == cols) && continue
        c = [x, y]
        if c ∉ found
            garden_plot = flood_fill(c)
            push!(gardens, garden_plot)
            for p in garden_plot
                push!(found, p)
            end
            part[1] += length(garden_plot) * edges(garden_plot)
            part[2] += length(garden_plot) * sides(garden_plot)
        end
    end

    return part
end

@show day12() #  [ 1359028, 839780]
