import numpy as np 
from scipy.interpolate import interp1d
from tqdm import tqdm
#from multiprocessing import Pool

def r02(nus, interp_freqs=None, perturb=False, verbose=False, 
        fill_value=np.nan, min_freqs=3):
    """r_02(n) = (nu_{n,0} - nu_{n-1, 2}) / 
                 (nu_{n,1} - nu_{n-1, 1})
       where nus is a pandas DataFrame with columns l, n, nu (, dnu)"""
    
    nus_ = nus.copy()
    
    if 'n_g' in nus_.columns:
        nus_ = nus_[nus_['n_g'] == 0]
    
    if perturb:
        nus_['nu'] = np.random.normal(nus_['nu'], nus_['dnu'])
    
    ell0, ell1, ell2 = (nus_[nus_['l'] == ell] for ell in range(3))
    
    ratios = []
    freqs  = []
    names  = []
    modes  = []
    for idx, mode in ell0.iterrows():
        n = mode['n'] # n, 0
        
        ell1m1 = ell1['n'] == (n - 1) # n-1, 1
        ell1n0 = ell1['n'] ==  n      # n,   1
        ell2m1 = ell2['n'] == (n - 1) # n-1, 2
        
        if not (sum(ell1m1) == 1 and 
                sum(ell1n0) == 1 and 
                sum(ell2m1) == 1):
            if verbose:
                print('skipping', n)
            continue 
        
        num = float(mode['nu'])         - float(ell2[ell2m1]['nu']) # nu_{n,0} - nu_{n-1, 2}
        den = float(ell1[ell1n0]['nu']) - float(ell1[ell1m1]['nu']) # nu_{n,1} - nu_{n-1, 1}
        ratio = num/den
        
        ratios += [ratio]
        freqs  += [float(mode['nu'])] 
        names  += ["r02_"  + str(int(n))]
        modes  += ["nu_0_" + str(int(n)), 
                   "nu_1_" + str(int(n-1)),
                   "nu_1_" + str(int(n)),
                   "nu_2_" + str(int(n-1))]
        
        if verbose:
            print('n:', n, 'num/den', num/den)
    
    if len(freqs) < min_freqs:
        # mixed modes, abort! 
        return {'ratios': None}
    
    if interp_freqs is None: 
        interp_freqs = freqs 
    
    if verbose:
        print(names)
        print(set(modes))
        print(interp_freqs)
    
    if len(ratios) > 0:
        interpolated = interp1d(freqs, ratios, 
            kind='cubic', bounds_error=False,
            fill_value=fill_value)(interp_freqs)
    else:
        interpolated = None 
    
    return {'names':  names,
            'modes':  set(modes),
            'freqs':  np.array(interp_freqs), 
            'ratios': interpolated}

def r13(nus, interp_freqs=None, perturb=False, verbose=False, 
        fill_value=np.nan, min_freqs=3):
    """r_13(n) = (nu_{n,1} - nu_{n-1, 3}) / 
                 (nu_{n+1,0} - nu_{n, 0})
       where nus is a pandas DataFrame with columns l, n, nu (, dnu)"""
    
    nus_ = nus.copy()
    
    if 'n_g' in nus_.columns:
        nus_ = nus_[nus_['n_g'] == 0]
    
    if perturb:
        nus_['nu'] = np.random.normal(nus_['nu'], nus_['dnu'])
    
    ell0, ell1, ell3 = (nus_[nus_['l'] == ell] for ell in [0, 1, 3])
    
    ratios = []
    freqs  = []
    names  = []
    modes  = []
    for idx, mode in ell1.iterrows():
        n = mode['n'] # n, 1
        
        ell3m1 = ell3['n'] == (n - 1) # n-1, 3
        ell0p1 = ell0['n'] == (n + 1) # n+1, 0
        ell0n0 = ell0['n'] ==  n      # n,   0
        #ell0m1 = ell0['n'] == (n - 1) # n-1, 0
        
        if not (sum(ell0p1) == 1 and 
                sum(ell0n0) == 1 and 
                sum(ell3m1) == 1):
            if verbose:
                print('skipping', n)
            continue 
        
        num = float(mode['nu'])         - float(ell3[ell3m1]['nu']) # nu_{n,0} - nu_{n-1, 2}
        den = float(ell0[ell0p1]['nu']) - float(ell0[ell0n0]['nu']) # nu_{n,1} - nu_{n-1, 1}
        ratio = num/den
        
        ratios += [ratio]
        freqs  += [float(mode['nu'])] # nu_{n, 3}
        names  += ["r13_"  + str(int(n))]
        modes  += ["nu_1_" + str(int(n)), 
                   "nu_3_" + str(int(n-1)),
                   "nu_0_" + str(int(n-1)),
                   "nu_0_" + str(int(n))]
        
        if verbose:
            print('n:', n, 'num/den', num/den)
    
    if len(freqs) < min_freqs:
        # mixed modes, abort! 
        return {'ratios': None}
    
    if interp_freqs is None: 
        interp_freqs = freqs 
    
    if verbose:
        print(names)
        print(set(modes))
        print(interp_freqs)
    
    if len(ratios) > 0:
        interpolated = interp1d(freqs, ratios, 
            kind='cubic', bounds_error=False,
            fill_value=fill_value)(interp_freqs)
    else:
        interpolated = None 
    
    return {'names':  names,
            'modes':  set(modes),
            'freqs':  np.array(interp_freqs), 
            'ratios': interpolated}

def r10(nus, interp_freqs=None, perturb=False, verbose=False, 
        fill_value=np.nan, min_freqs=3):
    """r_10(n) = (     nu_{n-1, 1} 
                   - 4*nu_{n,   0} 
                   + 6*nu_{n,   1} 
                   - 4*nu_{n+1, 0}
                   +   nu_{n+1, 1}
              ) / -[8*(nu_{n+1, 0} 
                     - nu_{n,   0})]
       where nus is a pandas DataFrame with columns l, n, nu (, dnu)"""
    
    nus_ = nus.copy()
    
    if 'n_g' in nus_.columns:
        nus_ = nus_[nus_['n_g'] == 0]
    
    if perturb:
        nus_['nu'] = np.random.normal(nus_['nu'], nus_['dnu'])
    
    ell0, ell1 = (nus_[nus_['l'] == ell] for ell in range(2))
    
    ratios = []
    freqs  = []
    names  = []
    modes  = []
    for idx, mode in ell0.iterrows():
        n = mode['n']
        
        ell1m1 = ell1['n'] == (n - 1)
        ell1n0 = ell1['n'] ==  n
        ell1p1 = ell1['n'] == (n + 1)
        
        ell0m1 = ell0['n'] == (n - 1)
        ell0p1 = ell0['n'] == (n + 1)
        
        if not (sum(ell1m1) == 1 and 
                sum(ell1n0) == 1 and 
                sum(ell1p1) == 1 and 
                sum(ell0m1) == 1 and 
                sum(ell0p1) == 1):
            if verbose:
                print('skipping', n)
            continue 
        
        num =     float(ell1[ell1m1]['nu']) \
              - 4*float(mode['nu'])         \
              + 6*float(ell1[ell1n0]['nu']) \
              - 4*float(ell0[ell0p1]['nu']) \
              +   float(ell1[ell1p1]['nu'])
        den = -8*(float(ell0[ell0p1]['nu']) \
                - float(mode['nu']))
        
        ratios += [num/den]
        freqs  += [float(mode['nu'])]
        names  += ["r10_" + str(int(n))]
        modes  += ["nu_1_" + str(int(n-1)), 
                   "nu_0_" + str(int(n)),
                   "nu_1_" + str(int(n)),
                   "nu_0_" + str(int(n+1)),
                   "nu_1_" + str(int(n+1))]
        
        if verbose:
            print('n:', n, 'num/den', num/den)
    
    if len(freqs) < min_freqs:
        # mixed modes, abort! 
        return {'ratios': None}
    
    if interp_freqs is None: 
        interp_freqs = freqs 
    
    if verbose:
        print(names)
        print(set(modes))
        print(interp_freqs)
    
    if len(ratios) > 0:
        interpolated = interp1d(freqs, ratios, 
            kind='cubic', bounds_error=False,
            fill_value=fill_value)(interp_freqs)
    else:
        interpolated = None 
    
    return {'names':  names,
            'modes':  set(modes),
            'freqs':  np.array(interp_freqs), 
            'ratios': interpolated}

#def inst(x):
#    return func(freqs, perturb=True)['ratios']

def get_ratios(func, freqs, n_perturb=100000, seed=None, progress=False):
    if seed is not None:
        np.random.seed(seed)
    #p = Pool(processes=4)
    #return np.array(p.map(inst, range(n_perturb)))
    if progress:
        return np.array([func(freqs, perturb=True)['ratios']
            for ii in tqdm(range(n_perturb))])
    return np.array([func(freqs, perturb=True)['ratios']
        for ii in range(n_perturb)])

#r02s = get_ratios(r02, freqs)
#r10s = get_ratios(r10, freqs)

if __name__ == '__main__':
    import sys 
    import pandas as pd 
    
    filename = sys.argv[1]
    out_name = sys.argv[2]
    
    DF = pd.read_table(filename, sep='\s+', 
        names=['l', 'n', 'nu', 'E', 'n_p', 'n_g'])
    
    ratios = r02(DF)
    cols = {'freqs':  ratios['freqs'], 
            'ratios': ratios['ratios']}
    
    if 'dnu' in DF.columns:
        perturb = get_ratios(r02, DF, n_perturb=100000)
        std = np.std(perturb, axis=0)
        cols['e_ratios'] = std
    
    res = pd.DataFrame(cols)
    res.to_csv(out_name + '_r02.csv', index=False)
    
    
    ratios = r10(DF)
    cols = {'freqs':  ratios['freqs'], 
            'ratios': ratios['ratios']}
    
    if 'dnu' in DF.columns:
        perturb = get_ratios(r10, DF, n_perturb=100000)
        std = np.std(perturb, axis=0)
        cols['e_ratios'] = std
    
    res = pd.DataFrame(cols)
    res.to_csv(out_name + '_r10.csv', index=False)
    
    ratios = r13(DF)
    cols = {'freqs':  ratios['freqs'], 
            'ratios': ratios['ratios']}

    if 'dnu' in DF.columns:
        perturb = get_ratios(r13, DF, n_perturb=100)
        std = np.std(perturb, axis=0)
        cols['e_ratios'] = std

    res = pd.DataFrame(cols)
    res.to_csv(out_name + '_r13.csv', index=False)

