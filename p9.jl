test9 = parse.(Int64, readlines("test9.txt"))
in9 = parse.(Int64, readlines("in9.txt"))

allPairSums(ns) = ((ns[i1] + r) for i1 in eachindex(ns) for r in ns[(i1 + 1):end])

function validateList(ns, preambleSize)
    for i in (preambleSize + 1:lastindex(ns))
        window = ns[i - preambleSize:i - 1]
        if ns[i] in allPairSums(window)
            println("$(ns[i]): valid")
        else
            println("$(ns[i]): invalid")
            return
        end
    end
end