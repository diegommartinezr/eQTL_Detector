# eQTL_Detector

An automated pipeline for eQTL detection and _downstream analysis_

## Before start 

Make sure you have istalled:

  * Docker
  
To intall Docker



  * Docker Comopose

To install Docker compose

Download Docker Compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Give execuable permission to the bin file

```
sudo chmod +x /usr/local/bin/docker-compose
```
To verify the isntallation is ok, check the Docker Compose version using:

```
docker-compose --version
```

  
  * Dowloand this repository

## Using the pipeline

This repository contain a Data folder where you will put you data, so all scripts can take the initial data from there.
