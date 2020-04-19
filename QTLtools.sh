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
mkdir /home/rstudio/Results/quan/stats
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

cd /home/rstudio

Rscript quan.R




#Compile Report
cd /home/rstudio
mkdir /home/rstudio/Results/Report
R -e "rmarkdown::render('eQTL_Detector_Report.Rmd',output_file='Report.pdf')"
mv Report.pdf /home/rstudio/Results/Report
