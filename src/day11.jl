const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"
const MAX_BLINKS = 75
const CACHE_SIZE = MAX_BLINKS * 10_000_000
const day11_int_cache = zeros(Int, CACHE_SIZE)
const day11_cache = Dict{Int, Int}()

function day11_blink(stone, n)
    n < 1 && return 1
    n -= 1
    iszero(stone) && return day11_blink(1, n)
    key = stone * CACHE_SIZE + n
    if key <= CACHE_SIZE && (cached = day11_int_cache[key] > 0)
        return cached
    end
    if (cached = get(day11_cache[key], stone, -1)) != -1
        return cached 
    end
    d = ndigits(stone)
    len = iseven(d) ? 
          (i = 10^(d ÷ 2); day11_blink(stone ÷ i, n) + day11_blink(stone % i, n)) :
          day11_blink(stone * 2024, n)
    if key <= CACHE_SIZE
        day11_int_cache[key] = len
    else
        day11_cache[key] = len
    end
    return len
end

function day11()
    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))
    return sum(day11_blink(s, 25) for s in base_stones), sum(day11_blink(s, 75) for s in base_stones)
end

@show day11() # [193269, 228449040027793]
