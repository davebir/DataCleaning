-- Change Sale Date --

SELECT
*
FROM
master.dbo.Houston;

ALTER TABLE Houston
ADD SaleDateConverted DATE;

UPDATE Houston
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT
    SaleDateConverted,
    CONVERT(DATE, SaleDate)
FROM
master.dbo.Houston;

-- Example of Changed Sale Date
SELECT
  SaleDate,
  SaleDateConverted
FROM master.dbo.Houston



-- Populate Property Address Data --

SELECT
*
FROM
master.dbo.Houston
WHERE PropertyAddress IS NULL


SELECT
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM master.dbo.Houston a
JOIN master.dbo.Houston b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueId]
WHERE a.PropertyAddress IS NULL

UPDATE a 
    SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM master.dbo.Houston a
    JOIN master.dbo.Houston b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueId]
WHERE a.PropertyAddress IS NULL



-- Breaking Out Address Into Individual Columns (Address, City, State) --
-- One way of accomplishing task
 SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
 FROM master.dbo.Houston

ALTER TABLE Houston
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Houston
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Houston
ADD PropertySplitCity NVARCHAR(255);

UPDATE Houston
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT
    PropertySplitAddress,
    PropertySplitCity
FROM
    master.dbo.Houston;

-- Other way of accomplishing task

SELECT
    OwnerAddress
FROM
    master.dbo.Houston;

SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM
    master.dbo.Houston;

ALTER TABLE Houston
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Houston
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE Houston
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Houston
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE Houston
ADD OwnerSplitState NVARCHAR(255);

UPDATE Houston
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT
    OwnerSplitAddress,
    OwnerSplitCity,
    OwnerSplitState
FROM
    master.dbo.Houston;

SELECT
    *
FROM
    master.dbo.Houston;



-- Change Y and N to Yes and No in 'SoldAsVacant'

SELECT
    DISTINCT(SoldAsVacant),
    COUNT(SoldAsVacant)
FROM
    master.dbo.Houston
GROUP BY SoldAsVacant
ORDER BY 2

SELECT
    SoldAsVacant,
CASE SoldAsVacant
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM
    master.dbo.Houston;

UPDATE Houston
SET SoldAsVacant = CASE SoldAsVacant
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE SoldAsVacant
    END



-- Remove Duplicates

WITH ROW_NUMCTE AS (
SELECT
    *,
    ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY
                    UNIQUEID
               ) ROW_NUM
FROM
    master.dbo.Houston
)
--ORDER BY ParcelID
SELECT *
FROM ROW_NUMCTE
WHERE ROW_NUM > 1
ORDER BY PropertyAddress



-- Delete Unused Columns

SELECT
    *
FROM
    master.dbo.Houston

ALTER TABLE master.dbo.Houston
DROP COLUMN OwwnerAddress, TaxDistrict, PropertyAddress

SELECT 
    DISTINCT(Bedrooms),
    COUNT(Bedrooms)
FROM
    master.dbo.Houston
GROUP BY Bedrooms
ORDER BY Bedrooms
