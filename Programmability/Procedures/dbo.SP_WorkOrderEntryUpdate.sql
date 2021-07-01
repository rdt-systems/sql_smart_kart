SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderEntryUpdate]

(@WorkOrderEntryID uniqueidentifier,
@WorkOrderID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Sort smallint,
@Taxable bit,
@Qty decimal(19,3),
@UOMQty decimal(19,3),
@Price money,
@UOMType int,
@PriceExplanation nvarchar(50),
@ParentTransactionEntry uniqueidentifier ,
@Note nvarchar(50),
@status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier
)
AS 

UPDATE ItemStore  --Chang OnWorkOrder
SET OnWorkOrder=IsNULL(OnWorkOrder,0) + 
		@Qty - (SELECT Qty FROM WorkOrderEntry WHERE WorkOrderEntryID = @WorkOrderEntryID),
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE ItemStoreID= @ItemStoreID

UPDATE dbo.WorkOrderEntry
SET
	WorkOrderID=@WorkOrderID ,
	ItemStoreID=@ItemStoreID ,
	Sort=@Sort ,
	Taxable=@Taxable ,
	Qty=@Qty ,
	UOMQty=isnull(@UOMQty,@Qty) ,
	UOMType = isnull(@UOMType,0),
	Price=@Price ,
	PriceExplanation=@PriceExplanation ,
	ParentTransactionEntry=@ParentTransactionEntry ,
	Note=@Note ,
	status=@status ,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
              
WHERE     
	(WorkOrderEntryID=@WorkOrderEntryID) and  (DateModified = @DateModified or DateModified is NULL)

EXEC UpdateParent @ItemStoreID,@ModifierID,0,0,1,0,0
GO