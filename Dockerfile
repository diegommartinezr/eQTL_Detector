FROM rocker/rstudio

#Install QTLtools

RUN apt-get update && apt-get install -y qtltools

#Copy

COPY QTLtools.sh /home/rstudio/QTLtools.sh
RUN chmod u+x /home/rstudio/QTLtools.sh

#Execute R-package installation and runing a script

COPY install_packages.R /home/rstudio/install_packages.R
COPY script.R /home/rstudio/script.R
COPY Testing.Rproj /home/rstudio/Testing.Rproj

#Run packages intallation
#RUN chmod u+x /home/rstudio/install_packages.R
#RUN ["/home/rstudio/install_packages.R"]
