mkdir /Results
mkdir /Results/bamstat
mkdir /Results/mbv
mkdir /Results/quan

docker-compose up -d
docker exec eqtl_detector-master_server_1 /bin/sh /home/rstudio/QTLtools.sh
