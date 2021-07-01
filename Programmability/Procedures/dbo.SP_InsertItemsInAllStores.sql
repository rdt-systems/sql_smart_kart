SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <11/6/2015>
-- Description:	<Make sure Item is in all stores with suppliers>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertItemsInAllStores]
	
AS
BEGIN
declare @IsInStore uniqueidentifier
DECLARE f CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT  StoreID
FROM dbo.Store
Open f
FETCH NEXT FROM f
Into @IsInStore
WHILE @@FETCH_STATUS = 0
Begin

Declare @StoreID uniqueidentifier
DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT  StoreID
FROM dbo.Store
WHERE StoreID<>@IsInStore

OPEN i

FETCH NEXT FROM i 
INTO @StoreID


WHILE @@FETCH_STATUS = 0
	BEGIN

Insert Into ItemStore (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, 
                         CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, 
                         OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, 
                         AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, 
                         NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, CountDate, CountOnHand, LastCount, LoyaltyGroupFromDate, LoyaltyGroupID, LoyaltyGroupToDate, 
                         RegCost, Tare, VoidReason, CaseSpecial, LastReceivedDate, LastReceivedQty, LastSoldDate, RegSalePrice)

SELECT      NEWID() AS  ItemStoreID, ItemNo, @StoreID AS StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, 
                         CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, 
                         OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, 
                         AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, 
                         NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, CountDate, CountOnHand, LastCount, LoyaltyGroupFromDate, LoyaltyGroupID, LoyaltyGroupToDate, 
                         RegCost, Tare, VoidReason, CaseSpecial, LastReceivedDate, LastReceivedQty, LastSoldDate, RegSalePrice
FROM            dbo.ItemStore WITH (NOLOCK)
WHERE        (StoreNo = @IsInStore) AND (ItemNo NOT IN
                             (SELECT        ItemNo
                               FROM            dbo.ItemStore WITH (NOLOCK)
                               WHERE        (StoreNo = @StoreID)))

INSERT INTO ItemToGroup (ItemToGroupID, ItemGroupID, ItemStoreID,Status, DateModified)
Select NEWID(), G.ItemGroupID, A.ItemStoreID, G.Status, dbo.GetLocalDate()
From dbo.ItemToGroup G WITH (NOLOCK) INNER JOIN dbo.ItemStore S WITH (NOLOCK) ON G.ItemStoreID = S.ItemStoreID AND G.Status > 0 AND S.StoreNo = @IsInStore INNER JOIN dbo.ItemStore A WITH (NOLOCK) ON S.ItemNo = A.ItemNo AND A.StoreNo = @StoreID 
Where NOT EXISTS(Select 1 From dbo.ItemToGroup GG WITH (NOLOCK) Where GG.ItemStoreID = A.ItemStoreID AND GG.ItemGroupID = G.ItemGroupID)

INSERT INTO ItemSupply(ItemSupplyID, ItemStoreNo, SupplierNo, ItemCode, IsMainSupplier, SortOrder, Status, DateCreated, DateModified)
Select NEWID(), A.ItemStoreID, P.SupplierNo, P.ItemCode, P.IsMainSupplier, P.SortOrder, P.Status, P.DateCreated, dbo.GetLocalDate()
From dbo.ItemSupply P WITH (NOLOCK) INNER JOIN dbo.ItemStore S WITH (NOLOCK) ON P.ItemStoreNo = S.ItemStoreID AND P.Status > 0 AND S.StoreNo = @IsInStore INNER JOIN dbo.ItemStore A WITH (NOLOCK) ON S.ItemNo = A.ItemNo AND A.StoreNo = @StoreID 
Where NOT EXISTS(Select 1 From dbo.ItemSupply PP WITH (NOLOCK) Where PP.ItemStoreNo = A.ItemStoreID AND PP.SupplierNo = P.SupplierNo)

	FETCH NEXT FROM i    --insert the next values to the instance
		INTO @StoreID
	END

CLOSE i
DEALLOCATE i

FETCH NEXT FROM f
Into @IsInStore
END

Close f
DEALLOCATE f
END
GO