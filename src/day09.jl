const DIR = "aoc_2024"

function day09()
    part = [0, 0]
    numbers = parse.(Int, collect(read("$DIR/day09.txt", String)))
    gaps = Vector{Vector{Int}}()
    raw_disk = Int[]
    gap_positions = Int[]
    runs, run_sizes, gaps, gap_sizes = Int[], Int[], Int[], Int[]
    is_space = false
    id = 0
    for n in numbers
        if is_space
            start = length(raw_disk) + 1
            push!(gaps, start)
            push!(gap_sizes, n)
            for k in start:start+n-1
                push!(raw_disk, -1)
                push!(gap_positions, k)
            end
        else
            push!(runs, length(raw_disk) + 1)
            push!(run_sizes, n)
            for _ in 1:n
                push!(raw_disk, id)
            end
            id += 1
        end
        is_space = !is_space
    end

    disk = copy(raw_disk)
    for i in length(runs):-1:1
        for j in 1:run_sizes[i]
            pos = popfirst!(gap_positions)
            if pos < runs[i] + j - 1
                disk[pos], disk[runs[i]+j-1] = disk[runs[i]+j-1], disk[pos]
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
        start, stop = runs[i], runs[i] + run_sizes[i] - 1
        pos = findfirst(>=(run_sizes[i]), gap_sizes)
        if !isnothing(pos) && gaps[pos] < start
            disk[gaps[pos]:gaps[pos]+run_sizes[i]-1] .= @view disk[start:stop]
            disk[start:stop] .= -1
            gaps[pos] += run_sizes[i]
            gap_sizes[pos] -= run_sizes[i]
        end
    end
    for i in eachindex(disk)
        disk[i] == -1 && continue
        part[2] += (i - 1) * disk[i]
    end

    return part
end

@show day09() # [6279058075753, 6301361958738]
