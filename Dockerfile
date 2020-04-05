FROM rocker/rstudio

RUN cd home/rstudio

#QTLtools stuff
COPY QTLtools.sh /home/rstudio/QTLtools.sh

#Now we have to make it executalbe
#RUN chmod u+x /home/rstudio/QTLtools.sh

COPY QTLtools.sh /home/rstudio/Install_Depend.sh
RUN chmod u+x /home/rstudio/Install_Depend.sh

#Executing script to install Depend

RUN ["/home/rstudio/Install_Depend.sh"]

#Execute R-package installation and runing a script

COPY install_packages.R /home/rstudio/install_packages.R
COPY script.R /home/rstudio/script.R
COPY Testing.Rproj /home/rstudio/Testing.Rproj

#Run packages intallation
#RUN chmod u+x /home/rstudio/install_packages.R
#RUN ["/home/rstudio/install_packages.R"]
