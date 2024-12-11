const DIR = "aoc_2024"

function day11()
    part = [0, 0]

    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))

    function blink(stone)
        iszero(stone) && return [1]
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
    for _ in 1:25
        for stone in stones
            append!(new_stones, blink(stone))
        end
        stones, new_stones = new_stones, stones
        empty!(new_stones)
    end
    part[1] = length(stones)

    stone_counts = Dict(s => 1 for s in base_stones)
    new_stone_counts = empty(stone_counts)
    for _ in 1:75
        for (stone, n) in stone_counts
            for s in blink(stone)
                if !haskey(new_stone_counts, s)
                    new_stone_counts[s] = n 
                else
                    new_stone_counts[s] += n 
                end
            end
        end
        stone_counts, new_stone_counts = new_stone_counts, stone_counts
        empty!(new_stone_counts)
    end
    part[2] = sum(values(stone_counts))

    return part
end

@show day11() # [193269, 228449040027793]
