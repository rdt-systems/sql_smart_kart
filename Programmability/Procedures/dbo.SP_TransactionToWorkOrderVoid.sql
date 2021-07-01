SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionToWorkOrderVoid]
(
@TransactionEntryID uniqueidentifier,
@ModifierID uniqueidentifier
)AS

------------Change The WO Status

DECLARE @WorkOrderID uniqueidentifier
DECLARE @Qty decimal(19,3)

DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR 
SELECT WorkOrderID,Qty
FROM dbo.TransactionToWorkOrder WHERE(TransactionEntryID=@TransactionEntryID) 

	OPEN c2
	
	FETCH NEXT FROM c2 
	INTO @WorkOrderID,@Qty   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE dbo.WorkOrder
			SET WOStatus = case When (SELECT sum(SoldQty) From dbo.OpenSaleOrderView 
					WHERE WOID=@WorkOrderID)=@Qty then 1 -- When left only the current Qty
					else 0 end,
			    DateModified=dbo.GetLocalDATE(),
			    UserModified=@ModifierID
			Where WorkOrderID=@WorkOrderID
		FETCH NEXT FROM c2    --insert the next values to the instance
			INTO @WorkOrderID,@Qty
		END

	CLOSE c2
DEALLOCATE c2
-----------------------------------

--Change OnWorkOrder
UPDATE ItemStore 
SET OnWorkOrder=IsNULL(OnWorkOrder,0)
		+(SELECT Sum(Qty) FROM TransactionToWorkOrder Where @TransactionEntryID=TransactionEntryID),
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE ItemStoreID=(SELECT ItemStoreID FROM TransactionEntry WHERE @TransactionEntryID=TransactionEntryID)



UPDATE dbo.TransactionToWorkOrder
set Status =0,
          DateModified =  dbo.GetLocalDATE(),
          UserModified = @ModifierID
Where @TransactionEntryID=TransactionEntryID
GO