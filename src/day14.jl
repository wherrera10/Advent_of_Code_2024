using BenchmarkTools

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

function day14()
	part = [0, 0]

	regex = r"[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)"
	robots = Vector{Int}[]
	for line in readlines("$DIR/day14.txt")
		push!(robots, parse.(Int, match(regex, line)))
	end
	x_size, y_size = 101, 103
	quad_counts = [0, 0, 0, 0]
    quad_indices = zeros(Int8, x_size, y_size)
    quad_indices[52:x_size, 1:51] .= 1
    quad_indices[1:50, 1:51] .= 2
    quad_indices[1:50, 53:y_size] .= 3
    quad_indices[52:x_size, 53:y_size] .= 4

	for _ in 1:100
		for r in robots
			r[1] = mod(r[1] + r[3], x_size)
            r[2] = mod(r[2] + r[4], y_size)
		end
	end
	for r in robots
        if (idx = quad_indices[r[1] + 1, r[2] + 1]) > 0
            quad_counts[idx] += 1
        end
	end
	part[1] = prod(quad_counts)

	for i in 101:100_000
		for r in robots
			r[1] = mod(r[1] + r[3], x_size)
            r[2] = mod(r[2] + r[4], y_size)
		end
		if count(r -> r[1] == 15, robots) > 30 && count(r -> r[2] == 34, robots) > 25 # frame
			part[2] = i
            break
		end
	end

	return part
end

@btime day14()

@show day14() #  [223020000, 7338]

