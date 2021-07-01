SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PoToReceiveView]
(@ReceiveID uniqueidentifier=null,
 @OrderID uniqueidentifier=null)
As

if @ReceiveID is null

Begin
        SELECT     dbo.PurchaseOrders.PurchaseOrderId,dbo.ReceiveOrder.ReceiveID,dbo.PurchaseOrders.PoNo, dbo.PurchaseOrders.GrandTotal, dbo.PurchaseOrders.PurchaseOrderDate, dbo.ReceiveOrder.Total, 
                      dbo.ReceiveOrder.ReceiveOrderDate, dbo.BillView.BillNo
        FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.ReceiveToPOView ON dbo.ReceiveOrder.ReceiveID = dbo.ReceiveToPOView.ReceiveID INNER JOIN
                      dbo.PurchaseOrders ON dbo.ReceiveToPOView.POID = dbo.PurchaseOrders.PurchaseOrderId INNER JOIN
                      dbo.BillView ON dbo.ReceiveOrder.BillID = dbo.BillView.BillID
        where dbo.PurchaseOrders.PurchaseOrderId=@OrderID
end

else

       SELECT     dbo.PurchaseOrders.PurchaseOrderId,dbo.ReceiveOrder.ReceiveID,dbo.PurchaseOrders.PoNo, dbo.PurchaseOrders.GrandTotal, dbo.PurchaseOrders.PurchaseOrderDate, dbo.ReceiveOrder.Total, 
                      dbo.ReceiveOrder.ReceiveOrderDate, dbo.BillView.BillNo
       FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.ReceiveToPOView ON dbo.ReceiveOrder.ReceiveID = dbo.ReceiveToPOView.ReceiveID INNER JOIN
                      dbo.PurchaseOrders ON dbo.ReceiveToPOView.POID = dbo.PurchaseOrders.PurchaseOrderId INNER JOIN
                      dbo.BillView ON dbo.ReceiveOrder.BillID = dbo.BillView.BillID
       where dbo.ReceiveOrder.ReceiveID=@ReceiveID
GO