const DIR = "aoc_2024"

function day24()
    part = [0, ""]

    v_text, eq_text = split(read("$DIR/day24.txt", String), "\n\n")

    all_z_var = Set{String}()
    all_x_var = Set{String}()
    all_y_var = Set{String}()
    d_val = Dict{String, Bool}()
    for line in split(v_text, "\n")
        var, s = split(line, r":\s*")
        d_val[var] = parse(Bool, s)
        startswith(var, 'x') && push!(all_x_var, var)
        startswith(var, 'y') && push!(all_y_var, var)
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

    sort!(d_eq, rev=true)
    max_bits = parse(Int, d_eq[1][1][2:end])
    routines = Vector{Vector{String}}[]
    push!(routines, filter(a -> "y00" in a, d_eq))
    for bit in 1:max_bits
        r = filter(a -> "y" * string(bit, pad=2) in a, d_eq)
        i, j = findfirst(a -> a[2] == "AND", r), findfirst(a -> a[2] == "XOR", r)
        out, carry = r[i][4], r[j][4]
        append!(r, filter(a -> carry in a, d_eq))
        append!(r, filter(a -> out in a, d_eq))
        push!(routines, unique!(r))
    end

    swap_items = String[]
    for a in routines
        if 2 < length(a)  < 5
            a[2][4], a[3][4] = a[3][4], a[2][4]
            push!(swap_items, a[2][4], a[3][4])
            missing_routines = filter(v -> a[2][4] ∈ v && v ∉ a, d_eq)
            append!(a, missing_routines)
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

@show day24() # [59364044286798, "cbj,cfk,dmn,gmt,qjj,z07,z18,z35"]
