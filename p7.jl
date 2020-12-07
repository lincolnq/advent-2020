using Memoize

__revise_mode__ = :evalassign
const rule = r"(\w+ \w+) bags? contain (.*)\."
const containmentOption = r"\s*(\d+) (\w+ \w+) bags?"
function parseRule(r)
    m = match(rule, r)
    outer = m[1]
    inners = [match(containmentOption, x) for x in split(m[2], ",")]
    if isnothing(first(inners))
        innerRules = []
    else
        innerRules = [(parse(Int64, x[1]), convert(String, x[2])) for x in inners]
    end
    (convert(String, outer), innerRules)
end



@memoize directlyHolds(rule, bag) = any(x[2] == bag for x in rule)


