#!/usr/bin/perl -w

open(TRJ,">trajetoria") or die "couldn't open Qi file"; # imprimir x,y,z em linhas.
open(PDB,"./../SBM_simulations/results/tmp.pdb") or die "pdb file missing somehow";

$SEQ=0;
while(<PDB>){
	$LINE=$_;
	chomp($LINE);

	if(substr($LINE,0,5) eq "MODEL"){
		$ATOMNUM=0;
		$SEQ ++;

	}

        if(substr($LINE,0,4) eq "ATOM"){
	        # store positions, index and residue number
		$ATOMNUM=$ATOMNUM+1;
	        $X[$ATOMNUM]=substr($LINE,30,8)*1;
                $Y[$ATOMNUM]=substr($LINE,38,8)*1;
               	$Z[$ATOMNUM]=substr($LINE,46,8)*1;
        }

        if(substr($LINE,0,3) eq "TER"){
	# do contact calculations
			print TRJ "AAA ";
			for ($i = 1;$i <= $ATOMNUM; $i +=1){
				print TRJ "$X[$i] $Y[$i] $Z[$i] ";
			}
			print TRJ "\n";
		}

}

close(PDB);
close(TRJ);
