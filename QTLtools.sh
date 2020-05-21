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

for b in *.bam;do 
QTLtools bamstat \
  --bam $b \
  --bed gencode.v19.exon.chr22.bed.gz \
  --filter-mapping-quality 15 \
  --out /home/rstudio/Results/bamstat/$b.txt;
done


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

cat RPKM_all.bed | mawk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k2,2n --parallel=6"}' > RPKM_all_sorted.bed

bgzip RPKM_all_sorted.bed

tabix -p bed RPKM_all_sorted.bed.gz  


####
####

#####################################################################################################################################
#####################################################################################################################################
#[pca]
cd /home/rstudio/Bed-Seq

QTLtools pca \
  --bed RPKM_all_sorted.bed.gz \
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
###############  cis eQTL  ##################

#############################################
#[cis] nominal

cd /hone/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz
wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz.tbi
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi
wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz


# QTLtools cis \
#  --vcf Genotypes.vcf.gz \
#  --bed RPKM_all_sorted.bed.gz \
#  --cov Cov.txt \
#  --nominal 0.01 \
#  --out /home/rstudio/Results/cis_nominal/nominals.txt

QTLtools cis \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.50percent.chr22.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --nominal 0.00000001 \
  --out /home/rstudio/Results/cis_nominal/nominals.txt

#############################################
#[cis] permutation

cd /home/rstudio/Results
mkdir cis_permutation
cd /hone/rstudio/Bed-Seq

# QTLtools cis \
#  --vcf Genotypes.vcf.gz \
#  --bed RPKM_all_sorted.bed.gz \
#  --cov Cov.txt \
#  --permute 1000 \
#  --out /home/rstudio/Results/cis_permutation/permutation.txt

#using Expression pca

#QTLtools cis \
#--vcf Genotypes.vcf.gz \ 
#--bed RPKM_all_sorted.bed.gz \ 
#--cov Cov.txt \
#--permute 1000 \ 
#--grp-/home/rstudio/Results/pca/pca.Exp.txt \ 
#--out /home/rstudio/Results/cis_permutation/permutations.group.txt 


QTLtools cis \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.50percent.chr22.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --permute 1000 \
  --out /home/rstudio/Results/cis_permutation/permutation.txt


#####################################################################################################################################
#####################################################################################################################################
###############  trans eQTL  ##################

#############################################
#[cis] permutation

cd /hone/rstudio/Results
mkdir trans
cd /hone/rstudio/Bed-Seq


#1 Run a nominal pass

#QTLtools trans \ 
#--vcf Genotypes.vcf.gz \
#--bed genes.simulated.chr22.bed.gz \
#--nominal \
#--threshold 1e-5 \
#--out /hone/rstudio/Results/trans/trans.nominal 

#2 Run a permutation pass

#QTLtools trans \
#--vcf Genotypes.vcf.gz \
#--bed genes.simulated.chr22.bed.gz \
#--threshold 1e-5 \
#--permute \
#-out /hone/rstudio/Results/trans/trans.nominal \
#--seed 123 

### Usging dumy data
#1 Run a nominal pass


wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.chr22.bed.gz
wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.chr22.bed.gz.tbi
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi


QTLtools trans \
--vcf genotypes.chr22.vcf.gz \
--bed genes.simulated.chr22.bed.gz \
--nominal \
--threshold 1e-5 \
--out trans.nominal


#2 Run a permutation pass

QTLtools trans \
--vcf genotypes.chr22.vcf.gz \
--bed genes.simulated.chr22.bed.gz \
--threshold 1e-5 \
--permute \
--out trans.permutation \
--seed 123 

for v in *.txt.gz;do
mv $v /hone/rstudio/Results/trans/$v;
done

##################################################################################################################################### 
#####################################################################################################################################
                                                        #################
#####################################################################################################################################
#####################################################################################################################################

#Compile Report

cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.html')"
mv Report.html /home/rstudio/Results/Report.html
