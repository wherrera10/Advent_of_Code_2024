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
                            seen[x2, y2 ] = true
                            push!(current, [x2, y2])
                        end
                    end
                end
                q2 = d & quadrants[1] # upper left, quadrant 2
                if q2 == 0 || q2 == quadrants[1] && mat[x - 1, y - 1] != v
                    corners += 1
                end
                q1 = d & quadrants[2]
                if q1 == 0 || q1 == quadrants[2] && mat[x - 1, y + 1] != v
                    corners += 1
                end
                q3 = d & quadrants[3]
                if q3 == 0 || q3 == quadrants[3] && mat[x + 1, y - 1] != v
                    corners += 1
                end
                q4 = d & quadrants[4]
                if q4 == 0 || q4 == quadrants[4] && mat[x + 1, y + 1] != v
                    corners += 1
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
