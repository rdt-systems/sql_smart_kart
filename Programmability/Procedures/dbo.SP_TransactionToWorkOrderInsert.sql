SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionToWorkOrderInsert]
(@WorkOrderID uniqueidentifier,
@TransactionEntryID uniqueidentifier,
@Qty decimal(19,3),
@ModifierID uniqueidentifier)
AS

INSERT INTO dbo.TransactionToWorkOrder
	(WorkOrderID ,TransactionEntryID ,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES (@WorkOrderID ,@TransactionEntryID ,@Qty,1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID )

UPDATE dbo.WorkOrder --Chang WO Status
SET WOStatus =case 
		when (SELECT sum(Qty-SoldQty)As sum From dbo.OpenSaleOrderView WHERE WOID=@WorkOrderID)=0
		then -1
		else 0 end,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE WorkOrderID=@WorkOrderID

UPDATE ItemStore --Change OnWorkOrder
SET OnWorkOrder=IsNULL(OnWorkOrder,0)-@qty,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE ItemStoreID=(SELECT ItemStoreID FROM TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)
GO