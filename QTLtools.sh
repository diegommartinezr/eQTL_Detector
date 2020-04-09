# QTL tools analysis
cd /home/rstudio/Data

## PCA Analysis
QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out genes.50percent.chr22
## Moving results to Folder
mv genes.50percent.chr22.pca /home/rstudio/Results
mv genes.50percent.chr22.pca_stats /home/rstudio/Results