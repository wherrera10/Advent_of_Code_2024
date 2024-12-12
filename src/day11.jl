const DIR = "aoc_2024"
const MAX_BLINKS = 75
const day11_cache = Dict{Int, Int}()

function day11_blink(stone, n)
    n < 1 && return 1
    n -= 1
    iszero(stone) && return day11_blink(1, n)
    key = stone * MAX_BLINKS + n
    if haskey(day11_cache, key)
        return day11_cache[key]
    end
    d = ndigits(stone)
    len = iseven(d) ?
          (i = 10^(d ÷ 2); day11_blink(stone ÷ i, n) + day11_blink(stone % i, n)) :
          day11_blink(stone * 2024, n)
    day11_cache[key] = len
    return len
end

function day11()
    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))
    return sum(day11_blink(s, 25) for s in base_stones), sum(day11_blink(s, 75) for s in base_stones)
end

@show day11() # [193269, 228449040027793]
