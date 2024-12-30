const DIR = "aoc_2024"

function next22(n)
    a = ((n * 64) ⊻ n) % 16777216
    b = ((a ÷ 32) ⊻ a) % 16777216
    return ((b * 2048) ⊻ b) % 16777216
end

function day22()
    part = [0, 0]
    numbers = parse.(Int, split(read("$DIR/day22.txt", String), r"\s+"))
    sequences, diffs = [Int[] for _ in eachindex(numbers)], [Int8[] for _ in eachindex(numbers)]
    n = 0
    for i in eachindex(numbers)
        n = numbers[i]
        push!(sequences[i], n % 10)
        for _ in 1:2000
            n = next22(n)
            push!(sequences[i], n % 10)
        end
        part[1] += n
        diffs[i] = Int8.(diff(sequences[i]))
    end
    unseen = trues(19, 19, 19, 19, length(diffs))
    sums = zeros(Int, 19, 19, 19, 19)
    a, b, c, d = 0, 0, 0, 0
    for i in eachindex(diffs)
        a, b, c, d = diffs[i][1:4] .+ 10
        j = 5
        len = length(diffs[i]) - 3
        while j < len
            if unseen[a, b, c, d, i]
                unseen[a, b, c, d, i] = false
                sums[a, b, c, d] += sequences[i][j]
            end
            a, b, c = b, c, d
            d = diffs[i][j] + 10
            j += 1
        end
    end
    part[2] = maximum(sums)

    return part
end

@show day22() # [17577894908, 1931] 
