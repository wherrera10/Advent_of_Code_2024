using BenchmarkTools

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

function day03()
    part = [0, 0]
    text = read("$DIR/day03.txt", String)
    for m in collect(eachmatch(r"mul\((\d{1,3}),(\d{1,3})\)", text))
        part[1] += prod(parse.(Int, m))
    end
    start = 1
    while start < length(text)
        stop = something(findfirst("don't()", text[start:end]), 1:length(text)).stop + start
        for m in collect(eachmatch(r"mul\((\d{1,3}),(\d{1,3})\)", text[start:stop]))
            part[2] += prod(parse.(Int, m))
        end
        start = something(findfirst("do()", text[stop:end]), 1:length(text)).stop + stop
    end
    return part
end

@show day03() # 54940, 54208
