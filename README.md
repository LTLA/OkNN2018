# Testing kmknn performance on real and simulated data

## Overview

This repository tests the performance of the [_kmknn_ package](https://github.com/LTLA/kmknn) for detecting nearest neighbours.
Speed comparisons are performed to existing R packages, mostly based on the ANN library (i.e., [RANN](https://cran.r-project.org/web/packages/RANN/index.html) and [FNN](https://cran.r-project.org/web/packages/FNN/index.html)). 
We focus on performance for data sets with moderately high (10-50) dimensions, as discussed by [Wang (2012)](https://dx.doi.org/10.1016/j.patcog.2010.01.003).

## Simulations 

Scenarios in `simulations/` include:

- `sim_hypercube.R`, consisting of uniformly distributed points in a hypercube.
- `sim_gaussclust.R`, consisting of Gaussian clusters.
- `sim_helical.R`, consisting of a helical trajectory.

Some of the scripts have tunable parameters that should be specified by the calling process.
This is controlled during job submission, which can be executed by calling `submitter.sh` for SLURM clusters.

## Real data

Each dataset in `real/` should contain:

- `proc_*.R`, which processes the data into a RDS file for nearest neighbor detection.
- `run_*.R`, which runs the algorithm timings on the processed data.

Currently the only dataset is the PBMC 68K single-cell RNA-seq data from 10X Genomics.

## Plot generation

The `plot_results.R` scripts in both directories will generate summary plots for each scenario/dataset.
Each plot will show the effect of dimensionality and choice of `k`, as well as the number of points for the simulations.
