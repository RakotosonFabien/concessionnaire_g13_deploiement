#!/bin/bash

CLIENTS_DIR="/vagrant/concessionnaire_g13/csv/clients"
CLIENTS_UNHEADERED_DIR="$CLIENTS_DIR/unheadered"
CLIENTS_HDFS_DIR="/groupe_13/clients"

echo "==> put fichiers clients dans répertoire $CLIENTS_HDFS_DIR de HDFS"

mkdir $CLIENTS_UNHEADERED_DIR

for file in $CLIENTS_DIR/*.csv
do
	tail -n +2 $file > $CLIENTS_UNHEADERED_DIR/$(basename "$file")
done

hadoop fs -mkdir "$CLIENTS_HDFS_DIR"
hadoop fs -put $CLIENTS_UNHEADERED_DIR/*.csv $CLIENTS_HDFS_DIR

echo "OK"

unset CLIENTS_DIR
unset CLIENTS_UNHEADERED_DIR
unset CLIENTS_HDFS_DIR
