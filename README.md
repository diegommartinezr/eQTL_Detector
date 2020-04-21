# eQTL_Detector

An automated pipeline for eQTL detection and _downstream analysis_

## Before start 

Make sure you have istalled Docker and Docker Compose.

### Install Docker

```
sudo apt install docker .io
```
### Download this repo

´´´
wget https://github.com/diegommartinezr/eQTL_Detector/archive/master.zip
´´´

## Data

This pipeline use three different data:

  * Genotyping data in .VCF format
  * RNA-Seq data in .BAM format
  * A covariance matrix in .txt format

Appart from the source data the reference data to use will be:

  * Annotations in .BED format
  * A .GTF file containing the gencode annotation

Put all these files on the Bed-Seq folder and you will be ready to go

## Running the pipeline

After you have all the data on the Bed-Seq folder to run the pipeline just run the follow command:

```
bash Run_Pipeline.sh
```
