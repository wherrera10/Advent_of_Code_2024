const DIR = "aoc_2024"

function day06()
	part = [0, 0]
	DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]
	right_turn(d) = mod1(d + 1, 4)
	grid = stack((collect(line) for line in split(read("$DIR/day06.txt", String), "\n")), dims = 1)
	rows, cols = size(grid)
	guard = findfirst(==('^'), grid)
	pos = [guard[1], guard[2]]
	visited = Set{Vector{Int}}()
	d = 1
	while true
		push!(visited, pos)
		next = pos .+ DIRECTIONS[d]
		!(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
		if grid[next[1], next[2]] == '#'
			d = right_turn(d)
		else
			pos = next
		end
	end
	part[1] = length(visited)

	delete!(visited, [guard[1], guard[2]])
    p_lock = ReentrantLock()
	Threads.@threads for v in collect(visited)
		visited_d = Set{Vector{Int}}()
		td = 1
		p = [guard[1], guard[2]]
		while true
			state = [p[1], p[2], td]
			if state in visited_d
				lock(p_lock)
				part[2] += 1
				unlock(p_lock)
				break
			end
			push!(visited_d, state)
			next = p .+ DIRECTIONS[td]
			!(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
			if grid[next[1], next[2]] == '#' || next == v
				td = right_turn(td)
			else
				p = next
			end
		end
	end
	return part

end

@show day06() # [4580, 1480]
