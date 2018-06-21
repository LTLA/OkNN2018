source("../functions.R")
run_simulation("res_hypercube.txt", FUN=function(npts, ndim) {
    matrix(runif(npts * ndim), ncol=ndim)
})
