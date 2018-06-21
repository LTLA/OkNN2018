library(FNN)
library(RANN)
library(kmknn)

find_knn <- function(X, k) 
# Timing function, triggering garbage collection first
# to minimize collection throughout the function call. 
{
    all.times <- list()

    gc()
    all.times$FNN <- system.time(get.knn(X, k))[["elapsed"]]

    gc()
    all.times$RANN <- system.time(nn2(X, k=k))[["elapsed"]]

    gc()
    all.times$kmknn <- system.time(findKNN(X, k))[["elapsed"]]

    return(unlist(all.times))
}    

run_simulation <- function(fname, FUN) 
# Function to run a simulation and save the results, 
# given a function to create the data matrix.
{
    start <- TRUE
    for (npts in c(5000, 10000, 20000, 50000, 100000)) { 
        for (ndim in c(2, 5, 10, 20, 50)) { 
            for (k in c(2, 5, 10, 20, 50)) {
                X <- FUN(npts, ndim)
                out <- find_knn(X, k=k)
                write.table(data.frame(npts=npts, ndim=ndim, k=k, rbind(out)), file=fname, append=!start, col.names=start, 
                        row.names=FALSE, quote=FALSE, sep="\t")
                start <- FALSE
            }
        }
    }
    return(TRUE)
}
