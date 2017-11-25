#!/bin/bash
IMPORT="BitacorasMicrotalleresConteo.csv"
TEMPLATE="plantilla"

for i in `cat ${IMPORT}`
do 
  word=`echo $i | awk -F, '{print $1}'`
  count=`echo $i | awk -F, '{print $2}'`
  cat $TEMPLATE | sed -e s/word/$word/g \
                      -e s/count/$count/g 
done
