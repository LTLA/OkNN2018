# Running nearest neighbor detection on the MNIST digits dataset.
# Except for BD, which stalls here.

source("../functions.R")
X <- readRDS("processed/mnist.rds")
dir.create("results", showWarnings=FALSE)
run_real("results/mnist.txt", X, methods=setdiff(METHODS, "RANN.bd")) 
