using DelimitedFiles

# Structures with differents alfa-helix content from total ensemble (5001 structures)

let

  h_25 = readdlm("./../../ContourMaps/fig_5/h_25.dat",Int64)
  h_50 = readdlm("./../../ContourMaps/fig_5/h_50.dat",Int64)
  h_75 = readdlm("./../../ContourMaps/fig_5/h_75.dat",Int64)
  h_100 = readdlm("./../../ContourMaps/fig_5/h_100.dat",Int64)

  label_25 = [ "A", "BI", "BII" ]
  label_50 = [ "CI", "CII", "DI", "DII", "DIII", "E", "F" ]
  label_75 = [ "G" ]
  label_100 = [ "H" ]

  ensemble_25 = [ "h_25_A", "h_25_BI", "h_25_BII" ]
  ensemble_50 = [ "h_50_CI", "h_50_CII", "h_50_DI", "h_50_DII", "h_50_DIII", "h_50_E", "h_50_F" ]
  ensemble_75 = [ "h_75_G" ]
  ensemble_100= [ "h_100_H" ]

  for i in 1:length(ensemble_25)
    region = readdlm("./region_$(label_25[i]).dat")
    region = map(Int64,region) # or Int.(region_A) --> Change from Float to Int

    open("./$(ensemble_25[i]).dat", "w") do io
      writedlm(io,h_25[region.+1]) # Python uses zero-based indexing
    end

  end

  for i in 1:length(ensemble_50)
    region = readdlm("./region_$(label_50[i]).dat")
    region = map(Int64,region) # or Int.(region_A) --> Change from Float to Int

    open("./$(ensemble_50[i]).dat", "w") do io
      writedlm(io,h_50[region.+1])
    end

  end

  for i in 1:length(ensemble_75)
    region = readdlm("./region_$(label_75[i]).dat")
    region = map(Int64,region) # or Int.(region_A) --> Change from Float to Int

    open("./$(ensemble_75[i]).dat", "w") do io
      writedlm(io,h_75[region.+1])
    end

  end
  
  for i in 1:length(ensemble_100)
    region = readdlm("./region_$(label_100[i]).dat")
    region = map(Int64,region) # or Int.(region_A) --> Change from Float to Int

    open("./$(ensemble_100[i]).dat", "w") do io
      writedlm(io,h_100[region.+1])
    end

  end

end
