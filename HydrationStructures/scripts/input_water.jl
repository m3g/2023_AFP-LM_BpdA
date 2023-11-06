using DelimitedFiles

  include("measure_prot.jl")
  include("box_gen.jl")
  
  simuls = collect(1:1:5001)
  solvent = ["water"] 

   main_dir="/home/lovelace/proj/proj868/ander/doutorado/projeto/mddf/proteina_a_water"
  
   for c in solvent
     for s in simuls  
       cd("$main_dir/$c/$(s-1)")
       box(6768.46,"$(s-1).pdb", 2) # c é o nome da pasta (water), i é a concentracao

     end
   end
