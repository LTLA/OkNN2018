# Running nearest neighbor detection on the 68K PBMC dataset from 10X Genomics.
# Except for BD, which stalls here.

source("../functions.R")
dir.create("results", showWarnings=FALSE)
run_real("results/pbmc68k.txt", X, methods=setdiff(METHODS, "RANN.bd")) 
