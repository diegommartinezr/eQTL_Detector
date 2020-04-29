# running some analysis with the published QTLtools dummy data

#[bamstat] to control the quality of the sequence data

cd /home/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.exon.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz

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

for d in *.bam;do
QTLtools quan \
  --bam $d \
  --gtf gencode.v19.annotation.chr22.gtf.gz \
  --sample "${d%.chr22.bam}" \
  --out-prefix $d \
  --filter-mapping-quality 150 \
  --filter-mismatch 5 \
  --filter-mismatch-total 5 \
  --rpkm;
done


for f in *gene.rpkm.bed;do
mv $f /home/rstudio/Results/quan/$f
done

for g in *exon.rpkm.bed;do
mv $g /home/rstudio/Results/quan/$g
done

for h in *gene.count.bed;do
mv $h /home/rstudio/Results/quan/$h
done

for i in *exon.count.bed;do
mv $i /home/rstudio/Results/quan/$i
done


cd /home/rstudio/Results/quan


FIRST=$(ls *.gene.rpkm.bed| head -1)

cut -f 1-6 $FIRST >RPKM.bed

paste *.bed| awk '{i=7;while($i){printf("%s ",$i);i+=7}printf("\n")}' >> RPKM_values.bed

paste RPKM.bed RPKM_values.bed > RPKM_all.bed

bgzip RPKM_all.bed  && tabix -p bed RPKM_all.bed.gz 

mv RPKM_all.bed.gz /home/rstudio/Bed-Seq/RPKM_all.bed.gz

cd /home/rstudio/Bed-Seq

#####################################################################################################################################
#####################################################################################################################################


#[pca]

QTLtools pca \
  --bed RPKM_all.bed.gz \
  --scale \
  --center \
  --out /home/rstudio/Results/pca/RPKM.bed


QTLtools pca 
  --vcf GENOTYPES.vcf.gz \
  --scale \
  --center \
  --maf 0.05 \
  --distance 50000 \
  --out genotypes_pca 


#[cis_nominal]

cd /home/rstudio/Bed-Seq



QTLtools cis \
  --vcf genotypes.chr22.vcf.gz \
  --bed RPKM_all.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --nominal 0.01 \
  --region chr22:17000000-18000000 \
  --out nominals.txt



#Compile Report
cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.pdf')"
mv Report.pdf /home/rstudio/Results/Report

