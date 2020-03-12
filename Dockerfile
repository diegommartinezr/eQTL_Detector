FROM r-base

## Rstuff

COPY install_packages.R /install_packages.R


#QTLtools stuff

COPY QTLtools.sh /QTLtools.sh

#Executing script

RUN ["/QTLtools.sh"]


