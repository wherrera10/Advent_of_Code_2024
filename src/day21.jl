using Memoization

const DIR = "aoc_2024"

const numeric21 = ['7' '8' '9'; '4' '5' '6'; '1' '2' '3'; ' ' '0' 'A']
const directional21 = [' ' '^' 'A'; '<' 'v' '>']

@memoize function numeric21_moves(from, to)
    from == to && return [['A']]
    c1, c2 = findfirst(==(from), numeric21), findfirst(==(to), numeric21)
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
    c1, c2 = findfirst(==(from), directional21), findfirst(==(to), directional21)
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

@show day21() # [163920, 204040805018350]
