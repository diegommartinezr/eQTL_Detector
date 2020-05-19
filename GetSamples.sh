#!bin/bash

mkdir transform

#Use bowtie2 to align

#bowtie2-build chr22.fa index

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188040/ERR188040_1.fastq.gz
#mv ERR188040_1.fastq.gz /home/diego/Desktop/Subset_BAM/HG00096.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188231/ERR188231_1.fastq.gz
#mv ERR188231_1.fastq.gz /home/diego/Desktop/Subset_BAM/fastq/HG00097.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188071/ERR188071_2.fastq.gz
#mv ERR188071_2.fastq.gz /home/diego/Desktop/Subset_BAM/HG00114.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188186/ERR188186_1.fastq.gz
#mv ERR188186_1.fastq.gz /home/diego/Desktop/Subset_BAM/HG00115.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188285/ERR188285_1.fastq.gz
#mv ERR188285_1.fastq.gz /home/diego/Desktop/Subset_BAM/HG00122.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188035/ERR188035_2.fastq.gz
#mv ERR188035_2.fastq.gz /home/diego/Desktop/Subset_BAM/HG00123.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188443/ERR188443_1.fastq.gz
#mv ERR188443_1.fastq.gz /home/diego/Desktop/Subset_BAM/HG00130.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204951/ERR204951_2.fastq.gz
#mv ERR204951_2.fastq.gz /home/diego/Desktop/Subset_BAM/HG00131.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204833/ERR204833_2.fastq.gz
#mv ERR204833_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12873.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204976/ERR204976_1.fastq.gz
#mv ERR204976_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12874.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188408/ERR188408_1.fastq.gz
#mv ERR188408_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20810.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188290/ERR188290_1.fastq.gz
#mv ERR188290_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20811.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188137/ERR188137_1.fastq.gz
#mv ERR188137_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20812.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188394/ERR188394_1.fastq.gz
#mv ERR188394_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20813.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188265/ERR188265_2.fastq.gz
#mv ERR188265_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20814.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188475/ERR188475_2.fastq.gz
#mv ERR188475_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20815.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188424/ERR188424_1.fastq.gz
#mv ERR188424_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20819.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188125/ERR188125_2.fastq.gz
#mv ERR188125_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20826.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188406/ERR188406_1.fastq.gz
#mv ERR188406_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20828.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188203/ERR188203_1.fastq.gz
#mv ERR188203_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20542.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188334/ERR188334_1.fastq.gz
#mv ERR188334_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20543.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188252/ERR188252_1.fastq.gz
#mv ERR188252_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20544.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188402/ERR188402_2.fastq.gz
#mv ERR188402_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20581.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188259/ERR188259_1.fastq.gz
#mv ERR188259_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20582.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188199/ERR188199_1.fastq.gz
#mv ERR188199_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20585.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188353/ERR188353_1.fastq.gz
#mv ERR188353_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20586.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188201/ERR188201_2.fastq.gz
#mv ERR188201_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20588.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188343/ERR188343_1.fastq.gz
#mv ERR188343_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA20589.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188054/ERR188054_2.fastq.gz
#mv ERR188054_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA20752.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188388/ERR188388_2.fastq.gz
#mv ERR188388_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12341.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188107/ERR188107_2.fastq.gz
#mv ERR188107_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12342.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188446/ERR188446_1.fastq.gz
#mv ERR188446_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12347.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204964/ERR204964_1.fastq.gz
#mv ERR204964_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12348.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188396/ERR188396_2.fastq.gz
#mv ERR188396_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12383.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204897/ERR204897_1.fastq.gz
#mv ERR204897_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12399.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188220/ERR188220_2.fastq.gz
#mv ERR188220_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12400.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR204/ERR204915/ERR204915_1.fastq.gz
#mv ERR204915_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12413.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188048/ERR188048_1.fastq.gz
#mv ERR188048_1.fastq.gz /home/diego/Desktop/Subset_BAM/NA12489.fastq.gz

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR188/ERR188092/ERR188092_2.fastq.gz
#mv ERR188092_2.fastq.gz /home/diego/Desktop/Subset_BAM/NA12546.fastq.gz


for a in *.fastq.gz;do
bowtie2 -x index -U $a -S $a.sam;
done

#with samtools we create a bam's

for b in *.sam;do
samtools sort -o $b.bam $b;
done

for b in *.bam;do
samtools index $b;
done

for a in *.bam;do
samtools view -h $a chr22 > $a.sam;
done

for c in *.sam;do
samtools view -bS $c > $c.bam;
done



















