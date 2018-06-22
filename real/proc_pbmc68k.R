library(scran)
library(scater)
library(DropletUtils)

# Pre-processing the 68K PBMC dataset.
# Unpack http://cf.10xgenomics.com/samples/cell-exp/1.1.0/fresh_68k_pbmc_donor_a/fresh_68k_pbmc_donor_a_filtered_gene_bc_matrices.tar.gz into "raw_data/pbmc68k".
sce.68 <- read10xCounts("raw_data/pbmc68k/hg19/") 

# Adding locational annotation (using a slightly off-version ensembl, but chromosome assignment shouldn't change).
library(EnsDb.Hsapiens.v86)
loc <- mapIds(EnsDb.Hsapiens.v86, keys=rownames(sce.68), keytype="GENEID", column="SEQNAME")
rowData(sce.68)$Chr <- loc

# Brief quality control.
sce.68 <- calculateQCMetrics(sce.68, compact=TRUE, feature_controls=list(Mt=which(loc=="MT")))
lowlib <- isOutlier(sce.68$scater_qc$all$log10_total_counts, type="lower", nmads=3)
lowfeat <- isOutlier(sce.68$scater_qc$all$log10_total_features_by_counts, type="lower", nmads=3)
highmito <- isOutlier(sce.68$scater_qc$feature_control_Mt$pct_counts, type="higher", nmads=3)
discard <- lowlib | lowfeat | highmito
##summary(discard)
sce.68 <- sce.68[,!discard]

# Performing normalization, breaking the problem up into smaller blocks and subclustering within them.
blocks <- rep(seq_len(10), length.out=ncol(sce.68))
clusters <- quickCluster(sce.68, min.mean=0.1, block=blocks, method="igraph", block.BPPARAM=MulticoreParam(2))
##table(clusters)
##table(clusters, blocks)

sce.68 <- computeSumFactors(sce.68, clusters=clusters, min.mean=0.1, BPPARAM=MulticoreParam(2))
##plot(sce.68$scater_qc$all$total_counts, sizeFactors(sce.68), log="xy")
sce.68 <- normalize(sce.68)

# Modelling the mean-variance trend.
fit.68 <- trendVar(sce.68, use.spikes=FALSE, loess.args=list(span=0.1))
##plot(fit.68$mean, fit.68$vars)
##curve(fit.68$trend(x), add=TRUE, col="red")
dec.68 <- decomposeVar(fit=fit.68)

# Obtaining the first 50 PCs from all HVGs with positive biological components.
to.use <- dec.68$bio > 0
out <- scran:::.multi_pca(list(logcounts(sce.68)[to.use,]), d=50, approximate=TRUE, use.crossprod=TRUE)
X <- out[[1]]

dir.create("processed", showWarnings=FALSE)
saveRDS(file="processed/pbmc68k.rds", X)
