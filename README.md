#Placement du dossier concessionnaire_g13
le .zip alefako décompréssena dia alefaso ao anatinle .../OracleDatabase/21.3.0/
raha vao mbola atony ao anaty dossier concessionnaire_g13 fanindroany le concessionnaire_g13 décompréssé dia avoahy tao
TOKONY TSY HAHAZO ZANY HOE .../21.3.0/concessionnaire_g13/concessionnaire_g13/...

#décompréssena le fichier immatriculations.csv anle groupe azo tany am Mopolo et dia alatsaka ao @ concessionnaire_g13/csv/immatriculations
Navesatra be loatra le fichier imatriculations mantsy dia tsy mety lasa ty zip ty raha tonga dia nataoko tato

#Ireo fichiers hafa efa ao:
	.concessionnaire_g13/catalogue/Catalogue.csv
	.concessionnaire_g13/clients/Clients_3.csv && Clients_12.csv
	.concessionnaire_g13/co2/CO2.csv
	.concessionnaire_g13/marketing/Marketing.csv

#1 alefa ny vagrant, aza miditra amle virtual box fa tonga dia manokafa cmd ao amle 21.3.0 fa manjary misy blem le izy
(raha vao miditra virtual box no midemaka anle vm dia tsy partagé en réseu le 21.3.0 dia tsy hita any anaty ssh le contenu any)

> vagrant up


#2 miditra ssh
> vagrant ssh

#3 démarrena daholo ny services (mety miandry kely eo amle kvstore, pingéo dia raha vao hita le infos be dia be dia démarré izy zay)

démarrage service mongodb (le serveur est peut-être déjà démarré automiquement au démarrage de la vm)
> sudo systemctl start mongodb

démarrage hdfs et yarn:
> start-dfs.sh
> start-yarn.sh

démarrage oracle nosql:
> nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &

ping serveur kvstore pour vérifier qu'il est démarré, il faut attendre quelques secondes, voire 1 minute:
> java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar ping -host localhost -port 5000


#4 executena le script mialimenter anle sources:

> bash /vagrant/concessionnaire_g13/init_sources.sh

*** manao ny execution tsirairay anle scripts bash sy programme java ireto ilay init_sources.sh:
. /vagrant/concessionnaire_g13/alimentation_sources/hdfs/put_co2_files_hdfs.sh

. /vagrant/concessionnaire_g13/alimentation_sources/hdfs/put_clients_files_hdfs.sh

. /vagrant/concessionnaire_g13/alimentation_sources/hdfs/put_immatriculations_files_hdfs.sh

. /vagrant/concessionnaire_g13/alimentation_sources/mongo/import_catalogue_file.sh

. /vagrant/concessionnaire_g13/alimentation_sources/oraclenosql/ConcessionnaireBase.java
	- compilation:
   javac /vagrant/concessionnaire_g13/alimentation_sources/oraclenosql/ConcessionnaireBase.java -d /vagrant/concessionnaire_g13/alimentation_sources/oraclenosql

	- exécution:
   java -cp $CLASSPATH:/vagrant/concessionnaire_g13/alimentation_sources/oraclenosql concessionnairebase.ConcessionnaireBase -init --import -table=marketing -file="/vagrant/concessionnaire_g13/csv/marketing/Marketing.csv" -headerline

***


vérifier les données:

	MONGODB:
> mongo
> use concessionnaire;
> db.catalogue.find({});
OK si toutes les données sont présentes
> exit; 

	HDFS:
> hdfs dfs -ls /co2_g13
(1 fichier co2)
	
> hdfs dfs -ls /clients_g13
(2 fichiers clients)

> hdfs dfs -ls /immatriculations_g13
(1 fichier immatriculation)
OK si tous les fichiers sont importés

	OracleNosql:
> java -Xmx256m -Xms256m -jar $KVHOME/lib/sql.jar -helper-hosts localhost:5000 -store kvstore
(ouverture du sql shell)

sql-> select * from marketing;

OK si toutes les données sont présentes
sql-> quit ou exit;

Si tout est OK, on peut passer à la création des tables de notre datalake
Sinon, il faut réexecuter (un à un les scripts et programme d'imports pour chaque source) ou le fichier init_sources.sh

#5 crééna ny tables externes HIVE anle datalake mipointe mankany amle sources tsirairay

# démarrena ny HIVE
> nohup hive --service metastore > hive_metastore.log 2>&1 &
> nohup hiveserver2 > hive_server.log 2>&1 &

#miconnecte amle HIVE
> beeline -u jdbc:hive2://localhost:10000 vagrant

#sokafana @ éditeur de texte any am windows ty script sql ty dia executena tsirairay le création de db sy table ao:
concessionnaire_g13/datalake_hive/concessionnaire_hive_datalake.sql

Refa vita dia testeo am 'select count(*) compte from table'
Aza atao 'select * from table' fa lava be loatra dia mety ho sahirana le pc, SURTOUT ny clients sy ny immatriculations 
misy tsy voateste ako le tables sy ny créations any noho ny blem isankarazany amle pc ako:
	.oracle NOSQL ako tsy mandeha tsony ndray amle tapaka tampoka ny jiro dia maty le pc nefa le VM nandeha teo
	.ny HIVE ako nisy blem tamle down sy install tamzany dia lasa tsy mety mipointe anle mongo fa tsy ampy anle le plugin manao anle izy.
Le tao anaty pdf '4Concepts_Des_Lacs_Donnees_Et_Mise_en_Pratique' an'i mr Mopolo sy le
Le script sql lava be 'ExercicesBigDataNosql_Data_Lake.sql' nataontsika ireny ihany no nalaiko tahaka
Izay mety ho blem tonga dia kozikozio ao anaty groupe amty herinandro ty ihany dia miaraka jerena.