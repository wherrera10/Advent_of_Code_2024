const DIR = "aoc_2024"

combo17(i, a, b, c) = i < 4 ? i : i == 4 ? a : i == 5 ? b : i == 6 ? c : error("bad operand $i")   

function run17(program, a, b=0, c=0)
        ip = 0
        len = length(program)
        output = Int8[]
        for _ in 1:typemax(Int32)
            ip >= len && break
            opr, opd = program[ip + 1], program[ip+2]
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
    d = digits(oct, base=8)
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

@show day17()
