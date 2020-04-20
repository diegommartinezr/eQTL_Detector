FROM rocker/rstudio

RUN mkdir /home/rstudio/Results
RUN mkdir /home/rstudio/Results/bamstat
RUN mkdir /home/rstudio/Results/mbv
RUN mkdir /home/rstudio/Results/quan

COPY eQTL_Detector_Report.Rmd /home/rstudio/eQTL_Detector_Report.Rmd
COPY quan.R /home/rstudio/quan.R
COPY QTLtools.sh /home/rstudio/QTLtools.sh

#RUN chmod u+x /home/rstudio/QTLtools.sh
