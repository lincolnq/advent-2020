function parseMask(s)
    foldl(((floating, ones), c) -> (2*floating + (c == 'X' ? 1 : 0), 2*ones + (c == '1' ? 1 : 0)), s; init=(0,0))
end

function parseLine(s)
    maskline = r"mask = ([10X]+)$"
    m = match(maskline, s)

    if !isnothing(m)
        # it's a mask line
        return (:setmask, parseMask(m[1]))
    end

    # otherwise it's a memory assignment
    memline = r"mem\[(\d+)\] = (\d+)"
    m = match(memline, s)

    println(m)
    return (:assign, parse(Int64, m[1]), parse(Int64, m[2]))
end

# returns all addresses that come out of applying mask to 'x'
function applyMask((floating, ones), x)
    baseaddr = x | ones
    applyFloating(all1bits(floating), baseaddr)
end

# recur, then apply first onebit to both
function applyFloating(onebits, x)
    if length(onebits) == 0
        [x]
    else
        firstonebit = onebits[1]
        prior = applyFloating(onebits[2:end], x)
        vcat([x | firstonebit for x in prior], [x & ~firstonebit for x in prior])
    end
end

# e.g., for 0b1111, return [0b1000, 0b0100, 0b0010, 0b0001]
function all1bits(floating)
    result = []
    while floating > 0
        # 'next' is floating with the rightmost 1-bit set to zero
        next = floating & (floating - 1)
        # now subtract to get just that 1-bit
        push!(result, floating - next)
        floating = next
    end
    result
end

function run(prog)
    mem = Dict()
    mask = (0,0)

    for line in prog
        println(line)
        if line[1] == :setmask
            mask = line[2]
        elseif line[1] == :assign
            v = line[3]
            ks = applyMask(mask, line[2])
            for k in ks
                #println("assign addr $k=$v")
                mem[k] = v
            end
        end
    end

    sum(values(mem))
end
