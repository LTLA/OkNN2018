# Creates the plots for each simulation scenario.

methods <- c("FNN.kd", "RANN.kd", "kmknn", "kmknn.pre")
color <- c("black", "blue", "red", "salmon")
names(color) <- methods
dir.create("pics", showWarnings=FALSE)

for (fname in list.files("results", full=TRUE)) {
    newfname <- file.path("pics", sub(".txt", ".pdf", basename(fname)))
    res <- read.delim(fname, stringsAsFactors=FALSE)

    all.d <- unique(res$ndim)
    all.k <- unique(res$k)
    pdf(newfname, width=length(all.d) * 7, height=length(all.k) * 7) # dimensions are columns, 'k' are rows.
    par(mfrow=c(length(all.k), length(all.d)), cex=1.2)

    # Plotting against the number of points, for each combination of neighbors and dimensions.
    for (d in all.d) {
        for (k in all.k) {
            chosen <- res[res$ndim==d & res$k==k,]

            chosen <- chosen[,methods]
            mean.time <- unlist(lapply(chosen, mean))
            sd.time <- unlist(lapply(chosen, sd))
            upper.time <- mean.time + sd.time

            out <- barplot(mean.time, ylab="Time (s)", col=color[methods], ylim=c(0, max(upper.time)),
                main=sprintf("D = %i, k = %i", d, k))
            segments(out, mean.time, out, upper.time)
            segments(out + 0.1, upper.time, out - 0.1, upper.time)
        }
    }

    dev.off()
}
