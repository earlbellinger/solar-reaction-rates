#!/bin/bash
#### Script for dispatching an ASTEC simulation 
#### Author: Earl Bellinger ( bellinger@phys.au.dk ) 
#### Stellar Astrophysics Centre Aarhus 

# run evolution code 
source astec.sh 

cleanup() {
    if [ $REMOVE -eq 1 ]; then
        rm -rf "$DIRNAME"
    fi
}

# grab last model 
LAST_LINE=$(cat LOGS/history.data | tail -n 1)
#STAR_AGE=$(echo $LAST_LINE | awk '{ print $3 }')
X_c=$(echo $LAST_LINE | awk '{ print $7 }' | sed 's/[eE]+*/\*10\^/')
if (( $(echo "$X_c < 0.001" | bc -l) )); then 
    cleanup 
    exit 
fi 

# grab the last model 
MDL_NUM=$(echo $LAST_LINE | awk '{ print $1 }')

# obtain the structure
logger csh run-evol.mass.stg d.$MT $ZT $X $ALPHAT $OV $CASE $MDL_NUM 

# redistribute the mesh 
logger csh run.redistrb prxq4 d.$MT.Z$ZT.X$X.a$ALPHAT.o$OV.$CASE $MDL_NUM 
#cp amdl/* .
#cp osc/* .

# calculate adiabatic pulsation frequencies 
logger csh run.adipls d.$MT.Z$ZT.X$X.a$ALPHAT.o$OV.$CASE $MDL_NUM prxq4 

FGONG_FILE="gong/fgong.d.$MT.Z$ZT.X$X.a$ALPHAT.o$OV.$CASE.$MDL_NUM"
cp $FGONG_FILE LOGS/profile1.FGONG
python3 /home/earl/asteroseismology/scripts/fgong2ascii.py -i LOGS/profile1.FGONG

# process frequencies 
FREQ_FILE="osc/fobs.d.$MT.Z$ZT.X$X.a$ALPHAT.o$OV.$CASE.$MDL_NUM.prxq4"
#cat $FREQ_FILE 
#cp $FREQ_FILE LOGS/profile1-freqs.dat

cp $FREQ_FILE ../$EXPNAME".freqs"
cp LOGS/history.data ../$EXPNAME".dat"
cp LOGS/profile1.FGONG.dat ../$EXPNAME".FGONG.dat"
cp LOGS/neutr_scl.dat ../$EXPNAME".neutr_scl.dat"

cd - 
#Rscript summarize.R "$DIRNAME"
cleanup

# fin. 
