struct Policy
    first::Int
    second::Int
    c::Char
end

struct Row
    policy::Policy
    password::String
end

function matchToRow(m)
    Row(Policy(parse(Int, m[1]), parse(Int, m[2]), first(m[3])), m[4])
end

function rowIsValid(row::Row)
    m1 = row.password[row.policy.first] == row.policy.c
    m2 = row.password[row.policy.second] == row.policy.c
    xor(m1,m2)
end

regex = r"^(\d+)-(\d+) ([a-z]): (.*)$"
lines = readlines(first(ARGS))
matched = matchToRow.(match.(regex, lines))

println("row matches=$(rowIsValid.(matched))")
println("valid rows=$(sum(rowIsValid.(matched)))")
