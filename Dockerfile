FROM rocker/rstudio

RUN cd home/rstudio

#QTLtools stuff
COPY QTLtools.sh /home/rstudio/QTLtools.sh
#Now we have to make it executalbe
#RUN chmod u+x /home/rstudio/QTLtools.sh
#Executing script to install QTLtools
RUN ["/home/rstudio/QTLtools.sh"]

#Execute R-package installation and runing a script
COPY install_packages.R /home/rstudio/install_packages.R
COPY script.R /home/rstudio/script.R
COPY Testing.Rproj /home/rstudio/Testing.Rproj

