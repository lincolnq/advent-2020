__revise_mode__ = :evalassign

include("ca.jl")

SeatingCA = CA.CADef(
    '.' => (_ -> '.'),
    'L' => (ns -> sum(n .== '#' for n in ns) == 0 ? '#' : 'L'),
    '#' => (ns -> sum(n .== '#' for n in ns) >= 5 ? 'L' : '#'),
)

