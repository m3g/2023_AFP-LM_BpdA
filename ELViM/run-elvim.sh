#!/bin/bash

# Get the distances of the residues from .pdb trajectory
./traj_distances.pl

# Calculate the distance matrix 
./little_qv1.2 ../SBM_simulations/scripts_run_sbm/native_ca.pdb trajetoria ca 12 ../SBM_simulations/scripts_run_sbm/proteina_a.cont

# Calculate the 2D projection from the Force Scheme method
Rscript r_projection.R dmat
