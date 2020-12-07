include("p7.jl")

rules = Dict(parseRule.(readlines(first(ARGS))))

@memoize function transitivelyHolds(rule, bag)
    println("transitively holds($rule, $bag)")
    directlyHolds(rule, bag) || any(transitivelyHolds(rules[b[2]], bag) for b in rule)
end

const goal = "shiny gold"
results = [(r, transitivelyHolds(rules[r], goal)) for r in keys(rules)]
println("number of bag types that can hold $goal = $(sum(x[2] for x in results))")