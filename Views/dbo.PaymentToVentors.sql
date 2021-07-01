SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PaymentToVentors]
AS
SELECT     3 AS Type, dbo.SupplierTenderEntry.TenderDate AS DAteT, dbo.SupplierTenderEntry.SuppTenderNo AS Num, NULL AS DueDate, 
                      - ISNULL(dbo.SupplierTenderEntry.Amount - ISNULL(PayToBill.AmountPay, 0), 0) AS OpenBalance, ISNULL(PayToBill.AmountPay, 0) AS AmountPay, 
                      dbo.SupplierTenderEntry.SuppTenderEntryID AS IDc, dbo.SupplierTenderEntry.SupplierID AS PID, dbo.Supplier.Name AS SuppName, 
                      dbo.SupplierTenderEntry.Amount, dbo.Supplier.SupplierNo, dbo.Supplier.Status AS SupplierStatus
FROM         dbo.SupplierTenderEntry INNER JOIN
                      dbo.Supplier ON dbo.SupplierTenderEntry.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                          (SELECT     SUM(Amount) AS AmountPay, SuppTenderID
                            FROM          dbo.PayToBill AS PayToBill_1
                            WHERE      (Status > 0)
                            GROUP BY SuppTenderID) AS PayToBill ON PayToBill.SuppTenderID = dbo.SupplierTenderEntry.SuppTenderEntryID
WHERE     (dbo.SupplierTenderEntry.Status > 0)
GO