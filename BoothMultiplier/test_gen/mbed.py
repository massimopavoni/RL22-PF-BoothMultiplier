from itertools import product

from binary_values import binary_values


def radix4(binx, y):
    if y in [0, 7]:
        return 0
    if y in [1, 2]:
        return binx[0]
    if y in [5, 6]:
        return '0' if binx[0] == '1' else '1'
    return binx[1] if y == 3 else ('0' if binx[1] == '1' else '1')

def main():
    valsx = list(range(0, 4))
    valsy = list(range(0, 8))
    binvalsx = binary_values(valsx, 2)
    binvalsy = binary_values(valsy, 3)
    ops = list(product(binvalsx, valsy))
    binops = list(product(binvalsx, binvalsy))
    binpps = []
    for o in ops:
        binpps.append(radix4(o[0], o[1]))
    with open('mbed_in.txt', 'w') as file:
        file.writelines([f"{o[0]} {o[1]}\n" for o in binops])
    with open('mbed_out.txt', 'w') as file:
        file.writelines([f"{p}\n" for p in binpps])


if __name__ == '__main__':
    main()
