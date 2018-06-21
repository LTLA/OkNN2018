source("../functions.R")

fname <- "res_hypercube.txt"
start <- TRUE

for (npts in c(5000, 10000, 20000, 50000, 100000)) { 
    for (ndim in c(2, 5, 10, 20, 50)) { 
        for (k in c(2, 5, 10, 20, 50)) {
            for (it in seq_len(5)) { 
                X <- matrix(runif(npts * ndim), ncol=ndim)
                out <- find_knn(X, k=k)
                write.table(data.frame(npts=npts, ndim=ndim, k=k, rbind(out)), file=fname, append=!start, col.names=start, 
                    row.names=FALSE, quote=FALSE, sep="\t")
                start <- FALSE
            }
        }
    }
}
