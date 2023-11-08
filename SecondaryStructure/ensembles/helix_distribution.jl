#
# Script originally developed with Julia 1.9.3
#
# For exact reproducibility:
# Install Julia with juliaup: https://github.com/JuliaLang/juliaup#readme
# Install the 1.9.3 version of Julia with: juliaup add 1.9.3
# Run with: julia +1.9.3 helix_distribution.jl
#
import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Plots
using Statistics
using DelimitedFiles
using LaTeXStrings

@views function plot_distributions(;save=false)
    ensemble_files = sort(filter(file -> occursin(r"h_.+dat", file), readdir()))
    hmatrix = readdlm("../hmatrix.txt")
    default(
        fontfamily="Computer Modern"
    )
    plt = plot(layout=(4, 3))
    labels = [
        L"N_{100}^8",
        L"U_{25}^1",
        L"U_{25}^{2.1}",
        L"U_{25}^{2.2}",
        L"U_{50}^{3.1}",
        L"U_{50}^{3.2}",
        L"U_{50}^{4.1}",
        L"U_{50}^{4.2}",
        L"U_{50}^{4.3}",
        L"U_{50}^{5}",
        L"U_{50}^{6}",
        L"U_{75}^{7}",
    ]
    for (ifile, file) in enumerate(ensemble_files)
        structures = vec(readdlm(file, Int))
        helix_i = mean(hmatrix[structures, 10:19], dims=2)
        helix_ii = mean(hmatrix[structures, 25:37], dims=2)
        helix_iii = mean(hmatrix[structures, 42:56], dims=2)
        helix_avg = (helix_i + helix_ii + helix_iii) / 3
        avg = mean(helix_avg)
        standard_deviation = std(helix_avg)
        println("$(file[3:end-4]) : Mean helicity: $(round(avg, digits=2)) ± $(round(standard_deviation, digits=2))")
        histogram!(plt, helix_avg, subplot=ifile,
            legend=nothing,
            title="$(labels[ifile]) : $(round(avg, digits=2)) ± $(round(standard_deviation, digits=2))",
            xlims=(0, 1),
        )
    end
    plot!(
        size=(800,1200),
        framestyle=:box,
        grid=:false,
        margin=0.3Plots.Measures.cm,
        leftmargin=0.5Plots.Measures.cm,
        xlabel="α-helical content",
        ylabel="density"
    )
    save && savefig("helix_distribution.pdf")
    return plt
end

!isinteractive() && plot_distributions(;save=true)



