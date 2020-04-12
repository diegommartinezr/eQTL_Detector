FROM rocker/rstudio

#Install QTLtools

RUN apt-get update && apt-get install -y qtltools
RUN apt-get update && apt-get install -y wget

RUN cd /opt && \
    wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -xf samtools-1.9.tar.bz2 && rm samtools-1.9.tar.bz2 && cd samtools-1.9 && \
    ./configure --with-htslib=/opt/htslib-1.9 && make && make install && make clean

RUN apt-get update && apt-get install -y tabix
RUN apt-get update && apt-get install -y bcftools

RUN apt-get update \
    && apt-get install -y \
    texlive-full \
    && echo "\nmain_memory = 12000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && echo "\nextra_mem_bot = 12000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && echo "\nfont_mem_size = 12000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && echo "\npool_size = 12000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && echo "\nbuf_size = 12000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && update-texmf \
    && texhash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#Otional aplications

RUN cd /opt && \
    wget https://github.com/francois-a/fastqtl/archive/59bcdc06c4277b2cf2e06f242eb89f7e1fd4cacd.tar.gz && \
    tar -xf 59bcdc06c4277b2cf2e06f242eb89f7e1fd4cacd.tar.gz && rm 59bcdc06c4277b2cf2e06f242eb89f7e1fd4cacd.tar.gz && \
    mv fastqtl-59bcdc06c4277b2cf2e06f242eb89f7e1fd4cacd fastqtl && \
    cd fastqtl && mkdir obj && sed -i 's/RMATH=/#RMATH/' Makefile && make
ENV PATH /opt/fastqtl/bin:$PATH

# PLINK
RUN mkdir /opt/plink && cd /opt/plink && \
    wget http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20200107.zip && \
    unzip plink_linux_x86_64_20200107.zip && rm plink_linux_x86_64_20200107.zip
ENV PATH $PATH:/opt/plink


#Copy QTLtools.sh

COPY QTLtools.sh /home/rstudio/QTLtools.sh
RUN chmod u+x /home/rstudio/QTLtools.sh

#Execute R-package installation and run R script

COPY install_packages.R /home/rstudio/install_packages.R
COPY eQTL_Detector_Report.Rmd /home/rstudio/eQTL_Detector_Report.Rmd

#Run packages intallation
#RUN Rscript /home/rstudio/install_packages.R


