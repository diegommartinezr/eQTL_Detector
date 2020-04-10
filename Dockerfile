FROM rocker/rstudio

#Install QTLtools

RUN apt-get update && apt-get install -y qtltools
RUN apt-get update && apt-get install -y wget
#Install Samtools

WORKDIR /tmp

### Install required packages (samtools)

RUN apt-get clean all &&\
    apt-get update &&\
    apt-get install -y  \
        libncurses5-dev && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

### Installing samtools/htslib/tabix/bgzip

ENV VERSIONH 1.2.1-254-6462e34
ENV NAMEH htslib
ENV URLH "https://github.com/sa     mtools/htslib/archive/${VERSIONH}.tar.gz"
ENV SHA1H "6462e349d16e83db8647272e4b98d2a92992071f"

ENV VERSION 1.2-242-4d56437
ENV NAME "samtools"
ENV URL "https://github.com/samtools/samtools/archive/${VERSION}.tar.gz"
ENV SHA1 "4d56437320ad370eb0b48c204ccec7c73f653393"

RUN git clone https://github.com/samtools/htslib.git && \
cd ${NAMEH} && \
git reset --hard ${SHA1H} && \
make -j 4 && \
cd .. && \
cp ./${NAMEH}/tabix /usr/local/bin/ && \
cp ./${NAMEH}/bgzip /usr/local/bin/ && \
cp ./${NAMEH}/htsfile /usr/local/bin/ && \
#RUN wget -q -O - $URLH | tar -zxv && \
#cd ${NAMEH}-${VERSIONH} && \
#make -j 4 && \
#cd .. && \
#cp ./${NAMEH}-${VERSIONH}/tabix /usr/local/bin/ && \
#cp ./${NAMEH}-${VERSIONH}/bgzip /usr/local/bin/ && \
#cp ./${NAMEH}-${VERSIONH}/htsfile /usr/local/bin/ && \
strip /usr/local/bin/tabix; true && \
strip /usr/local/bin/bgzip; true && \
strip /usr/local/bin/htsfile; true && \
#ln -s ./${NAMEH}-${VERSIONH}/ ./${NAMEH} && \

git clone https://github.com/samtools/samtools.git && \
cd ${NAME} && \
git reset --hard ${SHA1} && \
make -j 4 && \
cp ./${NAME} /usr/local/bin/ && \
cd .. && \
strip /usr/local/bin/${NAME}; true && \
rm -rf ./${NAMEH}/ && \
rm -rf ./${NAME}/ && \
rm -rf ./${NAMEH}

#wget -q -O - $URL | tar -zxv && \
#cd ${NAME}-${VERSION} && \
#make -j 4 && \
#cd .. && \
#cp ./${NAME}-${VERSION}/${NAME} /usr/local/bin/ && \
#strip /usr/local/bin/${NAME}; true && \
#rm -rf ./${NAMEH}-${VERSIONH}/ && \
#rm -rf ./${NAME}-${VERSION}/


RUN apt-get update && apt-get install -y tabix
RUN apt-get update && apt-get install -y bcftools

#Copy QTLtools .sh

COPY QTLtools.sh /home/rstudio/QTLtools.sh
RUN chmod u+x /home/rstudio/QTLtools.sh

#Execute R-package installation and run R script

COPY install_packages.R /home/rstudio/install_packages.R
COPY eQTL_Detector_Report.Rmd /home/rstudio/eQTL_Detector_Report.Rmd

#Run packages intallation
#RUN Rscript /home/rstudio/install_packages.R
