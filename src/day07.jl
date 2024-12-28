const DIR = "aoc_2024"

function dfs07(remaining, factors, target, part)
    remaining == 0 && return target == 0
    target < 0 && return false
    factor = factors[remaining]
    target % factor == 0 && dfs07(remaining - 1, factors, target ÷ factor, part) && return true
    part == 1 && return dfs07(remaining - 1, factors, target - factor, part)
    p10 = 10^ndigits(factor)
    target % p10 == factor && dfs07(remaining - 1, factors, target ÷ p10, part) && return true
    return dfs07(remaining - 1, factors, target - factor, part)
end
function day07()
    part = [0, 0]
    for line in readlines("$DIR/day07.txt")
        a = parse.(Int, split(line, r"\D+"))
        net, factors = a[1], a[2:end]
        part[1] += dfs07(length(factors), factors, net, 1) ? net : 0
        net, factors = a[1], a[2:end]
        part[2] += dfs07(length(factors), factors, net, 2) ? net : 0
    end

    return part
end

@show day07() #  [28730327770375, 424977609625985]
