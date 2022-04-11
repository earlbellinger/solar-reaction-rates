for idx in `seq 0 4`; do
    for rate in `seq -5 2 5`; do
        slurm_sub.sh -c q8 python3 calibrate_rates.py $rate $idx
    done 
done 


