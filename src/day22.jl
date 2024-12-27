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

    still_await = Dict{Vector{Int8}, BitSet}()
    sums = Dict{Vector{Int8}, Int}()
    last4 = diffs[1:4] 
    j, len = 5, length(diffs) - 4
    while j < len
        if !haskey(still_await, d4)
            still_await[last4] = trues(len(sequences))
        end
        if still_await[last4][i]
            still_await[last4][i] = false
            sums[last4] += prices[j]
        end
        popfirst!(last4)
        push!(last4, diffs[j])
        j += 1
    end   
    part[2] = maximum(values(sums))

    return part
end

@show day22() # [17577894908, 1931] 
