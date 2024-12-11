using Memoize

const DIR = "aoc_2024"

@memoize function day11_blink(stone, iterations)
    iterations < 1 && return 1
    iterations -= 1
    iszero(stone) && return day11_blink(1, iterations)
    n = ndigits(stone)
    if iseven(n)
        i = 10^(n ÷ 2)
        return day11_blink(stone ÷ i, iterations) + day11_blink(stone % i, iterations)
    end
    return day11_blink(stone * 2024, iterations)
end

function day11()
    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))
    return sum(day11_blink(s, 25) for s in base_stones), sum(day11_blink(s, 75) for s in base_stones)
end

@show day11() # [193269, 228449040027793]
