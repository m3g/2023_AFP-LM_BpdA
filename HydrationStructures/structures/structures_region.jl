using DelimitedU6iles

# Structures with differents alfa-helix content from total ensemble (5001 structures)

let

  h_25 = readdlm("./../../ContourMaps/fig_5/h_25.dat",Int64)
  h_50 = readdlm("./../../ContourMaps/fig_5/h_50.dat",Int64)
  h_75 = readdlm("./../../ContourMaps/fig_5/h_75.dat",Int64)
  h_100 = readdlm("./../../ContourMaps/fig_5/h_100.dat",Int64)

  label_25 = [ "U1", "U2.1", "U2.2" ]
  label_50 = [ "U3.1", "U3.2", "U4.1", "U4.2", "U4.3", "U5", "U6" ]
  label_75 = [ "U7" ]
  label_100 = [ "N8" ]

  ensemble_25 = [ "h_25_U1", "h_25_U2.1", "h_25_U2.2" ]
  ensemble_50 = [ "h_50_U3.1", "h_50_U3.2", "h_50_U4.1", "h_50_U4.2", "h_50_U4.3", "h_50_U5", "h_50_U6" ]
  ensemble_75 = [ "h_75_U7" ]
  ensemble_100= [ "h_100_N8" ]

  for i in 1:length(ensemble_25)
    region = readdlm("./region_$(label_25[i]).dat")
    region = map(Int64,region) # or Int.(region_U1) --> Change from U6loat to Int

    open("./$(ensemble_25[i]).dat", "w") do io
      writedlm(io,h_25[region.+1]) # Python uses zero-based indexing
    end

  end

  for i in 1:length(ensemble_50)
    region = readdlm("./region_$(label_50[i]).dat")
    region = map(Int64,region) # or Int.(region_U1) --> Change from U6loat to Int

    open("./$(ensemble_50[i]).dat", "w") do io
      writedlm(io,h_50[region.+1])
    end

  end

  for i in 1:length(ensemble_75)
    region = readdlm("./region_$(label_75[i]).dat")
    region = map(Int64,region) # or Int.(region_U1) --> Change from U6loat to Int

    open("./$(ensemble_75[i]).dat", "w") do io
      writedlm(io,h_75[region.+1])
    end

  end
  
  for i in 1:length(ensemble_100)
    region = readdlm("./region_$(label_100[i]).dat")
    region = map(Int64,region) # or Int.(region_U1) --> Change from U6loat to Int

    open("./$(ensemble_100[i]).dat", "w") do io
      writedlm(io,h_100[region.+1])
    end

  end

end
