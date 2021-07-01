SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ItemInsert]
(
@ItemStoreID uniqueidentifier,
@Name nvarchar(50),
@BarcodeNumber nvarchar(50),
@ItemCode nvarchar(50),
@CaseQty int,
@Price decimal(19,3),
@PriceByCase bit,
@Cost decimal(19,3),
@CostByCase bit,
@PriceA decimal(19,3),
@PriceB decimal(19,3),
@PriceC decimal(19,3),
@PriceD decimal(19,3),
@SupplierID uniqueidentifier,
@DepartmentID uniqueidentifier,
@Status bit,
@StoreID uniqueidentifier,
@ModifierID uniqueidentifier)

as
if (SELECT COUNT(*)
	FROM dbo.ItemStore
	WHERE ItemStoreID=@ItemStoreID)>0 RETURN


Declare @ID uniqueidentifier
Set @ID=NEWID()

INSERT INTO dbo.ItemMain
                   
      (ItemID,BarcodeType,ItemType,IsTemplate,IsSerial,Name,BarcodeNumber,ModalNumber,CaseQty,PriceByCase,CostByCase,Status, DateCreated, UserCreated, DateModified, UserModified)
       
VALUES
	   (@ID,0,0,0,0,dbo.CheckString(@Name),dbo.CheckString(@BarcodeNumber),dbo.CheckString(@ItemCode),ISNULL(@CaseQty,1),ISNULL(@PriceByCase,1),ISNULL(@CostByCase,1),1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)


INSERT INTO dbo.ItemStore
		(ItemStoreID,ItemNo,StoreNo,ProfitCalculation,CogsAccount,IncomeAccount,
		 CommissionType,BinLocation,IsTaxable,OnHand,OnOrder,IsDiscount,
		 IsFoodStampable,IsWIC,ReorderPoint,Cost,Price,PriceA,
		 PriceB,PriceC,PriceD,DepartmentID,Status, DateCreated, UserCreated, DateModified, UserModified)


VALUES
	   (@ItemStoreID,@ID,@StoreID,0,0,0,
		0,'',1,0,0,1,
		0,0,0,ROUND(ISNULL(@Cost,0),2),ROUND(ISNULL(@Price,0),2),ROUND(ISNULL(@PriceA,0),2),
        ROUND(ISNULL(@PriceB,0),2),ROUND(ISNULL(@PriceC,0),2),ROUND(ISNULL(@PriceD,0),2),(CASE WHEN @DepartmentID<> '00000000-0000-0000-0000-000000000000' Then @DepartmentID END),1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

if @SupplierID is not null
Exec Sync_UpdateItemSupply @ItemStoreID, @SupplierID, @ModifierID
GO