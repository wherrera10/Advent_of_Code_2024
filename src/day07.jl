using BenchmarkTools

const DIR = "aoc_2024"

function day07()
    part = [0, 0]
    loc = ReentrantLock()

    @Threads.threads for line in readlines("$DIR/day07.txt")
        a = parse.(Int, split(line, r"\D+"))
        net, factors = a[1], a[2:end]
        len = length(factors) - 1
        result = 0
        for i in 0:2^len-1
            result = factors[1]
            j = 2
            for dig in digits(i, base=2, pad=len)
                if dig == 0
                    result += factors[j]
                else
                    result *= factors[j]
                end
                j += 1
                result > net && break
            end
            if net == result
                lock(loc)
                part[1] += net
                unlock(loc)
                break
            end
        end

        for i in 0:3^len-1
            result = factors[1]
            j = 2
            for dig in digits(i, base=3, pad=len)
                if dig == 0
                    result += factors[j]
                elseif dig == 1
                    result *= factors[j]
                else # ||
                    result = result * 10^ndigits(factors[j]) + factors[j]
                end
                j += 1
                result > net && break
            end
            if net == result
                lock(loc)
                part[2] += net
                unlock(loc)
                break
            end
        end    
    end

    return part 
end

@show day07() #  [28730327770375, 424977609625985]
