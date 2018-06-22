library(kmknn)
nobs <- 100000
ndim <- 20
X <- matrix(runif(nobs*ndim), ncol=ndim)

pre <- precluster(X)
system.time(out <- findKNN(precomputed=pre, k=10))
system.time(out <- findKNN(precomputed=pre, k=10, BPPARAM=MulticoreParam(2)))
