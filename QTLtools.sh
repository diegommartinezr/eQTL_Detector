# running some analysis with the published QTLtools dummy data

#[bamstat] to control the quality of the sequence data
cd /home/rstudio/Bed-Seq

for j in *.bam;do
samtools index $j /home/rstudio/Bed-Seq/$j.bai;
done

for k in *.bam;do
QTLtools bamstat --bam $k --bed /home/rstudio/Data/gencode.v19.exon.chr22.bed.gz --filter-mapping-quality 150 --out /home/rstudio/Data/$k.txt;
done

#[match] to ensure good matching between sequence and genotype data

mkdir /home/rstudio/Results/mbv

##I'm goingfg to download the data for a momment to see how to get the index with vcf tools or somethig like.

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi

for k in *.bam;do
QTLtools mbv --bam $k --vcf genotypes.chr22.vcf.gz --filter-mapping-quality 150 --out mbv_$k.txt
done

for k in mbv_*;do
mv $k /home/rstudio/Results/mbv
done

#[quan] to quantify gene expression

mkdir /home/rstudio/Results/quan
wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz

for k in *.bam;do
QTLtools quan --bam $k --gtf gencode.v19.annotation.chr22.gtf.gz --sample "${k%.chr22.bam}" --out-prefix $k --filter-mapping-quality 150 --filter-mismatch 5 --filter-mismatch-total 5 --rpkm 
done


for r in *.bed;do
mv $r /home/rstudio/Results/quan
done


for r in *.stats;do
mv $r /home/rstudio/Results/quan
done

## Noew we need to create a unique file with all samples togeter with their quan values

#[pca] to perform PCA on phenotype and genotype data
QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out out_pca




#[cis] to discover QTL in cis via a nominal pass of association
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --nominal 0.01 --region chr22:17000000-18000000 --out out_cis_nominal.txt
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --nominal 0.01 --region chr22:17000000-18000000 --out out_cis_nominal_N.txt --normal

#[cis] to discover QTL in cis via a permutation pass of association
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --permute 1000 --region chr22:17000000-18000000 --out out_cis_permutations.txt
QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --permute 1000 --region chr22:17000000-18000000 --out out_cis_permutations_N.txt --normal --window 2000000

#[cis] to discover multiple QTLs per phenotype in cis using a conditional pass

#[trans] to discover QTL in trans using a full permutation pass
QTLtools trans --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --nominal --threshold 1e-5 --out out_trans.nominal 

#[trans] to discover QTL in trans using an approximated permutation pass
QTLtools trans --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --sample 1000 --normal --out out_trans.sample 
##Check como obtener dicho script

#[fdensity] to measure functional annotation density around QTLs



#[fenrich] to measure enrichment of QTLs within annotations

#[rtc] to overlap QTLs with GWAS hits



## Move all outputs to Results

#[bamstat]
mkdir /home/rstudio/Results/bamstat
cd /home/rstudio/Data
for h in *.bam.txt;do
mv $h /home/rstudio/Results/bamstat;
done



#[match]
mv out_match.txt /home/rstudio/Results
#[quan]
#mv out_quan.exon.count.bed /home/rstudio/Results
#mv out_quan.exon.rpkm.bed /home/rstudio/Results
#mv out_quan.gene.count.bed /home/rstudio/Results
#mv out_quan.gene.rpkm.bed /home/rstudio/Results
#mv out_quan.stats /home/rstudio/Results
##[pca]
#mv out_pca.pca /home/rstudio/Results
#mv out_pca.pca_stats /home/rstudio/Results
##[cis] Nominal
#mv out_cis_nominal.txt /home/rstudio/Results
#mv out_cis_nominal_N.txt /home/rstudio/Results
##[cis] Nominal permuation
#mv out_cis_permutations.txt /home/rstudio/Results
#mv out_cis_permutations_N.txt /home/rstudio/Results
##[cis] conditional pass

#[trans] conditional pass
#mv out_trans.nominal.best.txt.gz /home/rstudio/Results
#mv out_trans.nominal.bins.txt.gz /home/rstudio/Results
#mv out_trans.nominal.hits.txt.gz /home/rstudio/Results
##[trans] permutation pass
#mv out_trans.sample.best.txt.gz /home/rstudio/Results
#mv out_trans.sample.bins.txt.gz /home/rstudio/Results
#mv out_trans.sample.hits.txt.gz /home/rstudio/Results

#Compile Report
cd /home/rstudio
mkdir /home/rstudio/Results/Report
R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.pdf')"
mv Report.pdf /home/rstudio/Results/Report
