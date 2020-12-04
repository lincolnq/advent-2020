function parsePassport(s)
    keys_and_vals = split.(split(s, r"\s+"), ":")
    println(keys_and_vals)
    Dict(x for x in keys_and_vals if length(x) == 2)
end

const requiredfields = Set(["byr","iyr","eyr","hgt","hcl","ecl","pid"])
const eyecolors = Set(["amb","blu","brn","gry","grn","hzl","oth"])

function isValid(ppt)
    diffs = setdiff(requiredfields, keys(ppt))
    if length(diffs) > 0
        println("missing $diffs")
        return false
    end

    function valid(name::String, parser, f)
        result = parser(ppt[name])
        if isnothing(result) || !f(result)
            println("invalid $name: $result")
            false
        else
            true
        end
    end

    num(s) = tryparse(Int, s)
    function unit(s)::Union{Tuple{Int64, String}, Nothing}
        result = match(r"^(\d+)(\w+)$", s)
        if isnothing(result) return nothing end
        (parse(Int64, result[1]), result[2])
    end


    all([
        valid("byr", num, x -> 1920 <= x <= 2002),
        valid("iyr", num, x -> 2010 <= x <= 2020),
        valid("eyr", num, x -> 2020 <= x <= 2030),
        valid("hgt", unit, ( xu -> begin
                                (x,u) = xu
                                (u == "cm" && 150 <= x <= 193) ||  (u == "in" && 59 <= x <= 76)
                                end)),
        valid("hcl", identity, x -> occursin(r"^#[0-9a-f]{6}$", x)),
        valid("ecl", identity, x -> x in eyecolors),
        valid("pid", identity, x -> occursin(r"^[0-9]{9}$", x)),
    ])

end


contents = split(read(first(ARGS), String), "\n\n")
pps = parsePassport.(contents)
valids = isValid.(pps)

println("pps validity: ", valids, " num valid: ", sum(valids))

