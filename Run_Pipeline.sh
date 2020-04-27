VAR1=`docker ps | awk '{print $1}' | awk 'NR==2'`
echo $VAR1
docker exec -it $VAR1 /bin/sh /home/rstudio/QTLtools.sh
firefox localhost:8787/
