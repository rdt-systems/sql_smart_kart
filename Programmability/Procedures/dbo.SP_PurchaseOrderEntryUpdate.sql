SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrderEntryUpdate]
(@PurchaseOrderEntryId uniqueidentifier, 
@PurchaseOrderNo uniqueidentifier, 
@ItemNo uniqueidentifier, 
@QtyOrdered decimal(19, 3), 
@PricePerUnit  money,
@ExtPrice  money,
@UOMQty int,
@UOMType decimal,
@IsSpecialPrice Bit,
@LinkNo uniqueidentifier, 
@Note nvarchar (4000),
@SortOrder int,
@Status Smallint,
@DateModified datetime,
@ModifierID  uniqueidentifier,
@CostBeforeDis money = 0,
@EstimateCost money = 0,
@SupplierNo uniqueidentifier = null,
@Discount money = NULL,
@DiscountType int = NULL,
@NetCost money = 0,
@SpecialCost money = 0) 
     
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


Declare @OldItem uniqueidentifier
SET @OldItem =(SELECT ItemNo FROM dbo.PurchaseOrderEntry WHERE  PurchaseOrderEntryId = @PurchaseOrderEntryId)
DECLARE @OldQty decimal
SET @OldQty = (SELECT QtyOrdered FROM dbo.PurchaseOrderEntry WHERE  PurchaseOrderEntryId = @PurchaseOrderEntryId)

UPDATE  dbo.PurchaseOrderEntry        
SET    PurchaseOrderNo = @PurchaseOrderNo, ItemNo = @ItemNo,QtyOrdered = @QtyOrdered, PricePerUnit = @PricePerUnit,ExtPrice=@ExtPrice,      
          UOMQty = @UOMQty,  UOMType =@UOMType,IsSpecialPrice=@IsSpecialPrice,  LinkNo = @LinkNo, Note = @Note,SortOrder=@SortOrder, Status = @Status, 
		  CostBeforeDis = @CostBeforeDis, EstimateCost = @EstimateCost, DateModified = @UpdateTime,  UserModified = @ModifierID
        ,NetCost=@NetCost,SpecialCost=@SpecialCost, Discount = @Discount, DiscountType = @DiscountType

WHERE  (PurchaseOrderEntryId = @PurchaseOrderEntryId) and  (DateModified = @DateModified or DateModified is NULL)

--Alex Abreu 6/20/16
--Update the net cost for each item
if @NetCost > 0
Begin
	Update itemstore set Netcost = @NetCost where itemstoreid = @ItemNo
	Update ItemStore Set NetCost = @NetCost Where ItemNo = (Select TOP(1)LinkNo From ChildView Where ItemStoreID = @ItemNo)
End

if @@ROWCOUNT=0 return

exec UpdateOnOrderByOrder @ItemNo,@ModifierID

select @UpdateTime as DateModified
GO