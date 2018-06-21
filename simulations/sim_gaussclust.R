# Gaussian cluster simulation.
# Calling script should specify 'NCLUST' and 'SD'.

if (!exists("NCLUST")) NCLUST <- 10
if (!exists("SD")) SD <- 2

source("../functions.R")

FUN <- function(npts, ndim) {
    ids <- sample(NCLUST, npts, replace=TRUE)
    clust.centers <- matrix(rnorm(NCLUST * ndim, sd=SD), ncol=ndim) 
    means <- clust.centers[ids,]
    matrix(rnorm(npts * ndim, mean=means), ncol=ndim)
}

run_simulation(paste0("res_gaussclust-", NCLUST, "-", SD, ".txt"), FUN=FUN)

