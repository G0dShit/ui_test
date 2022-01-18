def cent_format(cent):
    cent = float(cent)
    f = "{:.5f}".format(cent)
    for i in range(len(f)-1,-1,-1):
        if "." in f and (f[i] == "0" or f[i] =='.'):
            f = f[:-1]
        else:
            break
    return str(f)
