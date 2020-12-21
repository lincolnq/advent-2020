struct Sim
    east
    north
    weast
    wnorth
end

init = Sim(0, 0, 10, 1)

function forward(sim, amount)
    Sim(sim.east + sim.weast * amount, sim.north + sim.wnorth * amount, sim.weast, sim.wnorth)
end

function rotate(s, amount)
    amount = mod(amount, 360)
    if amount == 90
        Sim(s.east, s.north, s.wnorth, -s.weast)
    elseif amount == 270
        Sim(s.east, s.north, -s.wnorth, s.weast)
    elseif amount == 180
        Sim(s.east, s.north, -s.weast, -s.wnorth)
    else
        s
    end
end

function parseline(s)
    (s[1], parse(Int64, s[2:end]))
end

function interp(s, cmd, amount)
    if cmd == 'N'
        Sim(s.east, s.north, s.weast, s.wnorth + amount)
    elseif cmd == 'S'
        Sim(s.east, s.north, s.weast, s.wnorth - amount)
    elseif cmd == 'E'
        Sim(s.east, s.north, s.weast + amount, s.wnorth)
    elseif cmd == 'W'
        Sim(s.east, s.north, s.weast - amount, s.wnorth)
    elseif cmd == 'L'
        rotate(s, -amount)
    elseif cmd == 'R'
        rotate(s, amount)
    elseif cmd == 'F'
        forward(s, amount)
    else
        println("interp fail: cmd=$cmd")
        s
    end
end

function simulate(s, cmds)
    news = reduce((s, (c,a)) -> interp(s,c,a), cmds, init=s)
    (news, abs(news.north) + abs(news.east))
end