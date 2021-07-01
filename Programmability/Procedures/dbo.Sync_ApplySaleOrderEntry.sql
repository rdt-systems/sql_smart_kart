SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ApplySaleOrderEntry]
(@TransactionEntryID uniqueidentifier,
@ModifierID uniqueidentifier)
AS


Declare @QtyToApply Decimal(19,3)
SET @QtyToApply=(SELECT Qty
				 FROM TransactionEntry
				 WHERE TransactionEntryID=@TransactionEntryID)

--Change OnSaleOrder
UPDATE [ItemStore] 
SET OnWorkOrder= IsNULL(OnWorkOrder,0)-(CASE WHEN @QtyToApply>IsNULL(OnWorkOrder,0) THEN IsNULL(OnWorkOrder,0) Else @QtyToApply End),
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE ItemStoreID=(SELECT ItemStoreID FROM TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)

Declare @ItemStoreID uniqueidentifier
Set @ItemStoreID=( SELECT ItemStoreID
				   FROM TransactionEntry
				   WHERE TransactionEntryID=@TransactionEntryID)

Declare @WorkOrderID uniqueidentifier
Declare @Qty Decimal(19,3)

DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT  WorkOrder.WorkOrderID,
		(SELECT SUM(Qty-SoldQty)
	   FROM OpenSaleOrderView
	   WHERE ItemStoreID=@ItemStoreID And WOID=WorkOrder.WorkOrderID 
	   GROUP BY ItemStoreID,WOID)
FROM dbo.WorkOrderEntry INNER JOIN
	WorkOrder On WorkOrderEntry.WorkOrderID=WorkOrder.WorkOrderID
WHERE ItemStoreID=@ItemStoreID And
	  (SELECT SUM(Qty-SoldQty)
	   FROM OpenSaleOrderView
	   WHERE ItemStoreID=@ItemStoreID And WOID=WorkOrder.WorkOrderID 
	   GROUP BY ItemStoreID,WOID)>0 And 
	   CustomerID=(SELECT CustomerID
				   FROM TransactionEntry INNER JOIN [Transaction] On TransactionEntry.TransactionID=[Transaction].TransactionID
				   WHERE TransactionEntryID=@TransactionEntryID)
ORDER BY StartSaleTime

OPEN i

FETCH NEXT FROM i 
INTO @WorkOrderID,@Qty


WHILE @@FETCH_STATUS = 0 And @QtyToApply>0
	BEGIN
		Insert INTO dbo.TransactionToWorkOrder
					(
					WorkOrderID,
					TransactionEntryID,
					Qty,
					Status,
					DateCreated, 
					UserCreated, 
					DateModified, 
					UserModified
					)
		Values
					(
					@WorkOrderID,
					@TransactionEntryID,
					(Case When @QtyToApply>@Qty Then @Qty Else @QtyToApply End),
					1, 
				    dbo.GetLocalDATE(), 
					@ModifierID,  
					dbo.GetLocalDATE(), 
					@ModifierID
					)
					
	Set @QtyToApply=@QtyToApply-@Qty

	--Change WO Status
	UPDATE dbo.WorkOrder 
	SET WOStatus =
	CASE 
	WHEN (Select Sum(SoldQty) From OpenSaleOrderView Where @WorkOrderID=WOID)=0 Then 1 --Open
	WHEN (Select Sum(Qty) From OpenSaleOrderView Where @WorkOrderID=WOID)<=(Select Sum(SoldQty) From OpenSaleOrderView Where @WorkOrderID=WOID) Then -1 --Close
	ELSE 0 -- PartialOrder
	End,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
	WHERE WorkOrderID=@WorkOrderID

	FETCH NEXT FROM i    --insert the next values to the instance
		INTO @WorkOrderID,@Qty
	END

CLOSE i
DEALLOCATE i
GO