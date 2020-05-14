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
#[cis]


cd /hone/rstudio/Bed-Seq


# QTLtools cis \
#  --vcf Genotypes.vcf.gz \
#  --bed RPKM_all.bed.gz \
#  --cov Cov.txt \
#  --nominal 0.01 \
#  --out /home/rstudio/Results/cis_nominal/nominals.txt



# QTLtools cis \
#  --vcf Genotypes.vcf.gz \
#  --bed RPKM_all.bed.gz \
#  --cov Cov.txt \
#  --permute 1000 \
#  --out /home/rstudio/Results/cis_nominal/permutation.txt




### Step1: Run the permutation pass


#for j in $(seq 1 16); do
#  echo "cis --vcf Genotypes.vcf.gz --bed RPKM_all.bed.gz --cov Cov.txt --permute 200 --chunk $j 16 --out permutations_$j\_16.txt";
#done | xargs -P4 -n14 QTLtools


#cat permutations_*.txt | gzip -c > permutations_all.txt.gz
#Rscript ./script/runFDR_cis.R permutations_all.txt.gz 0.05 permutations_all



#QTLtools cis 
#--vcf Genotypes.vcf.gz \
#--bed RPKM_all.bed.gz \
#--cov Cov.txt \
#--mapping permutations_all.thresholds.txt 
#--chunk 12 16 
#--out conditional_12_16.txt


#cat conditional_full.txt | awk '{ if ($19 == 1) print $0}' > conditional_top_variants.txt



####### usgin dummy data from the author

cd /hone/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz
wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz.tbi
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi
wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz


QTLtools cis \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.50percent.chr22.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --permute 1000 \
  --region chr22:17000000-18000000 \
  --out /home/rstudio/Results/cis_nominal/permutation.txt

QTLtools cis \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.50percent.chr22.bed.gz \
  --cov genes.covariates.pc50.txt.gz \
  --nominal 0.0001 \
  --region chr22:17000000-18000000 \
  --out /home/rstudio/Results/cis_nominal/nominals.txt


#####################################################################################################################################
#####################################################################################################################################

#[trans_full]

#mkdir /home/rstudio/Results/trans_full

#cd /hone/rstudio/Bed-Seq

#QTLtools trans \
#  --vcf Genotypes.vcf.gz \
#  --bed RPKM_all.bed.gz \
#  --nominal 0.0001 \
#  --threshold 1e-5 \
#  --out /home/rstudio/Results/trans/full.trans.nominal


#cd /hone/rstudio/Bed-Seq

#QTLtools trans  \
#  --vcf Genotypes.vcf.gz \ 
#  --bed RPKM_all.bed.gz \
#  --sample 1000 \
#  --normal \ 
#  --out full.trans.approx


#QTLtools trans \ 
#  --vcf Genotypes.vcf.gz \ 
#  --bed RPKM_all.bed.gz \ 
#  --adjust  \ .best.txt.gz \ 
#  --normal --threshold 0.1 \ 
#  --out trans.adjust

#Rscript ./script/runFDR_atrans.R trans.adjust.best.txt.gz trans.adjust.hits.txt.gz 0.05 trans.output.txt

#mv trans.output.txt /home/rstudio/Results/trans/trans_approx.output.txt



####### usgin dummy data from the author

cd /hone/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz
wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi


wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.chr22.bed.gz
wget http://jungle.unige.ch/QTLtools_examples/genes.simulated.chr22.bed.gz.tbi


QTLtools trans \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.simulated.chr22.bed.gz \
  --nominal \
  --threshold 1e-5 \
  --out trans.nominal \

QTLtools trans \
  --vcf genotypes.chr22.vcf.gz \
  --bed genes.simulated.chr22.bed.gz \
  --threshold 1e-5 \
  --permute \
  --out trans.perm123 \
  --seed 123





#####################################################################################################################################
#####################################################################################################################################
#####[fdensity]& [fenrich]

cd /home/rstudio/Results/cis_nominal

wget http://jungle.unige.ch/QTLtools_examples/results.genes.full.txt.gz

#move the Rscripts

for f in *.R;do
mv /home/rstudio/Bed-Seq/$f /home/rstudio/Results/cis_nominal/$f;
done

mv /home/rstudio/Bed-Seq/TF.bed.gz /home/rstudio/Results/cis_nominal/TF.bed.gz

#####[fdensity]

#Rscript runFDR_cis.R permutation.txt 0.0001 results.permutation.genes 
#cat results.permutation.genes.significant.txt | awk '{ print $9, $10-1, $11, $8, $1, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > permutation.results.genes.significant.bed 

# QTLtools fdensity \
# --qtl permutation.results.genes.significant.bed \
# --bed TF.bed.gz \
# --out nominal_density.TF.around.QTL.txt

####[fenrich]

#Rscript runFDR_cis.R permutation.txt 0.0001 results.genes
#cat results.genes.significant.txt | awk '{ print $9, $10-1, $11, $8, $1, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > results.genes.significant.bed 
#zcat results.genes.full.txt.gz | awk '{ print $2, $3-1, $4, $1, $8, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > results.genes.quantified.bed 

#QTLtools fenrich \
#  --qtl results.genes.significant.bed \
#  --tss results.genes.quantified.bed \
#  --bed TF.bed.gz \
#  --out enrichement.QTL.in.TF.txt 
 
#Using dummyData

#####[fdensity]
Rscript runFDR_cis.R results.genes.full.txt.gz 0.0001 results.permutation.genes 
cat results.permutation.genes.significant.txt | awk '{ print $9, $10-1, $11, $8, $1, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > permutation.results.genes.significant.bed 

 QTLtools fdensity \
 --qtl permutation.results.genes.significant.bed \
 --bed TF.bed.gz \
 --out nominal_density.TF.around.QTL.txt

####[fenrich]

zcat results.genes.full.txt.gz | awk '{ print $2, $3-1, $4, $1, $8, $5 }' | tr " " "\t" | sort -k1,1 -k2,2n > results.genes.quantified.bed 

QTLtools fenrich \
  --qtl results.genes.significant.bed \
  --tss results.genes.quantified.bed \
  --bed TFs.encode.bed.gz \
  --out enrichement.QTL.in.TF.txt
  


 

#####################################################################################################################################
#####################################################################################################################################
                                                        #################
#####################################################################################################################################
#####################################################################################################################################

#Compile Report

cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.html')"
mv Report.html /home/rstudio/Results/Report.html
