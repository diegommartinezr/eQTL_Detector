# running some analysis with the published dummy data)


## PCA Analysis 

(cd home/rstudio/Data ; QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out genes.50percent.chr22)

QTLtools pca --vcf genotypes.chr22.vcf.gz --scale --center --maf 0.05 --distance 50000 --out genotypes.chr22