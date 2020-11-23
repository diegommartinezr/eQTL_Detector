# eQTL_Detector

An automated pipeline for eQTL detection and _downstream analysis_

## Before start 

Make sure you have istalled Docker and Docker Compose.

### Install Docker

```
sudo apt install docker .io
```
### Install Docker-Compose

Firt download Docker-Compose

```
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

```
Give chmod to the application

```
sudo chmod +x /usr/local/bin/docker-compose
```
Finally check the version
```
docker-compose --version
```
If everything is fine you should see something like this:
```
docker-compose version 1.21.2, build a133471
```
### Download this repository

```
wget https://github.com/diegommartinezr/eQTL_Detector/archive/master.zip
```

### In case you have the usermode issue you need to use

```
sudo usermode -aG docker ${USER}
```
And then

```
su - ${USER}

```
This last step is going to ask you for your su passwoed

## Preparing your Data

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
