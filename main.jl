lines = readlines(first(ARGS))
parsed = parse.(Int, lines)
println("args=$parsed")


sums = [(x, y, z, x + y + z) for x in parsed for y in parsed for z in parsed if x + y + z == 2020]
f = first(sums)
println("sums=$sums, product=$(f[1] * f[2] * f[3])")
