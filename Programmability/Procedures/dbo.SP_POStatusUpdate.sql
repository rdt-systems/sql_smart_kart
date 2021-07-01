SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_POStatusUpdate] 
	(@PoID Uniqueidentifier,
	@ModifierID Uniqueidentifier)
AS
Declare @Status int = 0

SELECT        PurchaseOrders.PurchaseOrderId, PurchaseOrderEntry.QtyOrdered, (CASE WHEN PurchaseOrderEntry.UOMType = 2 AND IsNull(Receives.ReceivedQty, 0) 
                         > 0 THEN Receives.ReceivedQty / ISNULL(dbo.ItemMain.CaseQty, 1) ELSE IsNull(Receives.ReceivedQty, 0) END) AS ReceivedQty Into #OrderQty
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo INNER JOIN
                         PurchaseOrders INNER JOIN
                         PurchaseOrderEntry ON PurchaseOrders.PurchaseOrderId = PurchaseOrderEntry.PurchaseOrderNo ON ItemStore.ItemStoreID = PurchaseOrderEntry.ItemNo LEFT OUTER JOIN
                             (SELECT        SUM(CASE WHEN UOMType <> 0 AND CaseQty > 1 THEN Qty * CaseQty ELSE Qty END) AS ReceivedQty, PurchaseOrderEntryNo
                               FROM            ReceiveEntry
                               WHERE        (Status > 0)
                               GROUP BY PurchaseOrderEntryNo) AS Receives ON Receives.PurchaseOrderEntryNo = PurchaseOrderEntry.PurchaseOrderEntryId
WHERE        (PurchaseOrders.Status > 0) AND (PurchaseOrderEntry.Status > 0) and PurchaseOrders.PurchaseOrderId = @PoID


IF(SELECT  SUM(ISNULL(ReceivedQty,0)) FROM #OrderQty Where PurchaseOrderId = @PoID) > 0
BEGIN



SELECT @Status =  Case When SUM(ISNULL(QtyOrdered,0)) = SUM(ISNULL(ReceivedQty,0)) THEN 2 WHEN SUM(ISNULL(QtyOrdered,0)) > SUM(ISNULL(ReceivedQty,0))  THEN 1 ELSE 0 END 
FROM            #OrderQty Where PurchaseOrderId = @PoID


Update PurchaseOrders Set POStatus = @Status, DateModified = dbo.GetLocalDATE() Where PurchaseOrderId = @PoID

END
GO