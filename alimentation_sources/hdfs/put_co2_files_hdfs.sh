#!/bin/bash
CO2_DIR="/vagrant/concessionnaire_g13/csv/co2"
CO2_HDFS_DIR="/groupe_13/co2"

echo "==> put fichiers co2.csv dans répertoire $CO2_HDFS_DIR de HDFS"

hadoop fs -mkdir $CO2_HDFS_DIR
hadoop fs -put $CO2_DIR/*.csv $CO2_HDFS_DIR

echo "OK"

unset CO2_DIR
unset CO2_HDFS_DIR

