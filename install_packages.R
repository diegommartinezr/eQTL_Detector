install.packages("emma")

#Genomic tools intallation

if(!requireNamespace("BiocManager" , quietly =TRUE))
+ install.packages("BiocManager")

BiocManager::install("snpStats", version = "3.8")

install.library("GenomicTools")