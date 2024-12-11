const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"
const MAX_BLINKS = 75
const day11_int_cache = zeros(Int, 10000, MAX_BLINKS + 1) .- 1
const day11_cache = [Dict{Int, Int}() for _ in 1:MAX_BLINKS]

function day11_blink(stone, n)
    n < 1 && return 1
    n -= 1
    iszero(stone) && return day11_blink(1, n)
    if stone < 10000 && (cached = day11_int_cache[stone, n + 1] != -1)
        return cached
    end
    if (cached = get(day11_cache[n + 1], stone, -1)) != -1
        return cached 
    end
    d = ndigits(stone)
    len = iseven(d) ? 
        (i = 10^(d ÷ 2); day11_blink(stone ÷ i, n) + day11_blink(stone % i, n)) :
        day11_blink(stone * 2024, n)
    if stone >= 10000
        day11_cache[n + 1][stone] = len
    else
        day11_int_cache[stone, n + 1] = len
    end
    return len
end

function day11()
    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))
    return sum(day11_blink(s, 25) for s in base_stones), sum(day11_blink(s, 75) for s in base_stones)
end

@show day11() # [193269, 228449040027793]
