include("p5.jl")

lines = readlines(first(ARGS))
seatIds = seatId.(parseSeat.(lines))
(lo,hi) = minimum(seatIds), maximum(seatIds)
println("lo=$lo, hi=$hi")
zipped = collect(zip(lo:hi, sort(seatIds)))
nonequal((a,b)) = a != b
println("first missing id is ", first(filter(nonequal, zipped))[1])
