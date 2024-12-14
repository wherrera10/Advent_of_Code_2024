import LinearAlgebra.det

const DIR = "aoc_2024"

function day13()
    part = [0, 0]
    text = read("$DIR/day13.txt", String)
    machines = split(text, "\n\n")
    regex = r"\D+(\d+)\D+(\d+)\n\D+(\d+)\D+(\d+)\n\D+(\d+)\D+(\d+)"
    for m in machines
        ax, ay, bx, by, px, py = parse.(Int, match(regex, m).captures)
        A = [ax bx; ay by]
        for (i, n) in enumerate((0, 10000000000000))
            x, y = (px, py) .+ n
            if abs(det(A)) > 0.01
                a, b = round.(A \ [x, y])
                if ax * a + bx * b == x && ay * a + by * b == y
                    part[i] += 3a + b
                end
            end
        end
    end

    return part
end

@show day13() #  [38714, 74015623345775]
