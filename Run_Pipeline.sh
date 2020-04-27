docker-compose up -d
VAR1=docker ps | awk '{print $11}' | awk 'NR==2'
echo $VAR1
docker exec $VAR1 /bin/sh /home/rstudio/QTLtools.sh
firefox localhost:8787/
