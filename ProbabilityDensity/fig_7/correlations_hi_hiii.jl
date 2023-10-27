using PlotlyJS, DelimitedFiles

helix_i = readdlm("./../../SecondaryStructure/helix_i.txt")
helix_ii = readdlm("./../../SecondaryStructure/helix_ii.txt")
helix_iii = readdlm("./../../SecondaryStructure/helix_iii.txt")

hi = helix_i[:,1]
hii = helix_ii[:,1]
hiii = helix_iii[:,1]

x = hi*100
y = hiii*100

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
    xaxis_title="Helix-I content (%)",
    yaxis_title="Helix-III content (%)",
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
#     domain = [0,maximum(y)],
      showgrid = false,
      ticks="inside",
      tickwidth=2,
      showline=true, linewidth=2, linecolor="black", mirror=true
    ),
#   legend_title="Legend Title",
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

pl = plot([ trace1 ],layout)

savefig(pl, "fig_7b.pdf", width=860, height=800)
