#PBS -S /bin/bash
#PBS -m abe 
#PBS -q route
#PBS -N protein_a
#PBS -l walltime=72:00:00
#PBS -l select=1:ncpus=1:ngpus=0:Qlist=Allnodes
#PBS -V
#PBS -o /home/ander/proteina_a_ca_csu/117/jobout
#PBS -e /home/ander/proteina_a_ca_csu/117/joberr
#!/bin/bash

 run=/home/ander/proteina_a_ca_csu/117
 
 cd $PBS_O_WORKDIR
   
 module load fftw/fftw-3.3
 module load gromacs/gromacs-4.6.7/
 echo "hostname " `hostname`


cd $run

    grompp -f ca.mdp -c proteina_a.gro -p proteina_a.top -o run.tpr -maxwarn 5
    mdrun -s run.tpr -table table.xvg -tablep table.xvg

 ./Contacts.CA.pl
