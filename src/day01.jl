const DIR = "aoc_2024"

function day01()
    numbers = parse.(Int, split(read("$DIR/day01.txt", String), r"\s+"))
    a, b = sort!(numbers[1:2:length(numbers)]), sort!(numbers[2:2:length(numbers)])
    sum(abs.(a .- b)), sum(a[i] * count(==(a[i]), b) for i in eachindex(a))
end

@show day01() 
