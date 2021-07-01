SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPOReceive]
(@POID Nvarchar(50))
AS 
SELECT DISTINCT ReceiveOrderView.ReceiveID, ReceiveOrderView.BillNo, ReceiveOrderView.ReceiveOrderDate, PurchaseOrders.PurchaseOrderId, PurchaseOrders.PoNo, ReceiveOrderView.UserName
FROM            PurchaseOrders INNER JOIN
                         PurchaseOrderEntry ON PurchaseOrders.PurchaseOrderId = PurchaseOrderEntry.PurchaseOrderNo INNER JOIN
                         ReceiveEntry INNER JOIN
                         ReceiveOrderView ON ReceiveEntry.ReceiveNo = ReceiveOrderView.ReceiveID ON PurchaseOrderEntry.PurchaseOrderEntryId = ReceiveEntry.PurchaseOrderEntryNo
WHERE        (PurchaseOrders.PurchaseOrderId = @POID) AND (ReceiveOrderView.BillNo IS NOT NULL)
GO