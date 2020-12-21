# General tools supporting Cellular Automata
module CA

struct CADef
    mapping
end

CADef(args...) = CADef(Dict(args...))



# N-dimensional neighbors function: Return indexes of all inbounds neighbors
# of at most +/- 1 cell away along any number of dimensions, not including `pos`.
# The indexes are returned in the form of arrays which can be used to index `arr`
# via getindex(arr, r...) [FIXME(lincoln): should I use a different data type for index?]
function neighbors(arr, pos)
    if length(pos) == 0
        # base case: no pos left, return [1] as the final 'nullish' dimension
        return [[1]]
    end

    # we're going to use the 1st (remaining) dimension in this instance
    # recur on the remaining dimensions
    dim = 1 + length(size(arr)) - length(pos)
    prior = neighbors(arr, pos[2:end])
    results = []
    ix = pos[1]

    # ok, take the "largest"/last dimension and do +/- 1
    ix2 = ix - 1
    if checkindex(Bool, axes(arr, dim), ix2)
        append!(results, [vcat([ix2], x) for x in prior])
    end

    # include self. This is the only way to make the recursion work
    # (since self in one dimension can be used to do e.g. (+1, 0) and (-1,0)
    # in 2d).
    append!(results, [vcat([ix], x) for x in prior])
    if dim == 1
        # However, this ends up resulting in the final result containing the +(0,0...) etc --
        # in that case, remove it
        results = [r for r in results if r != vcat(pos, [1])]
    end


    ix3 = ix + 1
    if checkindex(Bool, axes(arr, dim), ix3)
        append!(results, [vcat([ix3], x) for x in prior])
    end

    results
end

# Parse a 2d CA array from a string with newlines as the row delimiter
# note that the rows of the original string input become columns of a 2d array!
function parse2d(s)
    hcat(collect.(split(strip(s), "\n"))...)
end

# starting at 'pos' + 'dir', find first non-floor in that direction
# if we run off the edge return 'L'
function findseat(arr, pos, dir)
    pos = pos + dir
    while checkbounds(Bool, arr, CartesianIndex(pos...))
        if arr[pos...] == 'L'
            return 'L'
        elseif arr[pos...] == '#'
            return '#'
        else
            pos = pos + dir
        end
    end
    'L'
end

# returns the new character for `arr` at `pos` in subsequent generation
# using the given CA definition.
function nextgen(cadef, arr, pos)
    pos = Tuple(pos)
    posarray = [pos...]
    #nis = neighbors(arr, posarray)
    ndirs = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
    ns = [findseat(arr, posarray, ni) for ni in ndirs]
    #println("ns of $pos=$ns")
    f = cadef.mapping[arr[pos...]]
    f(ns)
end

function step(cadef, arr)
    map(pos -> nextgen(cadef, arr, pos), CartesianIndices(arr))
end

function converge(cadef, arr)
    printarr(arr)
    while true
        arr2 = step(cadef, arr)
        println("--")
        printarr(arr2)
        if arr2 == arr
            return arr2
        end
        arr = arr2
    end
end

function printarr(arr)
    for y in 1:size(arr)[2]
        println(String(arr[:,y]))
    end
end

end