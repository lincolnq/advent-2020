function parseInput(s)
    lines = split(s, "\n")
    target = parse(Int64, lines[1])
    buses = tryparse.(Int64, split(lines[2], ","))
    (target, buses)
end

# given the target time and a bus id, find the time of the next time >= target time this bus arrives
function nextbus(target, bus)
    missed_by = mod(target, bus)
    if missed_by == 0
        target
    else
        target + bus - missed_by
    end
end

function solve(target, buses)
    candidates = filter(x->!isnothing(x), buses)
    nexts = [nextbus(target, x) for x in candidates]
    ix = argmin(nexts)
    busid = candidates[ix]
    busid * (nexts[ix] - target)
end