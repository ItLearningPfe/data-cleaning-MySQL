Voici une proposition de README.md professionnel, structuré et complet pour votre projet de nettoyage de données (Data Cleaning) avec SQL, basé sur les notes fournies.

Data Cleaning in SQL - Nashville Housing Dataset
📌 Présentation du Projet
Ce projet se concentre sur l'étape la plus cruciale du travail d'un analyste de données : le Nettoyage de Données (Data Cleaning). L'objectif est de prendre un jeu de données "brut" (raw data) sur le marché immobilier de Nashville et de le transformer en un ensemble de données propre, structuré et prêt pour l'analyse.

Le projet utilise SQL Server (T-SQL) pour manipuler environ 56 000 lignes de données et résoudre des problèmes courants tels que les formats de date incohérents, les valeurs nulles, les colonnes fusionnées et les doublons.

📊 Jeu de Données
Le dataset utilisé est le Nashville Housing Dataset. Il contient des informations sur les transactions immobilières :

Identifiants uniques (Unique ID, Parcel ID)

Adresses de propriété et de propriétaire

Dates de vente et prix

Détails techniques (nombre de chambres, salles de bain, valeur du terrain)

🛠️ Étapes de Nettoyage réalisées
1. Standardisation du format de Date
Le champ SaleDate contenait initialement une composante temporelle (Time) inutile.

Solution : Création d'une nouvelle colonne SaleDateConverted au format Date uniquement pour plus de clarté.

2. Remplissage des adresses de propriété manquantes
Certaines lignes présentaient des valeurs NULL pour l'adresse de la propriété alors qu'elles possédaient un ParcelID.

Solution : Utilisation d'une Self-Join (jointure de la table sur elle-même) pour faire correspondre les ParcelID identiques et peupler les adresses manquantes via la fonction ISNULL.

3. Fractionnement des Adresses (Propriété & Propriétaire)
Les adresses étaient stockées dans une seule colonne (Adresse, Ville, État).

Solution pour l'adresse propriété : Utilisation de SUBSTRING et CHARINDEX pour extraire l'adresse et la ville.

Solution pour l'adresse propriétaire : Utilisation de PARSENAME (après remplacement des virgules par des points) pour une méthode plus simple et efficace afin d'extraire l'adresse, la ville et l'état.

4. Harmonisation du champ "Sold as Vacant"
Ce champ contenait des valeurs disparates : "Yes", "No", "Y" et "N".

Solution : Utilisation d'une instruction CASE pour convertir tous les "Y" en "Yes" et les "N" en "No".

5. Suppression des Doublons
Identification des lignes identiques basées sur des critères spécifiques (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).

Solution : Utilisation de CTE (Common Table Expressions) et de la fonction de fenêtrage ROW_NUMBER() pour isoler et supprimer les doublons.

6. Nettoyage des colonnes inutilisées
Pour optimiser la base de données finale, les colonnes transformées ou devenues inutiles ont été supprimées.

🚀 Compétences SQL démontrées
DML (Data Manipulation Language) : UPDATE, DELETE, INSERT.

DDL (Data Definition Language) : ALTER TABLE, ADD.

Fonctions avancées : ISNULL, SUBSTRING, PARSENAME, CHARINDEX, CAST/CONVERT.

Requêtes complexes : Joins (Self-Join), CTEs, Window Functions (ROW_NUMBER).

⚙️ Installation
Téléchargez le jeu de données Excel fourni dans ce repository.

Importez le fichier dans SQL Server Management Studio (SSMS) à l'aide de l'outil "Import and Export Data".

Exécutez le script SQL fourni (cleaning_script.sql) pour appliquer les transformations.

📂 Structure du Repository
Nashville_Housing_Data.xlsx : Le fichier de données brut.

NettoyagePortfolio.sql : Le script complet avec les commentaires détaillés.

README.md : Documentation du projet.
