__revise_mode__ = :evalassign

load(ns) = vcat(0, sort(ns), maximum(ns) + 3)
deltas(ns) = ns[2:end] .- ns[1:end - 1]

test10 = sort(parse.(Int64, readlines("test10.txt")))
in10 = sort(parse.(Int64, readlines("in10.txt")))

# Examples:
# 1, 2:
# 0, 1, 2 (5)
# 0, 2 (5)
# Principle: Always include the last item.
# Principle: For any 3-jump in the source data, you must include both sides of that jump.
# Let's analyze the data to find the must-includes...

# Return the boolean array indicating which elements must be included in every valid charging configuration.
# This helps to greatly narrow the number of configurations that must be searched.
function mustInclude(ns, i)
    if i == lastindex(ns)
        return true
    elseif ns[i + 1] - ns[i] == 3
        return true
    elseif i > 1 && ns[i] - ns[i - 1] == 3
        return true
    else
        return false
    end
end

mustIncludes(ns) = [mustInclude(ns, i) for i in eachindex(ns)]

# Assuming the starting val of `prevval` and that the final element must be taken,
# returns how many valid sequences can be obtained by taking or dropping elements of `ns`,
# such that no jump between numbers is greater than 3.
# We solve this recursively for convenience.
function countValidSeq(prevval, ns)
    # Base case, we have only the last element. 1 if in range of prevval, 0 otherwise.
    if length(ns) == 1
        return convert(Int64, ns[1] - prevval <= 3)
    end

    # try dropping then taking the first element
    drops = countValidSeq(ns[1], ns[2:end])
    takes = countValidSeq(prevval, ns[2:end])

    drops + takes
end

function calculate(ns)
    mi = mustIncludes(ns)

    result = 1
    zeroChain = 0
    prevval = 0
    for i in eachindex(mi)
        if mi[i]
            # we found our 1 after a chain of zeros, run countValidSeq
            if zeroChain >= 1
                subseqResult = countValidSeq(prevval, ns[i - zeroChain:i])
                result *= subseqResult
                println("there were $subseqResult permutations between $prevval and $(ns[i])")
            end

            # now reset the chain and prevval
            zeroChain = 0
            prevval = ns[i]
        else
            # it's a zero
            zeroChain += 1
        end
    end

    result
end