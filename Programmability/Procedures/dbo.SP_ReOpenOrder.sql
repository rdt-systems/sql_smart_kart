SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReOpenOrder](@ID Uniqueidentifier)

AS
Declare @Status Int
BEGIN

SELECT @Status = CASE WHEN SUM(ISNULL(ReceivedQty,0)) = 0 AND SUM(ISNULL(ReceivedQty,0)) < SUM(ISNULL(QtyOrdered,0)) THEN 0 ELSE  1 END 
FROM            PurchaseOrderEntryView
WHERE        (PurchaseOrderNo = @ID)

UPDATE  PurchaseOrders set POStatus = @Status, DateModified = dbo.GetLocalDATE() Where PurchaseOrderId = @ID


UPDATE       ItemStore
SET                OnOrder = ISNULL(RecvOrder.OnOrder, 0)
FROM            ItemStore LEFT OUTER JOIN
                             (SELECT        PurchaseOrderEntryView.ItemNo, SUM(PurchaseOrderEntryView.OrderDeficit) AS OnOrder
                               FROM            PurchaseOrderEntryView INNER JOIN
                                                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId
                               WHERE        (PurchaseOrdersView.POStatus <> 2) AND (PurchaseOrdersView.Status > 0) AND (PurchaseOrderEntryView.Status > 0)
                               GROUP BY PurchaseOrderEntryView.ItemNo) AS RecvOrder ON ItemStore.ItemStoreID = RecvOrder.ItemNo
WHERE        (ItemStore.ItemStoreID IN
                             (SELECT        ItemNo
                               FROM            PurchaseOrderEntry
                               WHERE        (PurchaseOrderNo = @ID)))


END
GO