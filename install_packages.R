#installing EMMA for phylogenetic cofounder analysis
install.packages("emma")
#Genomic tools intallation
install.packages("BiocManager")
library(BiocManager)
install("snpStats", ask = FALSE)
library(snpStats)
install("GenomicTools", ask = FALSE)