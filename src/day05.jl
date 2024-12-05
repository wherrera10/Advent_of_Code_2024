using BenchmarkTools

const DIR = "aoc_2024"

function day05()
	part = [0, 0]
	rule_text, update_text = split(read("$DIR/day05.txt", String), "\n\n")
	rules = [parse.(Int, split(line, "|")) for line in split(rule_text, "\n")]
	updates = [parse.(Int, split(line, ",")) for line in split(update_text, "\n")]

	function is_sorted(update)
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
        if is_sorted(a)
    		part[1] += a[length(a)÷2+1]
        else
            apply = filter(r -> r[1] in a && r[2] in a, rules)
            while !is_sorted(a)
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
