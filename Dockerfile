FROM martindi/eqtldetectorbase

RUN mkdir /home/rstudio/Results
RUN mkdir /home/rstudio/Bed-Seq
RUN mkdir /home/rstudio/Results/bamstat
RUN mkdir /home/rstudio/Results/mbv
RUN mkdir /home/rstudio/Results/quan
RUN mkdir /home/rstudio/Results/pca
RUN mkdir /home/rstudio/Results/cis_nominal
RUN mkdir /home/rstudio/Results/trans
RUN mkdir /home/rstudio/Results/cis_permutation
RUN mkdir /home/rstudio/Results/fdensity
RUN mkdir /home/rstudio/Results/fenrich
RUN mkdir /home/rstudio/Results/rtc

COPY eQTL_Detector_Report.Rmd /home/rstudio/eQTL_Detector_Report.Rmd
COPY QTLtools.sh /home/rstudio/QTLtools.sh
