SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemStoreInsert]
(@ItemStoreID uniqueidentifier,
@ItemNo uniqueidentifier,
@StoreNo uniqueidentifier,
@DepartmentID uniqueidentifier,
@IsDiscount bit=1,
@IsTaxable bit=1,
@TaxID uniqueidentifier= NULL,
@IsFoodStampable bit= NULL,
@IsWIC bit= NULL,
@Cost money=0,
@ListPrice money=0,
@Price money,
@PriceA money=0,
@PriceB money=0,
@PriceC money=0,
@PriceD money=0,
@ExtraCharge1 uniqueidentifier= NULL,
@ExtraCharge2 uniqueidentifier= NULL,
@ExtraCharge3 uniqueidentifier= NULL,
@CogsAccount int= NULL,
@IncomeAccount int= NULL,
@ProfitCalculation int= 0,
@CommissionQty decimal(19, 3)= NULL,
@CommissionType int= 0,
@MainSupplierID uniqueidentifier= NULL,
@OnHand decimal(19, 3)=0,
@OnOrder decimal(19, 3)=0,
@OnTransferOrder decimal(19, 3)=0,
@ReorderPoint decimal=0,
@RestockLevel decimal=0,
@BinLocation nvarchar(50)= NULL,
@OnWorkOrder decimal=0,
@DaysForReturn int=0,
@AVGCost money =0,
@SalePrice money =0,
@SaleStartDate datetime = NULL,
@SaleEndDate datetime= NULL,
@SaleMin int= NULL,
@SaleMax int= NULL,
@MinForSale money= NULL,
@SpecialBuy int= NULL,
@SpecialPrice money= NULL,
@SpecialBuyFromDate datetime= NULL,
@SpecialBuyToDate datetime= NULL,
@NewPrice money= NULL,
@NewPriceDate datetime= NULL,
@SpecialsMemberOnly bit= NULL,
@CasePrice money= NULL,
@PkgPrice money= NULL,
@PkgQty int= NULL,
@Estimatedcost money= NULL,
@SpecialCost money= NULL,
@NetCost money= NULL,
@Status smallint= NULL,
@PrefSaleBy int=0,
@PrefOrderBy int=0,
@SaleType int=0,
@MixAndMatchID uniqueidentifier= NULL,
@AssignDate bit=null,
@RegCost money =Null,
@LoyaltyGroupID uniqueidentifier = null, 
@LoyaltyGroupFromDate DateTime = null,
@LoyaltyGroupToDate DateTime = null,
@Tare decimal(19,2)=0,
@ModifierID uniqueidentifier,
@WebPrice money =null,
@WebCasePrice money =null,
@SellOnWeb bit=null
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @ItID uniqueidentifier

IF EXISTS(SELECT * From ItemStore Where ItemStoreID = @ItemStoreID)
EXEC	 [dbo].[SP_ItemStoreUpdate]
@ItemStoreID = @ItemStoreID,@ItemNo = @ItemNo,@StoreNo = @StoreNo,@DepartmentID = @DepartmentID,@IsDiscount = @IsDiscount,@IsTaxable = @IsTaxable,@TaxID = @TaxID,@IsFoodStampable = @IsFoodStampable,@IsWIC = @IsWIC,@Cost = @Cost,@ListPrice = @ListPrice,
@Price = @Price,@PriceA = @PriceA,@PriceB = @PriceB,@PriceC = @PriceC,@PriceD = @PriceD,@ExtraCharge1 = @ExtraCharge1,@ExtraCharge2 = @ExtraCharge2,@ExtraCharge3 = @ExtraCharge3,@CogsAccount = @CogsAccount,@IncomeAccount = @IncomeAccount,@ProfitCalculation = @ProfitCalculation,
@CommissionQty = @CommissionQty,@CommissionType = @CommissionType,@PrefSaleBy = @PrefSaleBy,@PrefOrderBy = @PrefOrderBy,@MainSupplierID = @MainSupplierID,@OnHand = @OnHand,@OnOrder = @OnOrder,@OnTransferOrder = @OnTransferOrder,@ReorderPoint = @ReorderPoint,
@RestockLevel = @RestockLevel,@BinLocation = @BinLocation,@OnWorkOrder = @OnWorkOrder,@DaysForReturn = @DaysForReturn,@AVGCost = @AVGCost,@SaleType = @SaleType,@SalePrice = @SalePrice,@SaleStartDate = @SaleStartDate,@SaleEndDate = @SaleEndDate,@SaleMin = @SaleMin,
@SaleMax = @SaleMax,@MinForSale = @MinForSale,@SpecialBuy = @SpecialBuy,@SpecialPrice = @SpecialPrice,@SpecialBuyFromDate = @SpecialBuyFromDate,@SpecialBuyToDate = @SpecialBuyToDate,@AssignDate = @AssignDate,@MixAndMatchID = @MixAndMatchID,
@NewPrice = @NewPrice,@NewPriceDate = @NewPriceDate,@SpecialsMemberOnly = @SpecialsMemberOnly,@CasePrice = @CasePrice,@PkgPrice = @PkgPrice,@PkgQty = @PkgQty,@Tare = @Tare,@LoyaltyGroupID = @LoyaltyGroupID,@LoyaltyGroupFromDate = @LoyaltyGroupFromDate,
@LoyaltyGroupToDate = @LoyaltyGroupToDate,@RegCost = @RegCost,@SpecialCost = @SpecialCost,@NetCost = @NetCost,@Estimatedcost = @Estimatedcost,@WebPrice = @WebPrice,@WebCasePrice = @WebCasePrice,@SellOnWeb = @SellOnWeb,@Status = @Status,@DateModified = @UpdateTime,
@ModifierID = @ModifierID
ELSE
 INSERT INTO dbo.ItemStore
                      (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable,TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD,ExtraCharge1,ExtraCharge2,ExtraCharge3,
                      CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnHand, OnOrder,OnTransferOrder, ReorderPoint, 
                      RestockLevel, BinLocation, OnWorkOrder, DaysForReturn,AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, 
                      SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, NewPrice, NewPriceDate,SpecialsMemberOnly,CasePrice,PkgPrice,PkgQty, Status, DateCreated, UserCreated, DateModified, 
                      UserModified,LoyaltyGroupID,LoyaltyGroupFromDate,LoyaltyGroupToDate ,Tare,RegCost,SpecialCost,NetCost,Estimatedcost,WebPrice,WebCasePrice,SellOnWeb)
VALUES     (@ItemStoreID, @ItemNo, @StoreNo, @DepartmentID, @IsDiscount, @IsTaxable,@TaxID, @IsFoodStampable, @IsWIC, IsNull(@Cost,0), @ListPrice, IsNull(round(@Price,2),0), @PriceA,
                      @PriceB, @PriceC, @PriceD,@ExtraCharge1,@ExtraCharge2,@ExtraCharge3,@CogsAccount, @IncomeAccount, @ProfitCalculation, @CommissionQty, @CommissionType, @PrefSaleBy, 
                      @PrefOrderBy,@MainSupplierID, IsNull(@OnHand,0), @OnOrder,@OnTransferOrder, @ReorderPoint, @RestockLevel, @BinLocation, @OnWorkOrder, @DaysForReturn,@AVGCost, @SaleType, @SalePrice, 
                      @SaleStartDate, @SaleEndDate, @SaleMin, @SaleMax, @MinForSale, @SpecialBuy, @SpecialPrice, @SpecialBuyFromDate, @SpecialBuyToDate, 
                      @MixAndMatchID, @AssignDate, @NewPrice, @NewPriceDate,@SpecialsMemberOnly,@CasePrice,@PkgPrice,@PkgQty,ISNULL(@Status, 1), @UpdateTime, @ModifierID, @UpdateTime, @ModifierID,
                      @LoyaltyGroupID,@LoyaltyGroupFromDate,@LoyaltyGroupToDate ,@Tare,IsNull(@RegCost,IsNull(@Cost,0)),@SpecialCost,@NetCost,@Estimatedcost,@WebPrice,@WebCasePrice,@SellOnWeb)


select @UpdateTime as DateModified 

if @OnHand<>0 
begin
INSERT INTO dbo.AdjustInventory(AdjustInventoryId,ItemStoreNo,AdjustType,Qty,OldQty,AccountNo,Cost, Status, DateCreated, UserCreated, DateModified,UserModified)
VALUES 			       (newid(),        @ItemStoreID,4         ,@OnHand,0,  0,       @Cost,ISNULL(@Status, 1), dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
end 

--Update Matrix Parent

DECLARE @ID uniqueidentifier
SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

IF   (@ID is not null)
BEGIN
    UPDATE  dbo.ItemStore
     SET  OnHand =   (OnHand + ISNULL(@OnHand,0)), DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
    WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ID))

--insert group for all child items. if item is a matrix
declare @parentItemStoreID uniqueidentifier
set @parentItemStoreID = (select top(1) itemstoreid from ItemStore where itemno = @ID and status > -1)
 
INSERT INTO ItemToGroup (ItemToGroupID, ItemGroupID, ItemStoreID, Status, DateModified)
select NEWID() , ItemGroupID , @ItemStoreID , 1, dbo.GetLocalDATE() 
FROM ItemToGroup 
where ItemStoreID = @parentItemStoreID
END


--ALTER the item for all stores
Declare @StoreID uniqueidentifier
DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT  StoreID
FROM dbo.Store
WHERE StoreID<>@StoreNo

OPEN i

FETCH NEXT FROM i 
INTO @StoreID


WHILE @@FETCH_STATUS = 0
	BEGIN
SELECT @ItID = ItemStoreID From ItemStore Where ItemNo = @ItemNo and StoreNo = @StoreID
IF   (@ItID is not null)
		EXEC	 [dbo].[SP_ItemStoreUpdate]
		@ItemStoreID = @ItID,@ItemNo = @ItemNo,@StoreNo = @StoreID,@DepartmentID = @DepartmentID,@IsDiscount = @IsDiscount,@IsTaxable = @IsTaxable,@TaxID = @TaxID,@IsFoodStampable = @IsFoodStampable,@IsWIC = @IsWIC,@Cost = @Cost,@ListPrice = @ListPrice,
		@Price = @Price,@PriceA = @PriceA,@PriceB = @PriceB,@PriceC = @PriceC,@PriceD = @PriceD,@ExtraCharge1 = @ExtraCharge1,@ExtraCharge2 = @ExtraCharge2,@ExtraCharge3 = @ExtraCharge3,@CogsAccount = @CogsAccount,@IncomeAccount = @IncomeAccount,
		@ProfitCalculation = @ProfitCalculation,
		@CommissionQty = @CommissionQty,@CommissionType = @CommissionType,@PrefSaleBy = @PrefSaleBy,@PrefOrderBy = @PrefOrderBy,@MainSupplierID = @MainSupplierID,@OnHand = @OnHand,@OnOrder = @OnOrder,@OnTransferOrder = @OnTransferOrder,@ReorderPoint = @ReorderPoint,
		@RestockLevel = @RestockLevel,@BinLocation = @BinLocation,@OnWorkOrder = @OnWorkOrder,@DaysForReturn = @DaysForReturn,@AVGCost = @AVGCost,@SaleType = @SaleType,@SalePrice = @SalePrice,@SaleStartDate = @SaleStartDate,@SaleEndDate = @SaleEndDate,@SaleMin = @SaleMin,
		@SaleMax = @SaleMax,@MinForSale = @MinForSale,@SpecialBuy = @SpecialBuy,@SpecialPrice = @SpecialPrice,@SpecialBuyFromDate = @SpecialBuyFromDate,@SpecialBuyToDate = @SpecialBuyToDate,@AssignDate = @AssignDate,@MixAndMatchID = @MixAndMatchID,
		@NewPrice = @NewPrice,@NewPriceDate = @NewPriceDate,@SpecialsMemberOnly = @SpecialsMemberOnly,@CasePrice = @CasePrice,@PkgPrice = @PkgPrice,@PkgQty = @PkgQty,@Tare = @Tare,@LoyaltyGroupID = @LoyaltyGroupID,@LoyaltyGroupFromDate = @LoyaltyGroupFromDate,
		@LoyaltyGroupToDate = @LoyaltyGroupToDate,@RegCost = @RegCost,@SpecialCost = @SpecialCost,@NetCost = @NetCost,@Estimatedcost = @Estimatedcost,@WebPrice = @WebPrice,@WebCasePrice = @WebCasePrice,@SellOnWeb = @SellOnWeb,@Status = @Status,@DateModified = @UpdateTime,
		@ModifierID = @ModifierID
ELSE
		 INSERT INTO dbo.ItemStore
                      (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, 
                      CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, OnHand, OnOrder, ReorderPoint, 
                      RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, 
                      SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, NewPrice, NewPriceDate,MainSupplierID, Status, DateCreated, UserCreated, DateModified, 
                      UserModified,SpecialCost,NetCost,Estimatedcost,WebPrice,WebCasePrice,SellOnWeb)
		VALUES     (NEWID(), @ItemNo, @StoreID, @DepartmentID, @IsDiscount, @IsTaxable, @IsFoodStampable, @IsWIC, @Cost, @ListPrice, IsNull(@Price,0), @PriceA, 
                      @PriceB, @PriceC, @PriceD, @CogsAccount, @IncomeAccount, @ProfitCalculation, @CommissionQty, @CommissionType, @PrefSaleBy, 
                      @PrefOrderBy, 0, 0, @ReorderPoint, @RestockLevel, @BinLocation, 0, @DaysForReturn, @SaleType, @SalePrice, 
                      @SaleStartDate, @SaleEndDate, @SaleMin, @SaleMax, @MinForSale, @SpecialBuy, @SpecialPrice, @SpecialBuyFromDate, @SpecialBuyToDate, 
                      @MixAndMatchID, @AssignDate, @NewPrice, @NewPriceDate,@MainSupplierID, ISNULL(@Status, 1), dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@SpecialCost,@NetCost,@Estimatedcost,@WebPrice,@WebCasePrice,@SellOnWeb)
	FETCH NEXT FROM i    --insert the next values to the instance
		INTO @StoreID
	END

CLOSE i
DEALLOCATE i

declare @tmpOnHandTable table (onhand int)
insert into @tmpOnHandTable exec [dbo].[SP_UpdateOnHandOneItem] @StoreNo
GO