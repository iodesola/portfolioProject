/*Selecting the data to use*/

Select * from PortfolioPorject..NashVille

--1.Standardised Date format
Select *, CONVERT(date, SaleDate) as NewSaleDate from PortfolioPorject..NashVille
Update PortfolioPorject..NashVille set SaleDate=CONVERT(date, SaleDate)

ALTER Table PortfolioPorject..NashVille
add SalesDateConverted Date;

Update PortfolioPorject..NashVille set SalesDateConverted=CONVERT(date, SaleDate)
Select * from PortfolioPorject..NashVille

--2. Populating Property Address data
Select * from PortfolioPorject..NashVille order by ParcelID 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioPorject..NashVille a 
	Join PortfolioPorject..NashVille b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Method 1 on to populate the Address Column
Update a Set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioPorject..NashVille a 
	Join PortfolioPorject..NashVille b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
	
--Method 2 on to populate the Address Column

/*update ta set PropertyAddress= tb.PropertyAddress from PortfolioPorject..pNashVille tb
	join PortfolioPorject..pNashVille ta 
	on ta.ParcelID=tb.ParcelID 
	Where ta.[UniqueID]<>tb.[UniqueID] AND tb.PropertyAddress  is not null */

Select * from PortfolioPorject..NashVille

--3: Breaking Out Address to Individual Category
select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as NewAdd,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as NewAdd2
from PortfolioPorject..NashVille

ALTER Table PortfolioPorject..NashVille
Add Address1 varchar(100), Address2 varchar(100)

update PortfolioPorject..NashVille set Address1=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1), 
Address2=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))

Select * from PortfolioPorject..NashVille

--3b. Brreakin OwnersAddress
select OwnerAddress from PortfolioPorject..NashVille order by OwnerAddress

--Here i used parse to separate the columns(Delimiter)
Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as flatStreetNo,
PARSENAME(REPLACE(OwnerAddress, ',','.'),2)as City,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)as Statem
from PortfolioPorject..NashVille

ALTER Table PortfolioPorject..NashVille
Add FlatStreetNo varchar(100), City varchar(100), StateN nvarchar(20)

update PortfolioPorject..NashVille Set 
	FlatStreetNo=PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
	City=PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
	StateN=PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

Select * from PortfolioPorject..NashVille

--4. Change Y & N in Sold As Vacant to Yes and No

Select DISTINCT(SoldAsVacant),count(SoldAsVacant) 
from PortfolioPorject..NashVille
Group by (SoldAsVacant)
order by 1,2 

update PortfolioPorject..NashVille set SoldAsVacant=case when SoldAsVacant='Y' Then 'Yes' when SoldAsVacant='N' Then 'No'
else SoldAsVacant
end


--5. REMOVE DUBLICATE
With CountDub As (Select *, ROW_NUMBER() OVER(
	Partition By ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
		Order by
				UniqueID
) as Row_num
from PortfolioPorject..NashVille
)
--select * from CountDub order by Row_num Desc
Select * from CountDub Where Row_num>1

--DELETE from CountDub Where Row_num>1
Select * from PortfolioPorject..NashVille

--6 Drop Unwanted Columns
ALTER Table PortfolioPorject..NashVille
	Drop Column SaleDate,PropertyAddress,OwnerAddress, TaxDistrict

Select * from PortfolioPorject..NashVille