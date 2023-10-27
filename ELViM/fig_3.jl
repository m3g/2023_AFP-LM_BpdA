using Plots, DelimitedFiles, LaTeXStrings

##################
#     ELViM      #
##################
# 1-Traj.jl
# 2-little_qv1.2
# 3-r_projection.R - Cada linha de projection.log corresponde às coordenadas x,y de cada frame da dinâmica (0 para 5000).

  file1 = readdlm("./projection.out")
  file2 = readdlm("./../SBM_simulations/results/q_time.xvg")
  file3 = readdlm("./../SBM_simulations/results/rmsd.xvg")

  x = file1[:,1]
  y = file1[:,2]
  q = file2[:,2]
  rmsd = file3[:,1]

# Sortear q na ordem crescente, e manter a correspondência das demais variáveis.

  ids  = sortperm(q);
  x1 = x[ids]; 
  y1 = y[ids];
  r1 = rmsd[ids];
  q1 = sort(q);

# Plot defaults
plot_font = "Computer Modern"
default(
    fontfamily=plot_font,
    label="",
    border=:none,
    grid=false,
    right_margin=7Plots.mm,
    dpi=300
)
scalefontsizes(); scalefontsizes(1.3)

scatter(border=:none,right_margin=7Plots.mm,colorbar_titlefontsize=8)
scatter!(x1,y1,
         zcolor=q1,ms=1.8,
         markerstrokewidth=0.0,
         thickness_scaling=1.2,
         colorbar_titlefontsize=10,
         colorbar_title="\n Fraction of native contacts (Q) ")

plot!(size=(500,380))

savefig("./fig_3.pdf")
