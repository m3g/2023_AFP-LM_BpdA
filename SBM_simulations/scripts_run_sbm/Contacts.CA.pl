#!/usr/bin/perl -w
################################################################################
# Contacts.CA.pl is a simple script written to analyze C-alpha structure-based #
# simulations run in GROMACS.   You must supply a contact file, with 10-12     #
# parameters, the .tpr file used for the simulation, and an trajectory file.   #
# You must also have Gromacs 4.0 installed on your machine                     #
# This is a very straightforward script that you can modify in any way you see #
# fit.  This software comes with absolutely no guarantee, but let us know if   #
# believe you found a bug.                                                     #
# Written by Paul Whitford, 11/02/09                                           #
################################################################################

$CONTFILE1="proteina_a.cont";
$CUTOFF1=1.2;

$SKIPFRAMES=1; 

open(CONaa,"$CONTFILE1")  or die "no CA contacts file";
$CONNUMaa=0;
while(<CONaa>){
	$ConI1=$_;
	chomp($ConI1);
	$CONNUMaa ++;

	@TMP1=split(" ",$ConI1);
	$Iaa[$CONNUMaa]=$TMP1[0];
	$Jaa[$CONNUMaa]=$TMP1[1];
	# this gets the native distances from the 6-12 parameters and converts to Ang.
	$Raa[$CONNUMaa]=(6/5*$TMP1[3]/$TMP1[2])**(1/2.0)*10.0;
}
close(CONaa);

$TPR=run;

$XTCfile=traj;

`echo 0 | /softwares/gromacs/gromacs-4.6.7/bin/trjconv  -skip $SKIPFRAMES -s $TPR -o tmp.pdb -f  $XTCfile`;

open(CAQ,">$XTCfile.CA.Q") or die "couldn't open Q file";

open(PDB,"tmp.pdb") or die "pdb file missing somehow";
while(<PDB>){
     	$LINE=$_;
       	chomp($LINE);

        if(substr($LINE,0,5) eq "MODEL"){
        	# start the residue storing
               	$ATOMNUM=0;
        }

        if(substr($LINE,0,4) eq "ATOM"){
           	$ATOMNUM=$ATOMNUM+1;
        }

        if(substr($LINE,0,3) eq "TER"){
		last;
	}

}

close PDB;

open(PDB,"tmp.pdb") or die "pdb file missing somehow";
while(<PDB>){
	$LINE=$_;
	chomp($LINE);

	if(substr($LINE,0,5) eq "MODEL"){
		$ATOMNUM=0;
	}


        if(substr($LINE,0,4) eq "ATOM"){
	        # store positions, index and residue number
		$ATOMNUM=$ATOMNUM+1;
	        $X[$ATOMNUM]=substr($LINE,30,8);
                $Y[$ATOMNUM]=substr($LINE,38,8);
               	$Z[$ATOMNUM]=substr($LINE,46,8);
        }


        if(substr($LINE,0,3) eq "TER"){

	# do contact calculations
               	$Qaa=0;

		for($i = 1;$i <= $CONNUMaa; $i +=1){
			$R=sqrt( ($X[$Iaa[$i]]-$X[$Jaa[$i]])**2.0 + 
			       	 ($Y[$Iaa[$i]]-$Y[$Jaa[$i]])**2.0 + 
  			 	 ($Z[$Iaa[$i]]-$Z[$Jaa[$i]])**2.0);

 			if($R < $CUTOFF1*$Raa[$i]){
				$Qaa ++;
				
			}
		}
	        print CAQ "$Qaa\n";
        }
}
close(CAQ);

`rm tmp.pdb`;
