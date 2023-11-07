# Script originally execurted with Julia 1.9.3
# Install Julia with juliaup: https://github.com/JuliaLang/juliaup#readme
# Install the 1.9.3 version of Julia with: juliaup add 1.9.3
# Run with: julia +1.9.3 helix_content2.jl
import Pkg
Pkg.activate(".")
Pkg.instantiate()

using ZipFile
using ProteinSecondaryStructures
using PDBTools
using DelimitedFiles
using Statistics
using ProgressMeter
using EasyFit
using Plots

function get_helipticity(;dir="./equilibrated_all_atom_models", nfiles=5000)
  nresidues = 60
  hmatrix = zeros(Int,nfiles,nresidues) # nfiles = number of lines; nresidues = number of colums
  tmp_pdb = tempname()
  @showprogress for ifile in 1:nfiles
      @show "$dir/$(ifile-1).pdb.zip"
      r = ZipFile.Reader("$dir/$(ifile-1).pdb.zip")
      write(tmp_pdb, read(r.files[1], String))
      atoms = readPDB(tmp_pdb)
      hmatrix[ifile,:] .= is_alphahelix.(dssp_run(atoms))
  end
  helix_i = mean(hmatrix[:,10:19], dims=2)
  helix_i_std = std(hmatrix[:,10:19], dims=2)
  helix_ii  = mean(hmatrix[:,25:37], dims=2)
  helix_ii_std  = std(hmatrix[:,25:37], dims=2)
  helix_iii = mean(hmatrix[:,42:56], dims=2)
  helix_iii_std = std(hmatrix[:,42:56], dims=2)
  helix_tot = [ (helix_i[i].+helix_ii[i].+helix_iii[i])/3 for i in eachindex(helix_i) ]

  writedlm("helix_tot.txt", helix_tot)
  writedlm("hmatrix.txt", hmatrix)
  writedlm("helix_i.txt", helix_i)
  writedlm("helix_ii.txt", helix_ii)
  writedlm("helix_iii.txt", helix_iii)

  plt = plot(layout=(3,2), size=(800,600))
  d = fitdensity(vec(helix_i))
  plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_i", subplot=1)
  plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_i", subplot=2)
  d = fitdensity(vec(helix_ii))
  plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_ii", subplot=3)
  plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_ii", subplot=4)
  d = fitdensity(vec(helix_iii))
  plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_iii", subplot=5)
  plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_iii", subplot=6)
  savefig(plt, "hellipticity.png")

  return helix_tot, hmatrix, helix_i, helix_ii, helix_iii, plt
end

#get_helipticity()
