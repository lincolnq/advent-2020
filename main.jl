function parseRow(r::String)
    [c == '#' ? 1 : 0 for c in r if c == '#' || c == '.']
end

const pos = (1,1)

lines = readlines(first(ARGS))
result = parseRow.(lines)
map = hcat(result...)
println("map=$map, size = $(size(map))")
mapw = size(map, 1)
maph = size(map, 2)

function checkVector(vector)
    indexes = [pos .+ (t .* vector) for t in eachindex(result)]
    indexes = [CartesianIndex(mod1(x, mapw), y) for (x,y) in indexes if y <= maph]
    sum(map[indexes])
end

vectors = [(1,1), (3,1), (5,1), (7,1), (1,2)]
results = checkVector.(vectors)

println("results=$(results), prod=$(prod(results))")
