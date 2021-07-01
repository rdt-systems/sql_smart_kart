SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ItemUpdate]
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
@StoreID uniqueidentifier,
@Status bit,
@DateModified datetime=null,
@ModifierID uniqueidentifier
)
as

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
Declare @ItemNo uniqueidentifier
Set @ItemNo=(Select Top 1 ItemNo
			 From ItemStore
			 Where ItemStoreID=@ItemStoreID)

UPDATE dbo.ItemStore
SET
	StoreNo=@StoreID,       
    Cost = ROUND(ISNULL(@Cost,0),2),
    Price = ROUND(ISNULL(@Price,0),2),
	PriceA = ROUND(ISNULL(@PriceA,0),2),
	PriceB = ROUND(ISNULL(@PriceB,0),2),
	PriceC = ROUND(ISNULL(@PriceC,0),2),
	PriceD = ROUND(ISNULL(@PriceD,0),2),
    DepartmentID=(CASE WHEN @DepartmentID <> '00000000-0000-0000-0000-000000000000' Then @DepartmentID END),
    DateModified = @UpdateTime, 
	UserModified = @ModifierID

WHERE ItemStoreID=@ItemStoreID --AND (DateModified = @DateModified OR DateModified IS NULL)


UPDATE dbo.ItemMain
SET   
    Name = dbo.CheckString(@Name),
    BarcodeNumber = dbo.CheckString(@BarcodeNumber),
    ModalNumber = dbo.CheckString(@ItemCode),
    CaseQty = @CaseQty,
    PriceByCase = @PriceByCase,
    CostByCase = @CostByCase,
    DateModified = @UpdateTime, 
	UserModified = @ModifierID
WHERE ItemID=@ItemNo --AND (DateModified = @DateModified OR DateModified IS NULL)

--select @UpdateTime as DateModified 

  if @SupplierID is not null
Exec Sync_UpdateItemSupply @ItemStoreID, @SupplierID, @ModifierID
GO