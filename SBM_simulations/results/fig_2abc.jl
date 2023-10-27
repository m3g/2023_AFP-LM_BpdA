using Plots, LaTeXStrings, StatsPlots, DelimitedFiles

function readxvg(file)
  x = Float64[]
  y = Float64[]
  open(file,"r") do io
    for line in eachline(io)
      if line[1] in ['#','@'] # skip comments
        continue
      end
      line = split(line)
      push!(x,parse(Float64,line[1]))
      push!(y,parse(Float64,line[2]))
    end
  end
  return x, y
end

temp,cv=readxvg("./results_wham/cv")
q,f_q=readxvg("./results_wham/freeE1166")
time,fraq_q=readxvg("./q_time.xvg")

plot_font = "Computer Modern"

default(
           fontfamily=plot_font,
           framestyle=:box,
           label=nothing,
           grid=false,
	   lw=2,
	   minorticks=Integer,
     left_margin=4Plots.mm,
	   c=:green,
	   dpi=300
       )

#scalefontsizes(); scalefontsizes(1.3)

plot(layout=@layout [ [grid(2,2)] a{0.15w} ])

sp=1
plot!(temp./120.27236,cv,xlabel=L"\mathrm{T \ (units \ of\ T)}",ylabel=L"\mathrm{C_v \ (T)}",subplot=sp)
vline!(temp[findall(x->x==maximum(cv), cv)]./120.27236,linestyle=:dot,color=:black,label=L"\mathrm{T=0.97 \ T_f}",subplot=sp)

sp=2
plot!(q./98,f_q,xlabel=L"\mathrm{Q}",ylabel=L"\mathrm{F(Q)}",xlim=[0.15,0.85],ylim=[0,1],subplot=sp)

sp=3
plot!(10^-4*time,fraq_q,xlabel=L"\mathrm{Time \ steps}/10^{-4}",ylabel=L"\mathrm{Q}",lw=1,subplot=sp)

sp=4
plot!(xaxis=false,
      yaxis=false,
      frame=false,
      xlabel="",
      ylabel="",
      subplot=sp)

sp=5
plot!(xaxis=false,
      yaxis=false,
      frame=false,
      xlabel="",
      ylabel="",
      subplot=sp)

plot!(size=(700+(700*0.2),480+(480*0.2)))

sp=1
annotate!(0.5,760,L"\mathrm{A)}",12,subplot=sp)
sp=2
annotate!(0.01,1,L"\mathrm{B)}",12,subplot=sp)
annotate!(0.6,0.8,L"\mathrm{T=0.97 \ T_f}",12,subplot=sp)
sp=3
annotate!(-6,1.03,L"\mathrm{C)}",12,subplot=sp)
sp=4
annotate!(-0.2,1,L"\mathrm{D)}",12,subplot=sp)

savefig("./cv_q_fq_elvim.pdf")
