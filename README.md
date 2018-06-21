# Testing kmknn performance on real and simulated data

## Overview

This repository tests the performance of the [_kmknn_ package](https://github.com/LTLA/kmknn) for detecting nearest neighbours.
In particular, it compares to existing R packages based on the ANN library (i.e., [RANN](https://cran.r-project.org/web/packages/RANN/index.html) and [FNN](https://cran.r-project.org/web/packages/FNN/index.html)). 
Focus is on moderately high-dimensional data as discussed by [Wang (2012)](https://dx.doi.org/10.1016/j.patcog.2010.01.003).

## Simulations 

Scenarios include:

- `sim_hypercube.R`, consisting of uniformly distributed points in a hypercube.
