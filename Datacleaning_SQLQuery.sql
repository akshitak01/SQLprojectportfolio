-- Cleaning Data using SQL Queries

Select *
From [Project Portfolio].dbo.[Nashville Housing Data]

-- Standardizing data format

Select SaleDate, Convert (Date, SaleDate) as SalesDate
From [Project Portfolio].dbo.[Nashville Housing Data]


-- Converting Sale date format

Select SaleDateConverted, Convert(Date,Saledate) as SalesDate
From [Project Portfolio].dbo.[Nashville Housing Data]

Update [Nashville Housing Data]
Set SaleDate = Convert(Date, SaleDate)

Alter Table [Nashville Housing Data]
Add SaleDateConverted Date; 

Update [Nashville Housing Data]
Set SaleDateConverted = Convert(Date, SaleDate)

-- Populate Property Address Data

Select * 
From [Project Portfolio].dbo.[Nashville Housing Data]
Order by ParcelID

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress) 
From [Project Portfolio].dbo.[Nashville Housing Data] A
Join [Project Portfolio].dbo.[Nashville Housing Data] B
	 on A. ParcelID = B.ParcelID
	 AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress = NULL	

Update A
Set PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress) 
From [Project Portfolio].dbo.[Nashville Housing Data] A
Join [Project Portfolio].dbo.[Nashville Housing Data] B
	 on A. ParcelID = B.ParcelID
	 AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress = NULL	

-- Breaking out Address column into individual sections like Address, City, State.


Select PropertyAddress
From [Project Portfolio].dbo.[Nashville Housing Data]

Select 
Substring (PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address,
Substring (PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From [Project Portfolio].dbo.[Nashville Housing Data]

Alter Table [Nashville Housing Data]
Add PropertySplitAddresss Nvarchar(255); 


Update [Nashville Housing Data]
Set PropertySplitAddresss = Substring (PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter Table [Nashville Housing Data]
Add PropertySplitCity Nvarchar(255); 

Update [Nashville Housing Data]
Set PropertySplitCity = Substring (PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) 


Select*

From [Project Portfolio].dbo.[Nashville Housing Data]



-- Doing the exact same thing for Owner Address using a different query

Select OwnerAddress
From [Project Portfolio].dbo.[Nashville Housing Data]

Select
Parsename(replace(OwnerAddress, ',', '.'), 3),
Parsename(replace(OwnerAddress, ',', '.'), 2),
Parsename(replace(OwnerAddress, ',', '.'), 1)
From [Project Portfolio].dbo.[Nashville Housing Data]


Alter Table [Nashville Housing Data]
Add OwnerSplitAddresss Nvarchar(255); 


Update [Nashville Housing Data]
Set OwnerSplitAddresss = Parsename(replace(OwnerAddress, ',', '.'), 3)

Alter Table [Nashville Housing Data]
Add OwnerSplitCity Nvarchar(255); 


Update [Nashville Housing Data]
Set OwnerSplitCity = Parsename(replace(OwnerAddress, ',', '.'), 2)

Alter Table [Nashville Housing Data]
Add OwnerSplitState Nvarchar(255); 


Update [Nashville Housing Data]
Set OwnerSplitState = Parsename(replace(OwnerAddress, ',', '.'), 1)


Select *
From [Project Portfolio].dbo.[Nashville Housing Data]


-- Changing Y or N to Yes and NO in Sold as Vacant Column

Select Distinct(SoldasVacant), Count (SoldasVacant)
From [Project Portfolio].dbo.[Nashville Housing Data]
Group by SoldAsVacant
Order by 2

Select SoldasVacant,

CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 Else SoldAsVacant
END
From [Project Portfolio].dbo.[Nashville Housing Data]

Update [Nashville Housing Data]
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END




-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


-- Removing Unused columns

Select *
From [Project Portfolio].dbo.[Nashville Housing Data]

Alter Table [Project Portfolio].dbo.[Nashville Housing Data]
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Select *
Alter Table [Project Portfolio].dbo.[Nashville Housing Data]
Drop column SaleDate



