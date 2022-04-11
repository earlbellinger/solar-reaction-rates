#!/bin/sh
#SBATCH --job-name=ASTEC_MCMC
#SBATCH --partition=q8
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --output=sbatch_mcmc.err
#SBATCH --export="PYTHONUNBUFFERED=1"
#SBATCH --time=240:00:00
#SBATCH --mem=16G

export PYTHONUNBUFFERED=1
#stdbuf -oL python3 -u ASTEC.py >| sbatch_mcmc.out
python3 ASTEC.py /scratch/$SLURM_JOB_ID >| sbatch_mcmc.out
