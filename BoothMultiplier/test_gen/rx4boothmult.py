from itertools import product

from binary_values import binary_values


def main():
    vals = range(- 2 ** 7, 2 ** 7)
    binvals = binary_values(vals, 8)
    ops = list(product(vals, vals))
    binops = list(product(binvals, binvals))
    products = []
    for o in ops:
        products.append(o[0] * o[1])
    binproducts = binary_values(products, 16)
    with open('rx4boothmult_in.txt', 'w') as file:
        file.writelines([f"{o[0]} {o[1]}\n" for o in binops])
    with open('rx4boothmult_out.txt', 'w') as file:
        file.writelines([f"{p}\n" for p in binproducts])


if __name__ == '__main__':
    main()
