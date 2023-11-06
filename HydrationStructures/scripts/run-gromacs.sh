#!/bin/bash

### Configura ambiente para execucao do GROMACS ###

module load gromacs/2021.2-intel-2021.3.0

# packmol
export PATH=$PATH:/home/lovelace/proj/proj868/ander/programas/packmol-20.010

# julia
export PATH=$PATH:/home/lovelace/proj/proj868/ander/programas/julia-1.6.2/bin

### A opcao -n indica o numero total de processos.  ###

   packmol < box.inp > box.log   
  
   gmx_d grompp -f mim.mdp -c solvated.pdb -r solvated.pdb -p processed.top -o em.tpr -maxwarn 2
   mpirun -np $1 gmx_d mdrun -v -deffnm em

   gmx_d grompp -f nvt.mdp -c em.gro -r em.gro -p processed.top -o nvt.tpr -maxwarn 2
   mpirun -np $1 gmx_d mdrun -v -deffnm nvt
  
   gmx_d grompp -f npt.mdp -c nvt.gro -r nvt.gro -p processed.top -o npt.tpr -maxwarn 2
   mpirun -np $1 gmx_d mdrun -v -deffnm npt

   gmx_d grompp -f prod.mdp -c npt.gro -r npt.gro -p processed.top -o prod.tpr -maxwarn 2
   mpirun -np $1 gmx_d mdrun -v -deffnm prod 

   #commands to process the gromacs trajectory
  
     for a in "gro" "xtc"; do
 
         echo 1 0 |gmx_d trjconv -s prod.tpr -f prod."$a" -o processed."$a" -ur compact -pbc mol -center 
  
     done

  julia -t5 cm_water.jl
