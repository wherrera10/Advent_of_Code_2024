using Graphs

const DIR = "aoc_2024"

function day23()
    part = [0, ""]

    links = [split(strip(line), "-") for line in readlines("$DIR/day23.txt")]
    len = length(links) # 3380

    triplets = Set{Vector{Int}}()
    computers = sort!(unique!(reduce(vcat, links)))
    numbers_to_names = Dict(enumerate(computers))
    names_to_numbers = Dict((k => v) for (v, k) in enumerate(computers))
    g = SimpleGraph{Int}(len)
    for x in links
        e1, e2 = names_to_numbers[x[1]], names_to_numbers[x[2]]
        add_edge!(g, e1, e2)
        add_edge!(g, e2, e1)
    end
    for v in vertices(g)
        if haskey(numbers_to_names, v) && startswith(numbers_to_names[v], 't')
            neigh = neighbors(g, v)
            for i in eachindex(neigh), j in i:length(neigh)
                if has_edge(g, neigh[i], neigh[j])
                    push!(triplets, sort!([v, neigh[i], neigh[j]]))
                end
            end
        end
    end

    part[1] = length(triplets)

    q = maximal_cliques(g)
    _, idx = findmax(length, q)
    part[2] = join(sort!(map(n -> numbers_to_names[n], q[idx])), ",")

    return part
end

@show day23() #  [1218, "ah,ap,ek,fj,fr,jt,ka,ln,me,mp,qa,ql,zg"]
