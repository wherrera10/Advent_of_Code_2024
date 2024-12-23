using Combinatorics, Graphs

const DIR = "aoc_2024"

function day23()
    part = [0, ""]

    links = [split(strip(line), "-") for line in readlines("$DIR/day23.txt")]
    len = length(links) # 3380

    triplets = Set{String}()
    for a in links
        for pos in findall(x -> (x[1] ∈ a || x[2] ∈ a) && a != x, links)
            b = links[pos]
            ab = [a; b]
            b = filter(c -> count(==(c), ab) == 1, ab)
            b2 = [b, reverse(b)]
            pos2 = findfirst(k -> k ∈ b2, links)
            if !isnothing(pos2)
                abc = unique!([a; b; links[pos2]])
                if length(abc) == 3 && any(s -> startswith(s, 't'), abc)
                    push!(triplets, join(sort!(abc)))
                end
            end
        end
    end
    part[1] = length(triplets)

    computers = sort!(unique!(reduce(vcat, links)))
    numbers_to_names = Dict(enumerate(computers))
    names_to_numbers = Dict((k => v) for (v, k) in enumerate(computers))
    g = SimpleGraph{Int}(len)
    for x in links
        e1, e2 = names_to_numbers[x[1]], names_to_numbers[x[2]]
        add_edge!(g, e1, e2)
        add_edge!(g, e2, e1)
    end
    q = maximal_cliques(g)
    _, idx = findmax(length, q)
    part[2] = join(sort!(map(n -> numbers_to_names[n], q[idx])), ",")

    return part
end

@show day23() #  [1218, "ah,ap,ek,fj,fr,jt,ka,ln,me,mp,qa,ql,zg"]
