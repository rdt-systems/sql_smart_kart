SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderEntryVoid]
(
@WorkOrderEntryID uniqueidentifier,
@ModifierID uniqueidentifier
)

AS 
declare @ItemStoreID uniqueidentifier
set @ItemStoreID=(SELECT ItemStoreID FROM WorkOrderEntry WHERE WorkOrderEntryID = @WorkOrderEntryID)

UPDATE ItemStore  --Chang OnWorkOrder
SET 	OnWorkOrder = IsNULL(OnWorkOrder,0)-
		(SELECT Qty FROM WorkOrderEntry WHERE WorkOrderEntryID = @WorkOrderEntryID),
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID
WHERE ItemStoreID=@ItemStoreID

UPDATE  dbo.WorkOrderEntry
                       
SET  	Status = 0,    
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID

WHERE  WorkOrderEntryID  = @WorkOrderEntryID


EXEC UpdateParent @ItemStoreID,@ModifierID,0,0,1,0,0
GO