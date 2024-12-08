const DIR = "aoc_2024"

function day08()
    part = [0, 0]

    grid = stack((collect(line) for line in split(read("$DIR/day08.txt", String), "\n")), dims = 1)
    rows, cols = size(grid)
    delta(p1, p2) = [p2[1] - p1[1], p2[2] - p1[2]]

    function antinodes(p1, p2)
        nodes = Vector{Vector{Int}}()
        d = delta(p1, p2)
        push!(nodes, [p1[1] - d[1], p1[2] - d[2]], [p2[1] + d[1], p2[2] + d[2]])
        return filter(n -> 1 <= n[1] <= rows && 1 <= n[2] <= cols, nodes)
    end
    
    frequencies = Dict{Char, Vector{Vector{Int}}}()
    for p in CartesianIndices(grid)
        if grid[p] != '.'
            if !haskey(frequencies, grid[p])
                frequencies[grid[p]] = Vector{Vector{Int}}()
            end
            push!(frequencies[grid[p]], [p[1], p[2]])
        end
    end

    locations = Vector{Int}[]
    for (c, pos) in frequencies
        for i in eachindex(pos)
            for j in i+1:length(pos)
                nodes = antinodes(pos[i], pos[j])
                append!(locations, nodes)
            end
        end
    end
    part[1] = length(unique(locations))

    function updated_rules(p1, p2)
        nodes = Vector{Vector{Int}}()
        d = delta(p1, p2)
        d .÷= gcd(d[1], d[2])
        p = copy(p1)
        while 1 <= p[1] <= rows && 1 <= p[2] <= cols
            push!(nodes, p)
            p = p .- d
        end
        p = copy(p1)
        while 1 <= p[1] <= rows && 1 <= p[2] <= cols
            push!(nodes, p)
            p = p .+ d
        end
        return nodes
    end

    updated = Vector{Int}[]
    for (c, pos) in frequencies
        for i in eachindex(pos)
            for j in i+1:length(pos)
                nodes = updated_rules(pos[i], pos[j])
                append!(updated, nodes)
            end
        end
    end
    part[2] = length(unique(updated))
    
    return part
end

@show day08() # [1530215, 26800609]
