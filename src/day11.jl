const DIR = "aoc_2024"

function day11()
    part = [0, 0]

    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))

    function blink(stone)
        if iszero(stone) 
            return [1]
        end
        n = ndigits(stone)
        if iseven(n)
            i = n ÷ 2
            d = digits(stone)
            return [evalpoly(10, d[i+1:end]), evalpoly(10, d[1:i])]
        end
        return [stone * 2024]
    end

    new_stones = Int[]
    stones = copy(base_stones)
    for i in 1:25
        for stone in stones
            append!(new_stones, blink(stone))
        end
        stones, new_stones = new_stones, stones
        empty!(new_stones)
    end
    part[1] = length(stones)

    stones = copy(base_stones)
    stonecounts = Dict(s => 1 for s in stones)
    new_stonecounts = empty(stonecounts)
    for i in 1:75
        for (stone, n) in stonecounts
            for s in blink(stone)
                if !haskey(new_stonecounts, s)
                    new_stonecounts[s] = n 
                else
                    new_stonecounts[s] += n 
                end
            end
        end
        stonecounts, new_stonecounts = new_stonecounts, stonecounts
        empty!(new_stonecounts)
    end

    part[2] = sum(values(stonecounts))

    return part
end

@btime day11()

@show day11() # [624, 1483]
