const DIR = "aoc_2024"

function next22(n)
    a = ((n * 64) ⊻ n) % 16777216
    b = ((a ÷ 32) ⊻ a) % 16777216
    return ((b * 2048) ⊻ b) % 16777216
end

function day22()
    part = [0, 0]
    numbers = parse.(Int, split(read("$DIR/day22.txt", String), r"\s+"))
    all_diff = Int[]
    sequences, diffs = [Int[] for _ in eachindex(numbers)], [Int[] for _ in eachindex(numbers)]
    n = 0
    for i in eachindex(numbers)
        n = numbers[i]
        push!(sequences[i], n % 10)
        for _ in 1:2000
            n = next22(n)
            push!(sequences[i], n % 10)
        end
        part[1] += n
        diffs[i] = diff(sequences[i])
        append!(all_diff, diffs[i])
        unique!(all_diff)
    end

    sums = zeros(Int, 19^4)
    Threads.@threads for i in eachindex(sequences)
        for a in 0:19^4-1
            v = digits(a, base = 19, pad = 4) .- 9
            pos = findfirst(j -> all(v .== @view diffs[i][j:j+3]), 1:1997)
            isnothing(pos) && continue
            sums[a] += sequences[i][pos+4]
        end
    end
    part[2] = maximum(sums)

    return part
end

@show day22() # [17577894908, 1931] 
