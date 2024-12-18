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
    number 026424356514772 (base 8) working as candidate for A. 
    
    This was not the minimum, though, so below we loop and check two octal digit
    changes in 0o026424356514772 to find part 2's minimum value.
"""
function day17()
    part = [Int8[], 0]
    arr = parse.(Int, filter(!isempty, split(read("$DIR/day17.txt", String), r"[\D]+")))
    a, b, c, program = arr[1], arr[2], arr[3], arr[4:end]
    @show a, b, c, program, string(a, base=8) 
    function run(program, a, b=0, c=0)
        ip = 0
        len = length(program)
        output = Int8[]
        combo(i) = i < 4 ? i : i == 4 ? a : i == 5 ? b : i == 6 ? c : error("bad operand $i")   
        f0(i) =  (a = a ÷ 2^combo(i)) # adv   
        f1(i) = (b = b &#8891; i) # bxl
        f2(i) = (b = combo(i) % 8) # bst
        f3(i) = (if a != 0 ip = i - 2 end)     #jnz
        f4(_) = (b = b &#8891; c) #bxc
        f5(i) = (push!(output, combo(i) % 8))   # out
        f6(i) = (b = a ÷ 2^(combo(i)))  # bdv
        f7(i) = (c = a ÷ 2^(combo(i)))   # cdv
        codes = [f0, f1, f2, f3, f4, f5, f6, f7]
        for i in 1:typemax(Int32)
            ip >= len && break
            opr, opd = program[ip + 1], program[ip+2]
            codes[opr + 1](opd)
            ip += 2
        end
        return output
    end
    part[1] = run(program, a, b, c)
    target = copy(program)
    len = length(program)
    oct = 0o7026424356514772
    d = digits(oct, base=8)
    candidates = Int[]
    for i in eachindex(d), ii in eachindex(d)
        for j in 0:7, k in 0:7
            arr = copy(d)
            arr[i] = j
            arr[ii] = k
            a = evalpoly(8, arr)
            v = run(program, a, b, c)
            if length(v) == len && v == program
                push!(candidates, a)
             #   @show a, string(a, base=8), v, program
            end
        end
    end
    part[2] = minimum(candidates)
    return part
end

@show day17()
