  function box(MMP::Float64, PDB::String, charge::Int64)

    vol_box(a,b,c) = a*b*c*1e-27;     # Volume of the box (L)
    vol_prot(m) = (m/(6.02e23))*1e-3; # Volume of the protein 
    vol_sol(vs,vp) = vs - vp;         # Volume of the solution
  
    # Box dimensions
    lx,ly,lz = measure_prot(PDB) 
   
    vs   = vol_box(2*lx,2*ly,2*lz) - vol_prot(MMP); # Volume of the solution
    num_wat(vs) = round(Int128,((vs) * 6.02e23) / (18*1e-3));
    nwat = num_wat(vs); # number of water molecules
      
    io = open("box.inp","w")
    println(io,"tolerance 2.0")
    println(io,"output solvated.pdb")
    println(io,"add_box_sides 1.0")
    println(io,"filetype pdb")
    println(io,"seed -1")
    println(io,"                  ")
    println(io,"structure $PDB")
    println(io," number 1")
    println(io," center")
    println(io," fixed 0. 0. 0. 0. 0. 0.")
    println(io,"end structure")
    println(io,"                  ") 
    println(io,"structure tip3p.pdb")
    println(io," number $nwat")
    println(io," inside box -$(lx). -$(ly). -$(lz). $(lx). $(ly). $(lz).")
    println(io,"end structure")
    println(io,"                  ") 
    println(io,"structure SODIUM.pdb")
    println(io," number $charge")
    println(io," inside box -$(lx). -$(ly). -$(lz). $(lx). $(ly). $(lz).")
    println(io,"end structure")
    println(io,"                  ") 
    close(io)

     # creating a new topology file based in the previous model
    filem = open("processed_model.top", "r") 
    file  = open("processed.top", "w" )

    for line in eachline(filem)
      if occursin("NWAT",line)    
        println(file,replace(line,"NWAT" => "$nwat",count = 1)) 
      else
        println(file,line)       
      end
    end

    close(filem)    
    close(file)
  
  end

