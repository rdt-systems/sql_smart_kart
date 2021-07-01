SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderVoid]
(
@WorkOrderID uniqueidentifier,
@ModifierID uniqueidentifier
)
AS 

UPDATE  dbo.WorkOrder
                       
   SET        Status = 0,    DateModified=   dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE  WorkOrderID  = @WorkOrderID



EXEC SP_WorkOrderToTransactionVoid @WorkOrderID,@ModifierID



DECLARE @WOEntryID uniqueidentifier --Delete entries

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT WorkOrderEntryID
FROM dbo.WorkOrderEntry WHERE(WorkOrderID=@WorkOrderID) 

OPEN c1

FETCH NEXT FROM c1 
INTO @WOEntryID   -- holds the current transaction entry

WHILE @@FETCH_STATUS = 0
	BEGIN
		if (SELECT Status From WorkOrderEntry WHERE WorkOrderEntryID=@WOEntryID)=1
			EXEC SP_WorkOrderEntryVoid @WOEntryID,@ModifierID
	FETCH NEXT FROM c1    --insert the next values to the instance
		INTO @WOEntryID
	END

CLOSE c1
DEALLOCATE c1
GO