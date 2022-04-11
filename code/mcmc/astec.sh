#!/bin/bash
#### Script for dispatching an ASTEC simulation 
#### Author: Earl Bellinger ( bellinger@phys.au.dk ) 
#### Stellar Astrophysics Centre Aarhus 

################################################################################
### GLOBAL VARIABLES ###########################################################
################################################################################
#SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTDIR=/home/earl/astec/solar/mcmc

#export eprgdir=/home/jcd/evolpack_ast_111216.new
export eprgdir=/home/jcd/evolpack_ast1d_201021
export path=(.  $eprgdir/bin ~jcd/bin ~jcd/bin/evol ~jcd/bin/prog $path)
export PATH=$PATH:$eprgdir/bin:~jcd/bin:~jcd/bin/evol:~jcd/bin/prog

echo

function logger () {
    cat <<EOT >| next_command
$@
EOT
    source next_command
    cat next_command >> commands.log 
}

################################################################################
### PARSE COMMAND LINE ARGUMENTS ###############################################
################################################################################
M=1
Y=0.28
Z=0.02
ALPHA=1.8

AGE=1.e9
BETA=0
TGRAV0=13.799e9

ABUNDANCES='GS98'

RATE1=1.0
RATE2=1.0
RATE3=1.0
RATE4=1.0
RATE5=1.0

OV=0
M_TRIAL=-1

CASE=27 #25

STEPS=100000
HELP=0
REMOVE=0
DIRECTORY='simulations'

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h) HELP=1; break;;
    -r) REMOVE=1; shift 1;;
    -d) DIRECTORY="$2"; shift 2;;
    -n) EXPNAME="$2"; shift 2;;
    -C) CASE="$2"; shift 2;;
    -M) M=$(echo "$2" | cut -c 1-12); shift 2;;
    -Y) Y=$(echo "$2" | cut -c 1-12); shift 2;;
    -Z) Z=$(echo "$2" | cut -c 1-12); shift 2;;
    -a) ALPHA=$(echo "$2" | cut -c 1-12); shift 2;;
	-t) AGE="$2"; shift 2;;
    -t_0) TGRAV0="$2"; shift 2;;
	-b) BETA="$2"; shift 2;;
    -A) ABUNDANCES="$2"; shift 2;;
    -r1) RATE1="$2"; shift 2;;
    -r2) RATE2="$2"; shift 2;;
    -r3) RATE3="$2"; shift 2;;
    -r4) RATE4="$2"; shift 2;;
    -r5) RATE5="$2"; shift 2;;
    
    *) echo "unknown option: $1" >&2; exit 1;;
  esac
done

################################################################################
### TRANSFORM VARIABLES FOR ASTEC ##############################################
################################################################################
# transform mass variable 
# 1.00 goes to 0100 
# 0.75 goes to 0075 
# so multiply by 100, remove the decimal and see how many zeros to add 
PAD=0
if [ $( echo "$M < 1" | bc -l ) = 1 ]; then PAD=0$PAD; fi
MT=$PAD$(echo "$M * 100" | bc -l | sed 's,\.,,g')

# transform X variable 
# X = 1-Y-Z 
# 0.7 goes to 7 
# so we need to multiply by 10 and remove the decimal 
X=$(echo "(1-$Y-$Z) * 10" | bc -l | sed 's,\.,,g')

# transform Z variable 
# 0.02 goes to 2
# 0.002 goes to 02
# 0.0002 goes to 002
# so we need to multiply by 100, remove the decimal, and check the padding 
#PAD=''
#POST_ZEROS=$(echo $Z | egrep -o '^0\.0*')
#STR_LEN=$(echo "${#POST_ZEROS} - 3" | bc -l)
#if [ $STR_LEN -gt 0 ]; then for ii in `seq 1 $STR_LEN`; do PAD=0$PAD; done; fi
#ZT=$PAD$(echo "$Z * 100" | bc -l | sed 's,\.,,g')
ZT=$(echo "$Z" | cut -c 4-)

# transform ALPHA variable 
# 1.8 goes to 18
# .18 goes to 018
# .018 goes to 0018
# so we need to multiply by 10, remove the decimal, and check if we need a pad 
PAD=''
POST_ZEROS=$(echo $ALPHA | egrep -o '^0\.0*')
STR_LEN=$(echo "${#POST_ZEROS} - 1" | bc -l)
if [ $STR_LEN -gt 0 ]; then for ii in `seq 1 $STR_LEN`; do PAD=0$PAD; done; fi
ALPHAT=$PAD$(echo "$ALPHA * 10" | bc -l | sed 's,\.,,g')

#M=0100   # = 1.0 M_sol
#Z=2      # = 0.02
#X=7      # = 0.7
#ALPHA=18 # = 1.8

################################################################################
### INITIALIZATION AND EVOLUTION ###############################################
################################################################################
if [ -z ${EXPNAME+x} ]; then
    EXPNAME=M="$M"_Y="$Y"_Z="$Z"_alpha="$ALPHA"_age="$AGE"_beta="$BETA"\
t0_"$TGRAV0"_r1="$RATE1"_r2="$RATE2"_r3="$RATE3"_r4="$RATE4"_r5="$RATE5"
fi
DIRNAME=$DIRECTORY/$EXPNAME

mkdir -p $DIRNAME
cd $DIRNAME
cp -r $SCRIPTDIR/astec/* .
#rm -rf gong log osc amdl 
#rm -f track 
rm -rf LOGS 
#printf "id M Y Z alpha age beta t_0 abundances rate1 rate2 rate3 rate4 rate5\n"\
#    "$EXPNAME $M $Y $Z $ALPHA $AGE $BETA $ABUNDANCES"\
#    "$TGRAV0 $RATE1 $RATE2 $RATE3 $RATE4 $RATE5" >| track

# run evolution code 
#echo "calling run-evol.mass.d"
#echo "./run-evol.mass.d $MT $M_TRIAL $ZT $X $ALPHAT $OV $CASE $STEPS $AGE $BETA"\ 
#"$TGRAV0 $RATE1 $RATE2 $RATE3 $RATE4 $RATE5" >> commands.log
logger ./run-evol.mass.d $MT $M_TRIAL $ZT $X $ALPHAT $OV $CASE $STEPS $AGE \
    $BETA $TGRAV0 $RATE1 $RATE2 $RATE3 $RATE4 $RATE5 

# run neutrino code 
logger csh run-neutrino_cz -scl gong* $RATE1 $RATE2 $RATE3 $RATE4 $RATE5 

mkdir LOGS

# rename history file to something more convenient 
cp bcsum.d."$MT".Z"$ZT".X"$X".a"$ALPHAT".o"$OV"."$CASE".s LOGS/history.data

cp neutr_scl.gong* LOGS/neutr_scl.dat

# fin. 
