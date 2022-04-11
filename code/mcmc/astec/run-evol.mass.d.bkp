#!/bin/csh
#  driver for evolution programme, varying mass

#  Hardcode EOS

set eos = liv05

echo "Start of run-evol.mass.d"
date

if($#argv == 0) then
  echo "Usage:"
  echo "run-evol.mass.d [-dif] <new mass> <trial mass> <100 Z> "
  echo "<X> <alpha> <ovc> <case> [<no. of timesteps>]"
  echo "[<max age>] [<beta>] [<t_0>]"
  echo "[<rateA> <rateB> <rateC> <rateD> <rateE>]"
  echo "If <trial mass> is set to -1, trial mass is set automatically"
  echo "Default: He and Z diffusion"
  echo "[dif] = -dif: No diffusion"
  echo "[dif] = hedif: He diffusion"
  exit(1)
endif

if(-d log) then
else
	mkdir log
	echo Making log
endif

if(-d ttt) then
else
	mkdir ttt
	echo Making ttt
endif

if(-d amdl) then
else
	mkdir amdl
	echo Making amdl
endif

if(-d gong) then
else
	mkdir gong
	echo Making gong
endif

if(-d osc) then
else
	mkdir osc
	echo Making osc
endif

switch($1)
	case -dif:
	  set dif = ""
	  set idif = "0"
	  shift
	  breaksw
	case hedif:
	  set dif = "d."
	  set idif = "1"
	  shift
	  breaksw
	default:
	  set dif = "d."
	  set idif = "2"
	  breaksw
endsw

switch($eos)
        case eff:
        case ceff:
          set trialeos = "#logf"
          breaksw
        default:
          set trialeos = "#logrho"
          breaksw
endsw

set trial = `set-trial.f $1 $2 $3`
echo "trial set to" $trial

if($#argv <= 7) then
	set nt = 200
else
	set nt = $8
endif

if($#argv <= 8) then ## EPB 2019-01-09 added termination age 
    set agefin = 1.e15
else 
    set agefin = $9
endif

if($#argv <= 9) then ## EPB 2019-02-08 added variable G 
    set beta = 0.
else 
    set beta = $10
endif

if ($#argv <= 10) then ## EPB 2019-05-07 added variable t_0
    set tgrav0 = 13.799e9
else 
    set tgrav0 = $11
endif

if($#argv <= 11) then ## EPB 2019-02-18 added reaction rates 
    set rateA = 1.0
    set rateB = 1.0
    set rateC = 1.0
    set rateD = 1.0
    set rateE = 1.0
else 
    set rateA = $12
    set rateB = $13
    set rateC = $14
    set rateD = $15
    set rateE = $16
endif


set q = "null"

set sdir = ./ttt

set iqfit = "5"

echo "s/#mass/"$1"/" > tmp$$
echo "s/#tmass/"$trial"/" >> tmp$$
echo "s/#z/"$3"/" >> tmp$$
echo "s/#xh/"$4"/" >> tmp$$
echo "s/#alfa/"$5"/" >> tmp$$
echo "s/#ovc/"$6"/" >> tmp$$
echo "s/#case/"$7"/" >> tmp$$
echo "s/#iqfit/"$iqfit"/" >> tmp$$
echo "s/#nt/"$nt"/" >> tmp$$
echo "s/#agefin/"$agefin"/" >> tmp$$ ## EPB 2019-01-09 added termination age 
echo "s/#beta/"$beta"/"     >> tmp$$ ## EPB 2019-02-08 added variable G 
echo "s/#tgrav0/"$tgrav0"/" >> tmp$$ ## EPB 2019-05-07 added variable t_0
echo "s/#rateA/"$rateA"/"   >> tmp$$ ## EPB 2019-02-18 added reaction rates 
echo "s/#rateB/"$rateB"/"   >> tmp$$ ## EPB 2019-02-18 added reaction rates 
echo "s/#rateC/"$rateC"/"   >> tmp$$ ## EPB 2019-02-18 added reaction rates 
echo "s/#rateD/"$rateD"/"   >> tmp$$ ## EPB 2019-02-18 added reaction rates 
echo "s/#rateE/"$rateE"/"   >> tmp$$ ## EPB 2019-02-18 added reaction rates 
echo "s/#dif/"$dif"/" >> tmp$$
echo "s/#idif/"$idif"/" >> tmp$$
echo "s/#cwd/./" >> tmp$$
echo "s/#trailer/s/" >> tmp$$
echo "s/#evolfile/evol-file"$$".log/" >> tmp$$
echo "s/"$trialeos"/@/" >> tmp$$
sed -f tmp$$ evol.mass_$7.rin > tmp1$$

echo "Call run-evol"
date
run-evol -dcliv0511z tmp1$$ \
  $sdir/ttt.evol.mass.$dif$1.Z$3.X$4.a$5.o$6.$7.s run-evol$$.log
echo "End run-evol"
date

rm tmp$$ tmp1$$

cat run-evol$$.log evol-file$$.log > log/log.$dif$1.Z$3.X$4.a$5.o$6.$7.s

rm run-evol$$.log evol-file$$.log 

set-bsum csum.$dif$1.Z$3.X$4.a$5.o$6.$7.s

