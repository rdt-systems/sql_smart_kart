SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderEntryDelete]
(
@WorkOrderEntryID uniqueidentifier,
@ModifierID uniqueidentifier
)

AS 

declare @ItemStoreID uniqueidentifier
set @ItemStoreID=(SELECT ItemStoreID FROM WorkOrderEntry WHERE WorkOrderEntryID = @WorkOrderEntryID)

if (Select status from WorkOrderEntry WHERE  WorkOrderEntryID  = @WorkOrderEntryID)=1
begin

	UPDATE ItemStore  --Chang OnWorkOrder
	SET 	OnWorkOrder = IsNULL(OnWorkOrder,0)-
			(SELECT Qty FROM WorkOrderEntry WHERE WorkOrderEntryID = @WorkOrderEntryID),
		DateModified=dbo.GetLocalDATE(), 
		UserModified=@ModifierID
	WHERE ItemStoreID=@ItemStoreID
end

UPDATE  dbo.WorkOrderEntry
                       
SET  	Status = -1,    
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID

WHERE  WorkOrderEntryID  = @WorkOrderEntryID


EXEC UpdateParent @ItemStoreID,@ModifierID,0,0,1,0,0
GO