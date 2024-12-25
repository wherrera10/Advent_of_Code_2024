
using BenchmarkTools

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

function day25()
    part = [0, 0]

    tops, bottoms = Matrix{Char}[], Matrix{Char}[]
    for s in split(read("$DIR/day25.txt", String), "\n\n")
        push!((s[1:3] == "###" ? tops : bottoms), stack([collect(line) for line in split(s, "\n")], dims = 1))
    end
    rows, cols = size(tops[1])

    tcols, bcols = Vector{Vector{Int}}(), Vector{Vector{Int}}()
    for t in tops
        push!(tcols, [count(==('#'), @view t[:, i]) for i in 1:cols])
    end
    for t in bottoms
        push!(bcols, [count(==('#'), @view t[:, i]) for i in 1:cols])
    end   
    for t in tcols, b in bcols
        if all(col -> t[col] + b[col] <= rows, 1:cols)
            part[1] += 1
        end
    end

    return part 
end

@btime day25()

@show day25() [2978, 0]

