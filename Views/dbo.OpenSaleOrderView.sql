SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     view [dbo].[OpenSaleOrderView]
as
SELECT WorkOrderQty.WorkOrderID AS WOID, WorkOrderQty.ItemStoreID,WorkOrderQty.Qty ,ISNULL(SoldItems.SoldQty,0)AS SoldQty,WorkOrderQty.Price

FROM    
        (SELECT WorkOrderID,dbo.WorkOrderEntry.ItemStoreID,Price,SUM(dbo.WorkOrderEntry.qty) AS Qty
	FROM dbo.WorkOrderEntry
	GROUP BY WorkOrderID,dbo.WorkOrderEntry.ItemStoreID,Price) AS WorkOrderQty

	LEFT OUTER JOIN 
	
	(SELECT dbo.TransactionToWorkOrder.WorkOrderID,ItemStoreID,SUM(dbo.TransactionToWorkOrder.Qty) AS SoldQty
	 FROM dbo.TransactionEntry INNER JOIN dbo.TransactionToWorkOrder
	ON  dbo.TransactionToWorkOrder.TransactionEntryID=dbo.TransactionEntry.TransactionEntryID
	WHERE TransactionToWorkOrder.Status>-1
	 GROUP BY dbo.TransactionToWorkOrder.WorkOrderID,dbo.TransactionEntry.ItemStoreID) AS SoldItems 

	 ON WorkOrderQty.ItemStoreID=SoldItems.ItemStoreID
	 AND WorkOrderQty.WorkOrderID=SoldItems.WorkOrderID
GO