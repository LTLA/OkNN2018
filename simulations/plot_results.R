# Creates the plots for each simulation scenario.

color <- c(FNN="black", RANN="blue", kmknn="red")
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

            chosen$npts <- chosen$npts/1000
            methods <- c("FNN", "RANN", "kmknn")
            plot(1,1,type="n", xlim=range(chosen$npts), ylim=range(chosen[,methods]), log="xy",
                    xlab="Number of points (thousands)", ylab="Time (s)",
                    main=sprintf("D = %i, k = %i", d, k))

            for (meth in methods) {
                points(chosen$npts, chosen[,meth], pch=16, col=color[meth])
                lines(chosen$npts, chosen[,meth], lwd=2, col=color[meth])
            }
        }
    }

    dev.off()
}
