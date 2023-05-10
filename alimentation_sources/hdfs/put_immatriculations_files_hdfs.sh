#!/bin/bash

IMMATRICULATIONS_DIR="/vagrant/concessionnaire_g13/csv/immatriculations"
IMMATRICULATIONS_UNHEADERED_DIR="$IMMATRICULATIONS_DIR/unheadered"
IMMATRICULATIONS_HDFS_DIR="/groupe_13/immatriculations"

echo "==> put fichiers immatriculations dans répertoire $IMMATRICULATIONS_HDFS_DIR de HDFS"

mkdir $IMMATRICULATIONS_UNHEADERED_DIR

for file in $IMMATRICULATIONS_DIR/*.csv
do
	tail -n +2 $file > $IMMATRICULATIONS_UNHEADERED_DIR/$(basename "$file")
done

hadoop fs -mkdir "$IMMATRICULATIONS_HDFS_DIR"
hadoop fs -put $IMMATRICULATIONS_UNHEADERED_DIR/*.csv $IMMATRICULATIONS_HDFS_DIR

echo "OK"

unset IMMATRICULATIONS_DIR
unset IMMATRICULATIONS_UNHEADERED_DIR
unset IMMATRICULATIONS_HDFS_DIR
