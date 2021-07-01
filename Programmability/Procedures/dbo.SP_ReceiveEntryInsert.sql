SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ReceiveEntryInsert]

(
@ReceiveEntryID uniqueidentifier,
@ReceiveNo uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@PurchaseOrderEntryNo uniqueidentifier,
@RealCost Money, 
@Qty decimal(18,5),
@ExtPrice Money,
@ForApprove bit,
@UOMQty decimal(18,5),
@UOMType int,
@IsSpecialPrice Bit,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@Taxable bit,
@NetCost Money,
@Status  smallint, 
@CaseCost Money=0,
@PcCost Money=0,
@CaseQty decimal =1,       
@PriceStatus tinyint =0,
@LastNetCost Money= 0,
@ModifierID uniqueidentifier,
@SupplierNo uniqueidentifier = null,
@EstimatedPrice money = 0,
@DiscountType int =null,
@Discount money = 0,
@packsliplineno nvarchar(100) =NULL,
@UpdateOnHand Int = 1)

AS
IF @CaseQty = 0
SET @CaseQty = 1
IF EXISTS (select ReceiveEntryID from ReceiveEntry where ReceiveEntryID = @ReceiveEntryID)
BEGIN 
set @ReceiveEntryID = newid()
end

if @CaseQty =0 
begin 
set @CaseQty=1
end 
INSERT INTO dbo.ReceiveEntry
           (ReceiveEntryID, ReceiveNo, ItemStoreNo,  PurchaseOrderEntryNo,  Cost,  Qty,ExtPrice,ForApprove  , UOMQty,UOMType,IsSpecialPrice, LinkNo,   Note,SortOrder,Taxable, NetCost,Status, DateCreated, UserCreated, DateModified,CaseCost,PcCost,CaseQty,LastNetCost,PriceStatus, UserModified,EstimatedPrice
--,ListPrice,Markup,Margin
,DiscountType ,Discount,NetPcCost,PackingSlipLineNo
)
VALUES     (@ReceiveEntryID, @ReceiveNo, @ItemStoreNo, @PurchaseOrderEntryNo, @RealCost, @Qty,@ExtPrice,@ForApprove, @UOMQty,@UOMType,@IsSpecialPrice,@LinkNo,  @Note,@SortOrder,@Taxable, @NetCost,1, dbo.GetLocalDATE(), @ModifierID,dbo.GetLocalDATE(),@CaseCost,@PcCost,@CaseQty,@LastNetCost,@PriceStatus, @ModifierID, @EstimatedPrice
--,@ListPrice,@Markup,@Margin
,@DiscountType ,@Discount,@NetCost/ISNULL(@CaseQty,1),@packsliplineno 
)



if @SupplierNo is not  Null and @ItemStoreNo is not null and (select top(1)ItemSupplyID from dbo.ItemSupply where ItemStoreNo = @ItemStoreNo and SupplierNo = @supplierNo)is null 
begin
insert into dbo.ItemSupply
            (ItemSupplyID,ItemStoreNo,SupplierNo,Status,DateCreated)
values
(newid(),@ItemStoreNo,@SupplierNo,1,dbo.GetLocalDATE())

end

--**********************************************************
--Redirected Avg Cost to a seperate SP
--To make sure it gets saved to all stores
--And Also Targets the On Hand from All stores
--**********************************************************
IF @NetCost > @PcCost 
Exec SP_SaveAvgCost @ItemStoreNo = @ItemStoreNo, @Qty = @Qty, @NetCost = @NetCost, @CaseQty = @CaseQty
Else
Exec SP_SaveAvgCost @ItemStoreNo = @ItemStoreNo, @Qty = @Qty, @NetCost = @NetCost, @CaseQty = 1
--declare @AVGCost money

--BEGIN TRY
--  IF (SELECT IsNull(OnHand,0)From ItemStore WHERE ItemStoreID=@ItemStoreNo)<=0 
--    SET @AVgCost = @PcCost
--  ELSE
--    SET @AVGCost =(SELECT ((OnHand*ISnull(AVGCost,Cost))+(@Qty*@PcCost))/ (CASE WHEN OnHand +@Qty<>0 THEN(OnHand +@Qty)WHEN @Qty<>0 THEN @QTY ELSE 1 END) FROM ItemStore where ItemStoreID=@ItemStoreNo)
--IF (@AVGCost > (@PcCost*3)) OR (@AVGCost < -(@PcCost*3))
--  set @AVgCost = @PcCost
--END TRY
--BEGIN CATCH
--  SET @AVgCost = @PcCost
--END CATCH

----NE Check if the EvgCost is a big difrent then regCost if Yes the take Ragulare cost
IF @UpdateOnHand = 1
Begin
IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreNo)) NOT IN (3,5,7,9,2)     


UPDATE ItemStore SET    OnHand = (ItemStore.OnHand + @Qty), 
                        DateModified = dbo.GetLocalDATE(),
						--AVGCost=@AVGCost,
						LastReceivedDate=dbo.GetLocalDATE(),
						LastReceivedQty=@UOMQty
	WHERE ItemStoreID =@ItemStoreNo 
End


IF @PurchaseOrderEntryNo IS NOT NULL
Begin
Declare @POID Uniqueidentifier

SELECT  TOP(1) @POID = PurchaseOrderNo
FROM            PurchaseOrderEntry
WHERE        (PurchaseOrderEntryId = @PurchaseOrderEntryNo)

Exec SP_POStatusUpdate @POID, @ModifierID

Exec UpdateOnOrderByOrder @ItemStoreNo, @ModifierID
End

-- Update LastReceivedDate

--NE Comment it becuse Slow the system I add the "LastReceivedDate" and the "LastReceivedQty" the the last SQL  
--UPDATE       ItemStore
--SET                LastReceivedDate =
--                             (SELECT        TOP (1) ReceiveOrder.ReceiveOrderDate
--                               FROM            ReceiveEntry INNER JOIN
--                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
--                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
--                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),
-- LastReceivedQty = ISNULL(
--                             (SELECT        TOP (1) ReceiveEntry.UOMQty
--                               FROM            ReceiveEntry INNER JOIN
--                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
--                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
--                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),0)
--where ItemStore.ItemStoreID =@ItemStoreNo

-- Update LastReceivedQty
--UPDATE       ItemStore
--SET                LastReceivedQty = ISNULL(
--                             (SELECT        TOP (1) ReceiveEntry.UOMQty
--                               FROM            ReceiveEntry INNER JOIN
--                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
--                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
--                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),0)
GO