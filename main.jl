include("p6.jl")

groups = split(read(first(ARGS), String), "\n\n")
questions = parseGroupQuestions.(groups)

sumcounts = sum(length.(questions))

println("questions=$questions, sumcounts=$sumcounts")
