/*

Data Cleaning 

*/



SELECT *
FROM [SQL Tutorial]..NashvilleHousing


--Formating the Sales Date (making date more user friendly, removing unnecessary timestamp).


Update NashvilleHousing 
SET SalesDateConverted = Convert(Date, SaleDate)

SELECT SalesDateConverted
FROM [SQL Tutorial]..NashvilleHousing


--Populate property address, utilizing joins and appropriate existing data. 
/*Select all won't function properly since table is updated later in code, but did 
function at this point, shown for display purposes */

SELECT * 
FROM [SQL Tutorial]..NashvilleHousing
where PropertyAddress is null 

--Displaying where the null values are under PropertyAddress.


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM [SQL Tutorial]..NashvilleHousing a
JOIN [SQL Tutorial]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Utilizing ISNULL statement to insert column with information into column without. Now no null statements
--under PropertyAddress.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, 
b.PropertyAddress)
FROM [SQL Tutorial]..NashvilleHousing a
JOIN [SQL Tutorial]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [SQL Tutorial]..NashvilleHousing a
JOIN [SQL Tutorial]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, 
b.PropertyAddress) 
FROM [SQL Tutorial]..NashvilleHousing a
JOIN [SQL Tutorial]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null


--Making the property address more functional by separating Address into (address, city, state),
--using substring function. 

SELECT PropertyAddress
FROM [SQL Tutorial]..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM [SQL Tutorial]..NashvilleHousing


Alter Table NashvilleHousing
ADD PropertySepAddress Nvarchar(255)

Update NashvilleHousing
SET PropertySepAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
ADD PropertySepCity Nvarchar (255)

Update NashvilleHousing
SET PropertySepCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Making the owner address more functional by separating Address into (address, city, state), using 
--parsename function. 

SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(Replace(OwnerAddress, ',','.') , 3) as OwnerStreetAddress, 
PARSENAME(Replace(OwnerAddress, ',','.') , 2) as OwnerCityAddress,
PARSENAME(Replace(OwnerAddress, ',','.') , 1) as OwnerStateAddress
From NashvilleHousing


Alter Table NashvilleHousing
ADD OwnerStreetAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerStreetAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 3)

Alter Table NashvilleHousing
ADD OwnerCityAddress Nvarchar (255)

Update NashvilleHousing
SET OwnerCityAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 2) 

Alter Table NashvilleHousing
ADD OwnerStateAddress Nvarchar (255)

Update NashvilleHousing
SET OwnerStateAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 1) 


--Change Y or N to Yes or No in "Sold as Vacant" field

SELECT Distinct(SoldasVacant), COUNT(SoldasVacant)
FROM NashvilleHousing
Group by SoldAsVacant
Order by 2

SELECT SoldasVacant, CASE
	WHEN SoldasVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant 
END 
as SoldVacant
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldasVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant 
END 


--Remove Duplicates, utilizing CTE (for skill display only, understood not to delete raw data).

WITH RowNumCTE AS (
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num
FROM [SQL Tutorial].dbo.NashvilleHousing
)

DELETE
FROM RowNumCTE
Where row_num >1

SELECT * 
FROM [SQL Tutorial].dbo.NashvilleHousing


