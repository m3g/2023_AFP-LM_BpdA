using DelimitedFiles

work = @__DIR__

   helix = readdlm("./../../SecondaryStructure/helix_tot.txt")

function cluster_q(helix) 
  h_25 = Vector{Int64}(undef,0)
  h_50 = Vector{Int64}(undef,0)
  h_75 = Vector{Int64}(undef,0)
  h_100 = Vector{Int64}(undef,0)

  # 0 < hélice <= 0.25
    for i in 1:length(helix)
      if helix[i] <= 0.25 
        push!(h_25,i)
      end
    end

  # 0.25 < hélice <= 0.5
    for i in 1:length(helix)
      if helix[i] > 0.25 && helix[i] <= 0.5
        push!(h_50,i)
      end
    end

  # 0.5 < hélice <= 0.75
    for i in 1:length(helix)
      if helix[i] > 0.5 && helix[i] <= 0.75
        push!(h_75,i)
      end
    end

  # 0.75 < hélice <= 1.
    for i in 1:length(helix)
      if helix[i] > 0.75 && helix[i] <= 1.
        push!(h_100,i)
      end
    end

  return h_25, h_50, h_75, h_100
end

  open("h_25.dat","w") do io
    writedlm(io,cluster_q(helix)[1])
  end

  open("h_50.dat","w") do io
    writedlm(io,cluster_q(helix)[2])
  end

  open("h_75.dat","w") do io
    writedlm(io,cluster_q(helix)[3])
  end

  open("h_100.dat","w") do io
    writedlm(io,cluster_q(helix)[4])
  end

