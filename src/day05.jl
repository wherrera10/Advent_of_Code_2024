using BenchmarkTools

const DIR = "aoc_2024"

function day05()
	part = [0, 0]
	text = read("$DIR/day05.txt", String)
	part1, part2 = split(text, "\n\n")
	rules = Pair{Int}[]
	updates = Vector{Int}[]
	for line in split(part1, "\n")
		push!(rules, Pair(parse.(Int, split(line, "|"))...))
	end
	for line in split(part2, "\n")
		push!(updates, parse.(Int, split(line, ",")))
	end

	function inplace(update)
		for rule in rules
			p1 = findfirst(==(rule[1]), update)
			if !isnothing(p1)
				p2 = findfirst(==(rule[2]), update)
				if !isnothing(p2) && p1 > p2
					return false
				end
			end
		end
		return true
	end

	for a in updates
        if inplace(a)
    		part[1] += a[length(a)÷2+1]
        else
            apply = filter(r -> r[1] in a && r[2] in a, rules)
            while !inplace(a)
                for rule in apply
                    while (x = findfirst(==(rule[1]), a)) > findfirst(==(rule[2]), a)
                        a[x], a[x-1] = a[x-1], a[x]
                    end
                end
            end
            part[2] += a[length(a)÷2+1]
    	end
    end
	return part
end

@show day05()
