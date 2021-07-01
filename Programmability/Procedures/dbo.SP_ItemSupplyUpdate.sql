SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupplyUpdate](@ItemSupplyID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@SupplierNo uniqueidentifier,
@TotalCost money,
@GrossCost money =0,
@MinimumQty int,
@QtyPerCase int,
@IsOrderedOnlyInCase bit,
@AverageDeliveryDelay int,
@ItemCode nvarchar(50),
@IsMainSupplier bit,
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@CaseQty	decimal(18, 0)= null,
@SalePrice	money	= null,
@AssignDate	bit	= null,
@FromDate	datetime	= null,
@ToDate	datetime	= null,
@OnSpecialReq	bit	= null,
@MinQty	int	= null,
@ColorName nvarchar(50) = NULL,
@MaxQty	int	= null)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE    dbo.ItemSupply
SET              ItemStoreNo = @ItemStoreNo, SupplierNo = @SupplierNo, TotalCost = @TotalCost,GrossCost=@GrossCost, MinimumQty = @MinimumQty, QtyPerCase = 

@QtyPerCase, 
                      IsOrderedOnlyInCase = @IsOrderedOnlyInCase, AverageDeliveryDelay = @AverageDeliveryDelay, ItemCode = @ItemCode, ColorName = @ColorName,
                      IsMainSupplier = 0, SortOrder = @SortOrder, Status = IsNull(@Status,1), UserCreated= @ModifierID, 
                      DateModified = @UpdateTime, UserModified = @ModifierID
WHERE     (ItemSupplyID = @ItemSupplyID) 

Declare @ItemID uniqueidentifier
SET @ItemID = (Select ItemNo from ItemStore where ItemStoreID= @ItemStoreNo)
 
If @IsMainSupplier =1 
BEGIN
  Update ItemSupply Set IsMainSupplier =0, DateModified = dbo.GetLocalDATE() Where ItemStoreNo in(Select ItemStoreID from Itemstore Where (ItemNo =@ItemID)) and (SupplierNo<>@SupplierNo)
  Update ItemSupply Set IsMainSupplier =1, DateModified = dbo.GetLocalDATE() Where ItemStoreNo in(Select ItemStoreID from Itemstore Where (ItemNo =@ItemID)) and (SupplierNo=@SupplierNo) and Status>0 

--  insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
--select ItemStore.ItemStoreID,
--ItemStore.ItemNo,
--ItemStore.StoreNo,
--ItemStore.DepartmentID,
--ItemStore.IsDiscount,
--ItemStore.IsTaxable,
--ItemStore.TaxID,
--ItemStore.IsFoodStampable,
--ItemStore.IsWIC,
--ItemStore.Cost,
--ItemStore.ListPrice,
--ItemStore.Price,
--ItemStore.PriceA,
--ItemStore.PriceB,
--ItemStore.PriceC,
--ItemStore.PriceD,
--ItemStore.ExtraCharge1,
--ItemStore.ExtraCharge2,
--ItemStore.ExtraCharge3,
--ItemStore.CogsAccount,
--ItemStore.IncomeAccount,
--ItemStore.ProfitCalculation,
--ItemStore.CommissionQty,
--ItemStore.CommissionType,
--ItemStore.PrefSaleBy,
--ItemStore.PrefOrderBy,
--ItemStore.MainSupplierID,
--ItemStore.OnOrder,
--ItemStore.OnTransferOrder,
--ItemStore.OnHand,
--ItemStore.ReorderPoint,
--ItemStore.RestockLevel,
--ItemStore.BinLocation,
--ItemStore.OnWorkOrder,
--ItemStore.DaysForReturn,
--ItemStore.AVGCost,
--ItemStore.SaleType,
--ItemStore.SalePrice,
--ItemStore.SaleStartDate,
--ItemStore.SaleEndDate,
--ItemStore.SaleMin,
--ItemStore.SaleMax,
--ItemStore.MinForSale,
--ItemStore.SpecialBuy,
--ItemStore.SpecialPrice,
--ItemStore.SpecialBuyFromDate,
--ItemStore.SpecialBuyToDate,
--ItemStore.MixAndMatchID,
--ItemStore.AssignDate,
--ItemStore.Status,
--ItemStore.MTDQty,
--ItemStore.MTDDollar,
--ItemStore.PTDQty,
--ItemStore.PTDDollar,
--ItemStore.YTDQty,
--ItemStore.YTDDollar,
--ItemStore.MTDReturnQty,
--ItemStore.PTDReturnQty,
--ItemStore.YTDReturnQty,
--ItemStore.DateCreated,
--ItemStore.UserCreated,
--ItemStore.DateModified,
--ItemStore.UserModified,
--ItemStore.TDDate,
--ItemStore.TDReturnDate,
--ItemStore.NewPrice,
--ItemStore.NewPriceDate,
--ItemStore.SpecialsMemberOnly,
--ItemStore.CasePrice,
--ItemStore.CaseSpecial,
--ItemStore.PkgPrice,
--ItemStore.PkgQty,
--ItemStore.IsCaseDiscount,
--ItemStore.IsPkgDiscount,
--ItemStore.Tare,
--ItemStore.RegCost,
--ItemStore.LoyaltyGroupID,
--ItemStore.LoyaltyGroupFromDate,
--ItemStore.LoyaltyGroupToDate,
--ItemStore.VoidReason,
--ItemStore.LastCount,
--ItemStore.CountDate,
--ItemStore.CountOnHand,
--ItemStore.RegSalePrice,
--ItemStore.LastSoldDate,
--ItemStore.LastReceivedDate,
--ItemStore.LastReceivedQty,
--ItemStore.SpecialCost,
--ItemStore.NetCost,
--ItemStore.EstimatedCost,
--dbo.GetLocalDATE(),22,ItemSupply.ItemSupplyID
--  from  ItemStore INNER JOIN
--                         ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo 
--where ItemNo=@ItemID and SupplierNo=@SupplierNo  and ItemSupply.Status>0

UPDATE       ItemStore
SET                MainSupplierID =ItemSupply.ItemSupplyID
FROM            ItemStore INNER JOIN
                         ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo 
where ItemNo=@ItemID and SupplierNo=@SupplierNo  and ItemSupply.Status>0

  --Update ItemSupply Set IsMainSupplier =0, DateModified = dbo.GetLocalDATE() Where ItemStoreNo = @ItemStoreNo And ItemSupplyID NOT IN (@ItemSupplyID)
  --UPDATE    ItemStore Set MainSupplierID = @ItemSupplyID, DateModified = dbo.GetLocalDATE() Where ItemStoreID = @ItemStoreNo
END

select @UpdateTime as DateModified
GO