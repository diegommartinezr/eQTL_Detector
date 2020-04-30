# running some analysis with the published QTLtools dummy data

#[bamstat] to control the quality of the sequence data

cd /home/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz.tbi

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.exon.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.bed.gz.tbi


#Indexing.vcf.gz

mv genotypes.chr22.vcf.gz /home/rstudio/Bed-Seq/Genotypes.vcf.gz

tabix -p gff Genotypes.vcf.gz


#indexing .bed

for a in *.bam;do
samtools index $a /home/rstudio/Bed-Seq/$a.bai;
done

######################################################################################################################################
######################################################################################################################################

#[bamstat] to control the quality of the sequence data

for b in *.bam;do 
QTLtools bamstat \
  --bam $b \
  --bed gencode.v19.exon.chr22.bed.gz \
  --filter-mapping-quality 150 \
  --out /home/rstudio/Results/bamstat/$b.txt;
done

######################################################################################################################################
######################################################################################################################################
#[match] to ensure good matching between sequence and genotype data

for c in *.bam; do
QTLtools mbv \
--bam $c \
--vcf Genotypes.vcf.gz \
--filter-mapping-quality 150 \
--out /home/rstudio/Results/mbv/$c.txt;
done

#####################################################################################################################################
#####################################################################################################################################
#[quan] to quantify gene expression

cd /home/rstudio/Bed-Seq

for z in *.bam;do
QTLtools quan \
  --bam $z \
  --gtf gencode.v19.annotation.chr22.gtf.gz \
  --sample "${z%.chr22.bam}" \
  --out-prefix /home/rstudio/Results/quan/$z \
  --filter-mapping-quality 150 \
  --filter-mismatch 5 \
  --filter-mismatch-total 5 \
  --rpkm;
done


for t in *count.bed;do
mv $t /home/rstudio/Results/quan/$t
done

for p in *rpkm.bed;do
mv $p /home/rstudio/Results/quan/$p
done

####
####

####
####

cd /home/rstudio/Results/quan

FIRST=$(ls *.gene.rpkm.bed| head -1)

cut -f 1-6 $FIRST >RPKM.bed


mkdir stat

for d in *.exon.rpkm.bed;do
mv $d /home/rstudio/Results/quan/stat/$d
done

for d in *.exon.count.bed;do
mv $d /home/rstudio/Results/quan/stat/$d
done

for d in *.gene.count.bed;do
mv $d /home/rstudio/Results/quan/stat/$d
done

paste *.bed| awk '{i=7;while($i){printf("%s ",$i);i+=7}printf("\n")}' >> RPKM_values.bed

paste RPKM.bed RPKM_values.bed > RPKM_all.bed

mv RPKM_all.bed /home/rstudio/Bed-Seq/RPKM_all.bed

cd /home/rstudio/Bed-Seq

bgzip RPKM_all.bed && tabix -p bed RPKM_all.bed.gz 


####
####

#####################################################################################################################################
#####################################################################################################################################
#[pca]

QTLtools pca \
  --bed RPKM_all.bed.gz \
  --scale \
  --center \
  --out /home/rstudio/Results/pca/pca.Exp.txt

QTLtools pca \
  --vcf Genotypes.vcf.gz \
  --scale --center \
  --maf 0.05 \
  --distance 50000 \
  --out /home/rstudio/Results/pca/Genotypes_pca.txt


#####################################################################################################################################
#####################################################################################################################################
#[cis_nominal]

QTLtools cis \
  --vcf Genotypes.vcf.gz \
  --bed genes.50percent.chr22.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --nominal 0.01 \
  --region chr22:17000000-18000000 \
  --out /home/rstudio/Results/cis_nominal/nominals.txt

#####################################################################################################################################
#####################################################################################################################################
#[trans_full]

mkdir /home/rstudio/Results/trans_full

QTLtools trans \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.simulated.chr22.bed.gz \
  --nominal --threshold 1e-5 \
  --out /home/rstudio/Results/trans_full.trans.nominal 

#####################################################################################################################################
#####################################################################################################################################
#[trans_full]

#Compile Report

cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.pdf')"
mv Report.pdf /home/rstudio/Results/Report

