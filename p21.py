import re
import z3
from dataclasses import dataclass

test = """mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

@dataclass
class Line:
    ingredients: set
    allergens: set

def parse(s):
    lines = s.strip().split('\n')
    rows = [parseLine(l) for l in lines]
    print(rows)

    return rows


def parseLine(line):
    m = re.match(r'([\w ]+) \(contains ([\w, ]+)\)', line)
    assert m, f"line {line} didn't match"
    ingredients = m.group(1)
    allergens = m.group(2)

    return Line(set(ingredients.split()), set(allergens.split(', ')))

#rows = parse(test)
rows = parse(open('in21.txt').read())
allIngredients = set().union(*[l.ingredients for l in rows])
allAllergens = set().union(*[l.allergens for l in rows])

# make a solver
solver = z3.Solver()

# each ingredient's index number is just their index into this array
ingredients = list(sorted(allIngredients))

# create vars for all allergens
# Each allergen is associated with exactly one stuff. Some stuff have 0 allergens
# and some have 1, but no more.

allergenVars = {a: z3.Int(a) for a in allAllergens}

solver.add(z3.Distinct(*allergenVars.values()))

# go through the rows and describe the constraints:
# allergen1 = ingredient1 OR allergen1 = ingredient2...
# AND
# allergen2 = ingredient1 OR allergen2 = ingredient2...
for l in rows:
    for a in l.allergens:
        avar = allergenVars[a]
        ingixs = [ingredients.index(i) for i in l.ingredients]
        c = z3.Or([avar == ii for ii in ingixs])
        solver.add(c)

print(solver.check())
print(solver.model())

m = solver.model()
solvedIngredients = []
for var in m:
    ing = ingredients[m[var].as_long()]
    allergen = str(var)
    solvedIngredients.append((allergen, ing))

si = sorted(solvedIngredients)
print(','.join(x[1] for x in si))
