const DIR = "aoc_2024"

const DIRECTIONS18 = [[-1, 0], [0, 1], [1, 0], [0, -1]]
const MATRIX_SIZE18 = 71
function bfs18(mat)
    moves = [[0, 1, 1]]
    visited = Set{Vector{Int}}()
    while !isempty(moves)
        sort!(moves)
        dist, x, y = popfirst!(moves)
        if [x, y] ∉ visited
            push!(visited, [x, y])
            if x == MATRIX_SIZE18 && y == MATRIX_SIZE18
                return dist
            end
            for (dx, dy) in DIRECTIONS18
                x2, y2 = x + dx, y + dy
                if 1 <= x2 <= MATRIX_SIZE18 && 1 <= y2 <= MATRIX_SIZE18 && mat[x2, y2] == 0 && [x2, y2] ∉ visited
                    push!(moves, [dist + 1, x2, y2])
                end
            end
        end
    end
    return -1 # fail
end
function day18()
    part = [0, String]
    numbers = parse.(Int, split(read("$DIR/day18.txt", String), r"\D+"))
    bytes = [[numbers[i-1] + 1, numbers[i] + 1] for i in 2:2:length(numbers)]
    rows, cols = MATRIX_SIZE18, MATRIX_SIZE18
    grid = zeros(Int8, rows, cols)
    for (x, y) in @view bytes[1:1024]
        grid[x, y] = 1
    end

    part[1] = bfs18(grid)

    mat = copy(grid)
    left, right = 1025, length(bytes)
    while left < right
        mid = (right + left) ÷ 2
        for i in left:mid
            x, y = bytes[i]
            mat[x, y] = 1
        end
        if bfs18(mat) > 0
            left = mid + 1
        else
            right = mid
            mat = copy(grid)
            for i in 1:left
                x, y = bytes[i]
                mat[x, y] = 1
            end
        end
    end
    part[2] = "$(bytes[left][1]-1),$(bytes[left][2]-1)"

    return part
end

@show day18() # [436, (61, 50)]
