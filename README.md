# data-cleaning-MySQL

🧹 Data Cleaning avec MySQL — Dataset World Layoffs
📌 Description du projet

Ce projet consiste à nettoyer et préparer un dataset réel de licenciements dans le monde (World Layoffs) à l’aide de MySQL.

Le data cleaning est une étape essentielle en analyse de données : il permet de transformer des données brutes (raw data) en données fiables et exploitables pour l’analyse, la visualisation ou l’intégration dans des applications.

Dans ce projet, nous importons un dataset contenant des informations sur les licenciements dans différentes entreprises (secteur, pays, nombre d’employés licenciés, etc.), puis nous appliquons plusieurs étapes de nettoyage pour améliorer la qualité des données.

Le dataset nettoyé pourra ensuite être utilisé pour un projet d’analyse exploratoire des données (EDA).

🗂️ Dataset

Le dataset contient des informations sur des licenciements d'entreprises dans le monde depuis environ 2021.

Colonnes principales
Colonne	Description
company	Nom de l’entreprise
location	Localisation de l’entreprise
industry	Secteur d’activité
total_laid_off	Nombre total d’employés licenciés
percentage_laid_off	Pourcentage d’employés licenciés
date	Date de l’annonce des licenciements
stage	Stade de développement de l’entreprise (ex: Series B, Post-IPO…)
country	Pays
funds_raised_millions	Fonds levés par l’entreprise (en millions)
⚙️ Technologies utilisées

MySQL

SQL

MySQL Workbench

🏗️ Structure du projet

Le projet utilise deux tables principales :

1️⃣ Table layoffs

Contient les données brutes importées depuis le dataset.

2️⃣ Table layoffs_staging

Table de travail utilisée pour le nettoyage des données.

Cela permet de :

préserver les données originales

éviter de modifier directement les données sources

recommencer facilement le nettoyage en cas d’erreur

🔄 Étapes du Data Cleaning

Le nettoyage des données a été réalisé en plusieurs étapes.

1️⃣ Suppression des doublons

Nous avons identifié les lignes dupliquées à l’aide de la fonction SQL :

ROW_NUMBER() OVER(PARTITION BY ...)

Cette fonction permet :

d’attribuer un numéro à chaque ligne

d’identifier les doublons

de supprimer uniquement les lignes en trop

Les doublons ont ensuite été supprimés dans une table de staging.

2️⃣ Standardisation des données

Certaines valeurs contenaient des incohérences ou des différences d’écriture.

Exemples corrigés :

Espaces inutiles
UPDATE layoffs_staging2
SET company = TRIM(company);
Uniformisation des secteurs

Par exemple :

crypto
cryptocurrency
CryptoCurrency

ont été standardisés en :

crypto
3️⃣ Correction des valeurs incorrectes

Certaines valeurs contenaient des erreurs de format.

Exemple :

United States.

corrigé en :

United States

via la fonction TRIM.

4️⃣ Conversion des dates

La colonne date était initialement au format texte.

Elle a été convertie au format DATE avec :

STR_TO_DATE(date, '%m/%d/%Y')

Puis la colonne a été modifiée avec :

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;
5️⃣ Gestion des valeurs NULL et vides

Certaines colonnes contenaient :

valeurs NULL

valeurs vides

Dans certains cas, ces valeurs ont pu être remplies automatiquement grâce à d'autres lignes contenant les mêmes informations.

Exemple :

Si une entreprise avait :

industry = NULL

mais une autre ligne avec :

industry = Travel

alors la valeur a été complétée automatiquement.

6️⃣ Suppression de lignes inutiles

Les lignes contenant :

total_laid_off = NULL
AND percentage_laid_off = NULL

ont été supprimées car elles ne contiennent aucune information exploitable.

7️⃣ Suppression des colonnes temporaires

La colonne row_num, utilisée pour détecter les doublons, a été supprimée :

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
📊 Résultat

À la fin du processus, nous obtenons un dataset propre et prêt pour l’analyse :

sans doublons

avec des formats cohérents

avec des données standardisées

avec les valeurs inutiles supprimées



💡 Compétences démontrées

Ce projet met en pratique :

SQL avancé

Data Cleaning

Gestion des données manquantes

Standardisation de données

Manipulation de tables SQL

Bonnes pratiques en Data Analysis
