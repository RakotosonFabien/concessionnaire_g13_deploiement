#!/bin/bash

BASE_PATH="/vagrant/concessionnaire_g13"
GROUPHDFS_BASEDIR="/groupe_13"
HDFS_RESULTDIR="resultats_co2"

echo "==> traitement du ficher co2.csv et résultat dans $GROUPHDFS_BASEDIR/$HDFS_RESULTDIR"

# Execution HADOOP sur fichier CO2 et resultats dans /resultats_co2
hadoop jar $BASE_PATH/hadoop/co2_groupe13-0.0.1.jar org.mbds.Co2 $GROUPHDFS_BASEDIR/co2/CO2.csv $GROUPHDFS_BASEDIR/$HDFS_RESULTDIR

#Voir les resultats
echo "==> Résultats"
hadoop fs -cat $GROUPHDFS_BASEDIR/$HDFS_RESULTDIR/*

unset GROUPHDFS_BASEDIR
unset HDFS_RESULTDIR
