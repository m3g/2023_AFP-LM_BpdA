using DelimitedFiles

work = @__DIR__

    file1 = readdlm("./../../ELViM/projection.out")
     h_25 = readdlm("./h_25.dat",Int64)
     h_50 = readdlm("./h_50.dat",Int64)
     h_75 = readdlm("./h_75.dat",Int64)
    h_100 = readdlm("./h_100.dat",Int64)

    open("proj_25.dat", "w") do io
      writedlm(io,[ file1[h_25,1] file1[h_25,2] ])
    end

    open("proj_50.dat", "w") do io
      writedlm(io,[ file1[h_50,1] file1[h_50,2] ])
    end

    open("proj_75.dat", "w") do io
      writedlm(io,[ file1[h_75,1] file1[h_75,2] ])
    end

    open("proj_100.dat", "w") do io
      writedlm(io,[ file1[h_100,1] file1[h_100,2] ])
    end

