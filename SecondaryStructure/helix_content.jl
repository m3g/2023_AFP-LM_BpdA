using Plots, Statistics, DelimitedFiles

dir = @__DIR__
nresidues = 60

function get_helicity(dir,nresidues)
  files = filter(f -> f[end-4:end] == ".dssp", readdir(dir))   # Why [end-4:end] ?
  nfiles = length(files)  
  matrix = zeros(Float64,nfiles,nresidues)                            # nfiles = number of lines; nresidues = number of colums
  for i in 0:nfiles-1
    file = open("$dir/$(i)0.pdb.dssp","r")
    residue_start = false
    for line in eachline(file)
      # skip header
      if occursin("RESIDUE",line)
        residue_start = true
        continue
      end
      if ! residue_start 
        continue
      end
      # read data: columns 6:10 contain the residue number,
      # it data for the residue is available
      try
        residue = parse(Int,line[6:10])
        # If 17th character is an 'H', an helix was attributed
        # to this residue
        if line[17] == 'H'
          matrix[i+1,residue] = 1
        end
      catch
        continue
      end
    end
    close(file)
  end
  avg_helicity_per_frame = [ mean(matrix[i,:]) for i in 1:nfiles ]
  helix_i   = [ mean(matrix[i,10:19]) for i in 1:nfiles ]
  helix_ii  = [ mean(matrix[i,25:37]) for i in 1:nfiles ]
  helix_iii = [ mean(matrix[i,42:56]) for i in 1:nfiles ]
  helix_tot = [ mean(matrix[i,1:nresidues]) for i in 1:nfiles ]
  return avg_helicity_per_frame, matrix, helix_i, helix_ii, helix_iii, helix_tot
end

helix_tot, matrix, helix_i, helix_ii, helix_iii = get_helicity(dir,nresidues)

  open("helix_tot.txt", "w") do io
    writedlm(io,helix_tot)
  end

  open("matrix.txt", "w") do io
    writedlm(io,matrix)
  end

  open("helix_i.txt", "w") do io
    writedlm(io,helix_i)
  end

  open("helix_ii.txt", "w") do io
    writedlm(io,helix_ii)
  end

  open("helix_iii.txt", "w") do io
    writedlm(io,helix_iii)
  end
