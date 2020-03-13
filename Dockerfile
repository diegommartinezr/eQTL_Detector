FROM r-base

#QTLtools stuff

COPY QTLtools.sh /QTLtools.sh

#Executing script

RUN ["/QTLtools.sh"]


