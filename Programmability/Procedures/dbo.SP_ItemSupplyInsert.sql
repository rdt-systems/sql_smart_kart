SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupplyInsert]
(@ItemSupplyID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@SupplierNo uniqueidentifier,
@TotalCost money = null,
@GrossCost money =0,
@MinimumQty int =0,
@QtyPerCase int= 0,
@IsOrderedOnlyInCase bit= null,
@AverageDeliveryDelay int= 0,
@ItemCode nvarchar(50)= null,
@IsMainSupplier bit=1,
@SortOrder smallint=1,
@Status smallint=1,
@ModifierID uniqueidentifier= null,
@CaseQty	decimal(18, 0)= null,
@SalePrice	money	= null,
@AssignDate	bit	= null,
@FromDate	datetime	= null,
@ToDate	datetime	= null,
@OnSpecialReq	bit	= null,
@MinQty	int	= null,
@MaxQty	int	= null,
@ColorName nvarchar(50) = NULL,
@SaveAsNain int = 1)

AS 

DECLARE @tmpItemSupplyID uniqueidentifier
if (SELECT Count(*) from ItemSupply where SupplierNo = @SupplierNo and ItemStoreNo =@ItemStoreNo and Status >0) =0
BEGIN
    SET @tmpItemSupplyID = @ItemSupplyID
    DECLARE @B As bit
    SET @B =@IsMainSupplier 
	IF (@IsMainSupplier = 0) OR (@IsMainSupplier IS NULL)
	BEGIN
		IF(SELECT Count(*) from ItemSupply where ItemStoreNo =@ItemStoreNo and Status >0)= 0
			BEGIN
					IF @SaveAsNain =1
					   SET @B =1
			End
	END

	  if @B = 1 and  (SELECT Count(*) from ItemSupply where IsMainSupplier = 1 and ItemStoreNo =@ItemStoreNo and Status >0)>0
			begin
			set @B=0
			end 

	INSERT INTO dbo.ItemSupply 
						  (ItemSupplyID, ItemStoreNo, SupplierNo, TotalCost,GrossCost, MinimumQty, QtyPerCase, IsOrderedOnlyInCase, AverageDeliveryDelay,ItemCode,IsMainSupplier, SortOrder, Status, 
						  DateCreated, UserCreated, DateModified, UserModified,CaseQty,SalePrice,AssignDate,FromDate,ToDate,OnSpecialReq,MinQty,MaxQty, ColorName)
	VALUES     (@ItemSupplyID, @ItemStoreNo, @SupplierNo, @TotalCost,@GrossCost, @MinimumQty, @QtyPerCase, @IsOrderedOnlyInCase, @AverageDeliveryDelay,@ItemCode, @B ,
						  @SortOrder, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@CaseQty,@SalePrice,@AssignDate,@FromDate,@ToDate,@OnSpecialReq,@MinQty,@MaxQty, @ColorName)

    IF @B =1 BEGIN

--	insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
--select ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost ,dbo.GetLocalDATE(),24,@ItemSupplyID
--  from  ItemStore 
--WHERE ItemStoreID=@ItemStoreNo

      UPDATE ItemStore SET MainSupplierID = @ItemSupplyID,DateModified=dbo.GetLocalDATE() WHERE ItemStoreID=@ItemStoreNo
    END
END						 
ELSE BEGIN
    SET @tmpItemSupplyID =(SELECT TOP(1)ItemSupplyID FROM ItemSupply  WHERE(ItemStoreNo =@ItemStoreNo) AND (SupplierNo=@SupplierNo) and Status >0)
    if IsNull(@ItemCode,'')='' 
      UPDATE ItemSupply SET Status =1,DateModified =dbo.GetLocalDATE() WHERE (ItemStoreNo =@ItemStoreNo) AND (SupplierNo=@SupplierNo) and ItemSupplyID=@tmpItemSupplyID
    else
	  UPDATE ItemSupply SET Status =1,ItemCode= @ItemCode,DateModified =dbo.GetLocalDATE() WHERE (ItemStoreNo =@ItemStoreNo) AND (SupplierNo=@SupplierNo) and ItemSupplyID=@tmpItemSupplyID
END

If @IsMainSupplier =1
Begin
--	insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
--select ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost ,dbo.GetLocalDATE(),25,@tmpItemSupplyID
--  from  ItemStore 
--WHERE ItemStoreID=@ItemStoreNo

	Update ItemSupply Set IsMainSupplier =0, DateModified = dbo.GetLocalDATE() Where ItemStoreNo = @ItemStoreNo And ItemSupplyID NOT IN (@tmpItemSupplyID)
	Update ItemSupply Set IsMainSupplier =1, DateModified = dbo.GetLocalDATE() Where ItemStoreNo = @ItemStoreNo And ItemSupplyID = @tmpItemSupplyID
	UPDATE    ItemStore Set MainSupplierID = @tmpItemSupplyID, DateModified = dbo.GetLocalDATE() Where ItemStoreID = @ItemStoreNo
End

Declare @ItemID uniqueidentifier
declare @vItemSupplyID uniqueidentifier
print 'A'
Declare @ItemStoreID uniqueidentifier
DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT        ItemStoreID
FROM            ItemStore
WHERE        (Status > 0) AND (ItemStoreID <> @ItemStoreNo) AND ItemNo in(select ItemNo from ItemStore WHERE ItemStoreID =@ItemStoreNo)

OPEN i
print 'B'
FETCH NEXT FROM i INTO @ItemStoreID
WHILE @@FETCH_STATUS = 0
	BEGIN
	  print 'C'
	  	  print @b
		  
--		    print '@ItemStoreNo='+convert(varchar(max),@ItemStoreNo )
--		  print '@IsMainSupplier='+convert(varchar(max),@IsMainSupplier )
--print '@ItemSupplyID='+convert(varchar(max),@ItemSupplyID )
--print '@SupplierNo='+convert(varchar(max),@SupplierNo )
	  if (SELECT Count(*) from ItemSupply where SupplierNo = @SupplierNo and ItemStoreNo =@ItemStoreID and Status >0) =0
	  
		  BEGIN
		   if @B = 1 and  (SELECT Count(*) from ItemSupply where IsMainSupplier = 1 and ItemStoreNo =@ItemStoreID and Status >0)>0
			begin
			set @B=0
			end 
			SET @vItemSupplyID=NewID()
				INSERT INTO dbo.ItemSupply
						(ItemSupplyID, ItemStoreNo, SupplierNo, TotalCost,GrossCost, MinimumQty, QtyPerCase, IsOrderedOnlyInCase, AverageDeliveryDelay,ItemCode,IsMainSupplier, ColorName, SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified)
				VALUES     (@vItemSupplyID, @ItemStoreID, @SupplierNo, @TotalCost,@GrossCost, @MinimumQty, @QtyPerCase, @IsOrderedOnlyInCase, @AverageDeliveryDelay,@ItemCode, @B , @ColorName,
							@SortOrder, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
		END
If @IsMainSupplier =1 

BEGIN
  print 'D'
    SET @ItemID = (Select ItemNo from ItemStore where ItemStoreID= @ItemStoreNo)
	  Update ItemSupply Set IsMainSupplier =0, DateModified = dbo.GetLocalDATE() Where ItemStoreNo in(Select ItemStoreID from Itemstore Where (ItemNo =@ItemID)) and (SupplierNo<>@SupplierNo)
	  Update  ItemSupply Set  IsMainSupplier =1, DateModified = dbo.GetLocalDATE() Where ItemStoreNo in(Select ItemStoreID from Itemstore Where (ItemNo =@ItemID)) and (SupplierNo=@SupplierNo) and Status>0
	    print 'E'
END
		IF @B =1
		BEGIN
		print 'F'
--			insert into itemstoreLog(ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue) 
--select ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost ,dbo.GetLocalDATE(),27 ,@vItemSupplyID
--  from  ItemStore 
--WHERE ItemStoreID=@ItemStoreID
	print 'G'
			UPDATE ItemStore SET MainSupplierID = @vItemSupplyID,DateModified=dbo.GetLocalDATE() Where ItemStoreID =@ItemStoreID
				print 'H'
		END

		FETCH NEXT FROM i    --insert the next values to the instance
			INTO @ItemStoreID
	END
CLOSE i
DEALLOCATE i
GO