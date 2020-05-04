sudo apt install docker .io
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


docker build .
docker-compose up -d
VAR1=`docker ps | awk '{print $1}' | awk 'NR==2'`
docker exec -it $VAR1 /bin/sh /home/rstudio/QTLtools.sh
firefox localhost:8787/
