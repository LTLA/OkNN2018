# Helical trajectory simulation.
# Calling script should specify 'HEIGHT', 'CYCLES' and 'JITTER'

if (!exists("HEIGHT")) HEIGHT <- 10
if (!exists("JITTER")) JITTER <- 1 
if (!exists("CYCLES")) CYCLES <- 1 

source("../functions.R")
dir.create("results", showWarnings=FALSE)

FUN <- function(npts, ndim) {
    total <- pi * CYCLES
    angle <- runif(npts, 0, total)  
    x <- cos(angle)
    y <- sin(angle)
    z <- angle * HEIGHT / total

    if (ndim==2L) {
        samples <- cbind(x, y)
    } else {
        samples <- cbind(x, y, z)
        if (ndim > 3L) {
            samples <- samples %*% matrix(rnorm(3 * ndim), nrow=3) # projected into 'ndim'
        }
    }

    samples + rnorm(length(samples), sd=JITTER)
}

run_simulation(paste0("results/helix-", CYCLES, "-", HEIGHT, "-", JITTER, ".txt"), FUN=FUN)

