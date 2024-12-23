using Combinatorics, Graphs

const DIR = "aoc_2024"

function day23()
    part = [0, ""]

    link_lines = readlines("$DIR/day23.txt")
    links = [split(strip(s), "-") for s in link_lines]
    len = length(links) # 3380

    for i in 1:len, j in i+1:len, k in j+1:len
        a = unique([links[i]; links[j]; links[k]])
        length(a) == 3 && any(s -> startswith(s, 't'), a) && (part[1] += 1)
    end

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
    _, idx = findmax(v -> length(v), q)
    part[2] = join(sort!(map(n -> numbers_to_names[n], q[idx])), ",")

    return part
end

@show day23() #  [1218, "ah,ap,ek,fj,fr,jt,ka,ln,me,mp,qa,ql,zg"]
