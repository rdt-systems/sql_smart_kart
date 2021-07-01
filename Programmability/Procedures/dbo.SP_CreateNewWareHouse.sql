SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--Update ItemStore Set MainSupplierID = @SupplierID , DateModified =dbo.GetLocalDATE() Where ItemStoreID = @ItemID
CREATE PROCEDURE [dbo].[SP_CreateNewWareHouse]
(@NewStoreID uniqueidentifier,
@StoreID uniqueidentifier,
@UserID uniqueidentifier)

As 

--- New Supplier 
Declare @StoreName as Nvarchar(200) 
Set @StoreName= (Select StoreName From Store Where StoreID=@NewStoreID)

Declare @SupplierID as uniqueidentifier
Set @SupplierID=Newid()

INSERT INTO dbo.Supplier
                      (SupplierID, SupplierNo, [Name], DefaultCredit, WebSite, EmailAddress, MainAddress, ContactName, BarterID,WarehouseID, Status, DateCreated, UserCreated, 
                      DateModified, UserModified)
VALUES     (@SupplierID, @StoreName, dbo.CheckString(@StoreName), Null, Null, Null, Null,Null, Null,@NewStoreID, 1, dbo.GetLocalDATE(), 
                      @UserID, dbo.GetLocalDATE(), @UserID)


--Item Supplier

Update dbo.ItemSupply
Set IsMainSupplier = 0,		
    DateModified=dbo.GetLocalDATE()
Where Exists 
(Select *
 from  ItemStore
 WHERE Status>0 and StoreNo<>@NewStoreID And ItemSupply.ItemStoreNo=ItemStore.ItemStoreID)


INSERT INTO dbo.ItemSupply (ItemSupplyID,ItemStoreNo,SupplierNo,TotalCost,MinimumQty,QtyPerCase,IsOrderedOnlyInCase,AverageDeliveryDelay,
				ItemCode,IsMainSupplier,SortOrder, Status, DateCreated, UserCreated, DateModified, 
                                UserModified)
SELECT 	 NEWID(),ItemStoreID,@SupplierID,0,0,0,0,NUll,
				Null,1,Isnull((Select Count(*) From ItemSupply Where ItemSupply.ItemStoreNo=ItemStore.ItemStoreID and Status>0),0)+1  ,1, dbo.GetLocalDATE(), @UserID, dbo.GetLocalDATE(), 
                                @UserID 
from  ItemStore
WHERE Status>0 and StoreNo<>@NewStoreID

insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
select top 1 ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost ,dbo.GetLocalDATE(),33,(Select Top 1 ItemSupplyID  From ItemSupply where IsMainSupplier=1 And ItemSupply.ItemStoreNo=ItemStore.ItemStoreID)
  from  ItemStore 


Update ItemStore
Set MainSupplierID=(Select Top 1 ItemSupplyID  From ItemSupply where IsMainSupplier=1 And ItemSupply.ItemStoreNo=ItemStore.ItemStoreID)
GO