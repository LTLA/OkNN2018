# Creates the plots for each simulation scenario.

methods <- c("FNN.kd", "RANN.kd", "kmknn", "kmknn.pre")
color <- c("black", "blue", "red", "salmon")
lty <- c(1,1,1,2)
names(color) <- names(lty) <- methods

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
            chosen <- chosen[order(chosen$npts),]

            # Making the canvas.
            chosen$npts <- chosen$npts/1000
            plot(1,1,type="n", xlim=range(chosen$npts), ylim=range(chosen[,methods]), log="xy",
                    xlab="Number of points (thousands)", ylab="Time (s)",
                    main=sprintf("D = %i, k = %i", d, k))

            # Adding curves with error bars for each method.
            for (meth in methods) {
                current <- split(chosen[,meth], chosen$npts)
                all.means <- unlist(lapply(current, mean))
                all.sds <- unlist(lapply(current, sd))

                new.x <- as.numeric(names(all.means))
                points(new.x, all.means, pch=16, col=color[meth])
                lines(new.x, all.means, lwd=2, col=color[meth], lty=lty[meth])

                upper <- all.means + all.sds
                segments(new.x, all.means, new.x, upper, col=color[meth])
            }
        }
    }

    dev.off()
}
