## devtools::install_github("jlmelville/snedata")
library(snedata)
mnist <- download_mnist()   
out <- irlba::prcomp_irlba(mnist[,-ncol(mnist)], n=50)$x

dir.create("processed", showWarnings=FALSE)
saveRDS(file="processed/mnist.rds", out)
