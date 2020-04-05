# running some analysis with the published dummy data)

## bamstat

(cd home/rstudio/Data ; QTLtools bamstat --bam HG00381.chr22.bam --bed gencode.v19.exon.chr22.bed.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt)

##  Sequence to genotype matching

(cd home/rstudio/Data ; QTLtools mbv --bam HG00381.chr22.bam --vcf genotypes.chr22.vcf.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt)

## Gene expresion quentification

(cd home/rstudio/Data ; QTLtools quan --bam HG00381.chr22.bam --gtf gencode.v19.annotation.chr22.gtf.gz --sample HG00381 --out-prefix HG00381 --filter-mapping-quality 150 --filter-mismatch 5 --filter-mismatch-total 5 --rpkm)

## PCA Analysis 

(cd home/rstudio/Data ; QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out genes.50percent.chr22)
