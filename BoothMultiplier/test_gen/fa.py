from itertools import product

from binary_values import binary_values


def main():
    vals = list(range(0, 2))
    binvals = binary_values(vals, 1)
    ops = list(product(vals, vals, vals))
    binops = list(product(binvals, binvals, binvals))
    sums = []
    for o in ops:
        sums.append(o[0] + o[1] + o[2])
    binsums = binary_values(sums, 2)
    with open('fa_in.txt', 'w') as file:
        file.writelines([f"{o[0]} {o[1]} {o[2]}\n" for o in binops])
    with open('fa_out.txt', 'w') as file:
        file.writelines([f"{s[1:]} {s[:1]}\n" for s in binsums])


if __name__ == '__main__':
    main()
