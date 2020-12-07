include("p7.jl")

rules = Dict(parseRule.(readlines(first(ARGS))))

@memoize function transitivelyHolds(rule, bag)
    println("transitively holds($rule, $bag)")
    directlyHolds(rule, bag) || any(transitivelyHolds(rules[b[2]], bag) for b in rule)
end

@memoize function traverseRule(r)
    1 + ((length(r) > 0) ? sum(c * traverseRule(rules[bn]) for (c,bn) in r) : 0)
end

const goal = "shiny gold"
result = traverseRule(rules[goal]) - 1
println("You need $result bags within your $goal bag")