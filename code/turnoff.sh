slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m1s  -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 1
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m1m1 -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 0.99
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m1p1 -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 1.01

slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m12s  -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 1 -ND
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m12m1 -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 0.99 -ND
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m12p1 -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 1.01 -ND

slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m08s  -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 1
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m08m1 -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 0.99
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff -n m08p1 -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 1.01




slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m1s  -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 1
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m1m1 -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 0.999
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m1p1 -M 1.0 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 10e9 -r1 1.001

slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m12s  -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 1 -ND
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m12m1 -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 0.999 -ND
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m12p1 -M 1.2 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 6e9 -r1 1.001 -ND

slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m08s  -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 1
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m08m1 -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 0.999
slurm_sub.sh -p 1 -c q8 ./astec.sh -d turnoff2 -n m08p1 -M 0.8 -Y 0.2686717336 -Z 0.0171479742 -a 1.87982123230 -t 13.7e9 -r1 1.001

