# running some analysis with the published QTLtools dummy data

#[bamstat] to control the quality of the sequence data
cd /home/rstudio/Bed-Seq
mkdir /home/rstudio/Results/bamstat

#Download the test ref
wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.exon.chr22.bed.gz

for j in *.bam;do
samtools index $j /home/rstudio/Bed-Seq/$j.bai;
done

for k in *.bam;do
QTLtools bamstat --bam $k --bed gencode.v19.exon.chr22.bed.gz --filter-mapping-quality 150 --out $k.txt;
done

for k in *.txt;do
mv $k /home/rstudio/Results/bamstat
done


#[match] to ensure good matching between sequence and genotype data


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

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz

for k in *.bam;do
QTLtools quan --bam $k --gtf gencode.v19.annotation.chr22.gtf.gz --sample "${k%.chr22.bam}" --out-prefix $k --filter-mapping-quality 150 --filter-mismatch 5 --filter-mismatch-total 5 --rpkm 
done

for r in *gene.rpkm.bed;do
mv $r /home/rstudio/Results/quan
done

for r in *.bed;do
mv $r /home/rstudio/Results/quan/stats
done

for r in *.stats;do
mv $r /home/rstudio/Results/quan/stats
done

cd /home/rstudio/Results/quan


FIRST=$(ls *rpkm.bed| head -1)

cut -f 1-6 $FIRST >RPKM.bed

paste *.bed| awk '{i=7;while($i){printf("%s ",$i);i+=7}printf("\n")}' >> RPKM_values.bed

paste RPKM.bed RPKM_values.bed > RPKM_all.bed

bgzip RPKM_all.bed  && tabix -p bed RPKM_all.bed.gz 

#[pca]

QTLtools pca --bed RPKM_all.bed.gz --scale --center --out /home/rstudio/Results/pca/RPKM.bed

QTLtools pca --vcf GENOTYPES.vcf.gz --scale --center --maf 0.05 --distance 50000 --out genotypes_pca 

#[cis_nominal]
## Firts we get the data

# Get the files for the cis analysiis
cd /home/rstudio/Bed-Seq


# Get the files for the cis analysiis
cd /home/rstudio/Bed-Seq

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz.tbi

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz

# Rename them

mv genes.50percent.chr22.bed.gz /home/rstudio/Results/cis_nominal/RPKM_all.bed.gz

mv genes.50percent.chr22.bed.gz.tbi /home/rstudio/Results/cis_nominal/RPKM_all.bed.gz.tbi

mv genotypes.chr22.vcf.gz /home/rstudio/Results/cis_nominal/GENOTYPES.vcf.gz

mv genes.covariates.pc50.txt.gz /home/rstudio/Results/cis_nominal/COV.txt.gz

cd /home/rstudio/Results/cis_nominal


#Tabinx indexing VCF file

tabix -p gff GENOTYPES.vcf.gz

#bcftools view GENOTYPES.vcf.gz  | less -S 

QTLtools cis \
  --vcf /home/rstudio/Bed-Seq/GENOTYPES.vcf.gz \
  --bed /home/rstudio/Results/quan/RPKM_all.bed.gz \
  --cov /home/rstudio/Bed-Seq/COV.txt.gz \
  --nominal 0.01 \
  --region chr22:17000000-18000000 \
  --out nominals.txt


#Compile Report
cd /home/rstudio

R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.pdf')"
mv Report.pdf /home/rstudio/Results/Report

