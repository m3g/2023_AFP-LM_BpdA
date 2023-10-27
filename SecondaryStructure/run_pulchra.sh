#!/bin/bash

workdir=$(pwd)
results="./../../SBM_simulations/results/traj_tf"
scripts="./../../SBM_simulations/results/scripts_run_sbm"

    cd $workdir

# Generate the .pdb files from trajectory
    echo 1 | gmx trjconv -f $results/traj.xtc -s $scripts/proteina_a.gro -o $1.pdb -sep

# Recontruct each frame with pulchra package
    for i in {0..5000} ; do pulchra $i.pdb ; done
