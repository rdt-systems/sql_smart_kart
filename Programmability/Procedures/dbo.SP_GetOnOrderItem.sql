SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOnOrderItem]
(@ItemStoreID uniqueidentifier,
@ShowClose int = 1)
AS 
	SELECT     dbo.Supplier.Name,
		   dbo.PurchaseOrders.PoNo,
		   dbo.PurchaseOrderEntry.ItemNo,
                   dbo.PurchaseOrderEntry.QtyOrdered, 
                   dbo.PurchaseOrderEntry.PricePerUnit, 
                   dbo.PurchaseOrders.PurchaseOrderId,

	           CASE WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN 
	                     QtyOrdered - isnull(ReceivedQty, 0) 
	                ELSE
	                     0 
	           END AS OrderDeficit

	FROM       dbo.PurchaseOrderEntry 
		   INNER JOIN
                   dbo.PurchaseOrders ON dbo.PurchaseOrderEntry.PurchaseOrderNo = dbo.PurchaseOrders.PurchaseOrderId 
		   INNER JOIN
                   dbo.Supplier ON dbo.PurchaseOrders.SupplierNo = dbo.Supplier.SupplierID
                   LEFT OUTER JOIN
                           (SELECT     SUM(Qty) AS ReceivedQty, PurchaseOrderEntryNo
                            FROM          dbo.ReceiveEntry
			    WHERE Status>0
                            GROUP BY PurchaseOrderEntryNo) Receives
                    ON Receives.PurchaseOrderEntryNo = dbo.PurchaseOrderEntry.PurchaseOrderEntryId

	WHERE     (dbo.PurchaseOrders.Status > 0) AND 
		  (dbo.PurchaseOrderEntry.ItemNo = @ItemStoreID) AND 
		  (dbo.PurchaseOrders.POStatus <= @ShowClose) AND 
		  (dbo.PurchaseOrderEntry.Status >0)
UNION ALL

SELECT     dbo.Store.StoreName as [Name],
		   dbo.TransferOrder.TransferOrderNo  collate Hebrew_CI_AS as PoNo,
		   dbo.TransferOrderEntry.ItemStoreNo as ItemNo,
           dbo.TransferOrderEntry.Qty as QtyOrdered, 
           dbo.TransferOrderEntry.UOMPrice, 
           dbo.TransferOrder.TransferOrderID,
		   0 AS OrderDeficit

	FROM       dbo.TransferOrderEntry 
		   INNER JOIN
                   dbo.TransferOrder ON dbo.TransferOrderEntry.TransferOrderID = dbo.TransferOrder.TransferOrderID
		   INNER JOIN
                   dbo.Store ON dbo.TransferOrder.FromStoreID = dbo.Store.StoreID

	WHERE     (dbo.TransferOrder.Status > 0) AND 
		  (dbo.TransferOrderEntry.Status >0) AND 
		  (dbo.TransferOrder.OrderStatus <= @ShowClose) AND
		  (dbo.TransferOrderEntry.ItemStoreNo =(SELECT TOP 1 ItemNo
												FROM ItemStore
												WHERE ItemStoreID=@ItemStoreID))
GO