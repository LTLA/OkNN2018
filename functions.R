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
