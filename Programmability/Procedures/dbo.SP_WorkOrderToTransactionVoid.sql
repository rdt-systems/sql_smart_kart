SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_WorkOrderToTransactionVoid]
(
@WorkOrderID uniqueidentifier,
@ModifierID uniqueidentifier
)AS


DECLARE @TransactionEntryID uniqueidentifier
DECLARE @Qty decimal(19,3)

DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR 
SELECT TransactionEntryID,Qty
FROM dbo.TransactionToWorkOrder WHERE(WorkOrderID=@WorkOrderID) 

	OPEN c2
	
	FETCH NEXT FROM c2 
	INTO @TransactionEntryID,@Qty   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--Change OnWorkOrder
			UPDATE ItemStore 
			SET OnWorkOrder=IsNULL(OnWorkOrder,0)+@Qty,
			DateModified=dbo.GetLocalDATE(),
			UserModified=@ModifierID
			WHERE ItemStoreID=(SELECT ItemStoreID FROM TransactionEntry WHERE @TransactionEntryID=TransactionEntryID)
		
		FETCH NEXT FROM c2    --insert the next values to the instance
			INTO @TransactionEntryID,@Qty
		END

	CLOSE c2
DEALLOCATE c2



UPDATE dbo.TransactionToWorkOrder
set Status =0,
          DateModified =  dbo.GetLocalDATE(),
          UserModified = @ModifierID
Where WorkOrderID=@WorkOrderID
GO