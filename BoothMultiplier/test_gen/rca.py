from itertools import product
from random import sample as random_sample

from binary_values import binary_values


def sum(op):
    s = op[0] + op[1]
    if s > 2 ** 15 - 1:
        return s - 2 ** 16
    elif s < - 2 ** 15:
        return s + 2 ** 16
    else:
        return s

def main():
    vals0 = random_sample(range(- 2 ** 15, 2 ** 15), 512)
    vals1 = random_sample(range(- 2 ** 15, 2 ** 15), 512)
    binvals0 = binary_values(vals0, 16)
    binvals1 = binary_values(vals1, 16)
    ops = list(product(vals0, vals1))
    binops = list(product(binvals0, binvals1))
    sums = []
    for o in ops:
        sums.append(sum(o))
    binsums = binary_values(sums, 16)
    with open('rca_in.txt', 'w') as file:
        file.writelines([f"{o[0]} {o[1]}\n" for o in binops])
    with open('rca_out.txt', 'w') as file:
        file.writelines([f"{s}\n" for s in binsums])


if __name__ == '__main__':
    main()
