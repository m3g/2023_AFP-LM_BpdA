using DelimitedFiles, LaTeXStrings, Plots, EasyFit, ColorSchemes, ComplexMixtures, PDBTools, Formatting

# Will use moving averages for more pretty graphs
ma(data) = movingaverage(data,10).x

s=10
# Plot defaults
plot_font = "Computer Modern"
default(
    fontfamily=plot_font,
    linewidth=1,
    framestyle=:box,
    label=nothing,
    grid=false,
    dpi=300,
    leftmargin=0.6Plots.Measures.cm,
    bottommargin=0.6Plots.Measures.cm,
    xguidefontsize=s,
    xtickfontsize=s,
    yguidefontsize=s,
    ytickfontsize=s,
#    ylim=[0-0.2,4.2],
    minorticks=Integer)

#scalefontsizes(); scalefontsizes(1.3)

plot(layout=@layout [ [ a [ b ; c ] ] a{0.1w} ; d ] )
#plot(layout=@layout [ [ a b ]  a{0.1w} ] )

label = [ #"A",
          #"BI",
          #"BII", "CI",
          #"CII", "DI",
          "DII", 
          #"DIII",
          #"E", 
          "F",
          #"G", 
          "H" ]

  c = [ #get(ColorSchemes.okabe_ito,(1)/12),
      #get(ColorSchemes.okabe_ito,(2)/12),
      #get(ColorSchemes.okabe_ito,(3)/12),
      #get(ColorSchemes.okabe_ito,(4)/12),
      #get(ColorSchemes.okabe_ito,(5)/12),
      #get(ColorSchemes.okabe_ito,(6)/12),
      get(ColorSchemes.okabe_ito,(7)/12),
      #get(ColorSchemes.okabe_ito,(8)/12),
      #get(ColorSchemes.okabe_ito,(9)/12),
      get(ColorSchemes.okabe_ito,(10)/12),
      #get(ColorSchemes.okabe_ito,(11)/12),
      get(ColorSchemes.okabe_ito,(12)/12) 
      ]

sp=1
  for i in 1:length(label)  
    # Water
    cm_water = ComplexMixtures.load("./results-water_$(label[i]).json")
    plot!(cm_water.d,ma(cm_water.mddf),
    xlabel=L"\mathrm{r/Å}",ylabel=L"g^{md}_{pw} \ (r)",
    subplot=sp,
    xlim=[1.5,4.],
    color=c[i],
    ylim=[0.8,1.9])
  end

sp=2
  for i in 1:length(label)
    plot!([1],[1],
      xaxis=false,
      yaxis=false,
      xlabel="",
      ylabel="",
      legend=:topleft,
      color=c[i],
      subplot=sp)
  end

sp=3
  for i in 1:length(label)  
    # Water
    cm_water = ComplexMixtures.load("./results-water_$(label[i]).json")
    plot!(cm_water.d,ma(cm_water.kb./1000),
    xlabel=L"\mathrm{r/Å}",ylabel=L"{G_{pw}} \ (r) / \mathrm{L\ mol^{-1}}",
    subplot=sp,
    xlim=[0.5,6.0],
    color=c[i],
    ylim=[-6.6,-4.0])
  end

  label_t = [ #L"{\mathrm{U^{1}_{25}}}",
              #L"{\mathrm{U^{2.1}_{25}}}",
              #L"{\mathrm{U^{2.2}_{25}}}",
              #L"{\mathrm{U^{3.1}_{50}}}",
              #L"{\mathrm{U^{3.2}_{50}}}",
              #L"{\mathrm{U^{4.1}_{50}}}",
              L"{\mathrm{U^{4.2}_{50}}}",
              #L"{\mathrm{U^{4.3}_{50}}}",
              #L"{\mathrm{U^{5}_{50}}}",
              L"{\mathrm{U^{6}_{50}}}",
              #L"{\mathrm{U^{7}_{75}}}",
              L"{\mathrm{N^{8}_{100}}}" ]

sp=4
  for i in 1:length(label)
    plot!([1],[1],
      xaxis=false,
      yaxis=false,
      xlabel="",
      ylabel="",
      #label=L"{ \mathrm{U^{1}_{25}} }",
      label=label_t[i],
      legend=:topleft,
      color=c[i],
      legendfontsize=8,
      subplot=sp)
  end

# PDB file of the system simulated
pdb = readPDB("./solvated.pdb")

# Load results of a ComplexMixtures run
R = load("./results-water_F.json")

# Inform which is the solute
protein = select(pdb, "protein")
solute = Selection(protein, nmols=1)

# Inform which is the solvent
water = select(pdb, "resname SOL")
solvent = Selection(water, natomspermol=3)

# Plot a 2D map showing the contributions of some residues
residues = collect(eachresidue(protein))
irange = 1:60
rescontrib = zeros(length(R.mddf), length(residues))
for (ires, residue) in pairs(residues)
  rescontrib[:, ires] .= contrib(solute, R.solute_atom, residue)
end

# Plot only for distances within 1.5 and 3.5:
idmin = findfirst(d -> d > 1.5, R.d)
idmax = findfirst(d -> d > 3.5, R.d)

# Obtain pretty labels for the residues in the x-axis
labels = PDBTools.oneletter.(resname.(residues)).*format.(resnum.(residues))

sequence = getseq(protein)

rescontrib_U1 = copy(rescontrib)

# Load results of a ComplexMixtures run
R = load("./results-water_H.json")

rescontrib = zeros(length(R.mddf), length(residues))
for (ires, residue) in pairs(residues)
  rescontrib[:, ires] .= contrib(solute, R.solute_atom, residue)
end

# Plot only for distances within 1.5 and 3.5:
idmin = findfirst(d -> d > 1.5, R.d)
idmax = findfirst(d -> d > 3.5, R.d)

rescontrib_N = copy(rescontrib)

rescontrib = rescontrib_N.-rescontrib_U1

sp=5
contourf!(irange, R.d[idmin:idmax], rescontrib[idmin:idmax, irange],
  clims=(-0.02961, 0.02961),
  color=cgrad(:RdBu,rev=true), 
  linewidth=1, linecolor=:black,
  colorbar=:none, levels=5,
 # reversescale = true,
  xlabel="Residue", ylabel=L"r/\AA",
  xticks=(irange, labels[irange]), xrotation=90,
  xtickfont=font(6, plot_font),
  size=(700, 400),
#  label=L"{\mathrm{N^{8}_{100} - U^{6}_{50}}}",
  subplot=sp
)

plot!(size=(700,550))


sp=1
annotate!(0.8,1.9,L"\mathrm{A)}",10,subplot=sp)
sp=2
annotate!(0.64,2,L"\mathrm{B)}",10,subplot=sp)
annotate!(1,1.9,L"{\mathrm{U^{4.2}_{50}}}",10,subplot=sp)
annotate!(1.5,1.9,L"{\mathrm{U^{6}_{50}}}",10,subplot=sp)
annotate!(2.,1.9,L"{\mathrm{N^{8}_{100}}}",10,subplot=sp)
sp=3
annotate!(-1.3,-2.8,L"\mathrm{C)}",10,subplot=sp)
sp=5
annotate!(5.5,3.35,L"{\mathrm{N^{8}_{100} - U^{6}_{50}}}",10,subplot=sp)
annotate!(-3,3.5,L"\mathrm{D)}",10,subplot=sp)

# Save figure
savefig("./all-mddf_paper_okabe_ito.pdf")
#savefig("./all-mddf_paper_3.png")
