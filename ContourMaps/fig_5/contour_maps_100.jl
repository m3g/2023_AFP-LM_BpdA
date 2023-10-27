using PlotlyJS, DelimitedFiles

file1 = readdlm("./../../ElViM/projection.out")

proj_25 = readdlm("./proj_25.dat")
proj_50 = readdlm("./proj_50.dat")
proj_75 = readdlm("./proj_75.dat")
proj_100 = readdlm("./proj_100.dat")

x = proj_100[:,1]
y = proj_100[:,2]

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

trace2 = scatter(
        x = x,
        y = y,
        mode = "markers",
        marker = attr(
            color = "rgba(0,0,0,0.3)",
#            symbol="x", 
#            opacity=0.7, 
#            line_width=1,
            size = 3
        )
    )

#trace3 = histogram(
#        y = y,
#        xaxis = "x2",
#        marker = attr(
#            color = "black"
#        )
#    )
#
#trace4 = histogram(
#        x = x,
#        yaxis = "y2",
#        marker = attr(
#            color = "black"
#        )
#    )

layout = Layout(
#    title="Plot Title",
#    xaxis_title="Helix-II",
#    yaxis_title="Helix-III",
    xaxis_range=[103.2, 104.8],
    yaxis_range=[34.2, 35.8],
    autosize = false,
    xaxis = attr(
      zeroline = false,
      domain = [0,0],
#     domain = [0,maximum(x)],
      showgrid = false
    ),
    yaxis = attr(
      zeroline = false,
      domain = [0,0],
#     domain = [0,maximum(y)],
      showgrid = false
    ),
#   legend_title="Legend Title",
    font=attr(
      family="Computer Modern",
      size=28,
      color="Black"),
    width = 880,
    height = 800,
#    bargap = 0.15,
#    hovermode = "closest",
    showlegend = false
    )

pl = plot([trace1, trace2],layout)

savefig(pl, "proj_100_scatter.pdf", width=880, height=800)
