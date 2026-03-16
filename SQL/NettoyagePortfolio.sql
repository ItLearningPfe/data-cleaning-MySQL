/* 
Cleaning Data in SQL Queries
*/







/*
Le nombre de colonnes et de lignes 
*/

SELECT COUNT(*) AS nombre_lignes,
	   (SELECT COUNT(*)  FROM INFORMATION_SCHEMA.COLUMNS where table_name='NashVilleHousing') AS nombre_colonnes
FROM NashVilleHousing 

--(56373/20)

-- La liste des colonnes 

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashVilleHousing';

--Le contenu des colonnes
SELECT * from NashVilleHousing

/*
On remarque qu'il faut changer le format de la date, créer des colonnes suplémentaires pour mettre 
séparer le champ PropertyAddress et OwnerAddress. On peut aussi séparer le champ nom et prénom
*/


--Afficher les valeurs distinctes des colonnes LandUse, SoldAsVacant, pour detecter les valeurs abérrantes 
SELECT DISTINCT(LandUse)
FROM NashVilleHousing

--39 valeurs (Aucune valeur aberrantes)

SELECT DISTINCT(SoldAsVacant)
FROM NashVilleHousing

--4 valeurs : Yes, No, Y, N
--Il faut remplacer les Y, N par Yes No

--Pourcentage des nulls par colonne :
DECLARE @tableName NVARCHAR(128) = 'NashvilleHousing';
DECLARE @columnName NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX) = '';

DECLARE col_cursor CURSOR FOR
SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID(@tableName);

OPEN col_cursor;
FETCH NEXT FROM col_cursor INTO @columnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'SELECT ''' + @columnName + ''' AS ColumnName, ' +
               'COUNT(*) AS TotalRows, ' +
               'SUM(CASE WHEN [' + @columnName + '] IS NULL THEN 1 ELSE 0 END) AS NullCount, ' +
               'CAST(100.0 * SUM(CASE WHEN [' + @columnName + '] IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS NullPct ' +
               'FROM [' + @tableName + '];';

    PRINT @sql;  -- Optionnel : pour voir chaque requête générée
    EXEC sp_executesql @sql;

    FETCH NEXT FROM col_cursor INTO @columnName;
END

CLOSE col_cursor;
DEALLOCATE col_cursor;


/*
Les colonnes avec 0 nulls : UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice,
LegalReference, SoldAsVacant

Les colonnes avec des nulls : 

Column_name  Total_rows    NullCount     NullPct
OwnerName	    56373	       31158	     55.27
OwnerAddress	56373	       30404	     53.93
Acreage	        56373	       30404	     53.93
TaxDistrict	    56373	       30404	     53.93
LandValue	    56373	       30404	     53.93
BuildingValue	56373	       30404	     53.93
YearBuilt	    56373	       32255	     57.22
Bedrooms		56373		   32261	     57.23
FullBath	    56373	       32143	     57.02
HalfBath	    56373	       32274	     57.25
PropertyAddress                       
*/



--Standardize date format

Select SaleDate, SaleDateConverted from NashVilleHousing

ALTER TABLE NashVilleHousing
ADD SaleDateConverted date;

UPDATE NashVilleHousing
SET SaleDateConverted=CONVERT(Date, SaleDate)

--Populate Property Adress Data

Select * from NashVilleHousing
where PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashVilleHousing a
JOIN NashVilleHousing b
ON a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
and a.PropertyAddress is null

UPDATE a 
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashVilleHousing a
JOIN NashVilleHousing b
ON a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
and a.PropertyAddress is null

--Breaking out Address into individual columns 

Select PropertyAddress from NashVilleHousing


SELECT 
	SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)
	from NashVilleHousing

SELECT 
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
	from NashVilleHousing

ALTER TABLE NashVilleHousing
ADD Address nvarchar(255)

ALTER TABLE NashVilleHousing
ADD City nvarchar(255)

UPDATE NashVilleHousing
SET Address =SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

UPDATE NashVilleHousing
SET City =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



--Populate Owner Adress Data
SELECT OwnerAddress  
from NashVilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress,',','.'),3), 
	PARSENAME(REPLACE(OwnerAddress,',','.'),2), 
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashVilleHousing


ALTER TABLE NashVilleHousing
ADD OwnerAdress nvarchar(255),
	OwnerCity nvarchar(255),
	OwnerState nvarchar(255)

UPDATE NashVilleHousing
SET OwnerAdress =PARSENAME(REPLACE(OwnerAddress,',','.'),3),
    OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
from NashVilleHousing

--Change Y and O to Yes and No in "Sold or Vacant" Field
SELECT DISTINCT(SoldAsVacant)
from NashVilleHousing

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	 WHEN SoldAsVacant='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashVilleHousing

UPDATE NashVilleHousing
	SET SoldAsVacant =CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	 WHEN SoldAsVacant='N' THEN 'No'
	 ELSE SoldAsVacant
	 END

--Remove Duplicates

WITH RunCteNum AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY UniqueId
				 )row_num
from NashVilleHousing
)
DELETE from RunCteNum
where row_num>1

--Delete UNUSEFUL Comumns

SELECT * FROM NashVilleHousing

ALTER TABLE NashVilleHousing
DROP COLUMNS  PropertyAddress