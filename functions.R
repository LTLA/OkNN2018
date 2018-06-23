library(FNN)
library(RANN)
library(kmknn)

# Not using RANN box decomposition by default, as it seems to use too much memory.
METHODS <- c("FNN.kd", "FNN.cover", "RANN.kd", "kmknn", "kmknn.pre")

find_knn <- function(X, k, methods=METHODS) 
# Timing function, triggering garbage collection first
# to minimize collection throughout the function call. 
{
    all.times <- list()

    # FNN-related algorithms.
    if ("FNN.kd" %in% methods) { 
        gc()
        all.times$FNN.kd <- system.time(get.knn(X, k))[["elapsed"]]
    }

    if ("FNN.cover" %in% methods) {
        gc()
        all.times$FNN.cover <- system.time(get.knn(X, k, algorithm="cover_tree"))[["elapsed"]]
    }

    # RANN-related algorithms.
    if ("RANN.kd" %in% methods) {
        gc()
        all.times$RANN.kd <- system.time(nn2(X, k=k))[["elapsed"]]
    }

    if ("RANN.bd" %in% methods) {
        gc()
        all.times$RANN.bd <- system.time(nn2(X, k=k, treetype="bd"))[["elapsed"]]
    }

    # KMKNN and variants.
    if ("kmknn" %in% methods) {
        gc()
        all.times$kmknn <- system.time(findKNN(X, k))[["elapsed"]]
    }

    if ("kmknn.pre" %in% methods) {
        gc()
        pre <- precluster(X)
        all.times$kmknn.pre <- system.time(findKNN(precomputed=pre, k=k))[["elapsed"]]
    }

    return(unlist(all.times))
}    

run_simulation <- function(fname, FUN, iterations=5, ...) 
# Function to run a simulation and save the results, 
# given a function to create the data matrix.
{
    start <- TRUE
    for (npts in c(5000, 10000, 20000, 50000, 100000)) { 
        for (ndim in c(2, 5, 10, 20, 50)) { 
            for (k in c(2, 5, 10, 20, 50)) {
                for (it in seq_len(iterations)) { 
                    X <- FUN(npts, ndim)
                    out <- find_knn(X, k=k, ...)
                    write.table(data.frame(npts=npts, ndim=ndim, k=k, rbind(out)), file=fname, append=!start, col.names=start, 
                            row.names=FALSE, quote=FALSE, sep="\t")
                    start <- FALSE
                }
            }
        }
    }
    return(TRUE)
}

run_real <- function(fname, X, iterations=5, ...) 
# Function to run a NN search on the real data and save the results, 
# given a data matrix.
{
    start <- TRUE 
    for (d in c(2, 5, 10, 20, 50)) { 
        if (d > ncol(X)) break 
        Y <- X[,seq_len(d),drop=FALSE]

        for (k in c(2, 5, 10, 20, 50)) {
            for (it in seq_len(iterations)) { 
                timings <- find_knn(Y, k=k, ...)
                write.table(data.frame(ndim=d, k=k, rbind(timings)), file=fname, append=!start, col.names=start, 
                        row.names=FALSE, quote=FALSE, sep="\t")
            }
        }
    }
    return(TRUE)
}
