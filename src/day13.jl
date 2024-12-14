import LinearAlgebra.det

const DIR = "C:/Users/wherr/OneDrive/Documents/Julia Programs/aoc_2024"

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

        if abs(det(A)) > 0.01
            a, b = round.(A \ [px, py])
            if ax * a + bx * b == px && ay * a + by * b == py
                part[1] += 3a + b
            end
        end

        p2x, p2y = (px, py) .+ 10000000000000
        if abs(det(A)) > 0.01
            a, b = round.(A \ [p2x, p2y])
            if ax * a + bx * b == p2x && ay * a + by * b == p2y
                part[2] += 3a + b
            end
        end
    end

    return part
end

@show day13() #  [38714, 74015623345775]
