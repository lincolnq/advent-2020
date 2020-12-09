
function parseInstr(s)
    m = match(r"(\w+) ([-+]\d+)", s)
    (Symbol(m[1]), parse(Int64, m[2]))
end

# returns acc if it terminates correctly, nop if it loops
function simulate(code)
    ip = 1
    acc = 0
    executed = Set()

    while ip <= lastindex(code)
        # end before we reexecute the same instruction
        if ip in executed
            println("loops after $(length(executed)) steps")
            return nothing
        end
        push!(executed, ip)
        (instr, param) = code[ip]

        if instr == :acc
            acc += param
            ip += 1
        elseif instr == :jmp
            ip += param
        else
            ip += 1
        end
    end

    return acc
end

function tryfix(code)
    @assert isnothing(simulate(code)) "Initial code terminated"
    for i in eachindex(code)
        newcode = copy(code)
        if newcode[i][1] == :jmp
            newcode[i] = (:nop, newcode[i][2])
        elseif newcode[i][1] == :nop
            newcode[i] = (:jmp, newcode[i][2])
        else
            # nothing to change - don't simulate
            continue
        end

        # now run it
        result = simulate(newcode)
        if !isnothing(result)
            println("found fix @ line $i, result acc=$result")
        end
    end
end

