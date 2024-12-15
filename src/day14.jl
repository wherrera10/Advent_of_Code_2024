const DIR = "aoc_2024"

function day14()
    part = [0, 0]

    regex = r"[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)"
    robots = Vector{Int}[]
    for line in readlines("$DIR/day14.txt")
        push!(robots, parse.(Int, match(regex, line)))
    end
    x_size, y_size = 101, 103       
    quad_counts = [0, 0, 0, 0]

    for r in robots
        x, y = mod(r[1] + 100 * r[3], x_size), mod(r[2] + 100 * r[4], y_size)
        if x < 50
            if y < 51
                quad_counts[2] += 1
            elseif y > 51
                quad_counts[3] += 1
            end
        elseif x > 50
            if y < 51
                quad_counts[1] += 1
            elseif y > 51
                quad_counts[4] += 1
            end
        end
    end
    part[1] = prod(quad_counts)

    col_sums, row_sums = zeros(Int, x_size), zeros(Int, y_size)
    for i in 1:100_000
        for r in robots
            r[1] = mod(r[1] + r[3], x_size)
            r[2] = mod(r[2] + r[4], y_size)
            col_sums[r[1] + 1] += 1
            row_sums[r[2] + 1] += 1
        end
        if any(>(30), col_sums) && any(>(30), row_sums)
            part[2] = i
            break
        end
        col_sums .= 0
        row_sums .= 0
    end

    return part
end

@show day14() #  [223020000, 7338]
