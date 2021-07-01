SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 

  CREATE PROCEDURE [dbo].[SP_ItemStoreUpdate]
(@ItemStoreID uniqueidentifier,
@ItemNo uniqueidentifier,
@StoreNo uniqueidentifier,
@DepartmentID uniqueidentifier,
@IsDiscount bit=1,
@IsTaxable bit=1,
@TaxID uniqueidentifier =NULL,
@IsFoodStampable bit =NULL,
@IsWIC bit =NULL,
@Cost money =NULL,
@ListPrice money =0,
@Price money,
@PriceA money =0,
@PriceB money =0,
@PriceC money =0,
@PriceD money =0,
@ExtraCharge1 uniqueidentifier =NULL,
@ExtraCharge2 uniqueidentifier =NULL,
@ExtraCharge3 uniqueidentifier=NULL,
@CogsAccount int=NULL,
@IncomeAccount int=NULL,
@ProfitCalculation int=0,
@CommissionQty decimal(19, 3)=NULL,
@CommissionType int=0,
@PrefSaleBy int=0,
@PrefOrderBy int=0,
@MainSupplierID uniqueidentifier=NULL,
@OnHand decimal(19, 3)=0,
@OnOrder decimal(19, 3)=0,
@OnTransferOrder decimal(19, 3)=0,
@ReorderPoint decimal=0,
@RestockLevel decimal=0,
@BinLocation nvarchar(50)=null,
@OnWorkOrder decimal=0,
@DaysForReturn int=0,
@AVGCost money=0,
@SaleType int=null,
@SalePrice money=0,
@SaleStartDate  datetime=null,
@SaleEndDate datetime=null,
@SaleMin int=null,
@SaleMax int=null,
@MinForSale money=null,
@SpecialBuy int=null,
@SpecialPrice money=null,
@SpecialBuyFromDate datetime=null,
@SpecialBuyToDate datetime=null,
@AssignDate bit=null,
@MixAndMatchID uniqueidentifier=null,
@NewPrice money=null,
@NewPriceDate datetime=null,
@SpecialsMemberOnly bit=null,
@CasePrice money=null,
@PkgPrice money=null,
@PkgQty int=null,
@Tare decimal(19, 2)=null,
@LoyaltyGroupID uniqueidentifier = null,
@LoyaltyGroupFromDate DateTime = null,
@LoyaltyGroupToDate DateTime = null,
@RegCost money = null,
@SpecialCost money = null,
@NetCost money = null,
@Estimatedcost money = null,
@WebPrice money =null,
@WebCasePrice money =null,
@SellOnWeb bit=null,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

--IF (SELECT COUNT(*) from SetUpValues where OptionID = 224 and OptionValue IS NOT NULL AND (OptionValue = '1' OR OptionValue = 'True') AND StoreID <> '00000000-0000-0000-0000-000000000000') >0
--BEGIN

--insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCREATE, UserCREATE, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, DateCREATElog, step, MainSupplierIDValue)
--select ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCREATE, UserCREATE, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost,dbo.GetLocalDATE(),55,@MainSupplierID
--  from  ItemStore
--Where (ItemStoreID = @ItemStoreID)
--and status > -1

--UPDATE      dbo.ItemStore
--SET         DepartmentID=@DepartmentID,
--            IsDiscount=@IsDiscount,
--            IsTaxable = @IsTaxable,
--            TaxID = @TaxID,
--            IsFoodStampable=@IsFoodStampable,
--            IsWIC=@IsWIC,
--            Cost =@Cost,
--            ListPrice = @ListPrice,
--            Price = @Price,
--            PriceA = @PriceA,
--            PriceB = @PriceB,
--            PriceC = @PriceC,
--            PriceD = @PriceD,  
--            ExtraCharge1 = @ExtraCharge1,
--            ExtraCharge2 = @ExtraCharge2,
--            ExtraCharge3 = @ExtraCharge3,
--            CogsAccount = @CogsAccount,
--            IncomeAccount = @IncomeAccount,
--            ProfitCalculation = @ProfitCalculation,
--            CommissionQty = @CommissionQty,
--            CommissionType = @CommissionType,
--            PrefSaleBy=@PrefSaleBy,
--            PrefOrderBy=@PrefOrderBy,
--            --MainSupplierID=@MainSupplierID,
--            --OnHand = @OnHand,
--            OnOrder = @OnOrder,
--            OnTransferOrder = @OnTransferOrder,
--            ReorderPoint = @ReorderPoint,
--            RestockLevel = @RestockLevel,
--            BinLocation = @BinLocation,
--            DaysForReturn = @DaysForReturn,
--            AVGCost=@AVGCost,
--            SaleType=@SaleType,
--            SalePrice=@SalePrice,
--            SaleStartDate=@SaleStartDate,
--            SaleEndDate=@SaleEndDate,
--            SaleMin=@SaleMin,
--            SaleMax=@SaleMax,
--            MinForSale=@MinForSale,
--            SpecialBuy=@SpecialBuy,
--            SpecialPrice=@SpecialPrice,
--            SpecialBuyFromDate=@SpecialBuyFromDate,
--            SpecialBuyToDate=@SpecialBuyToDate,
--            AssignDate =@AssignDate,
--            MixAndMatchID=@MixAndMatchID,
--            NewPrice=@NewPrice,
--            NewPriceDate=@NewPriceDate,
--            SpecialsMemberOnly = @SpecialsMemberOnly,
--            CasePrice = @CasePrice,
--            PkgPrice = PkgPrice,
--            @PkgQty = PkgQty,
--            SpecialCost=@SpecialCost,
--            NetCost=@NetCost,
--            Estimatedcost=@Estimatedcost,
--            Status = IsNull(@Status,1),
--            Tare = @Tare ,
--            LoyaltyGroupID=@LoyaltyGroupID,
--            LoyaltyGroupFromDate=@LoyaltyGroupFromDate,
--            LoyaltyGroupToDate=@LoyaltyGroupToDate,
--            RegCost =@RegCost,
--            OnWorkOrder = @OnWorkOrder,
--            DateModified =@UpdateTime,
--            UserModified = @ModifierID
            
--WHERE     (ItemNo = @ItemNo) --AND (DateModified = @DateModified OR DateModified IS NULL)
--and status > -1


--UPDATE      dbo.ItemStore
--SET        
--            MainSupplierID=@MainSupplierID
--Where (ItemStoreID = @ItemStoreID) --AND (DateModified = @DateModified OR DateModified IS NULL)
--and status > -1
--END

--ELSE BEGIN

--insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCREATE, UserCREATE, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, DateCREATElog, step, MainSupplierIDValue)
--select ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCREATE, UserCREATE, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost ,dbo.GetLocalDATE(),21,@MainSupplierID
--  from  ItemStore
--Where (ItemStoreID = @ItemStoreID)

UPDATE      dbo.ItemStore
SET         
            ItemNo = @ItemNo,
            StoreNo = @StoreNo,
            DepartmentID=@DepartmentID,
            IsDiscount=@IsDiscount,
            IsTaxable = @IsTaxable,
            TaxID = @TaxID,
            IsFoodStampable=@IsFoodStampable,
            IsWIC=@IsWIC,
            Cost = @Cost,
            ListPrice = @ListPrice,
            Price = ROUND(@Price,2),
            PriceA = @PriceA,
            PriceB = @PriceB,
            PriceC = @PriceC,
            PriceD = @PriceD,  
            ExtraCharge1 = @ExtraCharge1,
            ExtraCharge2 = @ExtraCharge2,
            ExtraCharge3 = @ExtraCharge3,
            CogsAccount = @CogsAccount,
            IncomeAccount = @IncomeAccount,
            ProfitCalculation = @ProfitCalculation,
            CommissionQty = @CommissionQty,
            CommissionType = @CommissionType,
            PrefSaleBy=@PrefSaleBy,
            PrefOrderBy=@PrefOrderBy,
            MainSupplierID=@MainSupplierID,
            --OnHand = @OnHand,
            OnOrder = @OnOrder,
            OnTransferOrder = @OnTransferOrder,
            ReorderPoint = @ReorderPoint,
            RestockLevel = @RestockLevel,
            BinLocation = @BinLocation,
            DaysForReturn = @DaysForReturn,
            AVGCost=@AVGCost,
            SaleType=@SaleType,
            SalePrice=@SalePrice,
            SaleStartDate=@SaleStartDate,
            SaleEndDate=@SaleEndDate,
            SaleMin=@SaleMin,
            SaleMax=@SaleMax,
            MinForSale=@MinForSale,
            SpecialBuy=@SpecialBuy,
            SpecialPrice=@SpecialPrice,
            SpecialBuyFromDate=@SpecialBuyFromDate,
            SpecialBuyToDate=@SpecialBuyToDate,
            AssignDate =@AssignDate,
            MixAndMatchID=@MixAndMatchID,
            NewPrice=@NewPrice,
            NewPriceDate=@NewPriceDate,
            SpecialsMemberOnly = @SpecialsMemberOnly,
            CasePrice = @CasePrice,
            PkgPrice = @PkgPrice,
            PkgQty = @PkgQty,
            SpecialCost=@SpecialCost,
            NetCost=@NetCost,
            Estimatedcost=@Estimatedcost,
            Status = IsNull(@Status,1),
            Tare = @Tare ,
            LoyaltyGroupID=@LoyaltyGroupID,
            LoyaltyGroupFromDate=@LoyaltyGroupFromDate,
            LoyaltyGroupToDate=@LoyaltyGroupToDate,
            RegCost =@RegCost,
            OnWorkOrder = @OnWorkOrder,
            WebPrice=@WebPrice ,
            WebCasePrice=@WebCasePrice ,
            SellOnWeb=@SellOnWeb ,
            DateModified =@UpdateTime,
            UserModified = @ModifierID
            
WHERE     (ItemStoreID = @ItemStoreID) --AND (DateModified = @DateModified OR DateModified IS NULL)
--END


--update all departments.
Update ItemStore Set DepartmentID = @DepartmentID Where ItemNO = @ItemNo

--update other matrix items.
declare @itemType int
set @itemType = (select itemtype from ItemMain Where ItemId = @ItemNo)

If @ItemType = 2
begin
Update ItemStore Set DepartmentID = @DepartmentID
From ItemStore inner Join ItemMain on ItemID = ItemNo
Where LinkNo = @ItemNo
end

Update ItemMain Set DateModified = dbo.GetLocalDATE() where ItemID = @ItemNo

declare @tmpOnHandTable table (onhand int)
insert into @tmpOnHandTable exec [dbo].[SP_UpdateOnHandOneItem] @StoreNo

select @UpdateTime as DateModified
GO