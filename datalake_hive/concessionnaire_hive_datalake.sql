-- Création de la base
create database if not exists concessionnaire_dl_g13;
use concessionnaire_dl_g13;

-- Drop tables si elles existent déjà
drop table clients_ext if exists;
drop table catalogue_ext if exists;
drop table immatriculations_ext if exists;
drop table marketing_ext if exists;


-- Création des tables externes pointant vers les sources de données

create external table if not exists clients_ext(
age int,
sexe string,
taux int,
situationfamiliale string,
nbenfantsacharge int,
deuxiemevoiture string,
immatriculation string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/groupe_13/clients'; 


CREATE EXTERNAL TABLE catalogue_ext( 
id string, 
marque string, 
nom string,
puissance int,
longueur string,
nbPlaces int,
nbPortes int,
couleur string,
occasion boolean,
prix int
)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/concessionnaire_g13.catalogue');


create external table immatriculations_ext(
immatriculation string,
marque string,
nom string,
puissance int,
longueur string,
nbPlaces int,
nbPortes int,
couleur string,
occasion boolean,
prix int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/groupe_13/immatriculations'; 


create external table marketing_ext(
id int,
age int,
sexe string,
taux int,
situationFamiliale string,
nbEnfantsAcharge int,
deuxiemeVoiture boolean)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "MARKETING_G13");

CREATE EXTERNAL TABLE co2_ext (
  marque STRING,
  bonus_malus INT,
  rejets INT,
  cout_energie INT,
  occurrences INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE LOCATION 'hdfs:/groupe_13/resultats_co2';

CREATE TABLE catalogue_complet (
  id string,
  marque string,
  nom string,
  puissance int,
  longueur string,
  nbplaces int,
  nbportes int,
  couleur string,
  occasion boolean,
  prix int,
  bonus_malus int,
  rejets int,
  cout_energie int
);

INSERT OVERWRITE TABLE catalogue_complet
SELECT
  ce.id,
  ce.marque,
  ce.nom,
  ce.puissance,
  ce.longueur,
  ce.nbplaces,
  ce.nbportes,
  ce.couleur,
  ce.occasion,
  ce.prix,
  COALESCE(co2.bonus_malus, CAST(avg_bm AS INT)) AS bonus_malus,
  COALESCE(co2.rejets, CAST(avg_rejets AS INT)) AS rejets,
  COALESCE(co2.cout_energie, CAST(avg_ce AS INT)) AS cout_energie 
FROM
  catalogue_ext ce
LEFT JOIN co2_ext co2 ON ce.marque = co2.marque
CROSS JOIN (
  SELECT
    SUM(bonus_malus * occurrences) / SUM(occurrences) AS avg_bm,
    SUM(rejets * occurrences) / SUM(occurrences) AS avg_rejets,
    SUM(cout_energie * occurrences) / SUM(occurrences) AS avg_ce
  FROM
    co2_ext
) avg;

-- select count(*) compte from clients_ext;
-- select count(*) compte from catalogue_ext;
-- select count(*) compte from immatriculations_ext;
-- select count(*) compte from marketing_ext;
