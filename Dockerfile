FROM rocker/rstudio
#QTLtools stuff
COPY QTLtools.sh /QTLtools.sh
#Executing script
RUN ["/QTLtools.sh"]
#Execute R-package installation
COPY install_packages.R /install_packages.R
COPY script.R /script.R
RUN Rscript install_packages.R
RUN Rscript script.R
