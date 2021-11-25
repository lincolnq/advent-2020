import re
from dataclasses import dataclass
from typing import Tuple

@dataclass
class Constraint:
    name: str
    r1l: int
    r1h: int
    r2l: int
    r2h: int

    def isin(self, x: int) -> bool:
        return self.r1l <= x <= self.r1h or self.r2l <= x <= self.r2h

class ParseError(Exception): pass

def parseConstraint(line):
    m = re.match(r'([a-zA-Z ]+): (\d+)-(\d+) or (\d+)-(\d+)', line)
    if m is None: raise ParseError()
    return Constraint(m.group(1), *[int(x) for x in m.groups()[1:]])

def parseTicket(line):
    line = line.strip()
    if not len(line): raise ParseError()
    t = [int(x) for x in line.strip().split(',')]
    return t


def parseAll(file):
    # parse constraints
    cs = []
    for line in file:
        try:
            cs.append(parseConstraint(line))
        except ParseError:
            break

    # ok  no more constraints
    for line in file:
        if line.startswith('nearby tickets'):
            break

    # parse nearby tickets
    nts = []
    for line in file:
        try:
            nts.append(parseTicket(line))
        except ParseError:
            break

    return (cs, nts)


def checkInvalid(cs, nts):
    invals = []
    for t in nts:
        for field in t:
            if not any(c.isin(field) for c in cs):
                print(f'ticket {t} invalid - field {field} not valid for any c')
                invals.append(field)

    return sum(invals)

cs, nts = parseAll(open('in16.txt'))

print(checkInvalid(cs, nts))
