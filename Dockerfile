FROM rocker/rstudio

RUN mkdir /home/rstudio/Results
RUN mkdir /home/rstudio/Results/bamstat
RUN mkdir /home/rstudio/Results/mbv
RUN mkdir /home/rstudio/Results/quan

#Install R Packages
RUN Rscript -e "install.packages('glue')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('XML')"
RUN Rscript -e "install.packages('rlist')"
RUN Rscript -e "install.packages('readr')"

#Install QTLtools
RUN apt-get update && apt-get install -y qtltools
RUN apt-get update && apt-get install -y wget

RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 && \
    tar -xf htslib-1.9.tar.bz2 && rm htslib-1.9.tar.bz2 && cd htslib-1.9 && make && make install && make clean


RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -xf samtools-1.9.tar.bz2 && rm samtools-1.9.tar.bz2 && cd samtools-1.9 && \
    ./configure --with-htslib=/opt/htslib-1.9 && make && make install && make clean

RUN apt-get update && apt-get install -y tabix
RUN apt-get update && apt-get install -y bcftools

#RUN apt-get update && apt-get install -y texlive-full 

#Copy QTLtools.sh

COPY QTLtools.sh /home/rstudio/QTLtools.sh
RUN chmod u+x /home/rstudio/QTLtools.sh

#Execute R-package installation and run R script

COPY install_packages.R /home/rstudio/install_packages.R
COPY eQTL_Detector_Report.Rmd /home/rstudio/eQTL_Detector_Report.Rmd
COPY quan.R /home/rstudio/quan.R
