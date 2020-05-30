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


#1 Run a nominal pass

#QTLtools trans \ 
#--vcf Genotypes.vcf.gz \
#--bed genes.simulated.chr22.bed.gz \
#--nominal \
#--threshold 1e-5 \
#--out /home/rstudio/Results/trans/trans.nominal 

#2 Run a permutation pass

#QTLtools trans \
#--vcf Genotypes.vcf.gz \
#--bed genes.simulated.chr22.bed.gz \
#--threshold 1e-5 \
#--permute \
#-out /home/rstudio/Results/trans/trans.nominal \
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
--out /home/rstudio/Results/trans/trans.nominal


#2 Run a permutation pass

QTLtools trans \
--vcf genotypes.chr22.vcf.gz \
--bed genes.simulated.chr22.bed.gz \
--threshold 1e-5 \
--permute \
--out /home/rstudio/Results/trans/trans.permutation \
--seed 123 


#####################################################################################################################################
#####################################################################################################################################
###############  fdensiy  ##################
cd /home/rstudio/Bed-Seq

#Rscript unFDR_cis.R /home/rstudio/Results/cis_permutation/permutation.txt 0.05 /home/rstudio/Results/fdensity/results.genes 
#cat results.genes.significant.txt | awk '{ print $9, $10-1, $11, $8, $1, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > /home/rstudio/Results/fdensity/results.genes.significant.bed

#QTLtools fdensity \
#	--qtl /home/rstudio/Results/fdensity/results.genes.significant.bed \
#	--bed TF.bed.gz \
#	--out /home/rstudio/Results/fdensity/density.TF.around.QTL.txt

#Using dummy Data
cd /home/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/results.genes.full.txt.gz
wget http://jungle.unige.ch/QTLtools_examples/TFs.encode.bed.gz


Rscript runFDR_cis.R results.genes.full.txt.gz 0.05 results.genes 
cat results.genes.significant.txt | awk '{ print $9, $10-1, $11, $8, $1, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > /home/rstudio/Results/fdensity/results.genes.significant.bed 

QTLtools fdensity \
	--qtl /home/rstudio/Results/fdensity/results.genes.significant.bed \
	--bed TFs.encode.bed.gz \
	--out /home/rstudio/Results/fdensity/density.TF.around.QTL.txt 


#####################################################################################################################################
#####################################################################################################################################
###############  fenrich  ##################

#zcat /home/rstudio/Results/cis_permutation/permutation.txt | awk '{ print $2, $3-1, $4, $1, $8, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > /home/rstudio/Results/fenrichresults.genes.quantified.bed 
#QTLtools fenrich \
#	--qtl /home/rstudio/Results/fdensity/results.genes.significant.bed \
#	--tss /home/rstudio/Results/fenrichresults.genes.quantified.bed \
#	--bed TF.bed.gz \
#	--out /home/rstudio/Results/fenrich/enrichement.QTL.in.TF.txt 


#Using dummy Data
zcat results.genes.full.txt.gz | awk '{ print $2, $3-1, $4, $1, $8, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > /home/rstudio/Results/fenrich/results.genes.quantified.bed 

QTLtools fenrich \
	--qtl /home/rstudio/Results/fdensity/results.genes.significant.bed \
	--tss /home/rstudio/Results/fenrich/results.genes.quantified.bed \
	--bed TF.bed.gz \
	--out /home/rstudio/Results/fenrich/enrichement.QTL.in.TF.txt 



#####################################################################################################################################
#####################################################################################################################################
###############  rtc  ##################

cd /home/rstudio/Bed-Seq

#Step1: Run the permutation pass
#for j in $(seq 1 16); do
#  echo "cis --vcf Genotypes.vcf.gz --bed RPKM_all_sorted.bed.gz --cov Cov.txt --permute 200 --chunk $j 16 --out /home/rstudio/Results/cis_permutation/$j\_16.txt";
#done | xargs -P4 -n14 QTLtools


#Using dummy Data

#Step1: Run the permutation pass
for j in $(seq 1 16); do
  echo "cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --permute 200 --chunk $j 16 --out /home/rstudio/Results/cis_permutation/permutations_$j\_16.txt";
done | xargs -P4 -n14 QTLtools

cat /home/rstudio/Results/cis_permutation/permutations_*.txt | gzip -c > permutations_all.txt.gz
Rscript runFDR_cis.R permutations_all.txt.gz 0.05 permutations_all 

#Getting dummy data required for rtc analysis

wget http://jungle.unige.ch/QTLtools_examples/hotspots_b37_hg19.bed
wget http://jungle.unige.ch/QTLtools_examples/GWAS.b37.txt

QTLtools rtc \
	--vcf genotypes.chr22.vcf.gz \
	--bed genes.50percent.chr22.bed.gz \
	--cov genes.covariates.pc50.txt.gz \
	--hotspot hotspots_b37_hg19.bed \
	--gwas-cis GWAS.b37.txt permutations_all.significant.txt \
	--normal \
	--out /home/rstudio/Results/rtc/rtc_results.txt
	
##################################################################################################################################### 
#####################################################################################################################################
                                                        #################
#####################################################################################################################################
#####################################################################################################################################

#Compile Report

cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.html')"
mv Report.html /home/rstudio/Results/Report.html
