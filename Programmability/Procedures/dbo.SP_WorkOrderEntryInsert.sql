SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderEntryInsert](
@WorkOrderEntryID uniqueidentifier,
@WorkOrderID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Sort smallint,
@Taxable bit,
@Qty decimal(19,3),
@Price money,
@UOMType int,
@UOMQty decimal(19,3),
@PriceExplanation nvarchar(50),
@ParentTransactionEntry uniqueidentifier,
@Note nvarchar(50),
@status smallint,
@ModifierID uniqueidentifier)
AS 

INSERT INTO dbo.WorkOrderEntry
                      (WorkOrderEntryID, WorkOrderID, ItemStoreID, Sort, Taxable, Qty, UOMQty, Price, PriceExplanation, UOMType, ParentTransactionEntry, 
	         Note, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@WorkOrderEntryID, @WorkOrderID, @ItemStoreID, @Sort, @Taxable, @Qty, isnull(@UOMQty,@qty), @Price, @PriceExplanation, isnull(@UOMType,0), @ParentTransactionEntry, 
                      @Note, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

UPDATE ItemStore
SET OnWorkOrder=IsNULL(OnWorkOrder,0)+@Qty,
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID
WHERE ItemStoreID=@ItemStoreID

EXEC UpdateParent @ItemStoreID,@ModifierID,0,0,1,0,0
GO