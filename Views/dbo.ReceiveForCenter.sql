SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE      VIEW [dbo].[ReceiveForCenter]
AS
SELECT     dbo.Bill.BillNo, 1 AS Type, dbo.ReceiveOrder.ReceiveOrderDate, dbo.ReceiveOrder.SupplierNo, dbo.ReceiveOrder.StoreID, 
                      dbo.ReceiveOrder.ReceiveID,
dbo.ReceiveOrder.Total,
dbo.ReceiveOrder.Status,
(select case when isnull(dbo.Bill.AmountPay,0)=0 then 0 when isnull(dbo.bill.AmountPay,0)<isnull(dbo.bill.Amount,0) then 1 else 2 end) as Restatus
FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.Bill ON dbo.ReceiveOrder.BillID = dbo.Bill.BillID
WHERE     (dbo.ReceiveOrder.Status > -1)
GO