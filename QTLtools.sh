######################################################################################################################################
######################################################################################################################################

#[bamstat] to control the quality of the sequence data

cd /home/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.exon.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz


#indexing .bed and VCF

for a in *.bam;do
samtools index $a /home/rstudio/Bed-Seq/$a.bai;
done

bgzip -c Genotypes.vcf > Genotypes.vcf.gz
tabix -p vcf Genotypes.vcf.gz


######################################################################################################################################
######################################################################################################################################

#[bamstat] to control the quality of the sequence data

#for b in *.bam;do 
#QTLtools bamstat \
#  --bam $b \
#  --bed gencode.v19.exon.chr22.bed.gz \
#  --filter-mapping-quality 15 \
#  --out /home/rstudio/Results/bamstat/$b.txt;
#done


######################################################################################################################################
######################################################################################################################################
#[match] to ensure good matching between sequence and genotype data

cd /home/rstudio/Bed-Seq

for c in *.bam; do
QTLtools mbv \
--bam $c \
--vcf Genotypes.vcf.gz \
--filter-mapping-quality 1 \
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
  --sample "${z%.bam}" \
  --out-prefix $z \
  --filter-mapping-quality 1 \
  --filter-mismatch 1 \
  --filter-mismatch-total 1 \
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

cd /home/rstudio/Results/quan

###

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

###

FIRST=$(ls *.gene.rpkm.bed| head -1)

cut -f 1-6 $FIRST >RPKM.txt

for u in in *.gene.rpkm.bed;do
cut -f 7 $u > $u.values.txt;
done

paste RPKM.txt *values.txt > RPKM_all.bed

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


cd /hone/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz

 QTLtools cis \
  --vcf Genotypes.vcf.gz \
  --bed RPKM_all.bed.gz \
  --cov Cov.txt \
  --nominal 0.01 \
  --out nominals.txt
  
#####################################################################################################################################
#####################################################################################################################################
#[trans_full]

mkdir /home/rstudio/Results/trans_full

cd /hone/rstudio/Bed-Seq

QTLtools trans \
  --vcf Genotypes.vcf.gz \
  --bed RPKM_all.bed.gz \
  --nominal \
  --threshold 1e-5 \
  --out full.trans.nominal 

#####################################################################################################################################
#####################################################################################################################################
                                                        #################
#####################################################################################################################################
#####################################################################################################################################

#Compile Report

cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.html')"
mv Report.html /home/rstudio/Results/Report.html
