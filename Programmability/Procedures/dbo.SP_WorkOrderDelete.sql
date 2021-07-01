SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderDelete]
(
@WorkOrderID uniqueidentifier,
@ModifierID uniqueidentifier
)
AS 

UPDATE  dbo.WorkOrder
                       
   SET        Status = -1,    DateModified=   dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE  WorkOrderID  = @WorkOrderID



EXEC SP_WorkOrderToTransactionDelete @WorkOrderID,@ModifierID



DECLARE @WOEntryID uniqueidentifier --Delete entries

DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT WorkOrderEntryID
FROM dbo.WorkOrderEntry WHERE(WorkOrderID=@WorkOrderID) 

OPEN c1

FETCH NEXT FROM c1 
INTO @WOEntryID   -- holds the current transaction entry

WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC SP_WorkOrderEntryDelete @WOEntryID,@ModifierID
	FETCH NEXT FROM c1    --insert the next values to the instance
		INTO @WOEntryID
	END

CLOSE c1
DEALLOCATE c1
GO