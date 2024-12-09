const DIR = "aoc_2024"

function day09()
	part = [0, 0]
	numbers = parse.(Int, collect(read("$DIR/day09.txt", String)))
	gaps = Vector{Vector{Int}}()
	raw_disk = Int[]
	runs = Vector{Vector{Int}}()
	gaps = Vector{Vector{Int}}()
	gap_positions = Int[]
	is_space = false
	id = 0
	for n in numbers
		if is_space
			start = length(raw_disk) + 1
			push!(gaps, [start, n])
			for k in start:start+n-1
				push!(raw_disk, -1)
				push!(gap_positions, k)
			end
		else
			push!(runs, [length(raw_disk) + 1, n])
			for _ in 1:n
				push!(raw_disk, id)
			end
			id += 1
		end
		is_space = !is_space
	end

	disk = copy(raw_disk)
	for i in length(runs):-1:1
		for j in 1:runs[i][2]
			pos = popfirst!(gap_positions)
			if pos < runs[i][1] + j - 1
				disk[pos], disk[runs[i][1]+j-1] = disk[runs[i][1]+j-1], disk[pos]
			end
			isempty(gap_positions) && break
		end
		isempty(gap_positions) && break
	end

	for i in eachindex(disk)
		disk[i] == -1 && break
		part[1] += (i - 1) * disk[i]
	end

	disk = copy(raw_disk)
	for i in length(runs):-1:1
		start, stop = runs[i][1], runs[i][1] + runs[i][2] - 1
		len = stop - start + 1
		pos = findfirst(v -> v[2] >= len, gaps)
		if !isnothing(pos) && gaps[pos][1] < start
			disk[gaps[pos][1]:gaps[pos][1]+len-1] .= disk[start:stop]
			disk[start:stop] .= -1
			gaps[pos][1] += len
			gaps[pos][2] -= len
		end
	end
	for i in eachindex(disk)
		disk[i] == -1 && continue
		part[2] += (i - 1) * disk[i]
	end

	return part

end

@btime day09()

@show day09() # [6279058075753, 6301361958738]
