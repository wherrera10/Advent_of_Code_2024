import LinearAlgebra.det

const DIR = "aoc_2024"

function day13()
    part = [0, 0]
    text = read("$DIR/day13.txt", String)
    machines = split(text, "\n\n")
    regex = r"\D+(\d+)\D+(\d+)"

    for m in machines
        a, b, p = split(m, "\n")
        ax, ay = parse.(Int, match(regex, a).captures)
        bx, by = parse.(Int, match(regex, b).captures)
        px, py = parse.(Int, match(regex, p).captures)
        A = [ax bx; ay by]
        for (i, n) in enumerate((0, 10000000000000))
            px, py = (px, py) .+ n
            if abs(det(A)) > 0.01
                a, b = round.(A \ [px, py])
                if ax * a + bx * b == px && ay * a + by * b == py
                    part[i] += 3a + b
                end
            end
        end
    end

    return part
end

@show day13() #  [38714, 74015623345775]
