# Load packages
using DelimitedFiles, Statistics, ComplexMixtures

let 

label = [ 
	  "25_U1", 
	  "25_U2.1", 
	  "25_U2.2", "50_U3.1", 
	  "50_U3.2", "50_U4.1", 
	  "50_U4.2", "50_U4.3", 
	  "50_U5", "50_U6", 
	  "75_U7", "100_N8" 
	  ]

helice = [ 
	   "h_25_", 
	   "h_25_U2.1", 
           "h_25_U2.2", "h_50_U3.1", 
	   "h_50_U3.2", "h_50_U4.1", 
	   "h_50_U4.2", "h_50_U4.3", 
	   "h_50_U5", "h_50_U6", 
	   "h_75_U7", "h_100_N8" 
	   ]

  for i in 1:length(helice)

    cluster = readdlm("./../SecondaryStructure/ensembles/$(helice[i]).dat",Int64)  
  
  # Water 

  data_kb_w = Vector{Float64}(undef,0)
    for i in cluster
      cm = ComplexMixtures.load("./../water/$(i-1)/results-water.json")
      push!(data_kb_w, cm.kb[end]./1000)
    end
  avg_kb_w = [ mean(data_kb_w[:,1]) ]
  err_kb_w = [ std(data_kb_w[:,1];corrected=false)./sqrt(length(data_kb_w[:,1])) ]

  open("./avg_kb_w_$(label[i]).dat", "w") do io
    writedlm(io,avg_kb_w)
  end

  open("./err_kb_w_$(label[i]).dat", "w") do io
    writedlm(io,err_kb_w)
  end

  end

end
