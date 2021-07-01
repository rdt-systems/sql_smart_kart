SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReceiveWithBill]
AS
SELECT     1 AS Type, dbo.ReceiveOrder.ReceiveOrderDate AS DateT, dbo.Bill.BillNo AS Num, dbo.Bill.BillDue AS DueDate, 
                      dbo.ReceiveOrder.Total - ISNULL(Payments.TotalAmount, 0) AS OpenBalance, ISNULL(Payments.TotalAmount, 0) AS AmountPay, 
                      dbo.ReceiveOrder.ReceiveID AS IDc, dbo.ReceiveOrder.SupplierNo AS PID, dbo.Supplier.Name AS SuppName, dbo.Bill.Amount, 
                      dbo.Supplier.SupplierNo, dbo.Supplier.Status AS SupplierStatus
FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.Bill ON dbo.ReceiveOrder.BillID = dbo.Bill.BillID INNER JOIN
                      dbo.Supplier ON dbo.ReceiveOrder.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                          (SELECT     BillID, SUM(Amount) AS TotalAmount
                            FROM          dbo.PayToBill
                            WHERE      (Status > 0)
                            GROUP BY BillID) AS Payments ON dbo.ReceiveOrder.BillID = Payments.BillID
WHERE     (dbo.ReceiveOrder.Status > 0) AND (dbo.ReceiveOrder.Total - ISNULL(Payments.TotalAmount, 0) > 0)
GO