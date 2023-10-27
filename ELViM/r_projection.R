library(mp)
library(fields)
args <- commandArgs(trailingOnly = TRUE)

dmat <- read.table(args[1], quote="\"")

dt = 2 * pi / 100
offset = 10
theta = 0.0
k=0
i=0
init <- matrix(0, ncol=2, nrow = length(dmat))
while( i <= length(dmat)){
  init[i,1] = cos(theta) * offset
  init[i,2] = sin(theta) * offset
  k =  k + 1
  theta = theta + dt
  if (k == 100){
    offset = offset + 10
    k = 0
  }
  i = i+1
}
plot(init)

a = forceScheme(dmat,Y =init, max.it = 10000, tol = 0.000001)

fudgeit <- function(){
  xm <- get('xm', envir = parent.frame(1))
  ym <- get('ym', envir = parent.frame(1))
  z  <- get('dens', envir = parent.frame(1))
  colramp <- get('colramp', parent.frame(1))
  image.plot(xm,ym,z, col = colramp(256), legend.only = T, add =F)
}

par(mar = c(5,4,4,5) + .1)
density = smoothScatter(a, xaxt='n', yaxt='n', ann=FALSE, nbin = 100, postPlotHook = fudgeit)

plot(a, pch=21, cex = 1.2, bg="lightblue", xaxt='n', yaxt='n', ann=FALSE)
dev.off()
write.table(a, file = "projection.out", quote = FALSE, sep = " ",row.names = FALSE, col.names = FALSE)
