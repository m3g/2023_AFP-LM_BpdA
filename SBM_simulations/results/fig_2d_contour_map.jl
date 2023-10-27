using PlotlyJS, DelimitedFiles

q = readdlm("./q_time.xvg")
rmsd = readdlm("./rmsd.xvg")
x = q[:,2]
y = rmsd[:,1]

trace1 = histogram2dcontour(
        x = x,
        y = y,
        histnorm="probability density",
        bordercolor="black",
        borderwidth=2,
        colorscale = "Hot",
        reversescale = true,
        colorbar_title = "PD",
        showlabel = true,
        contours = attr(
           coloring = "fill"),
        line = attr(
           color = "gray",
           dash = "solid"),
        colorbar = attr(
           outlinecolor = "black",
           outlinewidth = 2)
        )

layout = Layout(
    xaxis_title="Fraction of native contacts (Q)",
    yaxis_title="RMSD (nm)",
    autosize = false,
    xaxis = attr(
      zeroline = false,
      domain = [0,0],
      showgrid = false,
      ticks="inside",
      tickwidth=2,
      showline=true, linewidth=2, linecolor="black", mirror=true
    ),
    yaxis = attr(
      zeroline = false,
      domain = [0,0],
      showgrid = false,
      ticks="inside",
      tickwidth=2,
      showline=true, linewidth=2, linecolor="black", mirror=true
    ),
    font=attr(
      family="Computer Modern",
      size=28,
      color="Black"),
    width = 860,
    height = 800,
    bargap = 0.15,
    hovermode = "closest",
    showlegend = false
    )

pl = plot([trace1],layout)

savefig(pl, "rmsd_q_counter.pdf", width=860, height=800)
