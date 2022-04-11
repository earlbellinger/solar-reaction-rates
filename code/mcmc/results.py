import pandas as pd
import numpy as np

DF = pd.read_table('MCMC_save/chain.dat', sep='\s+', header=None,
    names=['index', 'Y', 'Z', 'alpha', 'age',
           'rate1', 'rate2', 'rate3', 'rate4', 'rate5'])

print(DF.mean())
print(DF.std())

vals = [4.01, 5.21, 0.56, 2.08, 1.66]
unc = [0.04, 0.27, 0.03, 0.16, 0.12]
print('uncertainty [keV b]: ', DF.std().values[-5:] * vals)
print('uncertainty [%]: ', DF.std().values[-5:] / vals * 100)
print('improvement factor: ', unc / DF.std().values[-5:])

