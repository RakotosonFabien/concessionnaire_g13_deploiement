# Dossier de travail
setwd('E:/Etudes/Master/VAGRANT_FOPLA/vagrant-projects/OracleDatabase/21.3.0/concessionnaire_g13/R')

# 1 - Analyse exploratoire des données

#  -----------------------  Immatriculation
# lecture des données concernant les immatriculations
immatriculations <- read.csv('../csv/immatriculations/Immatriculations.csv', encoding = "latin1",   header = TRUE, sep = ',', dec = ".", stringsAsFactors = T)

# Afficher les premières lignes du jeu de données
head(immatriculations)

# Visualisation des données du dataframe
View(immatriculations)

# Vue sur les détails de la structure des données
str(immatriculations)

# Calculer les statistiques descriptives pour chaque variable
summary(immatriculations)

# Calculer la moyenne des variables numeriques
colMeans(immatriculations[, c("puissance", "nbPlaces", "nbPortes", "prix")]) 

# Calculer l'écart-type de chaque variable
apply(immatriculations, 2, sd)

# Tracer un histogramme pour une variable spécifique (prix)
hist(immatriculations$prix)

##Calcul ecart-type
# Exclure les variables non numériques
numeric_columns <- sapply(immatriculations, is.numeric)
numeric_data <- immatriculations[, numeric_columns]

# Calculer l'écart-type des variables numériques
sd_values <- apply(numeric_data, 2, sd)
print(sd_values)

# Verifications des valeurs manquantes
View(is.na(immatriculations))
any(is.na(immatriculations))

# redondances sur la clé primaire
length(unique(immatriculations$immatriculation))

# supprimer les doublons sur la clé primaire immatriculation
immatriculations <- immatriculations[!duplicated(immatriculations$immatriculation), ]

str(immatriculations)


# Graphiques et de diagrammes pour la visualisation des données
library(ggplot2)

# Pour chaque marque, afficher une graphique représentant
# la distribution des prix des voitures selon la valeur occasion
ggplot(immatriculations, aes(x = prix, fill = occasion)) + geom_histogram(binwidth = 5000) + facet_wrap(marque)

#  -----------------------  Catalogue
# Lecture du fichier Catalogue.csv contenant les catalogues
catalogue <- read.csv('../csv/catalogue/Catalogue.csv', encoding = "latin1",   header = TRUE, sep = ',', dec = ".", stringsAsFactors = T)

# Visualisation des données du dataframe
View(catalogue)

# Structures des données
str(catalogue)

# Résumé statistique sur les données
summary(catalogue)

# Lister les lignes doublons, pas de cle primaire
View(catalogue[duplicated(catalogue), ])

# Vérifier les valeurs manquantes
View(is.na(catalogue))
any(is.na(catalogue))


#  -----------------------  Clients
# lecture des données concernant les clients
clients <- read.csv("../csv/clients/Clients_3.csv", encoding = "latin1", header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)

# affichage des données du dataframe
View(clients)

# Affichage des détails sur la structure des données
str(clients)

# Calculer les statistiques descriptives pour chaque variable
summary(clients)

# Redondances sur la clé primaire
length(unique(clients$immatriculation))

# suppression des doublons sur la colonne immatriculation
clients <- clients[!duplicated(clients$immatriculation), ]


##  Correction des valeurs des variables
# Valeurs possibles de ages, on peut voir des " " et "?"
levels(clients$age)
clients$age <- as.integer(clients$age)

clients$age <- ifelse(clients$age == " "
                      | clients$age == "?"
                      | clients$age == "-1",
                      NA, clients$age)

View(clients)



# colonne sexe
# Valeurs possibles de sexe
levels(clients$sexe)

# changement du type de facteur vers character
clients$sexe <- as.character(clients$sexe)

# Remplacer des valeurs vides ou ? ou N/D pars NA
clients$sexe <- ifelse(clients$sexe == " " 
                       | clients$sexe == "?"
                       | clients$sexe == "N/D",
                       NA, clients$sexe)

# Remplacement des valeurs "Féminin" par "F"
clients$sexe <- ifelse(clients$sexe == "Femme"|clients$sexe == "Féminin",
                       "F", clients$sexe)

# Remplacement des valeurs "Masculin" par "M"
clients$sexe <- ifelse(clients$sexe == "Homme"|clients$sexe == "Masculin",
                       "M", clients$sexe)

clients$sexe <- as.factor(clients$sexe)

levels(clients$sexe)

# Traitement de la colonne situationFamiliale
levels(clients$situationFamiliale)
clients$situationFamiliale <- as.character(clients$situationFamiliale)
clients$situationFamiliale <- ifelse(clients$situationFamiliale == " "
                                     | clients$situationFamiliale == "?"
                                     | clients$situationFamiliale == "N/D"
                                     , NA, clients$situationFamiliale)
clients$situationFamiliale <- ifelse(clients$situationFamiliale == "Seul"
                                     | clients$situationFamiliale== "Seule",
                                     "Célibataire", clients$situationFamiliale)

clients$situationFamiliale <- ifelse(clients$situationFamiliale == "Marié(e)",
                                      "En Couple", clients$situationFamiliale)
clients$situationFamiliale <- as.factor(clients$situationFamiliale)
levels(clients$situationFamiliale)

# Traitement de la colonne nbEnfantsAcharge
levels(clients$nbEnfantsAcharge)
clients$nbEnfantsAcharge <- as.integer(clients$nbEnfantsAcharge)
clients$nbEnfantsAcharge <- ifelse(clients$nbEnfantsAcharge == " "
                                   | clients$nbEnfantsAcharge == "-1"
                                   | clients$nbEnfantsAcharge == "?",
                                   NA, clients$nbEnfantsAcharge)
View(clients$nbEnfantsAcharge)

# Traitement de la colonne X2eme.voiture
levels(clients$X2eme.voiture)
clients$X2eme.voiture <- as.character(clients$X2eme.voiture)
clients$X2eme.voiture <- ifelse(clients$X2eme.voiture == " "
                                | clients$X2eme.voiture == "?",
                                NA, clients$X2eme.voiture)
clients$X2eme.voiture = as.factor(clients$X2eme.voiture)
levels(clients$X2eme.voiture)


