source("../functions.R")
dir.create("results", showWarnings=FALSE)
run_simulation("results/hypercube.txt", FUN=function(npts, ndim) {
    matrix(runif(npts * ndim), ncol=ndim)
})
