bitsToInt(s) = foldl((sum, c) -> sum * 2 + c, s; init=0)

function parseSeat(s)
    (rowdesc, coldesc) = s[1:7], s[8:10]
    row = bitsToInt(c == 'B' for c in rowdesc)
    col = bitsToInt(c == 'R' for c in coldesc)
    println("seat: ", (row,col))
    (row,col)
end

seatId((row,col)) = 8row + col


