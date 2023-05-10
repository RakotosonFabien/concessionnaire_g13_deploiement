#!/bin/bash
DB_NAME="concessionnaire_g13"
COLLECTION="catalogue"
CATALOG_PATH="/vagrant/concessionnaire_g13/csv/catalogue"
FICHIER="Catalogue.csv"
UNHEADERED="$CATALOG_PATH/unheadered/$FICHIER"

echo "==> import du fichier $FICHIER dans mongodb"

mkdir $CATALOG_PATH/unheadered
tail -n +2 $CATALOG_PATH/$FICHIER > $UNHEADERED	

mongoimport --db=$DB_NAME --collection=$COLLECTION --type=csv --drop --file=$UNHEADERED --columnsHaveTypes --fields='marque.string(),nom.string(),puissance.int32(),longueur.string(),nbplaces.int32(),nbportes.int32(),couleur.string(),occasion.boolean(),prix.double()'

#affichage des infos portant sur le nombre de lignes importées dans la base:
# 2023-04-23T11:48:40.595+0300    connected to: localhost
# 2023-04-23T11:48:40.617+0300    imported 270 documents

#suppression des variables
unset DB_NAME
unset COLLECTION
unset CATALOG_PATH
unset FICHIER
unset UNHEADERED

#pour vérifier le nombre d'imports dans mongo
# mongo
# use concessionnaire;
# db.catalogue.count({});
