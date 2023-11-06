#!/bin/bash

echo "NAME OF THE SIMULATION FOLDER " # water

read folder
mkdir $folder
cd $folder

workdir=/home/lovelace/proj/proj868/ander/doutorado/projeto/mddf/proteina_a_water             # dir that you are  working
pdbdir=./../../SecondaryStructure/equilibrated_all_atom_models                                # dir with pdb files
mdpdir=/home/lovelace/proj/proj868/ander/doutorado/projeto/mddf/proteina_a_water/mdp_files    # dir with mdp files
ffdir=/home/lovelace/proj/proj868/ander/doutorado/projeto/mddf/proteina_a_water/ff            # dir with mdp files

for i in {1..5001} ; do # structures for all clusters

    mkdir -p "$[i-1]"

    \cp -f $workdir/scripts/"cm_water".jl    $workdir/"$folder"/"$[i-1]"/   # copy the .jl file to directory i.
    \cp -f $pdbdir/"$[i-1].pdb"              $workdir/"$folder"/"$[i-1]"/   # copy the pdb i (protein) to directory i.
    \cp -f $pdbdir/"tip3p.pdb"               $workdir/"$folder"/"$[i-1]"/   # copy the pdb of the water to directory i.
    \cp -f $pdbdir/"SODIUM.pdb"              $workdir/"$folder"/"$[i-1]"/   # copy the pdb of the counterion to directory i.
    \cp -f $mdpdir/*.mdp                     $workdir/"$folder"/"$[i-1]"/   # copy the mdp files to directory i.
    \cp -r $ffdir/"processed_model.top"      $workdir/"$folder"/"$[i-1]"/   # copy the ff files to directory i.
    \cp -r "./../scripts/run-gromacs.sh"     $workdir/"$folder"/"$[i-1]"/   # copy the.sh file to directory i.

done

  julia ./../scripts/input_water.jl
