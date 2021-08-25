/*

Cleaning data in SQL
Note: Deleting data only for show proof. Deleting any data from raw database is not something I would advise.
*/
-------------------------------------------------------------------------------------------------------------
Select *
FROM [PortfolioProject].[dbo].[nashville_housing]

--Standardize Data Format

Select SalesDateConverted, CONVERT(Date, SaleDate)
 FROM [PortfolioProject].[dbo].[nashville_housing]

 update PortfolioProject..nashville_housing
 Set SaleDate = CONVERT(Date, SaleDate)

 -- Since it didn't update properly

 Alter Table PortfolioProject..nashville_housing
 Add SalesDateConverted Date;

 update PortfolioProject..nashville_housing
 Set SalesDateConverted = CONVERT(Date, SaleDate)
 -------------------------------------------------------------------------------------------------------------------------------------
 --Populate Property Adress Data

 Select *
 FROM [PortfolioProject].[dbo].[nashville_housing]
-- Where PropertyAddress is Null
order by ParcelID

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM [PortfolioProject].[dbo].[nashville_housing] a
 Join [PortfolioProject].[dbo].[nashville_housing] b
       on a.ParcelID = b.ParcelID
       and a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is Null

 Update  a
 Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM [PortfolioProject].[dbo].[nashville_housing] a
 Join [PortfolioProject].[dbo].[nashville_housing] b
       on a.ParcelID = b.ParcelID
       and a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is Null

 ----------------------------------------------------------------------------------------------------------------------------
 --Breaking out Adress into separated columns(Adress, City, State)

 Select PropertyAddress
 FROM [PortfolioProject].[dbo].[nashville_housing]

 Select
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Adress
 ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Adress

FROM [PortfolioProject].[dbo].[nashville_housing]



Alter Table PortfolioProject..nashville_housing
Add PropertySplitAdress nVarchar(255);

update PortfolioProject..nashville_housing
Set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table PortfolioProject..nashville_housing
Add PropertySplitCity nVarchar(255);

update PortfolioProject..nashville_housing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))




Select *
From PortfolioProject..nashville_housing





Select OwnerAddress
From PortfolioProject..nashville_housing


Select
PARSENAME(Replace(OwnerAddress,',', '.'),3)
,PARSENAME(Replace(OwnerAddress,',', '.'),2)
,PARSENAME(Replace(OwnerAddress,',', '.'),1)
From PortfolioProject..nashville_housing


Alter Table PortfolioProject..nashville_housing
Add OwnerSplitAdress nVarchar(255);

update PortfolioProject..nashville_housing
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress,',', '.'),3)

Alter Table PortfolioProject..nashville_housing
Add OwnerSplitCity nVarchar(255);

update PortfolioProject..nashville_housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',', '.'),2)

Alter Table PortfolioProject..nashville_housing
Add OwnerSplitState nVarchar(255);

update PortfolioProject..nashville_housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',', '.'),1)

Select *
From PortfolioProject..nashville_housing

-------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "SoldasVacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..nashville_housing
Group By SoldAsVacant
Order by 2


Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldasVacant
	  End
From PortfolioProject..nashville_housing

Update  PortfolioProject..nashville_housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldasVacant
	  End

-----------------------------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE as (
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
				   [UniqueID ]
				   ) row_num
From PortfolioProject..nashville_housing
--Order By ParcelID
)
--Delete
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress
---------------------------------------------------------------------------------------------------------

--Delete unused Colomns

Select *
From PortfolioProject..nashville_housing

Alter Table PortfolioProject..nashville_housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
