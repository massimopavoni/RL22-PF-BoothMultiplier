from itertools import product
from random import sample as random_sample, seed as random_seed

from binary_values import binary_values


def main():
    random_seed(0)
    vals0 = random_sample(range(- 2 ** 15, 2 ** 15), 64)
    vals1 = random_sample(range(- 2 ** 15, 2 ** 15), 64)
    vals2 = random_sample(range(- 2 ** 15, 2 ** 15), 64)
    binvals0 = binary_values(vals0, 16)
    binvals1 = binary_values(vals1, 16)
    binvals2 = binary_values(vals2, 16)
    ops = list(product(vals0, vals1, vals2))
    binops = list(product(binvals0, binvals1, binvals2))
    sums = []
    couts = []
    for o in ops:
        sums.append(o[0] ^ o[1] ^ o[2])
        couts.append((o[0] & o[1]) | (o[0] & o[2]) | (o[1] & o[2]))
    binsums = binary_values(sums, 16)
    bincouts = binary_values(couts, 16)
    with open('csa_in.txt', 'w') as file:
        file.writelines([f"{o[0]} {o[1]} {o[2]}\n" for o in binops])
    with open('csa_out.txt', 'w') as file:
        file.writelines([f"{s} {c}\n" for s, c in zip(binsums, bincouts)])


if __name__ == '__main__':
    main()
