#
# Script originally developed with Julia 1.9.3
#
# For exact reproducibility:
# Install Julia with juliaup: https://github.com/JuliaLang/juliaup#readme
# Install the 1.9.3 version of Julia with: juliaup add 1.9.3
# Run with: julia +1.9.3 helix_content2.jl
#
import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Base.Threads
using ZipFile
using ProteinSecondaryStructures
using PDBTools
using DelimitedFiles
using Statistics
using ProgressMeter
using EasyFit
using Plots

function get_helicity(; dir="./equilibrated_all_atom_models", nfiles=5000)
    nresidues = 60
    # nfiles = number of lines; nresidues = number of colums
    hmatrix = zeros(Int, nfiles, nresidues)
    p = Progress(nfiles)
    @threads for ifile in 1:nfiles
        tmp_pdb = tempname()
        file = "$dir/$(ifile-1).pdb.zip" 
        file_read = try
            r = ZipFile.Reader(file)
            write(tmp_pdb, read(r.files[1], String))
        catch
            nothing
        end
        if isnothing(file_read)
            println("\n error in file: $file")
            continue
        end
        atoms = readPDB(tmp_pdb)
        hmatrix[ifile, :] .= is_alphahelix.(dssp_run(atoms))
        next!(p)
    end
    finish!(p)
    helix_i = mean(hmatrix[:, 10:19], dims=2)
    helix_ii = mean(hmatrix[:, 25:37], dims=2)
    helix_iii = mean(hmatrix[:, 42:56], dims=2)
    helix_tot = (helix_i + helix_ii + helix_iii) / 3
    writedlm("hmatrix.txt", hmatrix)
    writedlm("helix_tot.txt", hcat(helix_tot))
    writedlm("helix_i.txt", hcat(helix_i))
    writedlm("helix_ii.txt", hcat(helix_ii))
    writedlm("helix_iii.txt", hcat(helix_iii))
    return helix_tot, hmatrix, helix_i, helix_ii, helix_iii
end

function plot_helicity()
    helix_tot = vec(readdlm("helix_tot.txt"))
    helix_i = vec(readdlm("helix_i.txt"))
    helix_ii = vec(readdlm("helix_ii.txt"))
    helix_iii = vec(readdlm("helix_iii.txt"))
    plt = plot(layout=(3, 2), size=(800, 600))
    d = fitdensity(vec(helix_i))
    plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_i", subplot=1)
    plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_i", subplot=2)
    d = fitdensity(vec(helix_ii))
    plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_ii", subplot=3)
    plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_ii", subplot=4)
    d = fitdensity(vec(helix_iii))
    plot!(plt, helix_i, xlabel="frame", ylabel="α-helical content", label="helix_iii", subplot=5)
    plot!(plt, d.d, ylabel="density", xlabel="α-helical content", label="helix_iii", subplot=6)
    savefig(plt, "helicity.png")
    return plt
end




#get_helipticity()
