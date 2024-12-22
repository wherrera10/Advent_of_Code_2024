using BenchmarkTools

using Graphs, SparseArrays

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

next22(n) = (a = ((n * 64) ⊻ n) % 16777216; b = ((a ÷ 32) ⊻ a) % 16777216; ((b * 2048) ⊻ b) % 16777216)
bananas22(n, k) = (a = [n % 10]; for _ in 1:k push!(a, n % 10); n = next22(n) end; (a, diff(a)))

function day22()
    part = [0, 0]
    numbers = parse.(Int, split(read("$DIR/day22.txt", String), r"\s+"))
    #numbers = [1,2,3,2024]
    len = length(numbers)
    run_length, diff_length = 2000, 1999

    for i in numbers
        for _ in 1:run_length
            i = next22(i)
        end
        part[1] += i
    end

    all_diff = Int[]
    sequences, diffs = Vector{Vector{Int}}(), Vector{Vector{Int}}()
    for n in numbers
        s, d = bananas22(n, run_length)
        push!(sequences, s)
        push!(diffs, d)
        append!(all_diff, d)
        unique!(all_diff)
    end

    bas = maximum(abs(x) for x in extrema(all_diff)) * 2 + 1
    @assert bas == 19 # base for digit span of diff
    sums = zeros(Int, bas^4)
    @Threads.threads for i in eachindex(sequences)
        for a in 0:bas^4-1
            v = digits(a, base = bas, pad = 4) .- (bas ÷ 2)
            pos = findfirst(j -> diffs[i][j:j+3] == v, 1:diff_length-3)
            isnothing(pos) && continue
            sums[a] += sequences[i][pos+4]
        end
    end
    part[2] =  maximum(sums)

    return part
end

@show day22() # [17577894908, 1931] 
