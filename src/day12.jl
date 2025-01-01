const DIR = "aoc_2024"

function day12()
    part = [0, 0]
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    d_bits = [1, 4, 16, 64]
    quadrants = [1 | 64, 1 | 4, 16 | 64, 16 | 4]
    mat = stack([collect(line) for line in readlines("$DIR/day12.txt")], dims = 1)
    rows, cols = size(mat)
    seen = falses(rows, cols)
    current = Vector{Int}[]

    for r in 1:rows, c in 1:cols
        if !seen[r, c]
            seen[r, c] = true
            corners, perimeter, area = 0, 0, 0
            v = mat[r, c]
            push!(current, [r, c])
            while !isempty(current)
                sort!(current)
                x, y = popfirst!(current)
                area += 1
                edge_count = 4
                d = 0
                for (i, (dx, dy)) in enumerate(directions)
                    x2, y2 = x + dx, y + dy
                    if 1 <= x2 <= rows && 1 <= y2 <= cols && mat[x2, y2] == v
                        d |= d_bits[i]
                        edge_count -= 1
                        if !seen[x2, y2]
                            seen[x2, y2] = true
                            push!(current, [x2, y2])
                        end
                    end
                end
                for (i, dx, dy) in [(1, -1, -1), (2, -1, 1), (3, 1, -1), (4, 1, 1)]
                    q = d & quadrants[i]
                    if q == 0 || q == quadrants[i] && mat[x + dx, y + dy] != v
                        corners += 1
                    end
                end
                perimeter += edge_count
            end
            part[1] += perimeter * area
            part[2] += corners * area
        end
    end

    return part
end

@show day12() #  [1359028, 839780]
