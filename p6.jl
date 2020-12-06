function parseGroupQuestions(group)
    group = strip(group)
    loadRow(s) = Set(filter(x -> x != '\n', s))

    indivs = loadRow.(split(group, "\n"))
    println(indivs)
    intersect(indivs...)
end