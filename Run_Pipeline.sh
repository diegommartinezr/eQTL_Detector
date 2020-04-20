docker pull martindi/eqtldetector
docker-compose up -d
docker exec eqtl_detector-master_server /bin/sh /home/rstudio/QTLtools.sh
