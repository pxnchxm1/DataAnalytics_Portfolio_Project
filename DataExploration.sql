use portfolio_10;

--To showcase entire nashvileHousing table
select * from nashvilleHousing;
------------------------------------------------------------------------
--Top 1000 rows
select top(1000) [UniqueID ],
                 [ParcelID],
				 [LandUse],
				 [PropertyAddress],
				 [SaleDate],
				 [SalePrice],
				 [LegalReference]
				 from nashvilleHousing;
-------------------------------------------------------------------------

--Standardize date format
select SaleDate,convert(date,SaleDate) from nashvilleHousing;
Alter table nashvilleHousing add SaleDateCorrected Date;
UPDATE nashvilleHousing set SaleDateCorrected=Convert(date,SaleDate);
Alter Table nashvilleHousing Drop column SaleDate;
sp_rename 'dbo.nashvilleHousing.SaleDateCorrected', 'SaleDate', 'COLUMN';
select * from nashvilleHousing;
--------------------------------------------------------------------------

--Property Address data
select * from nashvilleHousing 
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,
isnull(a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing a 
join
nashvilleHousing b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

Update a 
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing a 
join
nashvilleHousing b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;
------------------------------------------------------------------

--Breaking Address into address,state,city

--Property Address data
select PropertyAddress from nashvilleHousing ;
--delimitter ',' seperation check
select 
Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,(charindex(',',PropertyAddress)+1),len(PropertyAddress))
as City
from nashvilleHousing ;
--alter table and add two columns address and city
alter table nashvilleHousing add Address nvarchar(255) ,City nvarchar(255);

update nashvilleHousing set Address=Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) ;
update nashvilleHousing set City=Substring(PropertyAddress,(charindex(',',PropertyAddress)+1),len(PropertyAddress));
select Address,City from nashvilleHousing;

select OwnerAddress,PARSENAME(replace(OwnerAddress,',','.'),3) as Address,
PARSENAME(replace(OwnerAddress,',','.'),2) as City ,
PARSENAME(replace(OwnerAddress,',','.'),1) as State
from nashvilleHousing;

alter table nashvilleHousing add OwnerAddress1 nvarchar(255) ,OwnerCity nvarchar(255),OwnerState nvarchar(255);
update nashvilleHousing set OwnerAddress1= PARSENAME(replace(OwnerAddress,',','.'),3);
update nashvilleHousing set OwnerCity=PARSENAME(replace(OwnerAddress,',','.'),2);
update nashvilleHousing set OwnerState=PARSENAME(replace(OwnerAddress,',','.'),1);
select OwnerAddress1,OwnerCity,OwnerState from nashvilleHousing;
Alter table nashvilleHousing Drop column OwnerAddress;
sp_rename 'dbo.nashvilleHousing.OwnerAddress1', 'OwnerAddress', 'COLUMN';
select * from nashvilleHousing;