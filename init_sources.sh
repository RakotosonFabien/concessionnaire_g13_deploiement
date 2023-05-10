BASE_PATH="/vagrant/concessionnaire_g13"
HDFS_BASEDIR="/groupe_13"

#mongo
bash $BASE_PATH/alimentation_sources/mongo/import_catalogue_file.sh

#HDFS
hdfs dfs -mkdir $HDFS_BASEDIR
bash $BASE_PATH/alimentation_sources/hdfs/put_co2_files_hdfs.sh
bash $BASE_PATH/alimentation_sources/hdfs/put_clients_files_hdfs.sh
bash $BASE_PATH/alimentation_sources/hdfs/put_immatriculations_files_hdfs.sh

#oracleNoSQL
javac $BASE_PATH/alimentation_sources/oraclenosql/ConcessionnaireBase.java -d $BASE_PATH/alimentation_sources/oraclenosql
java -cp $CLASSPATH:$BASE_PATH/alimentation_sources/oraclenosql concessionnairebase.ConcessionnaireBase -init --import -table=MARKETING_G13 -file="$BASE_PATH/csv/marketing/Marketing.csv" -headerline

unset HDFS_BASEDIR
