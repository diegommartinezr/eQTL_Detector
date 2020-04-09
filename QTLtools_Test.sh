# running some analysis with the published QTLtools dummy data

#We need to run this on the Data Folder

cd /home/rstudio/Data

#[bamstat] to control the quality of the sequence data
QTLtools bamstat --bam HG00381.chr22.bam --bed gencode.v19.exon.chr22.bed.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt
mv HG00381.chr22.bamstat.txt /home/rstudio/Results

#[match] to ensure good matching between sequence and genotype data
QTLtools mbv --bam HG00381.chr22.bam --vcf genotypes.chr22.vcf.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt
mv HG00381.chr22.match.txt /home/rstudio/Results

#[quan] to quantify gene expression
QTLtools quan --bam HG00381.chr22.bam --gtf gencode.v19.annotation.chr22.gtf.gz --sample HG00381 --out-prefix HG00381 --filter-mapping-quality 150 --filter-mismatch 5 --filter-mismatch-total 5 --rpkm
mv HG00381.5zDu4oPgLES.exon.count.bed /home/rstudio/Results
mv HG00381.5zDu4oPgLES.exon.rpkm.bed /home/rstudio/Results
mv HG00381.5zDu4oPgLES.gene.count.bed /home/rstudio/Results
mv HG00381.5zDu4oPgLES.gene.rpkm.bed /home/rstudio/Results
mv HG00381.5zDu4oPgLES.stats /home/rstudio/Results

#[pca] to perform PCA on phenotype and genotype data
QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out genes.50percent.chr22
mv genes.50percent.chr22.pca /home/rstudio/Results
mv genes.50percent.chr22.pca_stats /home/rstudio/Results

#[cis] to discover QTL in cis via a nominal pass of association
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --nominal 0.01 --region chr22:17000000-18000000 --out nominals.txt
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --nominal 0.01 --region chr22:17000000-18000000 --out nominals_withNormal.txt --normal

mv nominals_withNormal.txt /home/rstudio/Results
mv nominals.txt /home/rstudio/Results

#[cis] to discover QTL in cis via a permutation pass of association

#[cis] to discover multiple QTLs per phenotype in cis using a conditional pass

#[trans] to discover QTL in trans using a full permutation pass

#[trans] to discover QTL in trans using an approximated permutation pass

#[fdensity] to measure functional annotation density around QTLs

#[fenrich] to measure enrichment of QTLs within annotations

#[rtc] to overlap QTLs with GWAS hits






