def binary_values(vals, nbits):
    return [format(v if v >= 0 else 2 ** nbits + v, f'0{nbits}b') for v in vals]
