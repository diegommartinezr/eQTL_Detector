#!/bin/bash

# Install QTLtools

apt-get update && apt-get install -y qtltools

# running some analysis with the published dummy data

## bamstat

wget http://jungle.unige.ch/QTLtools_examples/HG00381.chr22.bam

wget http://jungle.unige.ch/QTLtools_examples/HG00381.chr22.bam.bai

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.exon.chr22.bed.gz

QTLtools bamstat --bam HG00381.chr22.bam --bed gencode.v19.exon.chr22.bed.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt

##  Sequence to genotype matching

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi

QTLtools mbv --bam HG00381.chr22.bam --vcf genotypes.chr22.vcf.gz --filter-mapping-quality 150 --out HG00381.chr22.bamstat.txt

## Gene expresion quentification

wget http://jungle.unige.ch/QTLtools_examples/gencode.v19.annotation.chr22.gtf.gz

QTLtools quan --bam HG00381.chr22.bam --gtf gencode.v19.annotation.chr22.gtf.gz --sample HG00381 --out-prefix HG00381 --filter-mapping-quality 150 --filter-mismatch 5 --filter-mismatch-total 5 --rpkm

## PCA Analysis 

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz

wget http://jungle.unige.ch/QTLtools_examples/genes.50percent.chr22.bed.gz.tbi

QTLtools pca --bed genes.50percent.chr22.bed.gz --scale --center --out genes.50percent.chr22

## Discover _cis_  eQTL

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz

wget http://jungle.unige.ch/QTLtools_examples/genotypes.chr22.vcf.gz.tbi

wget http://jungle.unige.ch/QTLtools_examples/genes.covariates.pc50.txt.gz

QTLtools cis --vcf genotypes.chr22.vcf.gz --bed genes.50percent.chr22.bed.gz --cov genes.covariates.pc50.txt.gz --nominal 0.01 --region chr22:17000000-18000000 --out nominals.txt 

