# coding: utf-8
import numpy as np
import pandas as pd
import scipy as sp
import subprocess
import os

# Asteroseismology of Sun-like stars as a probe of nuclear reaction rates 
# Asteroseismic probes of astrophysical S-factors 

np.set_printoptions(precision=10)
np.random.seed(42) # for reproducibility 

Z_X_solar  = 0.02307 # GS98
#Teff_solar = 5772.

# Directories and save files 
save_dir = "std2"
if not os.path.exists(save_dir):
    os.mkdir(save_dir)

t = 4.57
M = 1.0

rate_names = ['r' + str(n+1) for n in range(5)]
rate_mu  = [1 for n in range(5)]
rate_std = np.array([0.01, 0.05, 0.05, 0.08, 0.07])

X_names = [        'Y',            'Z',        'a']
#X       = [0.275129653,    0.018497747,  1.9058942]
#X       = [0.2686278106,   0.0171416492, 1.8798092463]
X       = [0.2686717336,   0.0171479742, 1.8798212323]
X_var   = [0.01,           0.002,        0.1]
bounds  = [(0.25, 0.29), (0.012, 0.02), (1.4, 2.2)]
print(X_names)

P = lambda x: (x-X)/X_var+100
R = lambda x: (x-100)*X_var+X
lower = P(np.array([bound[0] for bound in bounds]))
upper = P(np.array([bound[1] for bound in bounds]))

def get_flags(names, args):
    return ' -'.join([''] + list(map(lambda x,y: x+' '+str(y), names, args)))

def calibrate(theta):
    if np.any(theta < lower) or np.any(theta > upper):
        return 10**10
    
    _theta = R(np.copy(theta))
    print("parameters:", _theta)
    
    bash_cmd = " -d " + save_dir + " -n calibrate" + \
        " -M 1.0 -t 4.57e9" + \
        get_flags(X_names, _theta)
    with open('temp2.txt', 'w') as output:
        process = subprocess.Popen(("./freqs.sh"+bash_cmd).split(), 
            shell=False, stdout=output)
    process.wait(timeout=60000)
    
    # process the results 
    hist_file = os.path.join(save_dir, 'calibrate.dat')
    pro_file  = os.path.join(save_dir, 'calibrate.FGONG.dat')
    DF = pd.read_table(hist_file, sep='\s+', comment='#',
        names=['model', 'M', 'age', 'R', 'Teff', 'L', 'Xc', 'qc'])
    prof = pd.read_table(pro_file, sep='\s+')
    
    logR = np.log10(DF['R'].values[-1] / 6.9599e10)
    logL = np.log10(DF['L'].values[-1])
    Fe_H = np.log10(prof.Z.values[1] / prof.X.values[1] / Z_X_solar)
    objective = np.log10(np.abs(logR) + np.abs(logL) + np.abs(Fe_H))
    print("objective:", objective, '\n')
    return objective

from scipy import optimize
print(sp.optimize.minimize(calibrate, x0=P(np.array(X)), 
    method='Nelder-Mead', tol=1e-9, options={'disp':True}))
