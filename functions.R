library(FNN)
library(RANN)
library(kmknn)

find_knn <- function(X, k) 
# Timing function, triggering garbage collection first
# to minimize collection throughout the function call. 
{
    all.times <- list()

    # FNN-related algorithms.
    gc()
    all.times$FNN.kd <- system.time(get.knn(X, k))[["elapsed"]]

    gc()
    all.times$FNN.cover <- system.time(get.knn(X, k, algorithm="cover_tree"))[["elapsed"]]

    # RANN-related algorithms.
    gc()
    all.times$RANN.kd <- system.time(nn2(X, k=k))[["elapsed"]]

    gc()
    all.times$RANN.bd <- system.time(nn2(X, k=k, treetype="bd"))[["elapsed"]]

    # KMKNN and variants.
    gc()
    all.times$kmknn <- system.time(findKNN(X, k))[["elapsed"]]

    gc()
    pre <- precluster(X)
    all.times$kmknn.pre <- system.time(findKNN(precomputed=pre, k=k))[["elapsed"]]

    return(unlist(all.times))
}    

run_simulation <- function(fname, FUN, iterations=5) 
# Function to run a simulation and save the results, 
# given a function to create the data matrix.
{
    start <- TRUE
    for (npts in c(5000, 10000, 20000, 50000, 100000)) { 
        for (ndim in c(2, 5, 10, 20, 50)) { 
            for (k in c(2, 5, 10, 20, 50)) {
                for (it in seq_len(iterations)) { 
                    X <- FUN(npts, ndim)
                    out <- find_knn(X, k=k)
                    write.table(data.frame(npts=npts, ndim=ndim, k=k, rbind(out)), file=fname, append=!start, col.names=start, 
                            row.names=FALSE, quote=FALSE, sep="\t")
                    start <- FALSE
                }
            }
        }
    }
    return(TRUE)
}
