SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReturnForRep]
AS
SELECT     2 AS Type, dbo.ReturnToVender.ReturnToVenderDate AS DateT, dbo.ReturnToVender.ReturnToVenderNo AS Num, NULL AS DueDate, 
                      - ISNULL(dbo.ReturnToVender.Total - ISNULL(PayToBill.AmountPay, 0), 0) AS OpenBalance, ISNULL(PayToBill.AmountPay, 0) AS AmountPay, 
                      dbo.ReturnToVender.ReturnToVenderID AS IDc, dbo.Supplier.SupplierID AS PID, dbo.Supplier.Name AS SuppName, 
                      dbo.ReturnToVender.Total AS Amount, dbo.Supplier.SupplierNo, dbo.Supplier.Status AS SupplierStatus
FROM         dbo.ReturnToVender INNER JOIN
                      dbo.Supplier ON dbo.ReturnToVender.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                          (SELECT     SUM(Amount) AS AmountPay, SuppTenderID
                            FROM          dbo.PayToBill AS PayToBill_1
                            WHERE      (Status > 0)
                            GROUP BY SuppTenderID) AS PayToBill ON PayToBill.SuppTenderID = dbo.ReturnToVender.ReturnToVenderID
WHERE     (dbo.ReturnToVender.Status > 0)
GO