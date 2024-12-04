using BenchmarkTools

const DIR = "aoc_2024"

function day02()
    part = [0, 0]
    reports = [parse.(Int, split(line, r"\s+")) for line in readlines("$DIR/day02.txt")]
    for report in reports
        d = diff(report)
        if all(n -> 1 <= n <= 3, d) || all(n -> -3 <= n <= -1, d)
            part[1] += 1
            part[2] += 1
        else
            for i in eachindex(report)
                d2 = diff(deleteat!(copy(report), i))
                if all(n -> 1 <= n <= 3, d2) || all(n -> -3 <= n <= -1, d2)
                    part[2] += 1
                    break
                end
            end
        end
    end
    return part
end

@show day02() 
