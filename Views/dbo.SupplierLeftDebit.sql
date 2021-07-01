SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    VIEW [dbo].[SupplierLeftDebit]
AS
SELECT     TOP 100 PERCENT dbo.ReceiveOrder.ReceiveID, dbo.ReceiveOrder.ReceiveOrderDate, dbo.ReceiveOrder.Total - ISNULL(Payments.TotalAmount, 0) 
                      AS LeftDebit, dbo.ReceiveOrder.SupplierNo, dbo.Supplier.DefaultCredit, dbo.Bill.BillDue, dbo.ReceiveOrder.Total
FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.Supplier ON dbo.ReceiveOrder.SupplierNo = dbo.Supplier.SupplierID INNER JOIN
                      dbo.Bill ON dbo.ReceiveOrder.BillID = dbo.Bill.BillID LEFT OUTER JOIN
                          (SELECT     BillID, SUM(Amount) AS TotalAmount
                            FROM          dbo.PayToBill
where dbo.PayToBill.Status>0
                            GROUP BY BillID) Payments ON dbo.ReceiveOrder.BillID = Payments.BillID
WHERE     (dbo.ReceiveOrder.Status > 0)
ORDER BY dbo.ReceiveOrder.ReceiveOrderDate
GO