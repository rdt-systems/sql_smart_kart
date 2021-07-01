SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetEntryRowDetails]
(
@ReceiveEntryID uniqueidentifier,
@ReceiveNo uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@PurchaseOrderEntryNo uniqueidentifier = null,
@RealCost Money = null, 
@Qty decimal(18,5),
@ExtPrice Money,
@UOMQty decimal(18,5),
@UOMType int,
@IsSpecialPrice Bit = null,
@NetCost Money,
@CaseCost Money=0,
@PcCost Money=0,
@CaseQty decimal =0,       
@Discount money = 0,
@SortOrder int ,
@SupplierNo uniqueidentifier = null
)

AS

IF NOT EXISTS (SELECT * FROM ReceiveOrder ro Where ro.ReceiveID = @ReceiveNo)
BEGIN
  Insert Into ReceiveOrder (ReceiveID , SupplierNo , Status) values (@ReceiveNo, @SupplierNo, -9)
END

INSERT INTO dbo.ReceiveEntry
           (ReceiveEntryID, ReceiveNo, ItemStoreNo,  PurchaseOrderEntryNo,  Cost,  Qty,ExtPrice, UOMQty,UOMType,IsSpecialPrice, SortOrder, NetCost,Status, CaseCost,PcCost,CaseQty,Discount,NetPcCost
)
VALUES     (@ReceiveEntryID, @ReceiveNo, @ItemStoreNo, @PurchaseOrderEntryNo, @RealCost, @Qty,@ExtPrice, @UOMQty,@UOMType,@IsSpecialPrice,  @SortOrder, @NetCost, -9, @CaseCost,@PcCost,@CaseQty,@Discount,@NetCost/(case when ISNULL(@CaseQty,1)=0 then 1 else ISNULL(@CaseQty,1) end ))

-- make sure there's a itemsupply row.
IF (SELECT COUNT(*) From ItemSupply Where Status >0 AND ItemStoreNo = @ItemStoreNo AND SupplierNo = @SupplierNo) = 0
EXEC	[dbo].[UpdateSupplierItem]
		@ItemStoreID = @ItemStoreNo,
		@SupplierID = @SupplierNo,
		@MainSupplier = 0,
		@ModifierID = NULL

Declare @Id uniqueidentifier 
Declare @CbyCs bit
SELECT @CbyCs = CASE @UOMType WHEN 2 THEN 1 ELSE 0 END
SELECT TOP(1) @Id= ItemNo From ItemStore Where ItemStoreID = @ItemStoreNo
UPDATE ItemStore Set PrefOrderBy = @UOMType, PrefSaleBy = 0, DateModified = dbo.GetLocalDate() Where ItemNo = @Id and PrefOrderBy <> @UOMType
Update ItemMain Set CostByCase = @CbyCs, PriceByCase = 0, DateModified = dbo.GetLocalDate() Where ItemID = @Id And CostByCase <> @CbyCs


SELECT     dbo.ReceiveEntryView.* FROM dbo.ReceiveEntryView WHERE  (ReceiveEntryID=@ReceiveEntryID)

Delete From ReceiveOrder WHERE (ReceiveID=@ReceiveNo AND Status = -9)
Delete From ReceiveEntry WHERE (ReceiveEntryID=@ReceiveEntryID AND Status = -9)
Delete From ItemSupply WHERE (ItemStoreNo=@ItemStoreNo  AND SupplierNo=@SupplierNo AND Status = 19)
GO