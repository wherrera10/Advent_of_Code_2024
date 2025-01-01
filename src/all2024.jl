"""
 Day     Seconds
=================
day01   0.0002636
day02   0.0007942
day03   0.0021105
day04   0.0005642
day05   0.0032486
day06   0.018282
day07   0.0011929
day08   0.0002015
day09   0.0085071
day10   0.0007336
day11   1.85e-5
day12   0.0011119
day13   0.0003834
day14   0.0111692
day15   0.0013758
day16   0.0046334
day17   6.05e-5
day18   0.0044444
day19   0.0238405
day20   0.0144332
day21   2.46e-5
day22   0.036901
day23   0.0034165
day24   0.0039299
day25   0.0005664
=================
Total   0.142207
"""

using BenchmarkTools, Graphs, LinearAlgebra, Memoization

const DIR = "aoc_2024"

function day01()
    numbers = parse.(Int, split(read("$DIR/day01.txt", String), r"\s+"))
    a, b = sort!(numbers[1:2:lastindex(numbers)]), sort!(numbers[2:2:lastindex(numbers)])
    sum(abs.(a .- b)), sum(a[i] * count(==(a[i]), b) for i in eachindex(a))
end

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

function day04()
    part = [0, 0]
    mat = stack([collect(line) for line in readlines("$DIR/day04.txt")], dims = 1)
    nrows, ncols = size(mat)
    xmas = ['X', 'M', 'A', 'S']
    samx = ['S', 'A', 'M', 'X']
    for c in CartesianIndices(mat)
        if mat[c] == 'X'
            c[2] < ncols - 2 && mat[c[1], c[2]:c[2]+3] == xmas && (part[1] += 1)
            c[2] > 3 && mat[c[1], c[2]-3:c[2]] == samx && (part[1] += 1)
            c[1] < nrows - 2 && mat[c[1]:c[1]+3, c[2]] == xmas && (part[1] += 1)
            c[1] > 3 && mat[c[1]-3:c[1], c[2]] == samx && (part[1] += 1)
            c[1] < nrows - 2 && c[2] < ncols - 2 && [mat[c[1], c[2]], mat[c[1]+1, c[2]+1], mat[c[1]+2, c[2]+2], mat[c[1]+3, c[2]+3]] == xmas && (part[1] += 1)
            c[1] > 3 && c[2] > 3 && [mat[c[1]-3, c[2]-3], mat[c[1]-2, c[2]-2], mat[c[1]-1, c[2]-1], mat[c[1], c[2]]] == samx && (part[1] += 1)
            c[1] > 3 && c[2] < ncols - 2 && [mat[c[1], c[2]], mat[c[1]-1, c[2]+1], mat[c[1]-2, c[2]+2], mat[c[1]-3, c[2]+3]] == xmas && (part[1] += 1)
            c[1] < nrows - 2 && c[2] > 3 && [mat[c[1]+3, c[2]-3], mat[c[1]+2, c[2]-2], mat[c[1]+1, c[2]-1], mat[c[1], c[2]]] == samx && (part[1] += 1)
        elseif mat[c] == 'A' && 1 < c[1] < nrows && 1 < c[2] < ncols
            mat[c[1]-1, c[2]-1] == 'M' && mat[c[1]-1, c[2]+1] == 'M' && mat[c[1]+1, c[2]-1] == 'S' && mat[c[1]+1, c[2]+1] == 'S' && (part[2] += 1)
            mat[c[1]-1, c[2]-1] == 'M' && mat[c[1]-1, c[2]+1] == 'S' && mat[c[1]+1, c[2]-1] == 'M' && mat[c[1]+1, c[2]+1] == 'S' && (part[2] += 1)
            mat[c[1]-1, c[2]-1] == 'S' && mat[c[1]-1, c[2]+1] == 'S' && mat[c[1]+1, c[2]-1] == 'M' && mat[c[1]+1, c[2]+1] == 'M' && (part[2] += 1)
            mat[c[1]-1, c[2]-1] == 'S' && mat[c[1]-1, c[2]+1] == 'M' && mat[c[1]+1, c[2]-1] == 'S' && mat[c[1]+1, c[2]+1] == 'M' && (part[2] += 1)
        end
    end
    return part
end

function day05()
    part = [0, 0]
    rule_text, update_text = split(read("$DIR/day05.txt", String), "\n\n")
    rules = [parse.(Int, split(line, "|")) for line in split(rule_text, "\n")]
    updates = [parse.(Int, split(line, ",")) for line in split(update_text, "\n")]

    function is_sorted(update, rule_set)
        for rule in rule_set
            p1 = findfirst(==(rule[1]), update)
            if !isnothing(p1)
                p2 = findfirst(==(rule[2]), update)
                if !isnothing(p2) && p1 > p2
                    return false
                end
            end
        end
        return true
    end

    for a in updates
        if is_sorted(a, rules)
            part[1] += a[length(a)÷2+1]
        else
            apply = filter(r -> r[1] in a && r[2] in a, rules)
            while !is_sorted(a, apply)
                for rule in apply
                    while (x = findfirst(==(rule[1]), a)) > findfirst(==(rule[2]), a)
                        a[x], a[x-1] = a[x-1], a[x]
                    end
                end
            end
            part[2] += a[length(a)÷2+1]
        end
    end
    return part
end

right_turn6(d) = mod1(d + 1, 4)
function day06()
    part = [0, 0]
    DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    grid = stack((collect(line) for line in split(read("$DIR/day06.txt", String), "\n")), dims = 1)
    rows, cols = size(grid)
    guard = findfirst(==('^'), grid)
    pos = [guard[1], guard[2]]
    visited = Set{Vector{Int}}()
    guard_states = Dict{Vector{Int}, Vector{Int}}()
    d = 1 # guard is facing north ^ at start
    while true
        push!(visited, pos)
        next = pos .+ DIRECTIONS[d]
        !(1 <= next[1] <= rows && 1 <= next[2] <= cols) && break
        if grid[next[1], next[2]] == '#'
            d = right_turn6(d)
        else
            if next ∉ visited
                guard_states[[pos[1], pos[2], d]] = [next[1], next[2]]
            end
            pos = next
        end
    end
    part[1] = length(visited)

    possible_jumps = Dict{Vector{Int}, Vector{Int}}()
    for ((x, y, d), (x_obstacle, y_obstacle)) in collect(guard_states) # every place for an obstacle
        visited2 = Set{Vector{Int}}()
        push!(visited2, [x, y, d]) # direction sensitive for part 2
        off_grid = false
        while true
            dx, dy = DIRECTIONS[d]
            old_state = [x, y, d]
            if x != x_obstacle && y != y_obstacle && haskey(possible_jumps, [x, y, d])
                x, y, d = possible_jumps[[x, y, d]]
                if x == 0
                    break
                end
            else
                while true # move along til obstruction or off grid
                    x += dx
                    y += dy
                    if !(1 <= x <= rows && 1 <= y <= cols)
                        possible_jumps[[x, y, d]] = [0, 0, 0] # off grid
                        off_grid = true
                        break
                    elseif x == x_obstacle && y == y_obstacle || grid[x, y] == '#'
                        x -= dx
                        y -= dy
                        d = right_turn6(d)
                        if x != x_obstacle && y != y_obstacle
                            possible_jumps[old_state] = [x, y, d]
                        end
                        break
                    end
                end
            end
            off_grid && break
            if [x, y, d] ∈ visited2
                part[2] += 1
                break
            else
                push!(visited2, [x, y, d])
            end
        end
    end

    return part
end

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

delta08(p1, p2) = [p2[1] - p1[1], p2[2] - p1[2]]
function anti_nodes08(p1, p2, rows, cols)
    nodes = Vector{Vector{Int}}()
    d = delta08(p1, p2)
    push!(nodes, [p1[1] - d[1], p1[2] - d[2]], [p2[1] + d[1], p2[2] + d[2]])
    return filter(n -> 1 <= n[1] <= rows && 1 <= n[2] <= cols, nodes)
end
function updated_rules08(p1, p2, rows, cols)
    nodes = Vector{Vector{Int}}()
    d = delta08(p1, p2)
    d .÷= gcd(d[1], d[2])
    p = copy(p1)
    while 1 <= p[1] <= rows && 1 <= p[2] <= cols
        push!(nodes, p)
        p = p .- d
    end
    p = copy(p1)
    while 1 <= p[1] <= rows && 1 <= p[2] <= cols
        push!(nodes, p)
        p = p .+ d
    end
    return nodes
end
function day08()
    grid = stack((collect(line) for line in split(read("$DIR/day08.txt", String), "\n")), dims = 1)
    rows, cols = size(grid)
    frequencies = Dict{Char, Vector{Vector{Int}}}()
    locations = Vector{Int}[]
    updated = Vector{Int}[]
    for p in CartesianIndices(grid)
        if grid[p] != '.'
            if !haskey(frequencies, grid[p])
                frequencies[grid[p]] = Vector{Vector{Int}}()
            end
            push!(frequencies[grid[p]], [p[1], p[2]])
        end
    end
    for pos in values(frequencies)
        for i in eachindex(pos)
            for j in i+1:length(pos)
                nodes = anti_nodes08(pos[i], pos[j], rows, cols)
                append!(locations, updated_rules08(pos[i], pos[j], rows, cols))
                append!(updated, nodes)
            end
        end
    end
    length(unique(locations)), length(unique(updated))
end

function day09()
    part = [0, 0]
    numbers = parse.(Int, collect(read("$DIR/day09.txt", String)))
    gaps = Vector{Vector{Int}}()
    raw_disk = Int[]
    gap_positions = Int[]
    runs, run_sizes, gaps, gap_sizes = Int[], Int[], Int[], Int[]
    is_space = false
    id = 0
    for n in numbers
        if is_space
            start = length(raw_disk) + 1
            push!(gaps, start)
            push!(gap_sizes, n)
            for k in start:start+n-1
                push!(raw_disk, -1)
                push!(gap_positions, k)
            end
        else
            push!(runs, length(raw_disk) + 1)
            push!(run_sizes, n)
            for _ in 1:n
                push!(raw_disk, id)
            end
            id += 1
        end
        is_space = !is_space
    end

    disk = copy(raw_disk)
    for i in lastindex(runs):-1:1
        for j in 1:run_sizes[i]
            pos = popfirst!(gap_positions)
            if pos < runs[i] + j - 1
                disk[pos], disk[runs[i]+j-1] = disk[runs[i]+j-1], disk[pos]
            end
            isempty(gap_positions) && break
        end
        isempty(gap_positions) && break
    end

    for i in eachindex(disk)
        disk[i] == -1 && break
        part[1] += (i - 1) * disk[i]
    end

    disk = copy(raw_disk)
    for i in length(runs):-1:1
        start, stop = runs[i], runs[i] + run_sizes[i] - 1
        pos = findfirst(>=(run_sizes[i]), gap_sizes)
        if !isnothing(pos) && gaps[pos] < start
            disk[gaps[pos]:gaps[pos]+run_sizes[i]-1] .= @view disk[start:stop]
            disk[start:stop] .= -1
            gaps[pos] += run_sizes[i]
            gap_sizes[pos] -= run_sizes[i]
        end
    end
    for i in eachindex(disk)
        disk[i] == -1 && continue
        part[2] += (i - 1) * disk[i]
    end

    return part
end

function day10()
    part = [0, 0]
    mat = parse.(Int8, stack([collect(line) for line in readlines("$DIR/day10.txt")], dims = 1))
    rows, cols = size(mat)
    for t in findall(==(0), mat)
        trails = [[t[1], t[2]]]
        new_trails = empty(trails)
        for wanted in 1:9
            for (x, y) in trails
                append!(new_trails, filter(c -> 1 <= c[1] <= rows && 1 <= c[2] <= cols && mat[c[1], c[2]] == wanted,
                    [[x - 1, y], [x, y + 1], [x + 1, y], [x, y - 1]]))
            end
            trails, new_trails = new_trails, trails
            empty!(new_trails)
        end
        part[1] += length(unique(trails))
        part[2] += length(trails)
    end

    return part
end

const MAX_BLINKS11 = 75
const CACHE11 = Dict{Int, Int}()
function day11_blink(stone, n)
    n < 1 && return 1
    n -= 1
    iszero(stone) && return day11_blink(1, n)
    key = stone * MAX_BLINKS11 + n
    if haskey(CACHE11, key)
        return CACHE11[key]
    end
    d = ndigits(stone)
    len = iseven(d) ?
          (i = 10^(d ÷ 2); day11_blink(stone ÷ i, n) + day11_blink(stone % i, n)) :
          day11_blink(stone * 2024, n)
    CACHE11[key] = len
    return len
end

function day11()
    base_stones = parse.(Int, split(read("$DIR/day11.txt", String), r"\s+"))
    return sum(day11_blink(s, 25) for s in base_stones), sum(day11_blink(s, 75) for s in base_stones)
end

function day12()
    part = [0, 0]
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    d_bits = [1, 4, 16, 64]
    quadrants = [1 | 64, 1 | 4, 16 | 64, 16 | 4]
    mat = stack([collect(line) for line in readlines("$DIR/day12.txt")], dims = 1)
    rows, cols = size(mat)
    seen = falses(rows, cols)
    current = Vector{Int}[]

    for r in 1:rows, c in 1:cols
        if !seen[r, c]
            seen[r, c] = true
            corners, perimeter, area = 0, 0, 0
            v = mat[r, c]
            push!(current, [r, c])
            while !isempty(current)
                sort!(current)
                x, y = popfirst!(current)
                area += 1
                edge_count = 4
                d = 0
                for (i, (dx, dy)) in enumerate(directions)
                    x2, y2 = x + dx, y + dy
                    if 1 <= x2 <= rows && 1 <= y2 <= cols && mat[x2, y2] == v
                        d |= d_bits[i]
                        edge_count -= 1
                        if !seen[x2, y2]
                            seen[x2, y2] = true
                            push!(current, [x2, y2])
                        end
                    end
                end
                q2 = d & quadrants[1] # upper left, quadrant 2
                if q2 == 0 || q2 == quadrants[1] && mat[x-1, y-1] != v
                    corners += 1
                end
                q1 = d & quadrants[2]
                if q1 == 0 || q1 == quadrants[2] && mat[x-1, y+1] != v
                    corners += 1
                end
                q3 = d & quadrants[3]
                if q3 == 0 || q3 == quadrants[3] && mat[x+1, y-1] != v
                    corners += 1
                end
                q4 = d & quadrants[4]
                if q4 == 0 || q4 == quadrants[4] && mat[x+1, y+1] != v
                    corners += 1
                end
                perimeter += edge_count
            end
            part[1] += perimeter * area
            part[2] += corners * area
        end
    end

    return part
end

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

function day14()
    part = [0, 0]

    regex = r"[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)[^\d-]+([\d-]+)"
    robots = Vector{Int}[]
    for line in readlines("$DIR/day14.txt")
        push!(robots, parse.(Int, match(regex, line)))
    end
    x_size, y_size = 101, 103
    quad_counts = [0, 0, 0, 0]

    for r in robots
        x, y = mod(r[1] + 100 * r[3], x_size), mod(r[2] + 100 * r[4], y_size)
        if x < 50
            if y < 51
                quad_counts[2] += 1
            elseif y > 51
                quad_counts[3] += 1
            end
        elseif x > 50
            if y < 51
                quad_counts[1] += 1
            elseif y > 51
                quad_counts[4] += 1
            end
        end
    end
    part[1] = prod(quad_counts)

    col_sums, row_sums = zeros(Int, x_size), zeros(Int, y_size)
    for i in 1:100_000
        for r in robots
            r[1]             = mod(r[1] + r[3], x_size)
            r[2]             = mod(r[2] + r[4], y_size)
            col_sums[r[1]+1] += 1
            row_sums[r[2]+1] += 1
        end
        if any(>(30), col_sums) && any(>(30), row_sums)
            part[2] = i
            break
        end
        col_sums .= 0
        row_sums .= 0
    end

    return part
end

function row_tiles_to_move_day15(mat, dir, p, mov)
    indexes = [p]
    d = dir[mov]
    if mat[p] != 'O' && mov ∈ [1, 3] # north, south
        if mat[p] == '['
            push!(indexes, CartesianIndex(p[1], p[2] + 1))
        elseif mat[p] == ']'
            push!(indexes, CartesianIndex(p[1], p[2] - 1))
        end
    end
    for q in indexes
        x, y = q[1] + d[1], q[2] + d[2]
        mat[x, y] == '#' && return empty(indexes)
    end
    return indexes
end
function step_day15(mat, rows, cols, directions, pos, mov)
    d = directions[mov]
    next_pos = CartesianIndex(pos[1] + d[1], pos[2] + d[2])
    !(1 <= next_pos[1] <= rows && 1 <= next_pos[2] <= cols) && return pos
    mat[next_pos] == '#' && return pos
    if mat[next_pos] == '.'
        mat[pos] = '.'
        pos = next_pos
        mat[pos] = '@'
    elseif mat[next_pos] in "[]O"
        indexes = row_tiles_to_move_day15(mat, directions, next_pos, mov)
        if !isempty(indexes)
            d = directions[mov]
            for c in indexes
                p2 = CartesianIndex(c[1] + d[1], c[2] + d[2])
                if mat[p2] == '#'
                    empty!(indexes)
                    break
                end
                if mat[p2] != '.'
                    indexes2 = row_tiles_to_move_day15(mat, directions, p2, mov)
                    if isempty(indexes2)
                        empty!(indexes)
                        break
                    end
                    append!(indexes, indexes2)
                end
            end
        end
        if !isempty(indexes)
            for c in reverse!(indexes)
                x, y = c[1] + d[1], c[2] + d[2]
                mat[c], mat[x, y] = mat[x, y], mat[c]
            end
            mat[pos] = '.'
            mat[next_pos] = '@'
            pos = next_pos
        end
    end # do nothing if mat[next_pos] == '#'
    return pos
end

score15(p) = 100 * (p[1] - 1) + p[2] - 1
total_score15(mat) = sum(map(score15, filter(c -> mat[c] ∈ "[O", CartesianIndices(mat))))
function day15()
    part = [0, 0]

    room, move_chars = split(read("$DIR/day15.txt", String), "\n\n")
    base_mat = stack([collect(line) for line in split(room, "\n")], dims = 1)
    mat = deepcopy(base_mat)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    moves = map(ch -> findfirst(==(ch), "^>v<"), filter(c -> c in "^>v<", collect(move_chars)))

    pos = findfirst(==('@'), mat)
    for i in eachindex(moves)
        mov = moves[i]
        pos = step_day15(mat, rows, cols, directions, pos, mov)
    end
    part[1] = total_score15(mat)

    cols *= 2
    mat = fill('.', rows, cols)
    for c in CartesianIndices(base_mat)
        x, y = c[1], 2 * c[2]
        s = base_mat[c]
        mat[x, y-1] = s == 'O' ? '[' : s
        if s != '@'
            mat[x, y] = s == 'O' ? ']' : s
        end
    end

    pos = findfirst(==('@'), mat)
    for i in eachindex(moves)
        mov = moves[i]
        pos = step_day15(mat, rows, cols, directions, pos, mov)
    end
    part[2] = total_score15(mat)

    return part
end

function dfs16(vtx, set, allset, arr)
    a = arr[vtx]
    for p in a
        if p ∉ allset
            push!(allset, p)
            push!(set, p ÷ 5)
            dfs16(p, set, allset, arr)
        end
    end
end
left16(d) = mod1(d - 1, 4)
right16(d) = mod1(d + 1, 4)
function day16()
    part = [0, 0]

    mat = stack([collect(line) for line in readlines("$DIR/day16.txt")], dims = 1)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    start_c = findfirst(c -> mat[c] == 'S', CartesianIndices(mat))
    xb, yb = start_c[1], start_c[2]
    stop_c = findfirst(c -> mat[c] == 'E', CartesianIndices(mat))
    xe, ye = stop_c[1], stop_c[2]
    mat[stop_c] = '.'

    moves = [[0, xb, yb, 2]]
    costs_mat = fill(typemax(Int), rows, cols)
    costs_mat[xb, yb] = 0
    while !isempty(moves)
        sort!(moves)
        cost, x, y, d = popfirst!(moves)
        for (d2, c2) in [[d, cost + 1], [left16(d), cost + 1001], [right16(d), cost + 1001]]
            x2, y2 = x + directions[d2][1], y + directions[d2][2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && mat[x2, y2] != '#' && c2 < costs_mat[x2, y2]
                costs_mat[x2, y2] = c2
                push!(moves, [c2, x2, y2, d2])
            end
        end
    end
    part[1] = costs_mat[xe, ye]

    moves = [[costs_mat[xe, ye], xe, ye, 3], [costs_mat[xe, ye], xe, ye, 4]]
    visited = Set{Vector{Int}}()
    while !isempty(moves)
        sort!(moves)
        cost, x, y, d = popfirst!(moves)
        for (d2, c2) in [[d, cost - 1], [left16(d), cost - 1001], [right16(d), cost - 1001]]
            x2, y2 = x + directions[d2][1], y + directions[d2][2]
            if 1 <= x2 <= rows && 1 <= y2 <= cols && costs_mat[x2, y2] ∈ [c2, c2 - 1000] && [x2, y2] ∉ visited
                part[2] += 1
                push!(moves, [c2, x2, y2, d2])
                push!(visited, [x2, y2])
            end
        end
    end
    part[2] += 1

    return part
end

combo17(i, a, b, c) = i < 4 ? i : i == 4 ? a : i == 5 ? b : i == 6 ? c : error("bad operand $i")
function run17(program, a, b = 0, c = 0)
    ip = 0
    len = length(program)
    output = Int8[]
    for _ in 1:typemax(Int32)
        ip >= len && break
        opr, opd = program[ip+1], program[ip+2]
        if opr == 0
            a = a ÷ 2^combo17(opd, a, b, c)
        elseif opr == 1
            b = b ⊻ opd
        elseif opr == 2
            b = combo17(opd, a, b, c) % 8
        elseif opr == 3
            a != 0 && (ip = opd - 2)
        elseif opr == 4
            b = b ⊻ c
        elseif opr == 5
            push!(output, combo17(opd, a, b, c) % 8)
        elseif opr == 6
            b = a ÷ 2^(combo17(opd, a, b, c))
        elseif opr == 7
            c = a ÷ 2^(combo17(opd, a, b, c))
        else
            error("Bad AOC CPU opcode")
        end
        ip += 2
    end
    return output
end
"""
    Part 1 is straightforward. For part 2, pencil and paper can be used.
    The last instruction is a jump to reset IP to 1, the start. Most 
    instructions involve a XOR, division by 8, or saving A to B or C, often
    as mod 8. 

    The serial XOR is reversible, and the division by 8 can be seen as a kind of
    popping of octal digits from register A to B for output via a right shift. 
    So, we wrote candidates for register A as a sequence of octal digits. The 
    first octal digits of A should reflect the last digits of the program.
    
    Working backwards with pencil and paper and the Julia REPL, we got octal 
    number 7026424356514772 (base 8) working as candidate for A. 
    
    This was not the minimum, though, so below we loop and check octal digit
    changes in 0o7026424356514772 to find part 2's minimum value.
"""
function day17()
    part = [Int8[], 0]
    arr = parse.(Int, filter(!isempty, split(read("$DIR/day17.txt", String), r"[\D]+")))
    a, b, c, program = arr[1], arr[2], arr[3], arr[4:end]

    part[1] = run17(program, a, b, c)
    target = copy(program)
    len = length(program)
    oct = 0o7026424356514772
    d = digits(oct, base = 8)
    candidates = Int[]
    for i in eachindex(d)
        for j in 0:7
            prev = d[i]
            d[i] = j
            if program == run17(program, evalpoly(8, d), b, c)
                push!(candidates, a)
            end
            d[i] = prev
        end
    end
    part[2] = minimum(candidates)
    return part
end

const DIRECTIONS18 = [[-1, 0], [0, 1], [1, 0], [0, -1]]
const MATRIX_SIZE18 = 71
function bfs18(mat)
    moves = [[0, 1, 1]]
    visited = Set{Vector{Int}}()
    while !isempty(moves)
        sort!(moves)
        dist, x, y = popfirst!(moves)
        if [x, y] ∉ visited
            push!(visited, [x, y])
            if x == MATRIX_SIZE18 && y == MATRIX_SIZE18
                return dist
            end
            for (dx, dy) in DIRECTIONS18
                x2, y2 = x + dx, y + dy
                if 1 <= x2 <= MATRIX_SIZE18 && 1 <= y2 <= MATRIX_SIZE18 && mat[x2, y2] == 0 && [x2, y2] ∉ visited
                    push!(moves, [dist + 1, x2, y2])
                end
            end
        end
    end
    return -1 # fail
end
function day18()
    part = [0, String]
    numbers = parse.(Int, split(read("$DIR/day18.txt", String), r"\D+"))
    bytes = [[numbers[i-1] + 1, numbers[i] + 1] for i in 2:2:length(numbers)]
    rows, cols = MATRIX_SIZE18, MATRIX_SIZE18
    grid = zeros(Int8, rows, cols)
    for (x, y) in @view bytes[1:1024]
        grid[x, y] = 1
    end

    part[1] = bfs18(grid)

    mat = copy(grid)
    left, right = 1025, length(bytes)
    while left < right
        mid = (right + left) ÷ 2
        for i in left:mid
            x, y = bytes[i]
            mat[x, y] = 1
        end
        if bfs18(mat) > 0
            left = mid + 1
        else
            right = mid
            mat = copy(grid)
            for i in 1:left
                x, y = bytes[i]
                mat[x, y] = 1
            end
        end
    end
    part[2] = "$(bytes[left][1]-1),$(bytes[left][2]-1)"

    return part
end

@memoize all19(s, a) = sum((p == s) + (startswith(s, p) ? (all19(s[length(p)+1:end], a)) : 0) for p in a)
function day19()
    text1, text2 = split(read("$DIR/day19.txt", String), "\n\n")
    patterns, desired = split(text1, r"\s?,\s?"), split(text2, r"\s+")
    locker = ReentrantLock()
    n_can, n_all = 0, 0
    Threads.@threads for s in desired
        k = all19(s, patterns)
        if k > 0
            lock(locker)
            n_can += 1
            n_all += k
            unlock(locker)
        end
    end
    n_can, n_all
end

vec20(c) = [c[1], c[2]]
city20(x1, y1, x2, y2) = abs(x1 - x2) + abs(y1 - y2)
function day20()
    part = [0, 0]
    grid = stack([collect(line) for line in readlines("$DIR/day20.txt")], dims = 1)
    rows, cols = size(grid)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    stop_c = vec20(findfirst(c -> grid[c] == 'E', CartesianIndices(grid)))
    x0, y0 = vec20(findfirst(c -> grid[c] == 'S', CartesianIndices(grid)))
    moves = Vector{Int}[]
    while true
        push!(moves, [x0, y0])
        x, y = x0, y0
        [x, y] == stop_c && break
        grid[x, y] = '#'
        for (dx, dy) in directions
            x2, y2 = x + dx, y + dy
            if grid[x2, y2] != '#'
                x0, y0 = x2, y2
                break
            end
        end
    end
    len = length(moves)
    for i in 1:len-1
        x, y = moves[i]
        j = i + 100
        while j <= len
            x2, y2 = moves[j]
            delta = city20(x, y, x2, y2)
            if delta < 21 && j - i - delta >= 100
                delta == 2 && (part[1] += 1)
                part[2] += 1
            elseif delta > 20
                j += delta - 20
                continue
            end
            j += 1
        end
    end

    return part
end

const NUMERIC_PAD21 = ['7' '8' '9'; '4' '5' '6'; '1' '2' '3'; ' ' '0' 'A']
const DIRECTIONAL_PAD21 = [' ' '^' 'A'; '<' 'v' '>']
@memoize function numeric21_moves(from, to)
    from == to && return [['A']]
    c1, c2 = findfirst(==(from), NUMERIC_PAD21), findfirst(==(to), NUMERIC_PAD21)
    dx, dy = c2[1] - c1[1], c2[2] - c1[2]
    x, y = (dx >= 0 ? 'v' : '^'), (dy >= 0 ? '>' : '<')
    sx, sy = (x == 'v' ? 1 : -1), (y == '>' ? 1 : -1)
    if c1[2] == 1 && c2[1] == 4
        return [[fill(y, sy * dy); fill(x, sx * dx); 'A']]
    elseif c1[1] == 4 && c2[2] == 1
        return [[fill(x, sx * dx); fill(y, sy * dy); 'A']]
    else
        return unique([[fill(y, sy * dy); fill(x, sx * dx); 'A'], [fill(x, sx * dx); fill(y, sy * dy); 'A']])
    end
end
@memoize function directional21_moves(from, to)
    from == to && return [['A']]
    c1, c2 = findfirst(==(from), DIRECTIONAL_PAD21), findfirst(==(to), DIRECTIONAL_PAD21)
    dx, dy = c2[1] - c1[1], c2[2] - c1[2]
    x, y = (dx >= 0 ? 'v' : '^'), (dy >= 0 ? '>' : '<')
    sx, sy = (x == 'v' ? 1 : -1), (y == '>' ? 1 : -1)
    if c1[2] == 1
        return [[fill(y, sy * dy); fill(x, sx * dx); 'A']]
    elseif c2[2] == 1
        return [[fill(x, sx * dx); fill(y, sy * dy); 'A']]
    else
        return unique([[fill(y, sy * dy); fill(x, sx * dx); 'A'], [fill(x, sx * dx); fill(y, sy * dy); 'A']])
    end
end
@memoize function robot_move_length21(from::Char, to::Char, robot_chain_depth, depth)
    from == to && return 1 # just press key (eg. A)
    depth > robot_chain_depth && return 1 # user presses the key
    min_length = typemax(Int)
    choices = depth == 0 ? numeric21_moves(from, to) : directional21_moves(from, to)
    for moves in choices
        new_length, prev = 0, 'A'
        for m in moves
            new_length += robot_move_length21(prev, m, robot_chain_depth, depth + 1)
            prev = m
        end
        min_length = new_length < min_length ? new_length : min_length
    end
    return min_length
end
function day21()
    part = [0, 0]

    sequences = split(strip(read("$DIR/day21.txt", String)))
    numbers = parse.(Int, filter.(ch -> ch < 'A' || ch >= 'Z', sequences))
    for i in eachindex(sequences)
        total = 0
        prev = 'A'
        for ch in sequences[i]
            total += robot_move_length21(prev, ch, 2, 0)
            prev = ch
        end
        part[1] += total * numbers[i]
    end

    for i in eachindex(sequences)
        total = 0
        prev = 'A'
        for ch in sequences[i]
            total += robot_move_length21(prev, ch, 25, 0)
            prev = ch
        end
        part[2] += total * numbers[i]
    end

    return part
end

function next22(n)
    n = ((n << 6) ⊻ n) & 0xffffff
    n = ((n >> 5) ⊻ n) % 16777216
    ((n << 11) ⊻ n) % 16777216
end
function day22()
    part = [0, 0]
    numbers = parse.(Int, split(read("$DIR/day22.txt", String), r"\s+"))
    sequences, diffs = [Int8[] for _ in eachindex(numbers)], [Int8[] for _ in eachindex(numbers)]
    n = 0
    for i in eachindex(numbers)
        n = numbers[i]
        push!(sequences[i], n % 10)
        for _ in 1:2000
            n = next22(n)
            push!(sequences[i], n % 10)
        end
        part[1] += n
        diffs[i] = Int8.(diff(sequences[i]))
    end
    unseen = trues(19, 19, 19, 19, length(diffs))
    sums = zeros(Int, 19, 19, 19, 19)
    a, b, c, d = 0, 0, 0, 0
    len = length(diffs[1])
    for i in eachindex(diffs)
        a, b, c, d = diffs[i][1:4] .+ 10
        j = 5
        while j <= len
            if unseen[a, b, c, d, i]
                unseen[a, b, c, d, i] = false
                sums[a, b, c, d] += sequences[i][j]
            end
            a, b, c = b, c, d
            d = diffs[i][j] + 10
            j += 1
        end
    end
    part[2] = maximum(sums)

    return part
end

function day23()
    part = [0, ""]

    links = [split(strip(line), "-") for line in readlines("$DIR/day23.txt")]
    len = length(links) # 3380

    triplets = Set{Vector{Int}}()
    computers = sort!(unique!(reduce(vcat, links)))
    numbers_to_names = Dict(enumerate(computers))
    names_to_numbers = Dict((k => v) for (v, k) in enumerate(computers))
    g = SimpleGraph{Int}(len)
    for x in links
        e1, e2 = names_to_numbers[x[1]], names_to_numbers[x[2]]
        add_edge!(g, e1, e2)
        add_edge!(g, e2, e1)
    end
    for v in vertices(g)
        if haskey(numbers_to_names, v) && startswith(numbers_to_names[v], 't')
            neigh = neighbors(g, v)
            for i in eachindex(neigh), j in i+1:lastindex(neigh)
                if has_edge(g, neigh[i], neigh[j])
                    push!(triplets, sort!([v, neigh[i], neigh[j]]))
                end
            end
        end
    end

    part[1] = length(triplets)

    q = maximal_cliques(g)
    _, idx = findmax(length, q)
    part[2] = join(sort!(map(n -> numbers_to_names[n], q[idx])), ",")

    return part
end

function day24()
    part = [0, ""]

    v_text, eq_text = split(read("$DIR/day24.txt", String), "\n\n")

    all_z_var = Set{String}()
    d_val = Dict{String, Bool}()
    for line in split(v_text, "\n")
        var, s = split(line, r":\s*")
        d_val[var] = parse(Bool, s)
    end
    vals = deepcopy(d_val)

    d_eq = Vector{String}[]
    active = collect(keys(d_val))
    for line in split(eq_text, "\n")
        var1, logic, var2, var3 = split(line, r"[\s\->]+")
        push!(d_eq, [var1, logic, var2, var3])
        startswith(var3, 'z') && push!(all_z_var, var3)
    end
    while !all(v -> v in active, all_z_var)
        for (v1, b, v2, v3) in d_eq
            if haskey(vals, v1) && haskey(vals, v2)
                vals[v3] = b == "OR" ? (vals[v1] | vals[v2]) : b == "XOR" ? (vals[v1] ⊻ vals[v2]) : (vals[v1] & vals[v2])
                push!(active, v3)
            end
        end
    end
    part[1] = evalpoly(2, map(k -> vals[k], sort!(collect(all_z_var))))

    for a in d_eq
        if a[1] < a[3]
            a[1], a[3] = a[3], a[1]
        end
    end

    sort!(d_eq, rev = true)
    max_bits = parse(Int, d_eq[1][1][2:end])
    routines = Vector{Vector{String}}[]
    push!(routines, filter(a -> "y00" in a, d_eq))
    for bit in 1:max_bits
        r = filter(a -> "y" * string(bit, pad = 2) in a, d_eq)
        i, j = findfirst(a -> a[2] == "AND", r), findfirst(a -> a[2] == "XOR", r)
        out, carry = r[i][4], r[j][4]
        append!(r, filter(a -> carry in a, d_eq))
        append!(r, filter(a -> out in a, d_eq))
        push!(routines, unique!(r))
    end

    swap_items = String[]
    for a in routines
        if 2 < length(a) < 5
            if a[3][4][1] != 'z'
                j = findfirst(v -> v[4][1] == 'z', a)
                if !isnothing(j)
                    a[j][4], a[3][4] = a[3][4], a[j][4]
                    push!(swap_items, a[j][4], a[3][4])
                    missing_routines = filter(v -> a[2][4] ∈ v && v ∉ a, d_eq)
                    append!(a, missing_routines)
                end
            end
        end
    end
    sort!.(routines, by = a -> a[1][1] == 'y' ? a[1] : a[2], rev = true)

    for a in routines
        if length(a) == 5
            if a[3][4][1] != 'z'
                j = a[4][4][1] == 'z' ? 4 : 5
                a[3][4], a[j][4] = a[j][4], a[3][4]
                push!(swap_items, a[3][4], a[j][4])
            elseif a[1][4] ∉ [a[3][1], a[3][3]] && a[1][4] ∈ a[4] && a[2][4] ∈ a[3] && a[2][4] ∈ a[5]
                a[1][4], a[2][4] = a[2][4], a[1][4]
                push!(swap_items, a[1][4], a[2][4])
            end
        end
    end

    part[2] = join(sort!(swap_items), ",")

    return part
end

function day25()
    tops, bottoms = Matrix{Char}[], Matrix{Char}[]
    for s in split(read("$DIR/day25.txt", String), "\n\n")
        push!((s[1] == '#' ? tops : bottoms), stack([collect(line) for line in split(s, "\n")], dims = 1))
    end
    rows, cols = size(tops[1])

    key_sums = [[count(==('#'), @view t[:, i]) for i in 1:cols] for t in tops]
    lock_sums = [[count(==('#'), @view t[:, i]) for i in 1:cols] for t in bottoms]
    return count(all(c -> t[c] + b[c] <= rows, 1:cols) for t in key_sums, b in lock_sums)
end

function time2024()
    tsum = 0.0
    println(" Day     Seconds\n=================")
    for f in [day01, day02, day03, day04, day05, day06, day07, day08, day09, day10, day11, day12, day13,
        day14, day15, day16, day17, day18, day19, day20, day21, day22, day23, day24, day25]
        t = @belapsed $f()
        println(f, "   ", t)
        tsum += t
    end
    println("=================\nTotal   ", tsum)
end

time2024()
