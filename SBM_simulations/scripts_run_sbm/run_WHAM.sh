#!/bin/bash

################################################################################
################################################################################

export PATH=$PATH:/softwares/jre1.8.0/bin

TT=`ls -d [0-9]*[0-9]*/ | sed 's/\///g'`

for i  in $TT 
do 
cd $i/

paste potential-energy.xvg traj.CA.Q > E_Q.dat
cat E_Q.dat | awk '{print $2"  "$3}' > hist$i.0

rm E_Q.dat 

cd ../
cat $i/hist$i.0 >> TESTE_EQ.dat 
echo $i >> TEMP

done

Emin=`cat TESTE_EQ.dat | awk '{print $1}' | sort -n | head -1`  
Emax=`cat TESTE_EQ.dat | awk '{print $1}' | sort -n | tail -1` 
Ebins=`echo $Emax- $Emin | bc`

E_bins=${Ebins%.*}
echo $E_bins

Qmin=`cat TESTE_EQ.dat | awk '{print $2}' | sort -n | head -1`   
Qmax=`cat TESTE_EQ.dat | awk '{print $2}' | sort -n | tail -1`  
Q_bins=`echo $Qmax- $Qmin | bc`


################################################################################
################################################################################

#Contruir arquivo para o calcular o Wham pelo Java
echo "numDimensions 2" > config.wham	
echo "kB 0.008314" >> config.wham     		
echo "run_wham" >> config.wham        		
echo "dosFile dos" >> config.wham     		
echo "threads 1" >> config.wham
echo " " >> config.wham

echo "### energy binning ###" >> config.wham
echo "numBins $E_bins" >> config.wham
echo "start $Emin" >> config.wham
echo "step 1.0" >> config.wham
echo " " >> config.wham

echo "### reaction coordinate 1 binning ###" >> config.wham
echo "numBins $Q_bins" >> config.wham
echo "start $Qmin" >> config.wham
echo "step 1.0" >> config.wham
echo " " >> config.wham

nT=`wc -l TEMP | awk '{print $1}'`  

echo "### list of histogram filenames and their temperatures ###" >> config.wham
echo "numFiles  $nT" >> config.wham

WAY=`pwd`

for i  in $TT 
do 
 echo "name $WAY/$i/hist$i.0 temp $i" >> config.wham
done
echo " " >> config.wham

Tmin=`cat TEMP | awk '{print $1}' | sort -n | head -1` 

echo "###### ADVANCED #########" >> config.wham
echo "run_free" >> config.wham 
echo "run_free_out freeE" >> config.wham 
echo "startTF $Tmin" >> config.wham
echo "deltaTF 0.2" >> config.wham
echo "ntempsF 350" >> config.wham
echo " " >> config.wham

echo "### ADVANCED CV ######" >> config.wham
echo "run_cv" >> config.wham
echo "run_cv_out cv" >> config.wham
echo "startT $Tmin" >> config.wham
echo "deltaT 0.2" >> config.wham
echo "ntemps 350" >> config.wham
echo " " >> config.wham

################################################################################
################################################################################

rm TEMP TESTE_EQ.dat

################################################################################
################################################################################

mkdir results

cp WHAM.1.07.jar results/
cp config.wham results/

cd results/

java -jar WHAM.1.07.jar --config config.wham

