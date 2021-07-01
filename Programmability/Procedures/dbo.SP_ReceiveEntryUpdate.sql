SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveEntryUpdate]
(@ReceiveEntryID uniqueidentifier,
@ReceiveNo uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@PurchaseOrderEntryNo uniqueidentifier,
@RealCost Money, 
@Qty decimal(18,5),
@ExtPrice Money,
@ForApprove Bit,
@UOMQty decimal(18,5),
@UOMType int,
@IsSpecialPrice Bit,
@LinkNo uniqueidentifier = NULL,
@Note nvarchar(4000), 
@SortOrder int,
@Taxable bit,
@NetCost Money,
@Status  smallint, 
@DateModified datetime,
@CaseCost Money=0,
@PcCost Money=0,
@CaseQty decimal =1,
@PriceStatus tinyint =0,
@LastNetCost Money=0,
@ModifierID uniqueidentifier,
@SupplierNo uniqueidentifier = null,
@EstimatedPrice money=0,
@DiscountType int =null,
@Discount money = 0)
AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

IF @CaseQty = 0
SET @CaseQty = 1

IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreNo)) NOT IN (3,5,7,9)

UPDATE ItemStore SET    OnHand = (ItemStore.OnHand - ReceiveEntry.Qty)
FROM ItemStore RIGHT OUTER JOIN  ReceiveEntry ON ItemStore.ItemStoreID = ReceiveEntry.ItemStoreNo WHERE (ReceiveEntryID = @ReceiveEntryID) 

UPDATE  dbo.ReceiveEntry              
SET     ReceiveNo = @ReceiveNo, 
  ItemStoreNo =@ItemStoreNo,  
  PurchaseOrderEntryNo = @PurchaseOrderEntryNo,
  Cost = @RealCost, 
  Qty = @Qty,
  ExtPrice=@ExtPrice,
  ForApprove=@ForApprove,
  UOMQty = @UOMQty, 
  UOMType= @UOMType, 
  IsSpecialPrice=@IsSpecialPrice, 
  Note = @Note, 
  SortOrder=@SortOrder,
  Taxable=@Taxable,
  NetCost =@NetCost,
  Status = isnull( @Status,1),  
  DateModified = @UpdateTime, 
  CaseCost = @CaseCost,
  PcCost = @PcCost,
  CaseQty = @CaseQty,
  LastNetCost = @LastNetCost,
  PriceStatus= @PriceStatus,       
  UserModified = @ModifierID,
  EstimatedPrice = @EstimatedPrice,
  DiscountType = @DiscountType ,
  Discount= @Discount,
  NetPcCost=@NetCost/ISNULL(@CaseQty,1)
--  ListPrice = @ListPrice,
--  Markup = @Markup,
--  Margin = @Margin
WHERE  (ReceiveEntryID = @ReceiveEntryID) and
     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
        (@DateModified is null)
      )
      
IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreNo)) NOT IN (3,5,7,9)      
UPDATE ItemStore SET    OnHand = (ItemStore.OnHand + @Qty), DateModified = dbo.GetLocalDATE()
WHERE ItemStoreID =@ItemStoreNo 

IF @PurchaseOrderEntryNo IS NOT NULL
Begin
Declare @POID Uniqueidentifier

SELECT  TOP(1) @POID = PurchaseOrderNo
FROM            PurchaseOrderEntryView
WHERE        (PurchaseOrderEntryId = @PurchaseOrderEntryNo)

IF @NetCost > @PcCost 
Exec SP_SaveAvgCost @ItemStoreNo = @ItemStoreNo, @Qty = @Qty, @NetCost = @NetCost, @CaseQty = @CaseQty
Else
Exec SP_SaveAvgCost @ItemStoreNo = @ItemStoreNo, @Qty = @Qty, @NetCost = @NetCost, @CaseQty = 1

Exec SP_POStatusUpdate @POID, @ModifierID

Exec UpdateOnOrderByOrder @ItemStoreNo, @ModifierID
End



select @UpdateTime as DateModified

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO